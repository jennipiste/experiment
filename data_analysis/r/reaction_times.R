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

# Mean reaction times for participants for each condition
data.reactions.mean <- aggregate(data.reactions$reaction_time,
	by = list(data.reactions$participant, data.reactions$layout, data.reactions$chats),
	FUN = mean
)
colnames(data.reactions.mean) <- c("participant", "layout", "chats", "reaction_time")

dev.new()
plot(densityplot(data.reactions.mean$reaction_time))

data.reactions.mean.aov <- with(data.reactions.mean,
	aov(reaction_time ~ as.factor(layout) * as.factor(chats) + Error(participant / (as.factor(layout) * as.factor(chats))))
)
# print(summary(data.reactions.mean.aov))

m2 <- lmer(reaction_time ~ as.factor(layout) * as.factor(chats) + (1|participant), data = data.reactions.mean)
print(summary(m2))

data.reactions.mean %>%
	group_by(layout) %>%
	summarise(sd = sd(reaction_time), max=max(reaction_time), min=min(reaction_time), median=median(reaction_time), mean=mean(reaction_time)) %>%
	print(n=2)

data.reactions.mean %>%
	group_by(chats) %>%
	summarise(sd = sd(reaction_time), max=max(reaction_time), min=min(reaction_time), median=median(reaction_time), mean=mean(reaction_time)) %>%
	print(n=2)

p1 <- ggplot(data.reactions.mean, aes(reaction_time)) +
	scale_fill_manual(name = "Layout",
						labels = c("layout 1", "layout 2"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(layout), fill=as.factor(layout)), alpha = 0.6) +
	xlab("Reaction time (s)") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# plot(p1)

p2 <- ggplot(data.reactions.mean, aes(reaction_time)) +
	scale_fill_manual(name = "Chats",
						labels = c("3 chats", "4 chats"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(chats), fill=as.factor(chats)), alpha = 0.6) +
	xlab("Reaction time (s)") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# plot(p2)

p3 <- ggplot(data.reactions.mean %>%
	group_by(layout) %>%
	summarise(sd = sd(reaction_time), reaction_time = mean(reaction_time), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = reaction_time - se, se.max = reaction_time + se,
			   ci.min = reaction_time - ci, ci.max = reaction_time + ci),
		aes(as.factor(layout), reaction_time)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Layout") +
    ylab("Reaction time (s)") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# plot(p3)

p4 <- ggplot(data.reactions.mean %>%
	group_by(chats) %>%
	summarise(sd = sd(reaction_time), reaction_time = mean(reaction_time), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = reaction_time - se, se.max = reaction_time + se,
			   ci.min = reaction_time - ci, ci.max = reaction_time + ci),
		aes(as.factor(chats), reaction_time)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Chats") +
    ylab("Reaction time (s)") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# plot(p4)

##########################
#### WITHOUT OUTLIERS ####
##########################

data.reactions.iqr <- IQR(data.reactions$reaction_time)
data.reactions.lowerq <- quantile(data.reactions$reaction_time)[[2]]
data.reactions.upperq <- quantile(data.reactions$reaction_time)[[4]]

mild.threshold.upper <- (data.reactions.iqr * 1.5) + data.reactions.upperq
mild.threshold.lower <- data.reactions.lowerq - (data.reactions.iqr * 1.5)

print(mild.threshold.upper)
print(mild.threshold.lower)

data.reactions.filtered <- data.reactions[which(data.reactions$reaction_time <= mild.threshold.upper & data.reactions$reaction_time > mild.threshold.lower), ]
print(nrow(data.reactions))
print(nrow(data.reactions.filtered))


data.reactions.filtered.mean <- aggregate(data.reactions.filtered$reaction_time,
	by = list(data.reactions.filtered$participant, data.reactions.filtered$layout, data.reactions.filtered$chats),
	FUN = mean
)
colnames(data.reactions.filtered.mean) <- c("participant", "layout", "chats", "reaction_time")

dev.new()
plot(densityplot(data.reactions.filtered.mean$reaction_time))

data.reactions.filtered.mean.aov <- with(data.reactions.filtered.mean,
	aov(reaction_time ~ as.factor(layout) * as.factor(chats) + Error(participant / (as.factor(layout) * as.factor(chats))))
)
# print(summary(data.reactions.filtered.mean.aov))

m1 <- lmer(reaction_time ~ as.factor(layout) * as.factor(chats) + (1|participant), data = data.reactions.filtered.mean)
print(summary(m2))

data.reactions.filtered.mean %>%
	group_by(layout) %>%
	summarise(sd = sd(reaction_time), max=max(reaction_time), min=min(reaction_time), median=median(reaction_time), mean=mean(reaction_time)) %>%
	print(n=2)

data.reactions.filtered.mean %>%
	group_by(chats) %>%
	summarise(sd = sd(reaction_time), max=max(reaction_time), min=min(reaction_time), median=median(reaction_time), mean=mean(reaction_time)) %>%
	print(n=2)

p1 <- ggplot(data.reactions.filtered.mean, aes(reaction_time)) +
	ggtitle("Reaction time density (without outliers)") +
	scale_fill_manual(name = "Layout",
						labels = c("layout 1", "layout 2"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(layout), fill=as.factor(layout)), alpha = 0.6) +
	xlab("Reaction time (s)") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
dev.new()
plot(p1)

p2 <- ggplot(data.reactions.filtered.mean, aes(reaction_time)) +
	ggtitle("Reaction time density (without outliers)") +
	scale_fill_manual(name = "Chats",
						labels = c("3 chats", "4 chats"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(chats), fill=as.factor(chats)), alpha = 0.6) +
	xlab("Reaction time (s)") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
dev.new()
plot(p2)

p3 <- ggplot(data.reactions.filtered.mean %>%
	group_by(layout) %>%
	summarise(sd = sd(reaction_time), reaction_time = mean(reaction_time), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = reaction_time - se, se.max = reaction_time + se,
			   ci.min = reaction_time - ci, ci.max = reaction_time + ci),
		aes(as.factor(layout), reaction_time)) +
    ggtitle("Mean reaction time (without outliers)") +
	geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Layout") +
    ylab("Reaction time (s)") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
dev.new()
plot(p3)

p4 <- ggplot(data.reactions.filtered.mean %>%
	group_by(chats) %>%
	summarise(sd = sd(reaction_time), reaction_time = mean(reaction_time), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = reaction_time - se, se.max = reaction_time + se,
			   ci.min = reaction_time - ci, ci.max = reaction_time + ci),
		aes(as.factor(chats), reaction_time)) +
    ggtitle("Mean reaction time (without outliers)") +
	geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Chats") +
    ylab("Reaction time (s)") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
dev.new()
plot(p4)