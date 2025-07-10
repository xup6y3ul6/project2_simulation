library(quarto)
library(tidyverse)

model_names <- list.files("stan/draws") |> 
  str_subset("20250702") 
  # str_replace_all(".rds", "")
model_names

for (m in model_names) {
  tryCatch({
    file_name <- str_glue("{m}_result.html")
    quarto::quarto_render(
      input = "ssm_fit_lmm_data.qmd",
      execute_params = list(model_name = m),
      output_file = file_name)

    file.rename(file_name, file.path("results", file_name))
    
    cat(str_glue("Finish: {m}\n"))
  }, error = function(e) {
    cat(str_glue("Failed: {m}\n"))
    cat(str_glue("Error: {e$message}\n"))
  })  
}
