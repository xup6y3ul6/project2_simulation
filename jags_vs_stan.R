# Load libararies and set parameters ====
library(tidyverse)
library(jagsUI)
library(bayesplot)
library(posterior)

model_name <- "sim_3l-lmm_RIdHdARmHm"
N <- 20
D <- 20
M <- 20
phi_d <- 0.5
seed <- 20250708

is_lmm <-str_detect(model_name, "lmm")
is_ARd <- str_detect(model_name, "ARd")
is_Hd <- str_detect(model_name, "Hd")
is_ARm <- str_detect(model_name, "ARm")
is_Hm <- str_detect(model_name, "Hm")

file_name <- str_glue("{model_name}_N{N}D{D}M{M}_phi-d{phi_d}_Seed{seed}")

set.seed(seed)

# Generated simulation data or not ====

cat("Generate simulated data.\n")

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
  # phi_d <- 0.6
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
y_vec <- beta + 
  rep(s, each = D*M) +
  rep(as.vector(t(d)), each = M) +
  rep(as.vector(t(nu)), each = M) +
  as.vector(t(omega)) + 
  epsilon
y <- array(0, dim = c(N, D, M))
for (i in 1:N) {
  for (j in 1:D) {
    y[i, j, ] = y_vec[((i-1)*D*M + (j-1)*M + 1):((i-1)*D*M + (j-1)*M + M)]
  }
}

data <- list(N = N, D = D, M = M, beta = beta,
            psi_s = psi_s, s = s, psi_d = psi_d, d = d,
            phi_d = phi_d, H_d = H_d, sigma_omega_d = sigma_omega_d, 
            tau2_d = tau2_d, Sigma_d = Sigma_d, nu = nu,
            phi_m = phi_m, H_m = H_m, sigma_omega_m = sigma_omega_m, 
            tau2_m = tau2_m, Sigma_m = Sigma_m, omega = omega,
            sigma_epsilon = sigma_epsilon, epsilon = epsilon, 
            y = y, rel_T = rel_T)
write_rds(data, str_glue("data/{file_name}.rds"))


# Fit data by Bayesian approach ====
## Jags ====
library(jagsUI)

# writeLines("
#   model {
#     # Priors
#     beta ~ dnorm(0, 0.001)
    
#     psi_s ~ dt(0, 1/6.25, 3)T(0,) #SD for random effects for subjects
#     prec_s <- 1 / pow(psi_s, 2)

#     for (j in 1:D) {
#       psi_d[j] ~ dt(0, 1/6.25, 3)T(0,) # (hetero) SD for random effects for days
#       prec_d[j] <- 1 / pow(psi_d[j], 2)
#     }
   
#     # for (k in 1:M) {
#     #   sigma_epsilon[k] ~ dt(0, 1/6.25, 3)T(0,) #SD for error
#     #   prec_epsilon[k] <- 1 / pow(sigma_epsilon[k], 2)
#     # }
#     sigma_epsilon ~ dt(0, 1/6.25, 3)T(0,) #SD for error
#     prec_epsilon <- 1 / pow(sigma_epsilon, 2)
    
#     sigma_omega_m ~ dt(0, 1/6.25, 3)T(0,) #SD for AR(1) process
#     prec_omega_m <- 1 / pow(sigma_omega_m, 2)
    
#     phi_m ~ dnorm(0, 4)T(-1,1)  #autocorrelation
        
#     # Likelihood
#     for (i in 1:N) {
#       s[i] ~ dnorm(0, prec_s)

#       for (j in 1:D) {
#         d[i, j] ~ dnorm(0, prec_d[j])
#         mu_ij[i, j] <- beta + s[i] + d[i, j]

#         for (k in 1:M) {
#           # y[i, j, k] ~ dnorm(mu_ij[i, j], prec_epsilon[k])
#           y[i, j, k] ~ dnorm(mu_ij[i, j], prec_epsilon)
#         }
#       }
#     }
    
#     #Derived quantity: relative total variance (R_T)
#     tau2_m <- sigma_omega_m^2 / (1 - phi_m^2)
#     rel_T <- (psi_s^2 + mean(psi_d^2)) / (psi_s^2 + mean(psi_d^2) + tau2_m + mean(sigma_epsilon^2))
#   }
# ", con = "sim_3l-lmm_HdARm_jags.txt")


