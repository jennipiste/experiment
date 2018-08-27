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

# Filter outliers
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

# dev.new()
# plot(densityplot(data.durations$duration))

# Linear mixed model
# With interaction
# m1 <- lmer(duration ~ as.factor(layout) * as.factor(chats) + (1|participant) + (1|part) + (1|topic), data = data.durations)
# print(summary(m1))

# Without interaction
m1 <- lmer(duration ~ as.factor(layout) + as.factor(chats) + (1|participant), data = data.durations)
print(summary(m1))

m2 <- lmer(scale(duration) ~ as.factor(layout) + as.factor(chats) + (1|participant), data = data.durations)
print(summary(m2))

# Statistics
data.durations %>%
	group_by(condition) %>%
	summarise(mean=mean(duration), sd = sd(duration), min=min(duration),max=max(duration)) %>%
	print(n=4)

# Plots
p1 <- ggplot(data.durations, aes(duration)) +
	ggtitle("Chat duration density") +
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

p2 <- ggplot(data.durations %>%
	group_by(layout, chats) %>%
	summarise(sd = sd(duration), duration = mean(duration), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = duration - se, se.max = duration + se,
			   ci.min = duration - ci, ci.max = duration + ci),
		aes(as.factor(layout), duration, fill = as.factor(chats))) +
	theme_minimal() +
	scale_fill_manual(name = "chats",
					  labels = c("3", "4"),
 					  values = c("#F79E9B", "#62D2D4")) +
  	geom_bar(stat="identity", position = "dodge") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max), width=0.2, position=position_dodge(.9)) +
	xlab("layout") +
    ylab("time (s)") +
	ggtitle("Mean chat duration in seconds") +

dev.new()
plot(p2)

# Boxplot
p3 <- ggplot(data.durations %>%
       group_by(participant,layout,chats) %>%
       summarise(duration = mean(duration)),
       aes(as.factor(layout), duration, fill = as.factor(chats))) +
    geom_boxplot() +
	theme_minimal() +
	xlab("layout") +
    ylab("time (s)") +
	scale_fill_manual(name = "chats",
					  labels = c("3", "4"),
 					  values = c("#F79E9B", "#62D2D4"))
dev.new()
plot(p3)
