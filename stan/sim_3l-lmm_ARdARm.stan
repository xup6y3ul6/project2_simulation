
functions {
  // ar(1) correlation matrix generator
  matrix ar1_corr_matrix(int m, real phi) {
    matrix[m, m] h;
    for (i in 1:m)
      for (j in 1:m)
        h[i, j] = phi ^ abs(i - j);
    return h;
  }
}

data {
  int<lower=1> N;
  int<lower=1> D;
  int<lower=1> M;
  int<lower=0, upper=N*D*M> N_obs; 
  int<lower=0, upper=N*D*M> N_mis;
  array[N_obs] int<lower=1, upper=N*D*M> ii_obs;
  array[N_mis] int<lower=1, upper=N*D*M> ii_mis;
  vector[N_obs] y_obs;
}

parameters {
  vector[N_mis] y_mis;

  real beta; // ground mean (fixed effect)
  vector[N] s_raw; // (non-centered) subject effect (random effect)
  array[N] vector[D] d_raw; // (non-centered) day(/subject) effect (random effect)

  real<lower=0> psi_s; // population sd for the subject effect
  real<lower=0> psi_d; // population sd for the day effect

  real<lower=-1, upper=1> phi_d; // autoregressive parameter between days
  real<lower=-1, upper=1> phi_m; // autoregressive parameter between moments

  // real<lower=0> sigma_omega_d; // sd of the innovation noise for days
  // real<lower=0> sigma_omega_m; // sd of the innovation noise for moments
  real<lower=0> tau2_d;
  real<lower=0> tau2_m;
  
  real<lower=0> sigma_epsilon;
  array[N] vector[D] nu;
}

transformed parameters {
  vector[N_obs+N_mis] y_vec;
  y_vec[ii_obs] = y_obs;
  y_vec[ii_mis] = y_mis;
  array[N, D] vector[M] y;
  for (i in 1:N) {
    for (j in 1:D) {
      y[i, j] = y_vec[((i-1)*D*M + (j-1)*M + 1):((i-1)*D*M + (j-1)*M + M)];
    }
  }

  vector[N] s = psi_s * s_raw; // subject effect (random effect)
  array[N] vector[D] d; // day(/subject) effect (random effect)
  for (i in 1:N) {
    d[i] = psi_d .* d_raw[i];
  }

  // real<lower=0> tau2_m = sigma_omega_m^2 / (1 - phi_m^2); // variance of the stationary AR(1) process for moments
  // real<lower=0> tau2_d = sigma_omega_d^2 / (1 - phi_d^2); // variance of the stationary AR(1) process for days
  real<lower=0> sigma_omega_d = sqrt((1 - phi_d^2) * tau2_d); 
  real<lower=0> sigma_omega_m = sqrt((1 - phi_m^2) * tau2_m); 
  
  cov_matrix[M] Sigma = diag_matrix(rep_vector(sigma_epsilon^2, M));
  cov_matrix[M] H_m = ar1_corr_matrix(M, phi_m);
  cov_matrix[M] Sigma_m = tau2_m * H_m + Sigma;
  cov_matrix[M] Sigma_mR = Sigma_m + Sigma;
  matrix[M, M] L_Sigma_mR = cholesky_decompose(Sigma_mR);
  
  cov_matrix[D] H_d = ar1_corr_matrix(D, phi_d);
  cov_matrix[D] Sigma_d = tau2_d * H_d;
  matrix[D, D] L_Sigma_d = cholesky_decompose(Sigma_d);
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
    nu[i] ~ multi_normal_cholesky(rep_vector(0, D), L_Sigma_d);
    
    // Level 1:
    for (j in 1:D) {
      y[i, j] ~ multi_normal_cholesky(rep_vector(mu_ij[i, j], M), L_Sigma_mR);
    }
  }

  // priors:
  phi_d ~ normal(0, 0.5) T[-1, 1];
  phi_m ~ normal(0, 0.5) T[-1, 1];
  psi_d ~ cauchy(0, 2.5) T[0, ];
  psi_s ~ cauchy(0, 2.5) T[0, ];
  tau2_d ~ cauchy(0, 2.5) T[0, ];
  tau2_m ~ cauchy(0, 2.5) T[0, ];
}  

generated quantities {
  array[N, D] vector[M] y_hat; // fitted values
  for (i in 1:N) {
    for (j in 1:D) {
      y_hat[i, j] = rep_vector(beta + s[i], M) + d[i, j];
    }
  

  real rel_T = (psi_s^2 + psi_d^2) / (psi_s^2 + psi_d^2 + tau2_d + tau2_m + sigma_epsilon^2); // R_T
  }
}

