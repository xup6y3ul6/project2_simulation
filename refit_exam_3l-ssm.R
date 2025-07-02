
model_name <- "exam_3l-ssm_ZARdHdARmHm"
N <- 101
D <- 9
M <- 10
seed <- 20250630

# load packages
library(tidyverse)
library(cmdstanr)
library(posterior)

is_ARd <- str_detect(model_name, "ARd")
is_Hd <- str_detect(model_name, "Hd")
is_ARm <- str_detect(model_name, "ARm")
is_Hm <- str_detect(model_name, "Hm")

file_name <- str_glue("{model_name}_N{N}D{D}M{M}Seed{seed}")

# set.seed
set.seed(seed)

# read fitted results of Exam study
exam_summary <- read_csv("stan/summary/exam_3l-ssm_ZARdHdARmHm_Seed20250619_summary.csv")
exam_summary

# generate simulated data
ar1_corr_matrix <- function(m, phi) {
  t <- 1:m
  H <- phi^abs(outer(t, t, "-"))
}

# fixed effect
beta <- exam_summary |> filter(variable == "beta") |> pull(mean)

# random effect
psi_s <- exam_summary |> filter(variable == "psi_s") |> pull(mean)
s <- exam_summary |> slice(str_which(variable, "^s\\[")) |> pull(mean)

psi_d <- exam_summary |> slice(str_which(variable, "^psi_d\\[")) |> pull(mean)
d <- exam_summary |> slice(str_which(variable, "^d\\[")) |> pull(mean) |> 
  matrix(nrow = N)

# autoregressive effect
phi_d <- exam_summary |> filter(variable == "phi_d") |> pull(mean)
H_d <- ar1_corr_matrix(D, phi_d)
sigma_omega_d <- exam_summary |> filter(variable == "sigma_omega_d") |> pull(mean)
tau2_d <- exam_summary |> filter(variable == "tau2_d") |> pull(mean)
Sigma_d <- tau2_d * H_d  
nu <- MASS::mvrnorm(N, rep(0, D), Sigma_d)

phi_m <- exam_summary |> filter(variable == "phi_m") |> pull(mean)
H_m <- ar1_corr_matrix(M, phi_m)
sigma_omega_m <- exam_summary |> filter(variable == "sigma_omega_m") |> pull(mean)
tau2_m <- exam_summary |> filter(variable == "tau2_m") |> pull(mean)
Sigma_m <- tau2_m * H_m
omega <- MASS::mvrnorm(N*D, rep(0, M), Sigma_m)

# measurement error
sigma_epsilon <- exam_summary |> slice(str_which(variable, "^sigma_epsilon\\[")) |> pull(mean)
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


exam_data <- read_rds("data/exam_data.rds")

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
                y_obs = y,
                z_obs = exam_data$Get_grade)

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
