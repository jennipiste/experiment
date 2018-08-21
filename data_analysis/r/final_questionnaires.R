library(dplyr)
library(tidyr)
library(psych)
library(lme4)
library(lmerTest)
library(ggplot2)
library(lattice)
library(corrplot)
library(gridExtra)

data.questionnaires <- read.table("csv/final_questionnaires.csv", header = T, sep = ";", dec = ".")

data.firstlayout <- data.questionnaires[, 'first_layout']
data.preference <- data.questionnaires[, 'more_pleasant']
print(data.firstlayout)
print(data.preference)

cor <- cor(data.firstlayout, data.preference)
print(cor)

print(cor.test(data.firstlayout, data.preference))