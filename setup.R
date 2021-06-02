## Packages

library(vegan)
library(ggplot2)
library(reshape2)
library(here)
library(tidyverse)
library(scales)
library(phyloseq)
library(cowplot)
library(ggtext)
library(rio)

### Functions


### Settings

theme_set(theme_minimal())

### Data

data.priming <- read.csv(here("data", "priming_amoA_deltaCt.csv"), header = T) %>% 
  rename(sample_id = X) 

data.raw <- read.csv(here("data", "priming_amoA_rawCt.csv"), header = T) %>% 
  rename(sample_id = X)

data.priming.long <- data.priming %>% 
  pivot_longer(cols = amoA.001:amoA.078, names_to = "amoA", values_to = "deltaCT")


data.raw.long <- data.raw %>% 
  pivot_longer(cols = amoA.001:amoA.078, names_to = "amoA", values_to = "CT")

data.priming.long$sample_id <- fct_reorder(data.priming.long$sample_id, parse_number(data.priming.long$sample_id))

non_detect_counts <- data.raw.long %>%
  group_by(fert_level, amoA) %>% 
  count(CT == 40) %>% 
  rename(non_detect = `CT == 40`) %>%
  filter(non_detect == TRUE) 

removes <- non_detect_counts %>% 
  pivot_wider(names_from = fert_level, values_from = n, names_prefix = "fert.") %>%
  filter(fert.0 > 30 & fert.336 > 30) %>%
  pivot_longer(cols = fert.0:fert.336, names_to = "fert_level", values_to = "n")


