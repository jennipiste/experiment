# all libraries copy-pasted
library(dplyr)
library(tidyr)
library(psych)
library(lme4)
library(lmerTest)
library(ggplot2)
library(lattice)
library(corrplot)
library(gridExtra)

data.reactions <- read.table("csv/reaction_times.csv", header = T, sep = ";", dec = ",")

## RT model. Only main effects. Remove "scale" to get non-std model.
m1 <- lmer(scale(reaction_time) ~ as.factor(layout) + as.factor(chats) + (1|participant), data = data.reactions)
print(summary(m1))

## Boxplot of the main effects.
ggplot(data.reactions %>%
       group_by(participant,layout,chats) %>%
       summarise(reaction_time = mean(reaction_time)),
       aes(as.factor(layout), reaction_time, fill = as.factor(chats))) +
    geom_boxplot()

## Histogram of the main effects. Error bars will be misleading
## because they don't consider the within-subject design, so better
## use boxplots.
p1 <- ggplot(data.reactions %>%
       group_by(participant,layout,chats) %>%
       summarise(reaction_time = mean(reaction_time)) %>%
       group_by(layout,chats) %>%
       summarise(sd = sd(reaction_time),
                 mean = mean(reaction_time)) %>%
       mutate(se = sd / sqrt(24), ci = 1.96*se) %>%
       mutate(se.min = mean - se, se.max = mean + se,
              ci.min = mean - ci, ci.max = mean + ci),
       aes(as.factor(layout), mean, fill = as.factor(chats))) +
    geom_bar(stat = "identity", width = 0.7, position = position_dodge(0.9)) +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3), position=position_dodge(0.9))
dev.new()
plot(p1)

data.durations <- read.table("csv/chat_durations.csv", header = T, sep = ";", dec = ",")

## Duration model. Only main effects.
m2 <- lmer(scale(duration) ~ as.factor(layout) + as.factor(chats) + (1|participant), data = data.durations)
print(summary(m2))

## Boxplot of the main effects.
p2 <- ggplot(data.durations %>%
       group_by(participant,layout,chats) %>%
       summarise(duration = mean(duration)),
       aes(as.factor(layout), duration, fill = as.factor(chats))) +
    geom_boxplot()
dev.new()
plot(p2)

data.firstresponses <- read.table("csv/first_response_times.csv", header = T, sep = ";", dec = ",")

## Duration model. Only main effects.
m3 <- lmer(scale(first_response_time) ~ as.factor(layout) + as.factor(chats) + (1|participant),
           data = data.firstresponses %>% filter(first_response_time < 30))
print(summary(m3))

## Boxplot of the main effects.
p3 <- ggplot(data.firstresponses %>%
       group_by(participant,layout,chats) %>%
       summarise(first_response_time = mean(first_response_time)),
       aes(as.factor(layout), first_response_time, fill = as.factor(chats))) +
    geom_boxplot()
dev.new()
plot(p3)