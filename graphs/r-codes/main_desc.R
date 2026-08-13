# TRENDS IN INTERGENERATIONAL PROXIMITY AND CO-RESIDENCE

setwd("C:/Users/sba4/OneDrive - University of St Andrews/PhD Paper 2/Stata-do/graphs")

library(tidyverse)
library(readxl)
library(ggpubr)
library(ggrepel)
library(ggtext)
library(showtext)
library(viridis)
library(svglite)

font_add_google("Crimson Pro")
showtext_auto()

##--------------------------------------------------------
## Co-residence
##--------------------------------------------------------

## Trends in co-residence

cor <- read_xlsx("data/trends.xlsx", sheet = "cor")

cor$trend <- factor(cor$trend, levels = c("1","2"),
                    labels = c("Unadjusted", "Age-adjusted"))

cor$type <- factor(cor$type, levels = c("1","2","3","4"),
                   labels = c("Father-Son",
                              "Father-Daughter",
                              "Mother-Son",
                              "Mother-Daughter"))

cor$dyn <- factor(cor$dyn, levels = c("1","2","3","4","5","6","7","8"),
                  labels = c("Father-Son",
                             "Father-Daughter",
                             "Mother-Son",
                             "Mother-Daughter",
                             "Father-Son\n(age-adj)",
                             "Father-Daughter\n(age-adj)",
                             "Mother-Son\n(age-adj)",
                             "Mother-Daughter\n(age-adj)"))

cor <- mutate(cor,
              Label = ifelse((year == 2023 & trend == "Unadjusted"), name, NA),
              lb    = ifelse(trend == "Unadjusted", lb, NA),
              ub    = ifelse(trend == "Unadjusted", ub, NA))

gr_cor <- ggplot(cor, aes(x = year, y = percent, group = dyn, color = type, linetype = trend)) +
  geom_line(linewidth = 1.5) +
  geom_ribbon(aes(ymin = lb, ymax = ub), alpha = 0.1, colour = NA) +
  scale_color_viridis(discrete = T, begin = 0.1, end = 0.8, "", guide = "none") +
  labs(x = "Year", y = "Percentage co-residing") +
  scale_x_continuous(breaks = seq(2003,2023,5),
                     limits = c(2002,2027),
                     expand = c(0,0)) +
  ylim(0,20) +
  theme_minimal() +
  theme(legend.position = "none",
        plot.caption = element_text(hjust = 0)) +
  geom_text_repel(aes(color = type, label = Label),
                  size = 3.5,
                  fontface = "bold",
                  direction = "y",
                  xlim = c(2024, NA),
                  hjust = 0)
gr_cor

ggsave("Fig_1.svg", width = 2700, height = 1800, unit = "px")


##--------------------------------------------------------
## Proximity
##--------------------------------------------------------


## Trends in median spatial proximity, including co-resident children

mindur1 <- read_xlsx("data/trends.xlsx", sheet = "mindur")

mindur1$trend <- factor(mindur1$trend, levels = c("1","2"),
                        labels = c("Unadjusted", "Age-adjusted"))

mindur1$type <- factor(mindur1$type, levels = c("1","2","3","4"),
                       labels = c("Father-Son",
                                  "Father-Daughter",
                                  "Mother-Son",
                                  "Mother-Daughter"))

mindur1$dyn <- factor(mindur1$dyn, levels = c("1","2","3","4","5","6","7","8"),
                      labels = c("Father-Son",
                                 "Father-Daughter",
                                 "Mother-Son",
                                 "Mother-Daughter",
                                 "Father-Son\n(age-adj)",
                                 "Father-Daughter\n(age-adj)",
                                 "Mother-Son\n(age-adj)",
                                 "Mother-Daughter\n(age-adj)"))

mindur1 <- mutate(mindur1,
                  Label = ifelse((year == 2023 & trend == "Unadjusted"), name, NA),
                  lb    = ifelse(trend == "Unadjusted", lb, NA),
                  ub    = ifelse(trend == "Unadjusted", ub, NA))

