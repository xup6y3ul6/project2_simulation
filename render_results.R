library(quarto)
library(tidyverse)

model_names <- list.files("data") |> 
  str_subset("20250611") |> 
  str_replace_all(".rds", "")
model_names

for (m in model_names) {
  file_name <- str_glue("{m}_result.html")
  quarto::quarto_render(
    input = "simulation_study_for_lmm_threelevel.qmd",
    execute_params = list(model_name = m),
    output_file = file_name)
  
  file.rename(file_name, file.path("results", file_name))
}

