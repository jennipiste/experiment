library(dplyr)
library(tidyr)
library(psych)
library(lme4)
library(lmerTest)
library(ggplot2)
library(lattice)
library(corrplot)
library(gridExtra)
library(FSA)

data.questions <- read.table("csv/q&a.csv", header = T, sep = ";", dec = ",")

# Filter outliers for wait times
data.questions.iqr <- IQR(data.questions$wait_time)
data.questions.lowerq <- quantile(data.questions$wait_time)[[2]]
data.questions.upperq <- quantile(data.questions$wait_time)[[4]]

mild.threshold.upper <- (data.questions.iqr * 1.5) + data.questions.upperq
mild.threshold.lower <- data.questions.lowerq - (data.questions.iqr * 1.5)

print(mild.threshold.upper)
print(mild.threshold.lower)

data.questions.waittime.filtered <- data.questions[which(data.questions$wait_time <= mild.threshold.upper & data.questions$wait_time > mild.threshold.lower), ]
print(nrow(data.questions))
print(nrow(data.questions.waittime.filtered))

###########################
# Question response times #
###########################

# Statistics
data.questions.waittime.filtered %>%
	group_by(condition) %>%
	summarise(mean=mean(wait_time), sd = sd(wait_time), min=min(wait_time),max=max(wait_time)) %>%
	print(n=4)

# dev.new()
# plot(densityplot(data.questions.waittime.filtered$wait_time))

# Anova
data.questions.waittime.filtered.aov <- with(data.questions.waittime.filtered,
	aov(wait_time ~ as.factor(layout) * as.factor(chats) + Error(participant / (as.factor(layout) * as.factor(chats))))
)
# print(summary(data.questions.waittime.filtered.aov))

# Linear mixed model
# With interaction
m1 <- lmer(wait_time ~ as.factor(layout) * as.factor(chats) + (1|participant) + (1|part) + (1|topic), data = data.questions.waittime.filtered)
print(summary(m1))

# Without interaction
m2 <- lmer(wait_time ~ as.factor(layout) + as.factor(chats) + (1|participant) + (1|part) + (1|topic), data = data.questions.waittime.filtered)
print(summary(m2))

# Plots
p1 <- ggplot(data.questions.waittime.filtered, aes(wait_time)) +
	ggtitle("Question response time density") +
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

p2 <- ggplot(data.questions.waittime.filtered %>%
	group_by(layout, chats) %>%
	summarise(sd = sd(wait_time), wait_time = mean(wait_time), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = wait_time - se, se.max = wait_time + se,
			   ci.min = wait_time - ci, ci.max = wait_time + ci),
		aes(as.factor(layout), wait_time, fill = as.factor(chats))) +
	theme_minimal() +
	scale_fill_manual(name = "chats",
					  labels = c("3", "4"),
 					  values = c("#F79E9B", "#62D2D4")) +
  	geom_bar(stat="identity", position = "dodge") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max), width=0.2, position=position_dodge(.9)) +
	xlab("layout") +
    ylab("time (s)") +
	ggtitle("Mean question response time in seconds") +

dev.new()
plot(p2)

####################
# Number of errors #
####################

data.questions.errors <- aggregate(data.questions$correct,
	by = list(data.questions$participant, data.questions$condition, data.questions$layout, data.questions$chats),
	FUN = function(x){NROW(x) - sum(x)}
)
colnames(data.questions.errors) <- c("participant", "condition", "layout", "chats", "errors")

# Statistics
data.questions.errors %>%
	group_by(condition) %>%
	summarise(mean=mean(errors), sd = sd(errors), min=min(errors),max=max(errors)) %>%
	print(n=4)

# dev.new()
# plot(densityplot(data.questions.errors$errors))

# Linear mixed model
m1 <- lmer(errors ~ as.factor(layout) * as.factor(chats) + (1|participant), data = data.questions.errors)
print(summary(m1))

# Generalized mixed model
g1 <- glmer(errors ~ as.factor(layout) * as.factor(chats) + (1|participant), family=poisson, data=data.questions.errors)
print(summary(g1))

p1 <- ggplot(data.questions.errors, aes(errors)) +
	ggtitle("Number of errors density") +
	scale_fill_manual(name = "chats",
						labels = c("3", "4"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(chats), fill=as.factor(chats)), alpha = 0.6) +
	facet_grid(. ~ layout, labeller = label_both) +
	xlab("errors") +
	theme_minimal() +
	theme(legend.position = c(0.85, 0.85),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
dev.new()
plot(p1)

p2 <- ggplot(data.questions.errors %>%
	group_by(layout, chats) %>%
	summarise(sd = sd(errors), errors = mean(errors), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = errors - se, se.max = errors + se,
			   ci.min = errors - ci, ci.max = errors + ci),
		aes(as.factor(layout), errors, fill = as.factor(chats))) +
	scale_fill_manual(name = "chats",
					  labels = c("3", "4"),
 					  values = c("#F79E9B", "#62D2D4")) +
  	geom_bar(position=position_dodge(), stat="identity") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max), width=0.2, position=position_dodge(.9)) +
	theme_minimal() +
	xlab("layout") +
    ylab("errors") +
	ggtitle("Mean number of errors") +

dev.new()
plot(p2)
