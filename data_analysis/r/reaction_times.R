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

# Filter outliers
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

dev.new()
plot(densityplot(data.reactions.filtered$reaction_time))

# Linear mixed model
# m1 <- lmer(reaction_time ~ as.factor(layout) * as.factor(chats) + (1|participant), data = data.reactions.filtered)
# print(summary(m1))

m1 <- lmer(reaction_time ~ as.factor(layout) + as.factor(chats) + (1|participant), data = data.reactions.filtered)
print(summary(m1))

m2 <- lmer(scale(reaction_time) ~ as.factor(layout) + as.factor(chats) + (1|participant), data = data.reactions.filtered)
print(summary(m2))

# Without filtering
m3 <- lmer(scale(reaction_time) ~ as.factor(layout) + as.factor(chats) + (1|participant), data = data.reactions)
print(summary(m3))

# Statistics
data.reactions.filtered %>%
	group_by(condition) %>%
	summarise(mean=mean(reaction_time), sd = sd(reaction_time), min=min(reaction_time),max=max(reaction_time)) %>%
	print(n=4)

# Plots
p1 <- ggplot(data.reactions.filtered, aes(reaction_time)) +
	ggtitle("Reaction time density") +
	scale_fill_manual(name = "chats",
						labels = c("3", "4"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(chats), fill=as.factor(chats)), alpha = 0.6) +
	facet_grid(. ~ layout, labeller = label_both) +
	xlab("time (s)") +
	theme_minimal() +
	theme(legend.position = c(0.5, 0.85),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
dev.new()
plot(p1)

p2 <- ggplot(data.reactions.filtered %>%
	group_by(layout, chats) %>%
	summarise(sd = sd(reaction_time), reaction_time = mean(reaction_time), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = reaction_time - se, se.max = reaction_time + se,
			   ci.min = reaction_time - ci, ci.max = reaction_time + ci),
		aes(as.factor(layout), reaction_time, fill = as.factor(chats))) +
	theme_minimal() +
	scale_fill_manual(name = "chats",
					  labels = c("3", "4"),
 					  values = c("#F79E9B", "#62D2D4")) +
  	geom_bar(stat="identity", position = "dodge") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max), width=0.2, position=position_dodge(.9)) +
	xlab("layout") +
    ylab("time (s)") +
	ggtitle("Mean reaction time in seconds") +

dev.new()
plot(p2)

# Boxplot
p3 <- ggplot(data.reactions.filtered %>%
       group_by(participant,layout,chats) %>%
       summarise(reaction_time = mean(reaction_time)),
       aes(as.factor(layout), reaction_time, fill = as.factor(chats))) +
    geom_boxplot() +
	theme_minimal() +
	xlab("layout") +
    ylab("time (s)") +
	scale_fill_manual(name = "chats",
					  labels = c("3", "4"),
 					  values = c("#F79E9B", "#62D2D4"))
dev.new()
plot(p3)
