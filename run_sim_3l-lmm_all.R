# Receive shell arguments outside the Rscript
args <- commandArgs(trailingOnly = TRUE)

model_name <- ifelse(length(args) >= 1, args[1], "sim_3l-lmm_ARdHdARmHm")
N <- ifelse(length(args) >= 2, as.integer(args[2]), 100)
D <- ifelse(length(args) >= 3, as.integer(args[3]), 9)
M <- ifelse(length(args) >= 4, as.integer(args[4]), 10)
seed <- ifelse(length(args) >= 5, as.integer(args[5]), 20250610)

cat("Start to run the simulation.\n")

cat("Generate simulated data.\n")
# load packages
library(tidyverse)
library(cmdstanr)
library(posterior)

is_ARd <- str_detect(model_name, "ARd")
is_Hd <- str_detect(model_name, "Hd")
is_ARm <- str_detect(model_name, "ARm")
is_Hm <- str_detect(model_name, "Hm")

file_name <- str_glue("{model_name}_N{N}D{D}M{M}Seed{seed}")
if (length(args) >= 6) {
  file_name <- paste(file_name, args[6], sep = "_")
}

# set.seed
set.seed(seed)

# generate simulated data
ar1_corr_matrix <- function(m, phi) {
  t <- 1:m
  H <- phi^abs(outer(t, t, "-"))
}

# fixed effect
beta <- 50

# random effect
psi_s <- 3
s <- rnorm(N, 0, psi_s)

if (is_Hd) {
  psi_d <- runif(D, 1, 2) |> sort(decreasing = TRUE)
} else {
  psi_d <- 1.5
}
d <- matrix(rnorm(N*D, 0, psi_d), N, D, byrow = TRUE)

# autoregressive effect
if (is_ARd) {
  phi_d <- 0.6
  H_d <- ar1_corr_matrix(D, phi_d)
  sigma_omega_d <- 1.2
  tau2_d <- sigma_omega_d^2 / (1 - phi_d^2)
  Sigma_d <- tau2_d * H_d  
  nu <- MASS::mvrnorm(N, rep(0, D), Sigma_d)
} else {
  phi_d <- 0
  H_d <- ar1_corr_matrix(D, phi_d)
  sigma_omega_d <- 0
  tau2_d <- sigma_omega_d^2 / (1 - phi_d^2)
  Sigma_d <- tau2_d * H_d  
  nu <- 0
}

if (is_ARm) {
  phi_m <- 0.3
  H_m <- ar1_corr_matrix(M, phi_m)
  sigma_omega_m <- 1 
  tau2_m <- sigma_omega_m^2 / (1 - phi_m^2)
  Sigma_m <- tau2_m * H_m
  omega <- MASS::mvrnorm(N*D, rep(0, M), Sigma_m)
} else {
  phi_m <- 0
  H_m <- ar1_corr_matrix(M, phi_m)
  sigma_omega_m <- 0 
  tau2_m <- sigma_omega_m^2 / (1 - phi_m^2)
  Sigma_m <- tau2_m * H_m
  omega <- 0
}

# measurement error
if (is_Hm) {
  sigma_epsilon <- runif(M, 0.5, 2) |> sort(decreasing = TRUE)
} else {
  sigma_epsilon <- 1.25
}
epsilon <- rnorm(N*D*M, 0, sigma_epsilon)

rel_T = (psi_s^2 + mean(psi_d^2)) / (psi_s^2 + mean(psi_d^2) + tau2_d + tau2_m + mean(sigma_epsilon^2))

###index###
#   s d m
#   1 1 1
#   1 1 2
# y 1 2 1
#   1 2 2
#   2 1 1
#   2 1 2
#   . . .
###########

# observation 
y <- beta + 
  rep(s, each = D*M) +
  rep(as.vector(t(d)), each = M) +
  rep(as.vector(t(nu)), each = M) +
  as.vector(t(omega)) + 
  epsilon

data <- list(N = N, D = D, M = M, 
             psi_s = psi_s, s = s, psi_d = psi_d, d = d,
             phi_d = phi_d, H_d = H_d, sigma_omega_d = sigma_omega_d, 
             tau2_d = tau2_d, Sigma_d = Sigma_d, nu = nu,
             phi_m = phi_m, H_m = H_m, sigma_omega_m = sigma_omega_m, 
             tau2_m = tau2_m, Sigma_m = Sigma_m, omega = omega,
             sigma_epsilon = sigma_epsilon, epsilon = epsilon, 
             y = y, rel_T = rel_T)
write_rds(data, str_glue("data/{file_name}.rds"))

#######################################

cat("Run MCMC by Stan \n")

output_dir_lmm = str_glue("stan/draws/{file_name}")

if (dir.exists(output_dir_lmm)) {
  file.remove(list.files(output_dir_lmm, full.names = TRUE))
} else {
  dir.create(output_dir_lmm, recursive = TRUE)
}

lmm_data <- lst(N = N,
                D = D,
                M = M,
                y = y)

lmm <- cmdstan_model(str_glue("stan/{model_name}.stan"))

lmm_fit <- lmm$sample(data = lmm_data,
                      chains = 4,
                      parallel_chains = 4,
                      output_dir = output_dir_lmm,
                      iter_warmup = 4000,
                      iter_sampling = 4000,
                      thin = 1,
                      seed = seed,
                      refresh = 1000,
                      show_messages = TRUE)

write_rds(lmm_fit, str_glue("stan/{file_name}.rds"))

cat("Finished the MCMC sampling.\n")

cat("Calulate the summary of MCMC draws.\n")

lmm_summary <- lmm_fit$summary()
write_csv(lmm_summary, str_glue("stan/summary/{file_name}_summary.csv"))

cat("Finish the simulation procedure.\n")
