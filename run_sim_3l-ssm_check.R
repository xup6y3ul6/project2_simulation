# Receive shell arguments outside the Rscript
args <- commandArgs(trailingOnly = TRUE)

model_name <- ifelse(length(args) >= 1, args[1], "sim_3l-ssm_ARdHdARmHm")
N <- 20
D <- 20
M <- 20
seed <- 20250611

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

# set.seed
set.seed(seed)

# load data
data_name <- str_glue("data/{file_name}.rds") |> str_replace("ssm", "lmm")
data <- read_rds(data_name)


#######################################

cat("Run MCMC by Stan \n")

cat("SLURM_CPUS_PER_TASK = ", Sys.getenv("SLURM_CPUS_PER_TASK"), "\n")
cat("nproc = ", parallel::detectCores(), "\n")


output_dir_lmm = str_glue("stan/draws/{file_name}")

if (dir.exists(output_dir_lmm)) {
  file.remove(list.files(output_dir_lmm, full.names = TRUE))
} else {
  dir.create(output_dir_lmm, recursive = TRUE)
}

lmm_data <- lst(N = N,
                D = D,
                M = M,
                y = data$y)

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
