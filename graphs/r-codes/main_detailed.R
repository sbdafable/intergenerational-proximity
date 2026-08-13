# DETAILED DECOMPOSITION OF INTERGENERATIONAL PROXIMITY

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

# Variable levels and labels shared across proximity and co-residence plots
var_levels <- c("0", "1", "2", "3", "4", "5", "6", "7",
                "8", "9", "12", "13", "14", "15", "16",
                "21", "22", "23", "24",
                "10", "11",
                "17", "18", "19", "20",
                "25", "26", "27")

var_labels <- c("Intercept",
                "Number of grandchildren",
                "Any child lost job: No",
                "Any child lost job: Yes",
                "Any child divorced: No",
                "Any child divorced: Yes",
                "Any child college-educated: No",
                "Any child college-educated: Yes",
                "Median age of children",
                "Number of children",
                "Region: Aland",
                "Region: North & East Finland",
                "Region: South Finland",
                "Region: Helsinki-Uusimaa",
                "Region: West Finland",
                "Residence: Urban",
                "Residence: Rural",
                "Homeownership: Yes",
                "Homeownership: No",
                "Parent employed: No",
                "Parent employed: Yes",
                "Marital status: Widowed",
                "Marital status: Divorced",
                "Marital status: Married/Registered",
                "Marital status: Never-married",
                "Parent college-educated: No",
                "Parent college-educated: Yes",
                "Parental age")

coef_levels <- c("1", "3", "2")
coef_labels <- c("Composition effects", "Coefficient effects", "Interaction effects")

dyn_levels <- c("1", "2", "3", "4")
dyn_labels <- c("Father-Son", "Father-Daughter", "Mother-Son", "Mother-Daughter")


## Detailed decomposition - proximity

dprox <- read_xlsx("data/all_decomp_prox.xlsx", sheet = "prox")

dprox$coef <- factor(dprox$coef, levels = coef_levels, labels = coef_labels)
dprox$dyn  <- factor(dprox$dyn,  levels = dyn_levels,  labels = dyn_labels)
dprox$var  <- factor(dprox$var,  levels = var_levels,  labels = var_labels)

gr_detailed_prox <- ggplot(dprox, aes(fill = coef, x = var, y = value, label = name)) +
  geom_bar(position = "stack", stat = "identity", width = 0.7, colour = "white") +
  coord_flip() +
  theme_minimal() +
  geom_hline(yintercept = 0, color = "grey40") +
  scale_fill_viridis(option = "E", direction = 1, discrete = T, begin = 0.3, end = 0.9, "",
                     limits = coef_labels) +
  facet_wrap(dyn ~ ., ncol = 4) +
  theme(panel.spacing = unit(2, "lines"),
        legend.position = "top") +
  xlab("") + ylab("Change in distance (minutes)")
gr_detailed_prox

ggsave("Fig_4.svg", width = 3200, height = 1800, unit = "px")


## Detailed decomposition - co-residence

dcor <- read_xlsx("data/all_decomp_coresid.xlsx", sheet = "cores")

dcor$coef <- factor(dcor$coef, levels = coef_levels, labels = coef_labels)
dcor$dyn  <- factor(dcor$dyn,  levels = dyn_levels,  labels = dyn_labels)
dcor$var  <- factor(dcor$var,  levels = var_levels,  labels = var_labels)

gr_detailed_cor <- ggplot(dcor, aes(fill = coef, x = var, y = value, label = name)) +
  geom_bar(position = "stack", stat = "identity", width = 0.7, colour = "white") +
  coord_flip() +
  theme_minimal() +
  geom_hline(yintercept = 0, color = "grey40") +
  scale_fill_viridis(option = "E", direction = 1, discrete = T, begin = 0.3, end = 0.9, "",
                     limits = coef_labels) +
  facet_wrap(dyn ~ ., ncol = 4) +
  theme(panel.spacing = unit(2, "lines"),
        legend.position = "top") +
  xlab("") + ylab("Change in the prevalence of co-residence with a child")
gr_detailed_cor

ggsave("Fig_6.svg", width = 3200, height = 1800, unit = "px")
