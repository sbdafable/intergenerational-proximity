# TREND DECOMPOSITION OF INTERGENERATIONAL PROXIMITY

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

## Decomposition - overall, log distance

prox <- read_xlsx("data/decomp_prox.xlsx", sheet = "prox")

prox$gender <- factor(prox$gender, levels = c("1", "2", "3", "4"),
                      labels = c("Father-Son", "Father-Daughter",
                                 "Mother-Son", "Mother-Daughter"))

prox$component <- factor(prox$component, levels = c("1", "2", "3"),
                         labels = c("Composition effects", 
                                    "Coefficient effects", 
                                    "Interaction effects"))

gr_prox <- ggplot(prox, aes(x = gender, y = value, fill = component)) +
  geom_bar(width = 0.75, stat = "identity", color = "white", position = position_dodge()) +
  geom_errorbar(aes(ymin = lb, ymax = ub),
                width = 0.2, position = position_dodge(0.8)) +
  ylab("Effect (in minutes)") + xlab("") +
  theme_minimal() +
  theme(plot.title = element_text(margin = margin(0,0,20,0)),
        plot.title.position = "plot",
        axis.text.x = element_text(face = "bold")) +
  scale_fill_viridis(option = "E", discrete = T, begin = 0.3, end = 0.9, "")
  #ggtitle("(a) Change in the distance to the nearest child")
gr_prox

ggsave("Fig_3.svg", width = 2400, height = 1600, unit = "px")

## Decomposition - overall, co-residence

cor <- read_xlsx("data/decomp_coresid.xlsx", sheet = "cor")

cor$gender <- factor(cor$gender, levels = c("1", "2", "3", "4"),
                     labels = c("Father-Son", "Father-Daughter",
                                "Mother-Son", "Mother-Daughter"))

cor$component <- factor(cor$component, levels = c("1", "2", "3"),
                        labels = c("Composition effects", 
                                   "Coefficient effects", 
                                   "Interaction effects"))

gr_cor <- ggplot(cor, aes(x = gender, y = value, fill = component)) +
  geom_bar(width = 0.75, stat = "identity", color = "white", position = position_dodge()) +
  geom_errorbar(aes(ymin = lb, ymax = ub),
                width = 0.2, position = position_dodge(0.8)) +
  ylab("Effect (percentage points)") + xlab("") +
  theme_minimal() +
  theme(plot.title = element_text(margin = margin(0,0,20,0)),
        plot.title.position = "plot",
        axis.text.x = element_text(face = "bold")) +
  scale_fill_viridis(option = "E", discrete = T, begin = 0.3, end = 0.9, "")
  #ggtitle("(b) Change in the prevalence of co-residence with a child")
gr_cor

ggsave("Fig_5.svg", width = 2400, height = 1600, unit = "px")
