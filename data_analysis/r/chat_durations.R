library(dplyr)
library(tidyr)
library(psych)
library(lme4)
library(lmerTest)
library(ggplot2)
library(lattice)
library(corrplot)
library(gridExtra)

data.durations <- read.table("csv/chat_durations.csv", header = T, sep = ";", dec = ",")

# # Anova
# data.durations.aov <- with(data.durations,
# 	aov(duration ~ as.factor(layout) * as.factor(chats) + Error(participant / (as.factor(layout) * as.factor(chats))))
# )
# # print(summary(data.durations.aov))

# # Linear mixed model
# m1 <- lmer(duration ~ as.factor(layout) * as.factor(chats) + (1|participant) + (1|part) + (1|topic), data = data.durations)
# print(summary(m1))

# dev.new()
# print(densityplot(data.durations$duration))

# Both again with participant means for each condition
data.durations.mean <- aggregate(data.durations$duration,
	by = list(data.durations$participant, data.durations$layout, data.durations$chats),
	FUN = mean
)
colnames(data.durations.mean) <- c("participant", "layout", "chats", "duration")

data.durations.mean.aov <- with(data.durations.mean,
	aov(duration ~ as.factor(layout) * as.factor(chats) + Error(participant / (as.factor(layout) * as.factor(chats))))
)
# print(summary(data.durations.mean.aov))

m2 <- lmer(duration ~ as.factor(layout) * as.factor(chats) + (1|participant), data = data.durations.mean)
print(summary(m2))
# print(anova(m2))

data.durations.mean %>%
	group_by(layout) %>%
	summarise(sd = sd(duration), max=max(duration), min=min(duration), median=median(duration), mean=mean(duration)) %>%
	print(n=2)

data.durations.mean %>%
	group_by(chats) %>%
	summarise(sd = sd(duration), max=max(duration), min=min(duration), median=median(duration), mean=mean(duration)) %>%
	print(n=2)

p1 <- ggplot(data.durations.mean, aes(duration)) +
	scale_fill_manual(name = "Layout",
						labels = c("layout 1", "layout 2"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(layout), fill=as.factor(layout)), alpha = 0.6) +
	xlab("Chat duration (s)") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# print(p1)

p2 <- ggplot(data.durations.mean, aes(duration)) +
	scale_fill_manual(name = "Chats",
						labels = c("3 chats", "4 chats"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(chats), fill=as.factor(chats)), alpha = 0.6) +
	xlab("Chat duration (s)") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# print(p2)

p3 <- ggplot(data.durations.mean %>%
	group_by(layout) %>%
	summarise(sd = sd(duration), chat_duration = mean(duration), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = chat_duration - se, se.max = chat_duration + se,
			   ci.min = chat_duration - ci, ci.max = chat_duration + ci),
		aes(as.factor(layout), chat_duration)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Layout") +
    ylab("Chat duration (s)") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# print(p3)

p4 <- ggplot(data.durations.mean %>%
	group_by(chats) %>%
	summarise(sd = sd(duration), chat_duration = mean(duration), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = chat_duration - se, se.max = chat_duration + se,
			   ci.min = chat_duration - ci, ci.max = chat_duration + ci),
		aes(as.factor(chats), chat_duration)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Chats") +
    ylab("Chat duration (s)") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# print(p4)

##########################
#### WITHOUT OUTLIERS ####
##########################

data.durations.iqr <- IQR(data.durations$duration)
data.durations.lowerq <- quantile(data.durations$duration)[[2]]
data.durations.upperq <- quantile(data.durations$duration)[[4]]

mild.threshold.upper <- (data.durations.iqr * 1.5) + data.durations.upperq
mild.threshold.lower <- data.durations.lowerq - (data.durations.iqr * 1.5)

print(mild.threshold.upper)
print(mild.threshold.lower)

data.durations.filtered <- data.durations[which(data.durations$duration <= mild.threshold.upper & data.durations$duration > mild.threshold.lower), ]
print(nrow(data.durations))
print(nrow(data.durations.filtered))

# No outliers