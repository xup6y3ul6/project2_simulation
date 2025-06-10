/*
Three-level model for simulation study
3l = three-level
lmm = linear mixed-effect model
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
    mu_ij[i] = mu_i[i] + d[i];
    d_raw[i] ~ std_normal();
    
    // Level 1:
    for (j in 1:D) {
      y[((i-1)*D*M + (j-1)*M + 1):((i-1)*D*M + (j-1)*M + M)] ~ multi_normal_cholesky(rep_vector(mu_ij[i, j], M), L_Sigma);
    }
  }
  
  // priors:
  psi_d ~ cauchy(0, 2.5) T[0, ];
  psi_s ~ cauchy(0, 2.5) T[0, ];
}  

generated quantities {
  array[N, D] vector[M] y_hat; // fitted values
  for (i in 1:N) {
    for (j in 1:D) {
      y_hat[i, j] = rep_vector(beta + s[i], M) + d[i, j];
    }
  }

  real rel_T = (psi_s^2 + psi_d^2) / (psi_s^2 + psi_d^2 + sigma_epsilon^2); // R_T
}
