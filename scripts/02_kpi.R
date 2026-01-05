library(tidyverse)
library(lubridate)

data <- readRDS("output/clean/data_clean.rds")

cat("\n===== KPI CLIMATIQUES =====\n")

# Température
temp <- data$env %>% filter(str_detect(nom_fr, "Température"))
cat("Température moyenne :", mean(temp$valeur), "°C\n")

# Humidité relative
hum <- data$env %>% filter(str_detect(nom_fr, "Humidité"))
cat("Humidité moyenne :", mean(hum$valeur), "%\n")

# Pluie totale
cat("Pluie totale :", sum(data$pluie$valeur), "mm\n")
