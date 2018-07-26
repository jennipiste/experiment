library(dplyr)
library(tidyr)
library(psych)
library(lme4)
library(lmerTest)
library(ggplot2)
library(lattice)
library(corrplot)
library(gridExtra)

# TODO: Outliers???

data.questionnaires <- read.table("csv/questionnaires.csv", header = T, sep = ";", dec = ".")
#print(data.questionnaires)

# Take questions columns from data
data.questions <- data.questionnaires[6:10]
#print(data.questions)

factanal <- factanal(data.questions, 2, rotation="varimax")
#print(factanal)
#print(factanal, digits=2, cutoff=.4, sort=TRUE)

# What should I do for each condition????

alpha <- psych::alpha(data.questions, check.keys=TRUE)
#print(alpha)
#print(alpha$total$std.alpha)

# Cronbach's alpha for both factors
factor1 <- data.questions[, c("stress", "frustration", "memory")]
factor2 <- data.questions[, c("efficiency", "control")]

factor1.alpha <- psych::alpha(factor1, check.keys=TRUE)
factor2.alpha <- psych::alpha(factor2)
#print(factor1.alpha)
#print(factor1.alpha$total$std.alpha)
#print(factor2.alpha)
#print(factor2.alpha$total$std.alpha)

# TODO: What should really be done on factanal????

data.questionnaires.efficiency.aov <- with(data.questionnaires,
	aov(efficiency ~ as.factor(layout) * as.factor(chats) + Error(participant / (as.factor(layout) * as.factor(chats))))
)
# print(summary(data.questionnaires.efficiency.aov))

data.questionnaires.stress.aov <- with(data.questionnaires,
	aov(stress ~ as.factor(layout) * as.factor(chats) + Error(participant / (as.factor(layout) * as.factor(chats))))
)
# print(summary(data.questionnaires.stress.aov))

data.questionnaires.control.aov <- with(data.questionnaires,
	aov(control ~ as.factor(layout) * as.factor(chats) + Error(participant / (as.factor(layout) * as.factor(chats))))
)
# print(summary(data.questionnaires.control.aov))

data.questionnaires.frustration.aov <- with(data.questionnaires,
	aov(frustration ~ as.factor(layout) * as.factor(chats) + Error(participant / (as.factor(layout) * as.factor(chats))))
)
# print(summary(data.questionnaires.frustration.aov))

data.questionnaires.memory.aov <- with(data.questionnaires,
	aov(memory ~ as.factor(layout) * as.factor(chats) + Error(participant / (as.factor(layout) * as.factor(chats))))
)
# print(summary(data.questionnaires.memory.aov))

# EFFICIENCY
m1 <- lmer(efficiency ~ as.factor(layout) * as.factor(chats) + (1|participant) + (1|part), data = data.questionnaires)
print(summary(m1))

data.questionnaires %>%
	group_by(layout) %>%
	summarise(sd = sd(efficiency), max=max(efficiency), min=min(efficiency), median=median(efficiency), mean=mean(efficiency)) %>%
	print(n=2)

data.questionnaires %>%
	group_by(chats) %>%
	summarise(sd = sd(efficiency), max=max(efficiency), min=min(efficiency), median=median(efficiency), mean=mean(efficiency)) %>%
	print(n=2)

p1 <- ggplot(data.questionnaires, aes(efficiency)) +
	scale_fill_manual(name = "Layout",
						labels = c("layout 1", "layout 2"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(layout), fill=as.factor(layout)), alpha = 0.6) +
	xlab("Efficiency") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# print(p1)

p2 <- ggplot(data.questionnaires, aes(efficiency)) +
	scale_fill_manual(name = "Chats",
						labels = c("3 chats", "4 chats"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(chats), fill=as.factor(chats)), alpha = 0.6) +
	xlab("Efficiency") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# print(p2)

