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

# Filter outliers
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

# dev.new()
# plot(densityplot(data.dialogs.dialogs.filtered$dialogs_in_condition))

# Statistics
data.dialogs.dialogs.filtered %>%
	group_by(condition) %>%
	summarise(mean=mean(dialogs_in_condition), sd = sd(dialogs_in_condition), min=min(dialogs_in_condition),max=max(dialogs_in_condition)) %>%
	print(n=4)

# Linear mixed model
# m1 <- lmer(dialogs_in_condition ~ as.factor(layout) * as.factor(chats) + (1|participant) + (1|part) + (1|topic), data = data.dialogs.dialogs.filtered)
# print(summary(m1))

m1 <- lmer(dialogs_in_condition ~ as.factor(layout) + as.factor(chats) + (1|participant), data = data.dialogs.dialogs.filtered)
print(summary(m1))

m2 <- lmer(scale(dialogs_in_condition) ~ as.factor(layout) + as.factor(chats) + (1|participant), data = data.dialogs.dialogs.filtered)
print(summary(m2))

# Without filtering
m3 <- lmer(scale(dialogs_in_condition) ~ as.factor(layout) + as.factor(chats) + (1|participant), data = data.dialogs.dialogs)
print(summary(m3))

# Plots
p1 <- ggplot(data.dialogs.dialogs.filtered, aes(dialogs_in_condition)) +
	ggtitle("Total number of chats in condition density") +
	scale_fill_manual(name = "chats",
						labels = c("3", "4"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(chats), fill=as.factor(chats)), alpha = 0.6) +
	facet_grid(. ~ layout, labeller = label_both) +
	xlab("chats") +
	theme_minimal() +
	theme(legend.position = c(0.5, 0.85),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
dev.new()
plot(p1)

p2 <- ggplot(data.dialogs.dialogs.filtered %>%
	group_by(layout, chats) %>%
	summarise(sd = sd(dialogs_in_condition), dialogs_in_condition = mean(dialogs_in_condition), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = dialogs_in_condition - se, se.max = dialogs_in_condition + se,
			   ci.min = dialogs_in_condition - ci, ci.max = dialogs_in_condition + ci),
		aes(as.factor(layout), dialogs_in_condition, fill = as.factor(chats))) +
	theme_minimal() +
	scale_fill_manual(name = "chats",
					  labels = c("3", "4"),
 					  values = c("#F79E9B", "#62D2D4")) +
  	geom_bar(stat="identity", position = "dodge") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max), width=0.2, position=position_dodge(.9)) +
	xlab("layout") +
    ylab("chats") +
	ggtitle("Mean total number of chats") +
dev.new()
plot(p2)

# Boxplot
p3 <- ggplot(data.dialogs.dialogs.filtered %>%
       group_by(participant,layout,chats) %>%
       summarise(dialogs_in_condition = mean(dialogs_in_condition)),
       aes(as.factor(layout), dialogs_in_condition, fill = as.factor(chats))) +
    geom_boxplot() +
	theme_minimal() +
	xlab("layout") +
    ylab("chats") +
	scale_fill_manual(name = "chats",
					  labels = c("3", "4"),
 					  values = c("#F79E9B", "#62D2D4"))
dev.new()
plot(p3)

# ### FINISHED DIALOGS ###
# # Get only the rows that have dialogs_in_condition values
data.dialogs.finisheddialogs <- data.dialogs %>% drop_na("finished_dialogs_in_condition")

# Filter outliers
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

# dev.new()
# plot(densityplot(data.dialogs.finisheddialogs.filtered$finished_dialogs_in_condition))

# Statistics
data.dialogs.finisheddialogs.filtered %>%
	group_by(condition) %>%
	summarise(mean=mean(finished_dialogs_in_condition), sd = sd(finished_dialogs_in_condition), min=min(finished_dialogs_in_condition),max=max(finished_dialogs_in_condition)) %>%
	print(n=4)

# Linear mixed model
# m1 <- lmer(finished_dialogs_in_condition ~ as.factor(layout) * as.factor(chats) + (1|participant) + (1|part) + (1|topic), data = data.dialogs.finisheddialogs.filtered)
# print(summary(m1))

m1 <- lmer(finished_dialogs_in_condition ~ as.factor(layout) + as.factor(chats) + (1|participant), data = data.dialogs.finisheddialogs.filtered)
print(summary(m1))

m2 <- lmer(scale(finished_dialogs_in_condition) ~ as.factor(layout) + as.factor(chats) + (1|participant), data = data.dialogs.finisheddialogs.filtered)
print(summary(m2))

# Without filtering
m3 <- lmer(scale(finished_dialogs_in_condition) ~ as.factor(layout) + as.factor(chats) + (1|participant), data = data.dialogs.finisheddialogs)
print(summary(m3))