writeLines("
  model {
    # Priors
    beta ~ dnorm(0, 0.001)
    
    psi_s ~ dt(0, 1/6.25, 3)T(0,) #SD for random effects for subjects
    prec_s <- 1 / pow(psi_s, 2)

    for (j in 1:D) {
      psi_d[j] ~ dt(0, 1/6.25, 3)T(0,) # (hetero) SD for random effects for days
      prec_d[j] <- 1 / pow(psi_d[j], 2)
    }
   
    for (k in 1:M) {
      sigma_epsilon[k] ~ dt(0, 1/6.25, 3)T(0,) #SD for error
      prec_epsilon[k] <- 1 / pow(sigma_epsilon[k], 2)
    }
    
    sigma_omega_m ~ dt(0, 1/6.25, 3)T(0,)
    prec_omega_m <- 1 / pow(sigma_omega_m, 2)
    
    phi_m ~ dnorm(0, 4)T(-1,1)  #autocorrelation
  
    # Likelihood
    for (i in 1:N) {
      s[i] ~ dnorm(0, prec_s)

      for (j in 1:D) {
        d[i, j] ~ dnorm(0, prec_d[j])

        omega[i, j, 1] ~ dnorm(0, prec_omega_m) # AR(1) process for the first moment 
        for (k in 2:M) {
          omega_lat[i, j, k] <- phi_m * omega[i, j, k - 1]
          omega[i, j, k] ~ dnorm(omega_lat[i, j, k], prec_omega_m)
        }

        for (k in 1:M) {
          mu[i, j, k] <- beta + s[i] + d[i, j] + omega[i, j, k]
          y[i, j, k] ~ dnorm(mu[i, j, k], prec_epsilon[k])
        }
      }
    }
    
    # Derived quantity: relative total variance (R_T)
    tau2_m <- sigma_omega_m^2 / (1 - phi_m^2)
    rel_T <- (psi_s^2 + mean(psi_d^2)) / (psi_s^2 + mean(psi_d^2) + tau2_m + mean(sigma_epsilon^2))
  }
", con = "jags/sim_3l-lmm_RIdHdARmHm_jags.txt")

model_data <- list(N = data$N,
                   D = data$D,
                   M = data$M, 
                   y = data$y)

jags_inits <- list(beta = 50,
                   phi_m = 0.0,
                   sigma_epsilon = 1.25,
                   sigma_omega_m = 0.25,
                   psi_d = 0.5,
                   psi_s = 3)

params <- c("beta", 
            "s", "d", 
            "psi_s", "psi_d",
            "phi_m", "sigma_omega_m", "tau2_m",
            "sigma_epsilon",
            "rel_T")

lmm_j <- jags(data = model_data,
              # inits = jags_inits,
              parameters.to.save = params,
              model.file = "jags/sim_3l-lmm_RIdHdARmHm_jags.txt",
              n.chains = 3,
              n.adapt = 1000,
              n.burnin = 6000,
              n.iter = 8000,
              n.thin = 15,
              parallel = TRUE)


plot(lmm_j)
View(lmm_j$summary)


lmm_j_draws <- as_draws_matrix(lmm_j$samples)

ppc_intervals(y = data$beta, 
              yrep = subset_draws(lmm_j_draws, variable = "beta"),
              prob_outer = 0.95) + 
  scale_x_discrete(name = "Ground mean (beta)") 

order_s <- order(data$s)
ppc_intervals(y = data$s[order_s], 
              yrep = subset_draws(lmm_j_draws, variable = "s") %>% `[`(, order_s),
              prob_outer = 0.95) + 
  scale_x_discrete(name = "Subject effect (s)") 

order_d <- order(data$d)
ppc_intervals(y = data$d[order_d], 
              yrep = subset_draws(lmm_j_draws, variable = "d") %>% `[`(, order_d),
              prob_outer = 0.95) +
  scale_x_discrete(name = "Day effect (d)")

pars_sd <- c("psi_s", "psi_d", "sigma_epsilon")
pars_sd_draws <- c("psi_s", 
                   str_glue("psi_d[{j}]", j = 1:D), 
                   str_glue("sigma_epsilon[{k}]", k = 1:M))
ppc_intervals(y = data[pars_sd] |> unlist(), 
              yrep = subset_draws(lmm_j_draws, variable = pars_sd_draws),
              prob_outer = 0.95) + 
  scale_x_discrete(name = "Standard deviations", 
                   limits = pars_sd_draws)

pars_phi <- c("phi_m")
ppc_intervals(y = data[pars_phi] |> unlist(), 
              yrep = subset_draws(lmm_j_draws, variable = pars_phi),
              prob_outer = 0.95) + 
  scale_x_discrete(name = "Autocorrelation effects", 
                   limit = pars_phi)

pars_tau <- c("tau2_m")
ppc_intervals(y = data[pars_tau] |> unlist(), 
              yrep = subset_draws(lmm_j_draws, variable = pars_tau),
              prob_outer = 0.95) + 
  scale_x_discrete(name = "Variance of AR(1)", 
                   limit = pars_tau)


ppc_intervals(y = data$rel_T,
              yrep = subset_draws(lmm_j_draws, variable = "rel_T"),
              prob_outer = 0.95) + 
  scale_x_discrete(name = "Reliability", 
                   limit ="rel_T")

mcmc_pairs(lmm_j_draws, pars = c("beta", "tau2_m", "sigma_omega_m", "phi_m", "psi_s", "psi_d[1]", "psi_d[2]", "sigma_epsilon[1]"))















## Stan ====


# output_dir = str_glue("stan/draws/{file_name}")

# if (dir.exists(output_dir)) {
#   file.remove(list.files(output_dir, full.names = TRUE))
# } else {
#   dir.create(output_dir, recursive = TRUE)
# }

# model_data <- lst(N = N,
#                   D = D,
#                   M = M,
#                   y = y)

# model <- cmdstan_model(str_glue("stan/{model_name}.stan"))

# model_fit <- model$sample(data = model_data,
#                           chains = 4,
#                           parallel_chains = 4,
#                           output_dir = output_dir,
#                           iter_warmup = 4000,
#                           iter_sampling = 4000,
#                           thin = 1,
#                           seed = seed,
#                           refresh = 1000,
#                           show_messages = TRUE)

# write_rds(model_fit, str_glue("stan/{file_name}.rds"))