p3 <- ggplot(data.questionnaires %>%
	group_by(layout) %>%
	summarise(sd = sd(efficiency), efficiency = mean(efficiency), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = efficiency - se, se.max = efficiency + se,
			   ci.min = efficiency - ci, ci.max = efficiency + ci),
		aes(as.factor(layout), efficiency)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Layout") +
    ylab("Efficiency") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# print(p3)

p4 <- ggplot(data.questionnaires %>%
	group_by(chats) %>%
	summarise(sd = sd(efficiency), efficiency = mean(efficiency), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = efficiency - se, se.max = efficiency + se,
			   ci.min = efficiency - ci, ci.max = efficiency + ci),
		aes(as.factor(chats), efficiency)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Chats") +
    ylab("Efficiency") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# print(p4)

# STRESS
m2 <- lmer(stress ~ as.factor(layout) * as.factor(chats) + (1|participant) + (1|part), data = data.questionnaires)
print(summary(m2))

data.questionnaires %>%
	group_by(layout) %>%
	summarise(sd = sd(stress), max=max(stress), min=min(stress), median=median(stress), mean=mean(stress)) %>%
	print(n=2)

data.questionnaires %>%
	group_by(chats) %>%
	summarise(sd = sd(stress), max=max(stress), min=min(stress), median=median(stress), mean=mean(stress)) %>%
	print(n=2)

p1 <- ggplot(data.questionnaires, aes(stress)) +
	scale_fill_manual(name = "Layout",
						labels = c("layout 1", "layout 2"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(layout), fill=as.factor(layout)), alpha = 0.6) +
	xlab("Stress") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# print(p1)

p2 <- ggplot(data.questionnaires, aes(stress)) +
	scale_fill_manual(name = "Chats",
						labels = c("3 chats", "4 chats"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(chats), fill=as.factor(chats)), alpha = 0.6) +
	xlab("Stress") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# print(p2)

p3 <- ggplot(data.questionnaires %>%
	group_by(layout) %>%
	summarise(sd = sd(stress), stress = mean(stress), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = stress - se, se.max = stress + se,
			   ci.min = stress - ci, ci.max = stress + ci),
		aes(as.factor(layout), stress)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Layout") +
    ylab("Stress") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# print(p3)

p4 <- ggplot(data.questionnaires %>%
	group_by(chats) %>%
	summarise(sd = sd(stress), stress = mean(stress), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = stress - se, se.max = stress + se,
			   ci.min = stress - ci, ci.max = stress + ci),
		aes(as.factor(chats), stress)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Chats") +
    ylab("Stress") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# print(p4)

# CONTROL
m3 <- lmer(control ~ as.factor(layout) * as.factor(chats) + (1|participant) + (1|part), data = data.questionnaires)
print(summary(m3))

data.questionnaires %>%
	group_by(layout) %>%
	summarise(sd = sd(control), max=max(control), min=min(control), median=median(control), mean=mean(control)) %>%
	print(n=2)

data.questionnaires %>%
	group_by(chats) %>%
	summarise(sd = sd(control), max=max(control), min=min(control), median=median(control), mean=mean(control)) %>%
	print(n=2)

p1 <- ggplot(data.questionnaires, aes(control)) +
	scale_fill_manual(name = "Layout",
						labels = c("layout 1", "layout 2"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(layout), fill=as.factor(layout)), alpha = 0.6) +
	xlab("Control") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# print(p1)

p2 <- ggplot(data.questionnaires, aes(control)) +
	scale_fill_manual(name = "Chats",
						labels = c("3 chats", "4 chats"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(chats), fill=as.factor(chats)), alpha = 0.6) +
	xlab("Control") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# print(p2)

p3 <- ggplot(data.questionnaires %>%
	group_by(layout) %>%
	summarise(sd = sd(control), control = mean(control), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = control - se, se.max = control + se,
			   ci.min = control - ci, ci.max = control + ci),
		aes(as.factor(layout), control)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Layout") +
    ylab("Control") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# print(p3)

p4 <- ggplot(data.questionnaires %>%
	group_by(chats) %>%
	summarise(sd = sd(control), control = mean(control), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = control - se, se.max = control + se,
			   ci.min = control - ci, ci.max = control + ci),
		aes(as.factor(chats), control)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Chats") +
    ylab("Control") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# print(p4)

# FRUSTRATION
m4 <- lmer(frustration ~ as.factor(layout) * as.factor(chats) + (1|participant) + (1|part), data = data.questionnaires)
print(summary(m4))

data.questionnaires %>%
	group_by(layout) %>%
	summarise(sd = sd(frustration), max=max(frustration), min=min(frustration), median=median(frustration), mean=mean(frustration)) %>%
	print(n=2)

data.questionnaires %>%
	group_by(chats) %>%
	summarise(sd = sd(frustration), max=max(frustration), min=min(frustration), median=median(frustration), mean=mean(frustration)) %>%
	print(n=2)

p1 <- ggplot(data.questionnaires, aes(frustration)) +
	scale_fill_manual(name = "Layout",
						labels = c("layout 1", "layout 2"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(layout), fill=as.factor(layout)), alpha = 0.6) +
	xlab("Frustration") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# print(p1)

p2 <- ggplot(data.questionnaires, aes(frustration)) +
	scale_fill_manual(name = "Chats",
						labels = c("3 chats", "4 chats"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(chats), fill=as.factor(chats)), alpha = 0.6) +
	xlab("Frustration") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# print(p2)

p3 <- ggplot(data.questionnaires %>%
	group_by(layout) %>%
	summarise(sd = sd(frustration), frustration = mean(frustration), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = frustration - se, se.max = frustration + se,
			   ci.min = frustration - ci, ci.max = frustration + ci),
		aes(as.factor(layout), frustration)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Layout") +
    ylab("Frustration") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# print(p3)

p4 <- ggplot(data.questionnaires %>%
	group_by(chats) %>%
	summarise(sd = sd(frustration), frustration = mean(frustration), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = frustration - se, se.max = frustration + se,
			   ci.min = frustration - ci, ci.max = frustration + ci),
		aes(as.factor(chats), frustration)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Chats") +
    ylab("Frustration") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# print(p4)

# MEMORY
m5 <- lmer(memory ~ as.factor(layout) * as.factor(chats) + (1|participant) + (1|part), data = data.questionnaires)
print(summary(m5))

data.questionnaires %>%
	group_by(layout) %>%
	summarise(sd = sd(memory), max=max(memory), min=min(memory), median=median(memory), mean=mean(memory)) %>%
	print(n=2)

data.questionnaires %>%
	group_by(chats) %>%
	summarise(sd = sd(memory), max=max(memory), min=min(memory), median=median(memory), mean=mean(memory)) %>%
	print(n=2)

p1 <- ggplot(data.questionnaires, aes(memory)) +
	scale_fill_manual(name = "Layout",
						labels = c("layout 1", "layout 2"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(layout), fill=as.factor(layout)), alpha = 0.6) +
	xlab("Memory") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# print(p1)

p2 <- ggplot(data.questionnaires, aes(memory)) +
	scale_fill_manual(name = "Chats",
						labels = c("3 chats", "4 chats"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(chats), fill=as.factor(chats)), alpha = 0.6) +
	xlab("Memory") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# print(p2)

p3 <- ggplot(data.questionnaires %>%
	group_by(layout) %>%
	summarise(sd = sd(memory), memory = mean(memory), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = memory - se, se.max = memory + se,
			   ci.min = memory - ci, ci.max = memory + ci),
		aes(as.factor(layout), memory)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Layout") +
    ylab("Memory") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# print(p3)

p4 <- ggplot(data.questionnaires %>%
	group_by(chats) %>%
	summarise(sd = sd(memory), memory = mean(memory), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = memory - se, se.max = memory + se,
			   ci.min = memory - ci, ci.max = memory + ci),
		aes(as.factor(chats), memory)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Chats") +
    ylab("Memory") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# print(p4)