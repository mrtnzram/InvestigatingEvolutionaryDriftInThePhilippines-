# =============================================================================
# Grammar Analysis — Shuffled (null-model) EEMS surface
# Reads the shuffled grammar EEMS MCMC output, builds the land-masked migration
# and diversity surfaces, and overlays match-score points. Note: this saves over
# base_plot_GA.rds, so re-run [2]_eems_plot_GA_span.R afterwards to restore the
# real base map.
# Output: data/base_plot_GA.rds (shuffled variant)
# =============================================================================

library("reemsplots2")
library(ggplot2)
library(dplyr)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(maps)
library(here)

# ---- 1. Load shuffled EEMS MCMC output and the match-score table ----
mcmcpath <- here("matlab", "matlab_eems_grammar_shuffled", "datapath-g8x8-simno1")
GRAMFEATURE_match_df <- read.csv(here("data", "GRAMFEATURE_match_df.csv"))

# ---- 2. Generate the standard EEMS diagnostic plots ----
plots <- make_eems_plots(mcmcpath, longlat = TRUE)

names(plots)

print(plots$mrates01)

plots$mrates01
plots$qrates02
plots$rdist01
plots$pilogl01

str(plots$mrates02$data)
summary(plots$mrates02$data)

# ---- 3. Quick look: land-masked log-migration surface ----
ph_shape <- ne_countries(scale = "medium", country = "Philippines", returnclass = "sf")
ph_union <- st_union(ph_shape)

data_log <- plots$mrates02$data %>%
  mutate(z_log = log(z))

data_pts <- st_as_sf(data_log, coords = c("y", "x"), crs = 4326)

data_masked <- data_pts[st_intersects(data_pts, ph_union, sparse = FALSE), ]

coords <- st_coordinates(data_masked)
data_masked$x <- coords[, "Y"]
data_masked$y <- coords[, "X"]

ggplot() +
  geom_tile(data = data_masked, aes(x = y, y = x, fill = z_log)) +
  geom_sf(data = ph_shape, fill = NA, color = "black") +
  scale_fill_gradientn(
    colors = c("cyan", "white", "orange"),
    limits = range(data_masked$z_log, na.rm = TRUE),
    na.value = "transparent"
  ) +
  coord_sf(xlim = c(116, 127), ylim = c(4, 21), expand = FALSE) +
  labs(
    fill = "log(Migration Rate)",
    x = "Longitude",
    y = "Latitude"
  ) +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    axis.text = element_text(size = 10),
    axis.title = element_text(size = 12)
  )

# ---- 4. Base map: masked migration surface + match-score points and labels ----
data_log <- plots$mrates02$data %>%
  mutate(z_log = log(z))

tile_sf <- st_as_sf(data_log, coords = c("y", "x"), crs = 4326)

ph_shape <- ne_countries(scale = "medium", country = "Philippines", returnclass = "sf")
ph_union <- st_union(ph_shape)

tiles_masked <- tile_sf[st_intersects(tile_sf, ph_union, sparse = FALSE), ]

coords <- st_coordinates(tiles_masked)
tiles_masked$x <- coords[, "Y"]
tiles_masked$y <- coords[, "X"]

world_map <- map_data("world")
map_subset <- world_map %>% filter(region %in% c("Philippines", "Malaysia"))

label_df <- GRAMFEATURE_match_df %>%
  arrange(desc(zscore_span)) %>%
  distinct(language, .keep_all = TRUE) %>%
  slice_head(n = 10)