gr_medianprox1 <- ggplot(mindur1, aes(x = year, y = median, group = dyn, color = type, linetype = trend)) +
  geom_line(linewidth = 1.5) +
  geom_ribbon(aes(ymin = lb, ymax = ub), alpha = 0.1, colour = NA) +
  scale_color_viridis(option = "plasma", discrete = T, begin = 0.2, end = 0.7, "", guide = "none") +
  labs(title = "(a) including co-resident children",
       x = "Year", y = "Median shortest travel time (minutes)") +
  scale_x_continuous(breaks = seq(2003,2023,5),
                     limits = c(2002,2028),
                     expand = c(0,0)) +
  ylim(10,35) +
  theme_minimal() +
  theme(legend.position = "none",
        plot.caption = element_text(hjust = 0),
        plot.title = element_text(margin = margin(0,0,20,0)),
        plot.title.position = "plot") +
  geom_text_repel(aes(color = type, label = Label),
                  size = 3.5,
                  fontface = "bold",
                  direction = "y",
                  xlim = c(2024, NA),
                  hjust = 0)
  #+ labs(caption = "Dashed lines represent age-adjusted trends")
gr_medianprox1

## Trends in median spatial proximity, excluding co-resident children

mindur2 <- read_xlsx("data/trends.xlsx", sheet = "mindur_ncor")

mindur2$trend <- factor(mindur2$trend, levels = c("1","2"),
                        labels = c("Unadjusted", "Age-adjusted"))

mindur2$type <- factor(mindur2$type, levels = c("1","2","3","4"),
                       labels = c("Father-Son",
                                  "Father-Daughter",
                                  "Mother-Son",
                                  "Mother-Daughter"))

mindur2$dyn <- factor(mindur2$dyn, levels = c("1","2","3","4","5","6","7","8"),
                      labels = c("Father-Son",
                                 "Father-Daughter",
                                 "Mother-Son",
                                 "Mother-Daughter",
                                 "Father-Son\n(age-adj)",
                                 "Father-Daughter\n(age-adj)",
                                 "Mother-Son\n(age-adj)",
                                 "Mother-Daughter\n(age-adj)"))

mindur2 <- mutate(mindur2,
                  Label = ifelse((year == 2023 & trend == "Unadjusted"), name, NA),
                  lb    = ifelse(trend == "Unadjusted", lb, NA),
                  ub    = ifelse(trend == "Unadjusted", ub, NA))

gr_medianprox2 <- ggplot(mindur2, aes(x = year, y = median, group = dyn, color = type, linetype = trend)) +
  geom_line(linewidth = 1.5) +
  geom_ribbon(aes(ymin = lb, ymax = ub), alpha = 0.1, colour = NA) +
  scale_color_viridis(option = "plasma", discrete = T, begin = 0.2, end = 0.7, "", guide = "none") +
  labs(title = "(b) excluding co-resident children",
       x = "Year", y = "Median shortest travel time (minutes)") +
  scale_x_continuous(breaks = seq(2003,2023,5),
                     limits = c(2002,2028),
                     expand = c(0,0)) +
  ylim(10,35) +
  theme_minimal() +
  theme(legend.position = "none",
        plot.caption = element_text(hjust = 0),
        plot.title = element_text(margin = margin(0,0,20,0)),
        plot.title.position = "plot") +
  geom_text_repel(aes(color = type, label = Label),
                  size = 3.5,
                  fontface = "bold",
                  direction = "y",
                  xlim = c(2024, NA),
                  hjust = 0)
gr_medianprox2

gr_medianprox_comb <- ggarrange(gr_medianprox1, gr_medianprox2, nrow = 2) +
  labs(caption = "Dashed lines represent age-adjusted trends. Shaded areas represent 95% confidence intervals.")
gr_medianprox_comb

ggsave("Fig_2.svg", width = 2700, height = 3600, unit = "px")

