library(dplyr)
library(tidyr)
library(psych)
library(lme4)
library(lmerTest)
library(ggplot2)
library(lattice)
library(corrplot)
library(gridExtra)
library(emmeans)

data.firstresponses <- read.table("csv/first_response_times.csv", header = T, sep = ";", dec = ",")

# Filter outliers
data.firstresponses.iqr <- IQR(data.firstresponses$first_response_time)
data.firstresponses.lowerq <- quantile(data.firstresponses$first_response_time)[[2]]
data.firstresponses.upperq <- quantile(data.firstresponses$first_response_time)[[4]]

mild.threshold.upper <- (data.firstresponses.iqr * 1.5) + data.firstresponses.upperq
mild.threshold.lower <- data.firstresponses.lowerq - (data.firstresponses.iqr * 1.5)

print(mild.threshold.lower)
print(mild.threshold.upper)

data.firstresponses.filtered <- data.firstresponses[which(data.firstresponses$first_response_time <= mild.threshold.upper & data.firstresponses$first_response_time > mild.threshold.lower), ]
print(nrow(data.firstresponses))
print(nrow(data.firstresponses.filtered))

# data.firstresponses.filtered.mean <- aggregate(data.firstresponses.filtered$first_response_time,
# 	by = list(data.firstresponses.filtered$participant, data.firstresponses.filtered$condition, data.firstresponses.filtered$layout, data.firstresponses.filtered$chats),
# 	FUN = mean
# )
# colnames(data.firstresponses.filtered.mean) <- c("participant", "condition", "layout", "chats", "first_response_time")

# dev.new()
# plot(densityplot(data.firstresponses.filtered.mean$first_response_time))

# Statistics
data.firstresponses.filtered %>%
	group_by(condition) %>%
	summarise(mean=mean(first_response_time), sd = sd(first_response_time), min=min(first_response_time),max=max(first_response_time)) %>%
	print(n=4)

# Anova
data.firstresponses.filtered.aov <- aov(first_response_time ~ (as.factor(layout) * as.factor(chats)) + Error(participant / (as.factor(layout) * as.factor(chats))), data=data.firstresponses.filtered)
# print(summary(data.firstresponses.filtered.aov))

# Linear mixed model
# With interaction
m1 <- lmer(first_response_time ~ as.factor(layout) * as.factor(chats) + (1|participant) + (1|topic) + (1|part), data = data.firstresponses.filtered)
print(summary(m1))

# Without interaction
m2 <- lmer(first_response_time ~ as.factor(layout) + as.factor(chats) + (1|participant) + (1|topic) + (1|part), data = data.firstresponses.filtered)
print(summary(m2))

# Plots
p1 <- ggplot(data.firstresponses.filtered, aes(first_response_time)) +
	ggtitle("First response time density") +
	scale_fill_manual(name = "chats",
						labels = c("3", "4"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(chats), fill=as.factor(chats)), alpha = 0.6) +
	facet_grid(. ~ layout, labeller = label_both) +
	xlab("time (s)") +
	theme_minimal() +
	theme(legend.position = c(0.85, 0.85),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
dev.new()
plot(p1)

p2 <- ggplot(data.firstresponses.filtered %>%
	group_by(layout, chats) %>%
	summarise(sd = sd(first_response_time), first_response_time = mean(first_response_time), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = first_response_time - se, se.max = first_response_time + se,
			   ci.min = first_response_time - ci, ci.max = first_response_time + ci),
		aes(as.factor(layout), first_response_time, fill = as.factor(chats))) +
	theme_minimal() +
	scale_fill_manual(name = "chats",
					  labels = c("3", "4"),
 					  values = c("#F79E9B", "#62D2D4")) +
  	geom_bar(stat="identity", position = "dodge") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max), width=0.2, position=position_dodge(.9)) +
	xlab("layout") +
    ylab("time (s)") +
	ggtitle("Mean first response time in seconds") +

dev.new()
plot(p2)