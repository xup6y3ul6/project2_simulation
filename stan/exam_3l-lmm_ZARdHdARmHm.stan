/*
Three-level model for Exam data 
3l = three-level
lmm = linear mixed-effect model
Z = add covariate(s)
ARd = autoregressive process for days
Hd =  heterogeneity of variances/standard deviations between days
ADm = autoregressive process for moments
Hm = heterogeneity of variances/standard deviations between moments
*/


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
  int<lower=1> N; // number of subjects
  int<lower=1> D; // number of days
  int<lower=1> M; // number of time points
  vector[N*D*M] y_obs;
  vector[N*D*M] z_obs;
}

parameters {
  // Fixed effect
  // beta
  real beta; // ground mean

  // Random effect
  // s_raw
  vector[N] s_raw; // (non-centered) subject effect 
  real<lower=0> psi_s; // population sd for the subject effect
  // b_raw
  vector[N] b_raw; // (non-centered) effect for knowing exam results
  real<lower=0> psi_b; // population sd for the knowing eaxm results effect
  // d_raw
  array[N] vector[D] d_raw; // (non-centered) day(/subject) effect
  vector<lower=0>[D] psi_d; // population sd for the day effect (heterogenity between days)
  
  // Autoregression
  // nu_raw
  array[N] vector[D] nu_raw;
  real<lower=-1, upper=1> phi_d; // autoregressive parameter between days
  real<lower=0> tau2_d; // variance of the stationary AR(1) process for days
  // omega
  real<lower=-1, upper=1> phi_m; // autoregressive parameter between moments
  real<lower=0> tau2_m; // variance of the stationary AR(1) process for moments

  // Measurement error
  // epsilon
  vector<lower=0>[M] sigma_epsilon; // population sd for the measurment error (heterogenity between moments)
}

transformed parameters {
  // y, z reformate
  array[N, D] vector[M] y;
  array[N, D] vector[M] z;
  for (i in 1:N) {
    for (j in 1:D) {
      y[i, j] = y_obs[((i-1)*D*M + (j-1)*M + 1):((i-1)*D*M + (j-1)*M + M)];
      z[i, j] = z_obs[((i-1)*D*M + (j-1)*M + 1):((i-1)*D*M + (j-1)*M + M)];
    }
  }

  // Random effect
  // s
  vector[N] s = psi_s * s_raw; // subject effect
  // b
  vector[N] b = psi_b * b_raw; // knowing exam result effect 
  // d
  array[N] vector[D] d; // day(/subject) effect
  for (i in 1:N) {
    d[i] = psi_d .* d_raw[i];
  }

  // Autoregression
  // nu
  real<lower=0> sigma_omega_d = sqrt((1 - phi_d^2) * tau2_d); // sd of the innovation noise for days
  cov_matrix[D] H_d = ar1_corr_matrix(D, phi_d);
  cov_matrix[D] Sigma_d = tau2_d * H_d;
  matrix[D, D] L_Sigma_d = cholesky_decompose(Sigma_d);
  array[N] vector[D] nu;
  for (i in 1:N) {
    nu[i] = L_Sigma_d * nu_raw[i];
  }
  
  // omega
  real<lower=0> sigma_omega_m = sqrt((1 - phi_m^2) * tau2_m); // sd of the innovation noise for moments
  cov_matrix[M] H_m = ar1_corr_matrix(M, phi_m);
  cov_matrix[M] Sigma_m = tau2_m * H_m;
  
  // epsilon 
  cov_matrix[M] Sigma = diag_matrix(sigma_epsilon^2);
  
  // omega+epsilon
  cov_matrix[M] Sigma_mR = Sigma_m + Sigma;
  matrix[M, M] L_Sigma_mR = cholesky_decompose(Sigma_mR);
}

model {
  vector[N] mu_i;
  array[N] vector[D] mu_ij;

  // Likelihood
  // Level 3:
  mu_i = beta + s;
  s_raw ~ std_normal();
  b_raw ~ std_normal();

  for (i in 1:N) {
    // Level 2:
    mu_ij[i] = mu_i[i] + d[i] + nu[i];
    d_raw[i] ~ std_normal();
    nu_raw[i] ~ std_normal();

    for (j in 1:D) {
      // Level 1:
      y[i, j] ~ multi_normal_cholesky(rep_vector(mu_ij[i, j], M) + z[i, j] * b[i] , L_Sigma_mR);
    }
  }

  // Priors
  psi_s ~ cauchy(0, 2.5) T[0, ];
  psi_d ~ cauchy(0, 2.5) T[0, ];
  
  phi_d ~ normal(0, 0.5) T[-1, 1];
  tau2_d ~ cauchy(0, 2.5) T[0, ];
  
  phi_m ~ normal(0, 0.5) T[-1, 1];
  tau2_m ~ cauchy(0, 2.5) T[0, ];
}  

generated quantities {
  array[N, D] vector[M] y_hat; // fitted values
  for (i in 1:N) {
    for (j in 1:D) {
      y_hat[i, j] = rep_vector(beta + s[i] + d[i, j], M) + z[i, j] * b[i];
    }
  }

  real rel_T = (psi_s^2 + mean(psi_d^2)) / (psi_s^2 + mean(psi_d^2) + tau2_d + tau2_m + mean(sigma_epsilon^2)); // R_T
}
