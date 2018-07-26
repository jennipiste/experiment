library(dplyr)
library(tidyr)
library(psych)
library(lme4)
library(lmerTest)
library(ggplot2)
library(lattice)
library(corrplot)
library(gridExtra)

data.dialogs <- read.table("csv/dialogs.csv", header = T, sep = ";", dec = ",")

### DIALOGS ###
# Get only the rows that have dialogs_in_condition values
data.dialogs.dialogs <- data.dialogs %>% drop_na("dialogs_in_condition")

# ANOVA
data.dialogs.dialogs.aov <- with(data.dialogs.dialogs,
	aov(dialogs_in_condition ~ as.factor(layout) * as.factor(chats) + Error(participant / (as.factor(layout) * as.factor(chats))))
)
# print(summary(data.dialogs.dialogs.aov))

# Linear mixed model
m1 <- lmer(dialogs_in_condition ~ as.factor(layout) * as.factor(chats) + (1|participant) + (1|part) + (1|topic), data = data.dialogs.dialogs)
print(summary(m1))

data.dialogs.dialogs %>%
	group_by(layout) %>%
	summarise(sd = sd(dialogs_in_condition), max=max(dialogs_in_condition), min=min(dialogs_in_condition), median=median(dialogs_in_condition), mean=mean(dialogs_in_condition)) %>%
	print(n=2)

data.dialogs.dialogs %>%
	group_by(chats) %>%
	summarise(sd = sd(dialogs_in_condition), max=max(dialogs_in_condition), min=min(dialogs_in_condition), median=median(dialogs_in_condition), mean=mean(dialogs_in_condition)) %>%
	print(n=2)

p1 <- ggplot(data.dialogs.dialogs, aes(dialogs_in_condition)) +
	scale_fill_manual(name = "Layout",
						labels = c("layout 1", "layout 2"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(layout), fill=as.factor(layout)), alpha = 0.6) +
	xlab("Dialogs") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# print(p1)

p2 <- ggplot(data.dialogs.dialogs, aes(dialogs_in_condition)) +
	scale_fill_manual(name = "Chats",
						labels = c("3 chats", "4 chats"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(chats), fill=as.factor(chats)), alpha = 0.6) +
	xlab("Dialogs") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# print(p2)

