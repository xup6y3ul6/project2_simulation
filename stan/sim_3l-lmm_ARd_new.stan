data {
  int<lower=1> N;
  int<lower=1> D;
  int<lower=1> M;
  array[N, D, M] real y;
}

parameters {
  // beta
  real beta; // ground mean (fixed effect)
  
  // s
  vector[N] s;
  real<lower=0> psi_s; // population sd for the subject effect

  // d
  array[N] vector[D] d;
  real<lower=0> psi_d; // population sd for the day effect (heterogenity between days)

  // nu
  real<lower=-1, upper=1> phi_d; // autoregressive parameter between days
  real<lower=0> sigma_nu_d;

  // epsilon
  real<lower=0> sigma_epsilon; // population sd for the measurment error (heterogenity between moments)
}

model {
  array[N] vector[D] nu;
  array[N] vector[D] nu_lat;
  array[N] vector[D] mu_ij;

  for (i in 1:N) {
    s[i] ~ normal(0, psi_s);

    for (j in 1:D) {
      d[i, j] ~ normal(0, psi_d);
    }

    nu[i, 1] ~ normal(0, sigma_nu_d);
    for (j in 2:D) {
      nu[i, j] ~ normal(nu_lat[i, j], sigma_nu_d);
      nu_lat[i, j] = phi_d * nu[i, j-1];
    }

    for (j in 1:D) {
      mu_ij[i, j] = beta + s[i] + d[i, j] + nu[i, j];
      for (k in 1:M) {
        y[i, j, k] ~ normal(mu_ij[i, j], sigma_epsilon);
      }
    }

  }
  
  // priors:
  beta ~ normal(0, sqrt(1000));
  phi_d ~ normal(0, 0.5) T[-1, 1];
  psi_d ~ cauchy(0, 2.5) T[0, ];
  psi_s ~ cauchy(0, 2.5) T[0, ];
  sigma_nu_d ~ cauchy(0, 2.5) T[0, ];
}  

generated quantities {
  real<lower=0> tau2_d = sigma_nu_d^2/ (1 - phi_d^2);
  real rel_T = (psi_s^2 + psi_d^2) / (psi_s^2 + psi_d^2 + tau2_d + sigma_epsilon^2); // R_T
}
