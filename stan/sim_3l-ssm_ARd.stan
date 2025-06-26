/*
Three-level model for simulation study
3l = three-level
lmm = linear mixed-effect model
ARd = autoregressive process for days
Hd =  heterogeneity of variances/standard deviations between days
ARm = autoregressive process for moments
Hm = heterogeneity of variances/standard deviations between moments
*/


functions {
  // ar(1) correlation matrix generator
  matrix ar1_corr_matrix(int m, real phi) {
    matrix[m, m] h;
    for (i in 1:m)
      for (j in 1:m)
        h[i, j] = phi ^  abs(i - j);
    return h;
  }
}

data {
  int<lower=1> N;
  int<lower=1> D;
  int<lower=1> M;
  vector[N*D*M] y;
}

parameters {
  // beta
  real beta; // ground mean (fixed effect)

  // s_raw
  vector[N] s_raw; // (non-centered) subject effect (random effect)
  real<lower=0> psi_s; // population sd for the subject effect

  // d_raw
  array[N] vector[D] d_raw; // (non-centered) day(/subject) effect (random effect)
  real<lower=0> psi_d; // population sd for the day effect (heterogenity between days)

  // nu_raw
  array[N] vector[D] nu_raw;
  array[N] real nu_0;
  real<lower=-1, upper=1> phi_d; // autoregressive parameter between days
  real<lower=0> tau2_d;

  // epsilon_raw
  real<lower=0> sigma_epsilon; // population sd for the measurment error (heterogenity between moments)
}

transformed parameters {
  // s
  vector[N] s = psi_s * s_raw; // subject effect (random effect)
  
  // d
  array[N] vector[D] d; // day(/subject) effect (random effect)
  for (i in 1:N) {
    d[i] = psi_d .* d_raw[i];
  }

  // nu
  real<lower=0> sigma_omega_d = sqrt((1 - phi_d^2) * tau2_d); 
  array[N] vector[D] nu;
  for (i in 1:N) {
    nu[i, 1] = phi_d * nu_0[i] + sigma_omega_d * nu_raw[i, 1];
    for (j in 2:D) {
      nu[i, j] = phi_d * nu[i, (j-1)] + sigma_omega_d * nu_raw[i, j];
    }
  }
  
  // epsilon
  cov_matrix[M] Sigma = diag_matrix(rep_vector(sigma_epsilon^2, M));
  matrix[M, M] L_Sigma = cholesky_decompose(Sigma);
}

model {
  vector[N] mu_i;
  array[N] vector[D] mu_ij;

  // Level 3:
  mu_i = beta + s;
  s_raw ~ std_normal();

  for (i in 1:N) {
    // Level 2:
    mu_ij[i] = mu_i[i] + d[i] + nu[i];
    d_raw[i] ~ std_normal();
    nu_raw[i] ~ std_normal();
    nu_0[i] ~ normal(0, 10);
    
    // Level 1:
    for (j in 1:D) {
      y[((i-1)*D*M + (j-1)*M + 1):((i-1)*D*M + (j-1)*M + M)] ~ multi_normal_cholesky(rep_vector(mu_ij[i, j], M), L_Sigma);
    }
  }
  
  // priors:
  phi_d ~ normal(0, 0.5) T[-1, 1];
  psi_d ~ cauchy(0, 2.5) T[0, ];
  psi_s ~ cauchy(0, 2.5) T[0, ];
  tau2_d ~ cauchy(0, 2.5) T[0, ];
}  

generated quantities {
  array[N, D] vector[M] y_hat; // fitted values
  for (i in 1:N) {
    for (j in 1:D) {
      y_hat[i, j] = rep_vector(beta + s[i], M) + d[i, j];
    }
  }

  real rel_T = (psi_s^2 + psi_d^2) / (psi_s^2 + psi_d^2 + tau2_d + sigma_epsilon^2); // R_T
}
