library(tidyverse)
library(lubridate)

dir.create("output/graphs", recursive = TRUE, showWarnings = FALSE)
data <- readRDS("output/clean/data_clean.rds")

# 🌡️ Température journalière
temp_jour <- data$env %>%
  filter(str_detect(nom_fr, "Température")) %>%
  mutate(jour = as.Date(date)) %>%
  group_by(jour) %>%
  summarise(temp_moy = mean(valeur))

ggplot(temp_jour, aes(jour, temp_moy)) +
  geom_line(color = "red") +
  geom_point() +
  labs(title = "Température moyenne journalière", y = "°C")

ggsave("output/graphs/temperature.png", width = 8, height = 4)

# 💧 Humidité du sol
hum <- bind_rows(
  data$hum10 %>% mutate(profondeur = "10 cm"),
  data$hum30 %>% mutate(profondeur = "30 cm")
) %>%
  mutate(jour = as.Date(date)) %>%
  group_by(jour, profondeur) %>%
  summarise(hum_moy = mean(valeur))

ggplot(hum, aes(jour, hum_moy, color = profondeur)) +
  geom_line() +
  labs(title = "Humidité du sol moyenne", y = "%")

ggsave("output/graphs/humidite_sol.png", width = 8, height = 4)

# 🌧️ Pluie journalière (SUM PAS MAX ❗)
pluie_jour <- data$pluie %>%
  mutate(jour = as.Date(date)) %>%
  group_by(jour) %>%
  summarise(pluie = sum(valeur))

ggplot(pluie_jour, aes(jour, pluie)) +
  geom_col(fill = "steelblue") +
  labs(title = "Pluie totale par jour", y = "mm")

ggsave("output/graphs/pluie.png", width = 8, height = 4)

cat("✅ Graphes générés dans output/graphs\n")
