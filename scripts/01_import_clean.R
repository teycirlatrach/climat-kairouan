library(tidyverse)
library(lubridate)
library(janitor)

dir.create("output/clean", recursive = TRUE, showWarnings = FALSE)

# chemins
path_env   <- "data/environnement.csv"
path_pluie <- "data/pluviometrie.csv"
path_h10   <- "data/humidite_sol_10cm.csv"
path_h30   <- "data/humidite_sol_30cm.csv"

read_clean <- function(path) {
  read_csv(path, show_col_types = FALSE) %>%
    clean_names() %>%
    mutate(
      date = ymd_hms(date, quiet = TRUE),
      valeur = as.numeric(valeur)
    ) %>%
    filter(!is.na(date), !is.na(valeur))
}

data <- list(
  env   = read_clean(path_env),
  pluie = read_clean(path_pluie),
  hum10 = read_clean(path_h10),
  hum30 = read_clean(path_h30)
)

saveRDS(data, "output/clean/data_clean.rds")

cat("✅ Données nettoyées et sauvegardées\n")