# Plots
p1 <- ggplot(data.dialogs.finisheddialogs.filtered, aes(finished_dialogs_in_condition)) +
	ggtitle("Number of handled chats in condition density") +
	scale_fill_manual(name = "chats",
						labels = c("3", "4"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(chats), fill=as.factor(chats)), alpha = 0.6) +
	facet_grid(. ~ layout, labeller = label_both) +
	xlab("chats") +
	theme_minimal() +
	theme(legend.position = c(0.5, 0.85),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
dev.new()
plot(p1)

p2 <- ggplot(data.dialogs.finisheddialogs.filtered %>%
	group_by(layout, chats) %>%
	summarise(sd = sd(finished_dialogs_in_condition), finished_dialogs_in_condition = mean(finished_dialogs_in_condition), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = finished_dialogs_in_condition - se, se.max = finished_dialogs_in_condition + se,
			   ci.min = finished_dialogs_in_condition - ci, ci.max = finished_dialogs_in_condition + ci),
		aes(as.factor(layout), finished_dialogs_in_condition, fill = as.factor(chats))) +
	theme_minimal() +
	scale_fill_manual(name = "chats",
					  labels = c("3", "4"),
 					  values = c("#F79E9B", "#62D2D4")) +
  	geom_bar(stat="identity", position = "dodge") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max), width=0.2, position=position_dodge(.9)) +
	xlab("layout") +
    ylab("chats") +
	ggtitle("Mean number of handled chats") +
dev.new()
plot(p2)

# Boxplot
p3 <- ggplot(data.dialogs.finisheddialogs.filtered %>%
       group_by(participant,layout,chats) %>%
       summarise(finished_dialogs_in_condition = mean(finished_dialogs_in_condition)),
       aes(as.factor(layout), finished_dialogs_in_condition, fill = as.factor(chats))) +
    geom_boxplot() +
	theme_minimal() +
	xlab("layout") +
    ylab("chats") +
	scale_fill_manual(name = "chats",
					  labels = c("3", "4"),
 					  values = c("#F79E9B", "#62D2D4"))
dev.new()
plot(p3)

# ### RESPONSES ###
# # Get only the rows that have responses_in_condition values
data.dialogs.responses <- data.dialogs %>% drop_na("responses_in_condition")

# Filter outliers
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

# dev.new()
# plot(densityplot(data.dialogs.responses.filtered$responses_in_condition))

# Statistics
data.dialogs.responses.filtered %>%
	group_by(condition) %>%
	summarise(mean=mean(responses_in_condition), sd = sd(responses_in_condition), min=min(responses_in_condition),max=max(responses_in_condition)) %>%
	print(n=4)

# Linear mixed model
# m1 <- lmer(responses_in_condition ~ as.factor(layout) * as.factor(chats) + (1|participant) + (1|part) + (1|topic), data = data.dialogs.responses.filtered)
# print(summary(m1))

m1 <- lmer(responses_in_condition ~ as.factor(layout) + as.factor(chats) + (1|participant), data = data.dialogs.responses.filtered)
print(summary(m1))

m2 <- lmer(scale(responses_in_condition) ~ as.factor(layout) + as.factor(chats) + (1|participant), data = data.dialogs.responses.filtered)
print(summary(m2))

# Without filtering
m3 <- lmer(scale(responses_in_condition) ~ as.factor(layout) + as.factor(chats) + (1|participant), data = data.dialogs.responses)
print(summary(m3))

# Plots
p1 <- ggplot(data.dialogs.responses.filtered, aes(responses_in_condition)) +
	ggtitle("Number of repsonses in condition density") +
	scale_fill_manual(name = "chats",
						labels = c("3", "4"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(chats), fill=as.factor(chats)), alpha = 0.6) +
	facet_grid(. ~ layout, labeller = label_both) +
	xlab("chats") +
	theme_minimal() +
	theme(legend.position = c(0.5, 0.85),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
dev.new()
plot(p1)

p2 <- ggplot(data.dialogs.responses.filtered %>%
	group_by(layout, chats) %>%
	summarise(sd = sd(responses_in_condition), responses_in_condition = mean(responses_in_condition), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = responses_in_condition - se, se.max = responses_in_condition + se,
			   ci.min = responses_in_condition - ci, ci.max = responses_in_condition + ci),
		aes(as.factor(layout), responses_in_condition, fill = as.factor(chats))) +
	theme_minimal() +
	scale_fill_manual(name = "chats",
					  labels = c("3", "4"),
 					  values = c("#F79E9B", "#62D2D4")) +
  	geom_bar(stat="identity", position = "dodge") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max), width=0.2, position=position_dodge(.9)) +
	xlab("layout") +
    ylab("responses") +
	ggtitle("Mean number of responses") +
dev.new()
plot(p2)

# Boxplot
p3 <- ggplot(data.dialogs.responses.filtered %>%
       group_by(participant,layout,chats) %>%
       summarise(responses_in_condition = mean(responses_in_condition)),
       aes(as.factor(layout), responses_in_condition, fill = as.factor(chats))) +
    geom_boxplot() +
	theme_minimal() +
	xlab("layout") +
    ylab("responses") +
	scale_fill_manual(name = "chats",
					  labels = c("3", "4"),
 					  values = c("#F79E9B", "#62D2D4"))
dev.new()
plot(p3)