p3 <- ggplot(data.dialogs.dialogs %>%
	group_by(layout) %>%
	summarise(sd = sd(dialogs_in_condition), dialogs = mean(dialogs_in_condition), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = dialogs - se, se.max = dialogs + se,
			   ci.min = dialogs - ci, ci.max = dialogs + ci),
		aes(as.factor(layout), dialogs)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Layout") +
    ylab("Dialogs") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# print(p3)

p4 <- ggplot(data.dialogs.dialogs %>%
	group_by(chats) %>%
	summarise(sd = sd(dialogs_in_condition), dialogs = mean(dialogs_in_condition), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = dialogs - se, se.max = dialogs + se,
			   ci.min = dialogs - ci, ci.max = dialogs + ci),
		aes(as.factor(chats), dialogs)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Chats") +
    ylab("Dialogs") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# print(p4)

### FINISHED DIALOGS ###
# Get only the rows that have dialogs_in_condition values
data.dialogs.finisheddialogs <- data.dialogs %>% drop_na("finished_dialogs_in_condition")

# ANOVA
data.dialogs.finisheddialogs.aov <- with(data.dialogs.finisheddialogs,
	aov(finished_dialogs_in_condition ~ as.factor(layout) * as.factor(chats) + Error(part / (as.factor(layout) * as.factor(chats))))
)
# print(summary(data.dialogs.finisheddialogs.aov))

# Linear mixed model
m2 <- lmer(finished_dialogs_in_condition ~ as.factor(layout) * as.factor(chats) + (1|participant) + (1|part) + (1|topic), data = data.dialogs.finisheddialogs)
print(summary(m2))

data.dialogs.finisheddialogs %>%
	group_by(layout) %>%
	summarise(sd = sd(finished_dialogs_in_condition), max=max(finished_dialogs_in_condition), min=min(finished_dialogs_in_condition), median=median(finished_dialogs_in_condition), mean=mean(finished_dialogs_in_condition)) %>%
	print(n=2)

data.dialogs.finisheddialogs %>%
	group_by(chats) %>%
	summarise(sd = sd(finished_dialogs_in_condition), max=max(finished_dialogs_in_condition), min=min(finished_dialogs_in_condition), median=median(finished_dialogs_in_condition), mean=mean(finished_dialogs_in_condition)) %>%
	print(n=2)

p1 <- ggplot(data.dialogs.finisheddialogs, aes(finished_dialogs_in_condition)) +
	scale_fill_manual(name = "Layout",
						labels = c("layout 1", "layout 2"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(layout), fill=as.factor(layout)), alpha = 0.6) +
	xlab("Finished dialogs") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# print(p1)

p2 <- ggplot(data.dialogs.finisheddialogs, aes(finished_dialogs_in_condition)) +
	scale_fill_manual(name = "Chats",
						labels = c("3 chats", "4 chats"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(chats), fill=as.factor(chats)), alpha = 0.6) +
	xlab("Finished dialogs") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# print(p2)

p3 <- ggplot(data.dialogs.finisheddialogs %>%
	group_by(layout) %>%
	summarise(sd = sd(finished_dialogs_in_condition), dialogs = mean(finished_dialogs_in_condition), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = dialogs - se, se.max = dialogs + se,
			   ci.min = dialogs - ci, ci.max = dialogs + ci),
		aes(as.factor(layout), dialogs)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Layout") +
    ylab("Finished dialogs") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# print(p3)

p4 <- ggplot(data.dialogs.finisheddialogs %>%
	group_by(chats) %>%
	summarise(sd = sd(finished_dialogs_in_condition), dialogs = mean(finished_dialogs_in_condition), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = dialogs - se, se.max = dialogs + se,
			   ci.min = dialogs - ci, ci.max = dialogs + ci),
		aes(as.factor(chats), dialogs)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Chats") +
    ylab("Finished dialogs") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# print(p4)

### RESPONSES ###
# Get only the rows that have responses_in_condition values
data.dialogs.responses <- data.dialogs %>% drop_na("responses_in_condition")

# ANOVA
data.dialogs.responses.aov <- with(data.dialogs.responses,
	aov(responses_in_condition ~ as.factor(layout) * as.factor(chats) + Error(participant / (as.factor(layout) * as.factor(chats))))
)
# print(summary(data.dialogs.responses.aov))

# Linear mixed model
m3 <- lmer(responses_in_condition ~ as.factor(layout) * as.factor(chats) + (1|participant) + (1|part) + (1|topic), data = data.dialogs.responses)
print(summary(m3))

data.dialogs.responses %>%
	group_by(layout) %>%
	summarise(sd = sd(responses_in_condition), max=max(responses_in_condition), min=min(responses_in_condition), median=median(responses_in_condition), mean=mean(responses_in_condition)) %>%
	print(n=2)

data.dialogs.responses %>%
	group_by(chats) %>%
	summarise(sd = sd(responses_in_condition), max=max(responses_in_condition), min=min(responses_in_condition), median=median(responses_in_condition), mean=mean(responses_in_condition)) %>%
	print(n=2)

p1 <- ggplot(data.dialogs.responses, aes(responses_in_condition)) +
	scale_fill_manual(name = "Layout",
						labels = c("layout 1", "layout 2"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(layout), fill=as.factor(layout)), alpha = 0.6) +
	xlab("Responses") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# print(p1)

p2 <- ggplot(data.dialogs.responses, aes(responses_in_condition)) +
	scale_fill_manual(name = "Chats",
						labels = c("3 chats", "4 chats"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(chats), fill=as.factor(chats)), alpha = 0.6) +
	xlab("Responses") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# print(p2)

p3 <- ggplot(data.dialogs.responses %>%
	group_by(layout) %>%
	summarise(sd = sd(responses_in_condition), responses = mean(responses_in_condition), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = responses - se, se.max = responses + se,
			   ci.min = responses - ci, ci.max = responses + ci),
		aes(as.factor(layout), responses)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Layout") +
    ylab("Responses") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# print(p3)

p4 <- ggplot(data.dialogs.responses %>%
	group_by(chats) %>%
	summarise(sd = sd(responses_in_condition), responses = mean(responses_in_condition), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = responses - se, se.max = responses + se,
			   ci.min = responses - ci, ci.max = responses + ci),
		aes(as.factor(chats), responses)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Chats") +
    ylab("Responses") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# print(p4)

### ACCURACY ###
# Get only the rows that have accuracy_in_condition values
data.dialogs.accuracy <- data.dialogs %>% drop_na("accuracy_in_condition")

# ANOVA
data.dialogs.accuracy.aov <- with(data.dialogs.accuracy,
	aov(accuracy_in_condition ~ as.factor(layout) * as.factor(chats) + Error(participant / (as.factor(layout) * as.factor(chats))))
)
# print(summary(data.dialogs.accuracy.aov))

m4 <- lmer(accuracy_in_condition ~ as.factor(layout) * as.factor(chats) + (1|participant) + (1|part) + (1|topic), data = data.dialogs.accuracy)
print(summary(m4))

data.dialogs.accuracy %>%
	group_by(layout) %>%
	summarise(sd = sd(accuracy_in_condition), max=max(accuracy_in_condition), min=min(accuracy_in_condition), median=median(accuracy_in_condition), mean=mean(accuracy_in_condition)) %>%
	print(n=2)

data.dialogs.accuracy %>%
	group_by(chats) %>%
	summarise(sd = sd(accuracy_in_condition), max=max(accuracy_in_condition), min=min(accuracy_in_condition), median=median(accuracy_in_condition), mean=mean(accuracy_in_condition)) %>%
	print(n=2)

p1 <- ggplot(data.dialogs.accuracy, aes(accuracy_in_condition)) +
	scale_fill_manual(name = "Layout",
						labels = c("layout 1", "layout 2"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(layout), fill=as.factor(layout)), alpha = 0.6) +
	xlab("Accuracy (%)") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# print(p1)

p2 <- ggplot(data.dialogs.accuracy, aes(accuracy_in_condition)) +
	scale_fill_manual(name = "Chats",
						labels = c("3 chats", "4 chats"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(chats), fill=as.factor(chats)), alpha = 0.6) +
	xlab("Accuracy (%)") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# print(p2)

p3 <- ggplot(data.dialogs.accuracy %>%
	group_by(layout) %>%
	summarise(sd = sd(accuracy_in_condition), accuracy = mean(accuracy_in_condition), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = accuracy - se, se.max = accuracy + se,
			   ci.min = accuracy - ci, ci.max = accuracy + ci),
		aes(as.factor(layout), accuracy)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Layout") +
    ylab("Accuracy (%)") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# print(p3)

p4 <- ggplot(data.dialogs.accuracy %>%
	group_by(chats) %>%
	summarise(sd = sd(accuracy_in_condition), accuracy = mean(accuracy_in_condition), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = accuracy - se, se.max = accuracy + se,
			   ci.min = accuracy - ci, ci.max = accuracy + ci),
		aes(as.factor(chats), accuracy)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Chats") +
    ylab("Accuracy (%)") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# print(p4)

##########################
#### WITHOUT OUTLIERS ####
##########################

### DIALOGS ###
data.dialogs.dialogs.iqr <- IQR(data.dialogs.dialogs$dialogs_in_condition)
data.dialogs.dialogs.lowerq <- quantile(data.dialogs.dialogs$dialogs_in_condition)[[2]]
data.dialogs.dialogs.upperq <- quantile(data.dialogs.dialogs$dialogs_in_condition)[[4]]

mild.threshold.upper <- (data.dialogs.dialogs.iqr * 1.5) + data.dialogs.dialogs.upperq
mild.threshold.lower <- data.dialogs.dialogs.lowerq - (data.dialogs.dialogs.iqr * 1.5)

print(mild.threshold.upper)
print(mild.threshold.lower)

data.dialogs.dialogs.filtered <- data.dialogs.dialogs[which(data.dialogs.dialogs$dialogs_in_condition <= mild.threshold.upper & data.dialogs.dialogs$dialogs_in_condition > mild.threshold.lower), ]
print(nrow(data.dialogs.dialogs))
print(nrow(data.dialogs.dialogs.filtered))

# ANOVA
data.dialogs.dialogs.filtered.aov <- with(data.dialogs.dialogs.filtered,
	aov(dialogs_in_condition ~ as.factor(layout) * as.factor(chats) + Error(participant / (as.factor(layout) * as.factor(chats))))
)
# print(summary(data.dialogs.dialogs.filtered.aov))

m1 <- lmer(dialogs_in_condition ~ as.factor(layout) * as.factor(chats) + (1|participant) + (1|part) + (1|topic), data = data.dialogs.dialogs.filtered)
print(summary(m1))

# dev.new()
# print(densityplot(data.dialogs.dialogs.filtered$dialogs_in_condition))

data.dialogs.dialogs.filtered %>%
	group_by(layout) %>%
	summarise(sd = sd(dialogs_in_condition), max=max(dialogs_in_condition), min=min(dialogs_in_condition), median=median(dialogs_in_condition), mean=mean(dialogs_in_condition)) %>%
	print(n=2)

data.dialogs.dialogs.filtered %>%
	group_by(chats) %>%
	summarise(sd = sd(dialogs_in_condition), max=max(dialogs_in_condition), min=min(dialogs_in_condition), median=median(dialogs_in_condition), mean=mean(dialogs_in_condition)) %>%
	print(n=2)

p1 <- ggplot(data.dialogs.dialogs.filtered, aes(dialogs_in_condition)) +
	scale_fill_manual(name = "Layout",
						labels = c("layout 1", "layout 2"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(layout), fill=as.factor(layout)), alpha = 0.6) +
	xlab("Dialogs") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# print(p1)

p2 <- ggplot(data.dialogs.dialogs.filtered, aes(dialogs_in_condition)) +
	scale_fill_manual(name = "Chats",
						labels = c("3 chats", "4 chats"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(chats), fill=as.factor(chats)), alpha = 0.6) +
	xlab("Dialogs") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# print(p2)

p3 <- ggplot(data.dialogs.dialogs.filtered %>%
	group_by(layout) %>%
	summarise(sd = sd(dialogs_in_condition), dialogs = mean(dialogs_in_condition), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = dialogs - se, se.max = dialogs + se,
			   ci.min = dialogs - ci, ci.max = dialogs + ci),
		aes(as.factor(layout), dialogs)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Layout") +
    ylab("Dialogs") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# print(p3)

p4 <- ggplot(data.dialogs.dialogs.filtered %>%
	group_by(chats) %>%
	summarise(sd = sd(dialogs_in_condition), dialogs = mean(dialogs_in_condition), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = dialogs - se, se.max = dialogs + se,
			   ci.min = dialogs - ci, ci.max = dialogs + ci),
		aes(as.factor(chats), dialogs)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Chats") +
    ylab("Dialogs") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# print(p4)

# TODO: Dialogs in condition without outliers shows better results???

### FINISHED DIALOGS ###
data.dialogs.finisheddialogs.iqr <- IQR(data.dialogs.finisheddialogs$finished_dialogs_in_condition)
data.dialogs.finisheddialogs.lowerq <- quantile(data.dialogs.finisheddialogs$finished_dialogs_in_condition)[[2]]
data.dialogs.finisheddialogs.upperq <- quantile(data.dialogs.finisheddialogs$finished_dialogs_in_condition)[[4]]

mild.threshold.upper <- (data.dialogs.finisheddialogs.iqr * 1.5) + data.dialogs.finisheddialogs.upperq
mild.threshold.lower <- data.dialogs.finisheddialogs.lowerq - (data.dialogs.finisheddialogs.iqr * 1.5)

print(mild.threshold.upper)
print(mild.threshold.lower)

data.dialogs.finisheddialogs.filtered <- data.dialogs.finisheddialogs[which(data.dialogs.finisheddialogs$finished_dialogs_in_condition <= mild.threshold.upper & data.dialogs.finisheddialogs$finished_dialogs_in_condition > mild.threshold.lower), ]
print(nrow(data.dialogs.finisheddialogs))
print(nrow(data.dialogs.finisheddialogs.filtered))

# ANOVA
data.dialogs.finisheddialogs.filtered.aov <- with(data.dialogs.finisheddialogs.filtered,
	aov(finished_dialogs_in_condition ~ as.factor(layout) * as.factor(chats) + Error(participant / (as.factor(layout) * as.factor(chats))))
)
# print(summary(data.dialogs.finisheddialogs.filtered.aov))

m1 <- lmer(finished_dialogs_in_condition ~ as.factor(layout) * as.factor(chats) + (1|participant) + (1|part) + (1|topic), data = data.dialogs.finisheddialogs.filtered)
print(summary(m1))

# dev.new()
# print(densityplot(data.dialogs.finisheddialogs.filtered$finished_dialogs_in_condition))

data.dialogs.finisheddialogs.filtered %>%
	group_by(layout) %>%
	summarise(sd = sd(finished_dialogs_in_condition), max=max(finished_dialogs_in_condition), min=min(finished_dialogs_in_condition), median=median(finished_dialogs_in_condition), mean=mean(finished_dialogs_in_condition)) %>%
	print(n=2)

data.dialogs.finisheddialogs.filtered %>%
	group_by(chats) %>%
	summarise(sd = sd(finished_dialogs_in_condition), max=max(finished_dialogs_in_condition), min=min(finished_dialogs_in_condition), median=median(finished_dialogs_in_condition), mean=mean(finished_dialogs_in_condition)) %>%
	print(n=2)

p1 <- ggplot(data.dialogs.finisheddialogs.filtered, aes(finished_dialogs_in_condition)) +
	scale_fill_manual(name = "Layout",
						labels = c("layout 1", "layout 2"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(layout), fill=as.factor(layout)), alpha = 0.6) +
	xlab("Finished dialogs") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# print(p1)

p2 <- ggplot(data.dialogs.finisheddialogs.filtered, aes(finished_dialogs_in_condition)) +
	scale_fill_manual(name = "Chats",
						labels = c("3 chats", "4 chats"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(chats), fill=as.factor(chats)), alpha = 0.6) +
	xlab("Finished dialogs") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# print(p2)

p3 <- ggplot(data.dialogs.finisheddialogs.filtered %>%
	group_by(layout) %>%
	summarise(sd = sd(finished_dialogs_in_condition), dialogs = mean(finished_dialogs_in_condition), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = dialogs - se, se.max = dialogs + se,
			   ci.min = dialogs - ci, ci.max = dialogs + ci),
		aes(as.factor(layout), dialogs)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Layout") +
    ylab("Finished dialogs") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# print(p3)

p4 <- ggplot(data.dialogs.finisheddialogs.filtered %>%
	group_by(chats) %>%
	summarise(sd = sd(finished_dialogs_in_condition), dialogs = mean(finished_dialogs_in_condition), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = dialogs - se, se.max = dialogs + se,
			   ci.min = dialogs - ci, ci.max = dialogs + ci),
		aes(as.factor(chats), dialogs)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Chats") +
    ylab("Finished dialogs") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# print(p4)

### RESPONSES ###
data.dialogs.responses.iqr <- IQR(data.dialogs.responses$responses_in_condition)
data.dialogs.responses.lowerq <- quantile(data.dialogs.responses$responses_in_condition)[[2]]
data.dialogs.responses.upperq <- quantile(data.dialogs.responses$responses_in_condition)[[4]]

mild.threshold.upper <- (data.dialogs.responses.iqr * 1.5) + data.dialogs.responses.upperq
mild.threshold.lower <- data.dialogs.responses.lowerq - (data.dialogs.responses.iqr * 1.5)

print(mild.threshold.upper)
print(mild.threshold.lower)

data.dialogs.responses.filtered <- data.dialogs.responses[which(data.dialogs.responses$responses_in_condition <= mild.threshold.upper & data.dialogs.responses$responses_in_condition > mild.threshold.lower), ]
print(nrow(data.dialogs.responses))
print(nrow(data.dialogs.responses.filtered))

# ANOVA
data.dialogs.responses.filtered.aov <- with(data.dialogs.responses.filtered,
	aov(responses_in_condition ~ as.factor(layout) * as.factor(chats) + Error(participant / (as.factor(layout) * as.factor(chats))))
)
# print(summary(data.dialogs.responses.filtered.aov))

m1 <- lmer(responses_in_condition ~ as.factor(layout) * as.factor(chats) + (1|participant) + (1|part) + (1|topic), data = data.dialogs.responses.filtered)
print(summary(m1))

# dev.new()
# print(densityplot(data.dialogs.responses.filtered$responses_in_condition))

data.dialogs.responses.filtered %>%
	group_by(layout) %>%
	summarise(sd = sd(responses_in_condition), max=max(responses_in_condition), min=min(responses_in_condition), median=median(responses_in_condition), mean=mean(responses_in_condition)) %>%
	print(n=2)

data.dialogs.responses.filtered %>%
	group_by(chats) %>%
	summarise(sd = sd(responses_in_condition), max=max(responses_in_condition), min=min(responses_in_condition), median=median(responses_in_condition), mean=mean(responses_in_condition)) %>%
	print(n=2)

p1 <- ggplot(data.dialogs.responses.filtered, aes(responses_in_condition)) +
	scale_fill_manual(name = "Layout",
						labels = c("layout 1", "layout 2"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(layout), fill=as.factor(layout)), alpha = 0.6) +
	xlab("Responses") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# print(p1)

p2 <- ggplot(data.dialogs.responses.filtered, aes(responses_in_condition)) +
	scale_fill_manual(name = "Chats",
						labels = c("3 chats", "4 chats"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(chats), fill=as.factor(chats)), alpha = 0.6) +
	xlab("Responses") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# print(p2)

p3 <- ggplot(data.dialogs.responses.filtered %>%
	group_by(layout) %>%
	summarise(sd = sd(responses_in_condition), dialogs = mean(responses_in_condition), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = dialogs - se, se.max = dialogs + se,
			   ci.min = dialogs - ci, ci.max = dialogs + ci),
		aes(as.factor(layout), dialogs)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Layout") +
    ylab("Responses") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# print(p3)

p4 <- ggplot(data.dialogs.responses.filtered %>%
	group_by(chats) %>%
	summarise(sd = sd(responses_in_condition), dialogs = mean(responses_in_condition), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = dialogs - se, se.max = dialogs + se,
			   ci.min = dialogs - ci, ci.max = dialogs + ci),
		aes(as.factor(chats), dialogs)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Chats") +
    ylab("Responses") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# print(p4)

### ACCURACY ###
data.dialogs.accuracy.iqr <- IQR(data.dialogs.accuracy$accuracy_in_condition)
data.dialogs.accuracy.lowerq <- quantile(data.dialogs.accuracy$accuracy_in_condition)[[2]]
data.dialogs.accuracy.upperq <- quantile(data.dialogs.accuracy$accuracy_in_condition)[[4]]

mild.threshold.upper <- (data.dialogs.accuracy.iqr * 1.5) + data.dialogs.accuracy.upperq
mild.threshold.lower <- data.dialogs.accuracy.lowerq - (data.dialogs.accuracy.iqr * 1.5)

print(mild.threshold.upper)
print(mild.threshold.lower)

data.dialogs.accuracy.filtered <- data.dialogs.accuracy[which(data.dialogs.accuracy$accuracy_in_condition <= mild.threshold.upper & data.dialogs.accuracy$accuracy_in_condition > mild.threshold.lower), ]
print(nrow(data.dialogs.accuracy))
print(nrow(data.dialogs.accuracy.filtered))

# ANOVA
data.dialogs.accuracy.filtered.aov <- with(data.dialogs.accuracy.filtered,
	aov(accuracy_in_condition ~ as.factor(layout) * as.factor(chats) + Error(participant / (as.factor(layout) * as.factor(chats))))
)
# print(summary(data.dialogs.accuracy.filtered.aov))

m1 <- lmer(accuracy_in_condition ~ as.factor(layout) * as.factor(chats) + (1|participant) + (1|part) + (1|topic), data = data.dialogs.accuracy.filtered)
print(summary(m1))

# dev.new()
# print(densityplot(data.dialogs.accuracy.filtered$accuracy_in_condition))

data.dialogs.accuracy.filtered %>%
	group_by(layout) %>%
	summarise(sd = sd(accuracy_in_condition), max=max(accuracy_in_condition), min=min(accuracy_in_condition), median=median(accuracy_in_condition), mean=mean(accuracy_in_condition)) %>%
	print(n=2)

data.dialogs.accuracy.filtered %>%
	group_by(chats) %>%
	summarise(sd = sd(accuracy_in_condition), max=max(accuracy_in_condition), min=min(accuracy_in_condition), median=median(accuracy_in_condition), mean=mean(accuracy_in_condition)) %>%
	print(n=2)

p1 <- ggplot(data.dialogs.accuracy.filtered, aes(accuracy_in_condition)) +
	scale_fill_manual(name = "Layout",
						labels = c("layout 1", "layout 2"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(layout), fill=as.factor(layout)), alpha = 0.6) +
	xlab("Accuracy") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# print(p1)

p2 <- ggplot(data.dialogs.accuracy.filtered, aes(accuracy_in_condition)) +
	scale_fill_manual(name = "Chats",
						labels = c("3 chats", "4 chats"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(chats), fill=as.factor(chats)), alpha = 0.6) +
	xlab("Accuracy") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# print(p2)

p3 <- ggplot(data.dialogs.accuracy.filtered %>%
	group_by(layout) %>%
	summarise(sd = sd(accuracy_in_condition), dialogs = mean(accuracy_in_condition), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = dialogs - se, se.max = dialogs + se,
			   ci.min = dialogs - ci, ci.max = dialogs + ci),
		aes(as.factor(layout), dialogs)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Layout") +
    ylab("Accuracy") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# print(p3)

p4 <- ggplot(data.dialogs.accuracy.filtered %>%
	group_by(chats) %>%
	summarise(sd = sd(accuracy_in_condition), dialogs = mean(accuracy_in_condition), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = dialogs - se, se.max = dialogs + se,
			   ci.min = dialogs - ci, ci.max = dialogs + ci),
		aes(as.factor(chats), dialogs)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Chats") +
    ylab("Accuracy") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# print(p4)