base_plot <- ggplot() +
  geom_tile(data = tiles_masked, aes(x = y, y = x, fill = z_log), alpha = 0.85) +
  geom_polygon(data = map_subset, aes(x = long, y = lat, group = group),
               fill = NA, color = "black") +
  geom_point(data = GRAMFEATURE_match_df,
             aes(x = longitude, y = latitude, color = match_score_span),
             size = 10, alpha = 0.7) +
  geom_point(data = label_df, aes(x = longitude, y = latitude),
             size = 10, shape = 21, color = "black") +
  geom_text(data = label_df,
            aes(x = longitude, y = latitude, label = language),
            size = 2.5, fontface = "italic", color = "black", check_overlap = TRUE,
            nudge_y = 0.6) +
  scale_fill_gradientn(
    colors = c("orange", "white", "#0096FF"),
    limits = range(tiles_masked$z_log, na.rm = TRUE),
    na.value = "transparent"
  ) +
  scale_color_gradient(low = "white", high = "navy") +
  guides(
    fill = guide_colorbar(title = "log(Migration Rate)", title.position = "top", title.hjust = 0.5),
    color = guide_colorbar(title = "Match Score (Spanish)", title.position = "top", title.hjust = 0.5)
  ) +
  coord_fixed(xlim = c(115, 130), ylim = c(4, 22)) +
  scale_x_continuous(breaks = seq(115, 130, by = 2)) +
  scale_y_continuous(breaks = seq(4, 22, by = 2)) +
  labs(
    title = "Linguistic Z-Scores Over Migration Surface",
    x = "Longitude",
    y = "Latitude"
  ) +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    axis.text = element_text(size = 10),
    axis.title = element_text(size = 12)
  )

saveRDS(base_plot, file = here("data", "base_plot_GA.rds"))

# ---- 5. Diversity-rate surface with match-score points and top labels ----
data_log <- plots$qrates02$data %>%
  mutate(z_log = log(z))

tile_sf <- st_as_sf(data_log, coords = c("y", "x"), crs = 4326)

ph_shape <- ne_countries(scale = "medium", country = "Philippines", returnclass = "sf")
ph_union <- st_union(ph_shape)

tiles_masked <- tile_sf[st_intersects(tile_sf, ph_union, sparse = FALSE), ]

coords <- st_coordinates(tiles_masked)
tiles_masked$x <- coords[, "Y"]
tiles_masked$y <- coords[, "X"]

world_map <- map_data("world")
map_subset <- world_map %>% filter(region %in% c("Philippines", "Malaysia"))

label_df <- GRAMFEATURE_match_df %>%
  arrange(desc(zscore_span)) %>%
  distinct(language, .keep_all = TRUE) %>%
  slice_head(n = 10)

ggplot() +
  geom_tile(data = tiles_masked, aes(x = y, y = x, fill = z_log), alpha = 0.6) +
  geom_polygon(data = map_subset, aes(x = long, y = lat, group = group),
               fill = NA, color = "black") +
  geom_point(data = GRAMFEATURE_match_df,
             aes(x = longitude, y = latitude, color = match_score_span),
             size = 10, alpha = 0.7) +
  geom_point(data = label_df, aes(x = longitude, y = latitude),
             size = 10, shape = 21, color = "black") +
  geom_text(data = label_df,
            aes(x = longitude, y = latitude, label = language),
            size = 2.5, fontface = "italic", color = "black", check_overlap = TRUE,
            nudge_y = 0.6) +
  scale_fill_gradientn(
    colors = c("orange", "white", "#0096FF"),
    limits = range(tiles_masked$z_log, na.rm = TRUE),
    na.value = "transparent"
  ) +
  scale_color_gradient(low = "white", high = "navy") +
  guides(
    fill = guide_colorbar(title = "log(Diversity Rate)", title.position = "top", title.hjust = 0.5),
    color = guide_colorbar(title = "Match Score (Spanish)", title.position = "top", title.hjust = 0.5)
  ) +
  coord_fixed(xlim = c(115, 130), ylim = c(4, 22)) +
  scale_x_continuous(breaks = seq(115, 130, by = 2)) +
  scale_y_continuous(breaks = seq(4, 22, by = 2)) +
  labs(
    title = "Linguistic Z-Scores Over Diversity Surface",
    x = "Longitude",
    y = "Latitude"
  ) +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    axis.text = element_text(size = 10),
    axis.title = element_text(size = 12)
  )
