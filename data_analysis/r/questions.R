library(lme4)
library(lmerTest)

data.questions <- read.table("csv/q&a.csv", header = T, sep = ";", dec = ",")

# TODO: Should wait time be first calculated as average for each dialog????

# Wait time participant means for each condition
data.questions.waittime.mean <- aggregate(data.questions$wait_time,
	by = list(data.questions$participant, data.questions$layout, data.questions$chats),
	FUN = mean
)
colnames(data.questions.waittime.mean) <- c("participant", "layout", "chats", "wait_time")
data.questions.waittime.mean <- data.questions.waittime.mean[order(data.questions.waittime.mean$participant), ]

dev.new()
print(densityplot(data.questions.waittime.mean$wait_time))

# Anova
data.questions.waittime.mean.aov <- with(data.questions.waittime.mean,
	aov(wait_time ~ as.factor(layout) * as.factor(chats) + Error(participant / (as.factor(layout) * as.factor(chats))))
)
print(summary(data.questions.waittime.mean.aov))

# Linear mixed model
m1 <- lmer(wait_time ~ as.factor(layout) * as.factor(chats) + (1|participant), data = data.questions.waittime.mean)
print(summary(m1))

data.questions.waittime.mean %>%
	group_by(layout) %>%
	summarise(sd = sd(wait_time), response_time = mean(wait_time)) %>%
	print(n=2)

data.questions.waittime.mean %>%
	group_by(chats) %>%
	summarise(sd = sd(wait_time), response_time = mean(wait_time)) %>%
	print(n=2)

p1 <- ggplot(data.questions.waittime.mean, aes(wait_time)) +
	scale_fill_manual(name = "Layout",
						labels = c("layout 1", "layout 2"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(layout), fill=as.factor(layout)), alpha = 0.6) +
	xlab("Question response time (s)") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# print(p1)

p2 <- ggplot(data.questions.waittime.mean, aes(wait_time)) +
	scale_fill_manual(name = "Chats",
						labels = c("3 chats", "4 chats"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(chats), fill=as.factor(chats)), alpha = 0.6) +
	xlab("Question response time (s)") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# print(p2)

p3 <- ggplot(data.questions.waittime.mean %>%
	group_by(layout) %>%
	summarise(sd = sd(wait_time), response_time = mean(wait_time), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = response_time - se, se.max = response_time + se,
			   ci.min = response_time - ci, ci.max = response_time + ci),
		aes(as.factor(layout), response_time)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Layout") +
    ylab("Question response time (s)") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# print(p3)

p4 <- ggplot(data.questions.waittime.mean %>%
	group_by(chats) %>%
	summarise(sd = sd(wait_time), response_time = mean(wait_time), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = response_time - se, se.max = response_time + se,
			   ci.min = response_time - ci, ci.max = response_time + ci),
		aes(as.factor(chats), response_time)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Chats") +
    ylab("Question response time (s)") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# print(p4)

##########################
#### WITHOUT OUTLIERS ####
##########################

data.questions.iqr <- IQR(data.questions$wait_time)
data.questions.lowerq <- quantile(data.questions$wait_time)[[2]]
data.questions.upperq <- quantile(data.questions$wait_time)[[4]]

mild.threshold.upper <- (data.questions.iqr * 1.5) + data.questions.upperq
mild.threshold.lower <- data.questions.lowerq - (data.questions.iqr * 1.5)

print(mild.threshold.upper)
print(mild.threshold.lower)

data.questions.filtered <- data.questions[which(data.questions$wait_time <= mild.threshold.upper), ]
print(nrow(data.questions))
print(nrow(data.questions.filtered))

# Wait time participant means for each condition
data.questions.filtered.waittime.mean <- aggregate(data.questions.filtered$wait_time,
	by = list(data.questions.filtered$participant, data.questions.filtered$layout, data.questions.filtered$chats),
	FUN = mean
)
colnames(data.questions.filtered.waittime.mean) <- c("participant", "layout", "chats", "wait_time")
data.questions.filtered.waittime.mean <- data.questions.filtered.waittime.mean[order(data.questions.filtered.waittime.mean$participant), ]

dev.new()
print(densityplot(data.questions.filtered.waittime.mean$wait_time))

# Anova
data.questions.filtered.waittime.mean.aov <- with(data.questions.filtered.waittime.mean,
	aov(wait_time ~ as.factor(layout) * as.factor(chats) + Error(participant / (as.factor(layout) * as.factor(chats))))
)
print(summary(data.questions.filtered.waittime.mean.aov))

# Linear mixed model
m1 <- lmer(wait_time ~ as.factor(layout) * as.factor(chats) + (1|participant), data = data.questions.filtered.waittime.mean)
print(summary(m1))

data.questions.filtered.waittime.mean %>%
	group_by(layout) %>%
	summarise(sd = sd(wait_time), response_time = mean(wait_time)) %>%
	print(n=2)

data.questions.filtered.waittime.mean %>%
	group_by(chats) %>%
	summarise(sd = sd(wait_time), response_time = mean(wait_time)) %>%
	print(n=2)

p1 <- ggplot(data.questions.filtered.waittime.mean, aes(wait_time)) +
	scale_fill_manual(name = "Layout",
						labels = c("layout 1", "layout 2"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(layout), fill=as.factor(layout)), alpha = 0.6) +
	xlab("Question response time (s)") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# print(p1)

p2 <- ggplot(data.questions.filtered.waittime.mean, aes(wait_time)) +
	scale_fill_manual(name = "Chats",
						labels = c("3 chats", "4 chats"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(chats), fill=as.factor(chats)), alpha = 0.6) +
	xlab("Question response time (s)") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# print(p2)

p3 <- ggplot(data.questions.filtered.waittime.mean %>%
	group_by(layout) %>%
	summarise(sd = sd(wait_time), response_time = mean(wait_time), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = response_time - se, se.max = response_time + se,
			   ci.min = response_time - ci, ci.max = response_time + ci),
		aes(as.factor(layout), response_time)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Layout") +
    ylab("Question response time (s)") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# print(p3)

p4 <- ggplot(data.questions.filtered.waittime.mean %>%
	group_by(chats) %>%
	summarise(sd = sd(wait_time), response_time = mean(wait_time), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = response_time - se, se.max = response_time + se,
			   ci.min = response_time - ci, ci.max = response_time + ci),
		aes(as.factor(chats), response_time)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Chats") +
    ylab("Question response time (s)") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# print(p4)