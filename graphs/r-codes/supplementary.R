# SUPPLEMENTARY: DECOMPOSITION

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
## Shared factor levels and labels
##--------------------------------------------------------

## Decomposition effect types (coef)
coef_levels <- c("1", "3", "2")
coef_labels <- c("Composition effects", "Coefficient effects", "Interaction effects")

## Parent-child dyads (dyn)
dyn_levels <- c("1", "2", "3", "4")
dyn_labels <- c("Father-Son", "Father-Daughter", "Mother-Son", "Mother-Daughter")

## Variable levels and labels - base model (no hosp variable)
var_levels_base <- c("0", "1", "2", "3", "4", "5", "6", "7",
                     "8", "9", "12", "13", "14", "15", "16",
                     "21", "22", "23", "24",
                     "10", "11",
                     "17", "18", "19", "20",
                     "25", "26", "27")

var_labels_base <- c("Intercept",
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

## Variable levels and labels - health model (adds Hospitalised; note different numeric ordering)
var_levels_health <- c("0", "1", "2", "3", "4", "5", "6", "7",
                       "8", "9",
                       "14", "15", "16", "17", "18",
                       "23", "24", "25", "26",
                       "12", "13",
                       "20", "19", "21", "22",
                       "27", "28", "29",
                       "10", "11")

var_labels_health <- c("Intercept",
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
                       "Parental age",
                       "Hospitalised: No",
                       "Hospitalised: Yes")


##--------------------------------------------------------
## Fig S2: Including health
##--------------------------------------------------------

## Detailed decomposition - proximity

dprox <- read_xlsx("data/supp_health/all_decomp_prox.xlsx", sheet = "prox")

dprox$coef <- factor(dprox$coef, levels = coef_levels,      labels = coef_labels)
dprox$dyn  <- factor(dprox$dyn,  levels = dyn_levels,       labels = dyn_labels)
dprox$var  <- factor(dprox$var,  levels = var_levels_health, labels = var_labels_health)

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

## Detailed decomposition - co-residence

dcor <- read_xlsx("data/supp_health/all_decomp_coresid.xlsx", sheet = "cores")

dcor$coef <- factor(dcor$coef, levels = coef_levels,      labels = coef_labels)
dcor$dyn  <- factor(dcor$dyn,  levels = dyn_levels,       labels = dyn_labels)
dcor$var  <- factor(dcor$var,  levels = var_levels_health, labels = var_labels_health)

gr_detailed_cor <- ggplot(dcor, aes(fill = coef, x = var, y = value, label = name)) +
  geom_bar(position = "stack", stat = "identity", width = 0.7, colour = "white") +
  coord_flip() +
  theme_minimal() +
  geom_hline(yintercept = 0, color = "grey40") +
  scale_fill_viridis(option = "E", direction = 1, discrete = T, begin = 0.3, end = 0.9, "",
                     limits = coef_labels) +
  facet_wrap(dyn ~ ., ncol = 4) +
  theme(panel.spacing = unit(2, "lines"),
        legend.position = "bottom") +
  xlab("") + ylab("Change in co-residence (percentage points)") +
  ggtitle("(b) Change in the prevalence of co-residence with a child") +
  theme(plot.title.position = "plot")
gr_detailed_cor

gr_detailed_comb <- ggarrange(gr_detailed_prox, gr_detailed_cor, nrow = 2, common.legend = TRUE, legend = "bottom")
gr_detailed_comb

ggsave("Fig_S2.svg", width = 3200, height = 3600, unit = "px")


##--------------------------------------------------------
## Fig S3: Sample limited to age 65-69
##--------------------------------------------------------

## Detailed decomposition - proximity

dprox <- read_xlsx("data/supp_age/all_decomp_prox.xlsx", sheet = "prox")

dprox$coef <- factor(dprox$coef, levels = coef_levels,    labels = coef_labels)
dprox$dyn  <- factor(dprox$dyn,  levels = dyn_levels,     labels = dyn_labels)
dprox$var  <- factor(dprox$var,  levels = var_levels_base, labels = var_labels_base)

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

## Detailed decomposition - co-residence

dcor <- read_xlsx("data/supp_age/all_decomp_coresid.xlsx", sheet = "cores")

dcor$coef <- factor(dcor$coef, levels = coef_levels,    labels = coef_labels)
dcor$dyn  <- factor(dcor$dyn,  levels = dyn_levels,     labels = dyn_labels)
dcor$var  <- factor(dcor$var,  levels = var_levels_base, labels = var_labels_base)

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

gr_detailed_comb <- ggarrange(gr_detailed_prox, gr_detailed_cor, nrow = 2, common.legend = TRUE, legend = "bottom")
gr_detailed_comb

ggsave("Fig_S3.svg", width = 3200, height = 3600, unit = "px")
dev.off()


##--------------------------------------------------------
## Fig S4: Trends in distance (km) - OSM
##--------------------------------------------------------

## Trends in median spatial proximity, including co-resident children

mindur1 <- read_xlsx("data/supp_trends_km.xlsx", sheet = "mindur")

mindur1$trend <- factor(mindur1$trend, levels = c("1","2"),
                        labels = c("Unadjusted", "Age-adjusted"))

mindur1$type <- factor(mindur1$type, levels = c("1","2","3","4"),
                       labels = c("Father-Son",
                                  "Father-Daughter",
                                  "Mother-Son",
                                  "Mother-Daughter"))

mindur1$dyn <- factor(mindur1$dyn, levels = c("1","2","3","4",
                                              "5","6","7","8"),
                      labels = c("Father-Son",
                                 "Father-Daughter",
                                 "Mother-Son",
                                 "Mother-Daughter",
                                 "Father-Son\n(age-adj)",
                                 "Father-Daughter\n(age-adj)",
                                 "Mother-Son\n(age-adj)",
                                 "Mother-Daughter\n(age-adj)"))

mindur1 <- mutate(mindur1, Label = ifelse((year == 2023 & trend == "Unadjusted"), name, NA))
mindur1 <- mutate(mindur1, lb = ifelse(trend == "Unadjusted", lb, NA), ub = ifelse(trend == "Unadjusted", ub, NA))

gr_medianprox1 <- ggplot(mindur1, aes(x = year, y = median, group = dyn, color = type, linetype = trend)) +
  geom_line(linewidth = 1.5) +
  geom_ribbon(aes(ymin = lb, ymax = ub), alpha = 0.1, colour = NA) +
  scale_color_viridis(discrete = T, begin = 0.1, end = 0.8, "", guide = "none") +
  labs(title = "(a) including co-resident children",
       x = "Year", y = "Median shortest route (kilometers)") +
  scale_x_continuous(breaks = seq(2003,2023,5),
                     limits = c(2002,2028),
                     expand = c(0,0)) +
  ylim(5,30) +
  theme_minimal() +
  theme(legend.position = "none",
        plot.caption = element_text(hjust = 0)) +
  geom_text_repel(aes(color = type, label = Label),
                  size = 3.5,
                  fontface = "bold",
                  direction = "y",
                  xlim = c(2024, NA),
                  hjust = 0) +
  theme(plot.title = element_text(margin = margin(0,0,20,0))) +
  theme(plot.title.position = "plot")

#+ labs(caption = "Dashed lines represent age-adjusted trends")
gr_medianprox1

## Trends in median spatial proximity, excluding co-resident children

mindur2 <- read_xlsx("data/supp_trends_km.xlsx", sheet = "mindur_ncor")

mindur2$trend <- factor(mindur2$trend, levels = c("1","2"),
                        labels = c("Unadjusted", "Age-adjusted"))

mindur2$type <- factor(mindur2$type, levels = c("1","2","3","4"),
                       labels = c("Father-Son",
                                  "Father-Daughter",
                                  "Mother-Son",
                                  "Mother-Daughter"))

mindur2$dyn <- factor(mindur2$dyn, levels = c("1","2","3","4",
                                              "5","6","7","8"),
                      labels = c("Father-Son",
                                 "Father-Daughter",
                                 "Mother-Son",
                                 "Mother-Daughter",
                                 "Father-Son\n(age-adj)",
                                 "Father-Daughter\n(age-adj)",
                                 "Mother-Son\n(age-adj)",
                                 "Mother-Daughter\n(age-adj)"))

mindur2 <- mutate(mindur2, Label = ifelse((year == 2023 & trend == "Unadjusted"), name, NA))
mindur2 <- mutate(mindur2, lb = ifelse(trend == "Unadjusted", lb, NA), ub = ifelse(trend == "Unadjusted", ub, NA))

gr_medianprox2 <- ggplot(mindur2, aes(x = year, y = median, group = dyn, color = type, linetype = trend)) +
  geom_line(linewidth = 1.5) +
  geom_ribbon(aes(ymin = lb, ymax = ub), alpha = 0.1, colour = NA) +
  scale_color_viridis(discrete = T, begin = 0.1, end = 0.8, "", guide = "none") +
  labs(title = "(b) excluding co-resident children",
       x = "Year", y = "Median shortest route (kilometers)") +
  scale_x_continuous(breaks = seq(2003,2023,5),
                     limits = c(2002,2028),
                     expand = c(0,0)) +
  ylim(5,30) +
  theme_minimal() +
  theme(legend.position = "none",
        plot.caption = element_text(hjust = 0)) +
  geom_text_repel(aes(color = type, label = Label),
                  size = 3.5,
                  fontface = "bold",
                  direction = "y",
                  xlim = c(2024, NA),
                  hjust = 0) +
  theme(plot.title = element_text(margin = margin(0,0,20,0))) +
  theme(plot.title.position = "plot")

gr_medianprox2

gr_medianprox_comb <- ggarrange(gr_medianprox1, gr_medianprox2, nrow = 2)
gr_medianprox_comb

ggsave("Fig_S4.svg", width = 2700, height = 3600, unit = "px")
dev.off()
