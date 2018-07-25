library(lme4)
library(lmerTest)

data.firstresponses <- read.table("csv/first_response_times.csv", header = T, sep = ";", dec = ",")

# Anova
data.firstresponses.aov <- with(data.firstresponses,
	aov(first_response_time ~ as.factor(layout) * as.factor(chats) + Error(participant / (as.factor(layout) * as.factor(chats))))
)
print(summary(data.firstresponses.aov))

# Linear mixed model
m1 <- lmer(first_response_time ~ as.factor(layout) * as.factor(chats) + (1|participant) + (1|part) + (1|topic), data = data.firstresponses)
print(summary(m1))

# dev.new()
# print(densityplot(data.firstresponses$first_response_time))

# Both again with participant means for each condition
data.firstresponses.mean <- aggregate(data.firstresponses$first_response_time,
	by = list(data.firstresponses$participant, data.firstresponses$layout, data.firstresponses$chats),
	FUN = mean
)
colnames(data.firstresponses.mean) <- c("participant", "layout", "chats", "first_response_time")

data.firstresponses.mean.aov <- with(data.firstresponses.mean,
	aov(first_response_time ~ as.factor(layout) * as.factor(chats) + Error(participant / (as.factor(layout) * as.factor(chats))))
)
print(summary(data.firstresponses.mean.aov))

m2 <- lmer(first_response_time ~ as.factor(layout) * as.factor(chats) + (1|participant), data = data.firstresponses.mean)
print(summary(m2))

data.firstresponses.mean %>%
	group_by(layout) %>%
	summarise(sd = sd(first_response_time), response_time = mean(first_response_time)) %>%
	print(n=2)

data.firstresponses.mean %>%
	group_by(chats) %>%
	summarise(sd = sd(first_response_time), response_time = mean(first_response_time)) %>%
	print(n=2)

p1 <- ggplot(data.firstresponses.mean, aes(first_response_time)) +
	scale_fill_manual(name = "Layout",
						labels = c("layout 1", "layout 2"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(layout), fill=as.factor(layout)), alpha = 0.6) +
	xlab("First response time (s)") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# print(p1)

p2 <- ggplot(data.firstresponses.mean, aes(first_response_time)) +
	scale_fill_manual(name = "Chats",
						labels = c("3 chats", "4 chats"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(chats), fill=as.factor(chats)), alpha = 0.6) +
	xlab("First response time (s)") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# print(p2)

p3 <- ggplot(data.firstresponses.mean %>%
	group_by(layout) %>%
	summarise(sd = sd(first_response_time), response_time = mean(first_response_time), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = response_time - se, se.max = response_time + se,
			   ci.min = response_time - ci, ci.max = response_time + ci),
		aes(as.factor(layout), response_time)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Layout") +
    ylab("First response time (s)") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# print(p3)

p4 <- ggplot(data.firstresponses.mean %>%
	group_by(chats) %>%
	summarise(sd = sd(first_response_time), response_time = mean(first_response_time), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = response_time - se, se.max = response_time + se,
			   ci.min = response_time - ci, ci.max = response_time + ci),
		aes(as.factor(chats), response_time)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Chats") +
    ylab("First response time (s)") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# print(p4)

##########################
#### WITHOUT OUTLIERS ####
##########################

data.firstresponses.iqr <- IQR(data.firstresponses$first_response_time)
data.firstresponses.lowerq <- quantile(data.firstresponses$first_response_time)[[2]]
data.firstresponses.upperq <- quantile(data.firstresponses$first_response_time)[[4]]

mild.threshold.upper <- (data.firstresponses.iqr * 1.5) + data.firstresponses.upperq
mild.threshold.lower <- data.firstresponses.lowerq - (data.firstresponses.iqr * 1.5)

data.firstresponses.filtered <- data.firstresponses[which(data.firstresponses$first_response_time <= mild.threshold.upper), ]
print(nrow(data.firstresponses))
print(nrow(data.firstresponses.filtered))

m1 <- lmer(first_response_time ~ as.factor(layout) * as.factor(chats) + (1|participant) + (1|part) + (1|topic), data = data.firstresponses.filtered)
print(summary(m1))

# dev.new()
# print(densityplot(data.firstresponses.filtered$first_response_time))

data.firstresponses.filtered.mean <- aggregate(data.firstresponses.filtered$first_response_time,
	by = list(data.firstresponses.filtered$participant, data.firstresponses.filtered$layout, data.firstresponses.filtered$chats),
	FUN = mean
)
colnames(data.firstresponses.filtered.mean) <- c("participant", "layout", "chats", "first_response_time")

data.firstresponses.filtered.mean.aov <- with(data.firstresponses.filtered.mean,
	aov(first_response_time ~ as.factor(layout) * as.factor(chats) + Error(participant / (as.factor(layout) * as.factor(chats))))
)
print(summary(data.firstresponses.filtered.mean.aov))

m2 <- lmer(first_response_time ~ as.factor(layout) * as.factor(chats) + (1|participant), data = data.firstresponses.filtered.mean)
print(summary(m2))

data.firstresponses.filtered.mean %>%
	group_by(layout) %>%
	summarise(sd = sd(first_response_time), response_time = mean(first_response_time)) %>%
	print(n=2)

data.firstresponses.filtered.mean %>%
	group_by(chats) %>%
	summarise(sd = sd(first_response_time), response_time = mean(first_response_time)) %>%
	print(n=2)

p1 <- ggplot(data.firstresponses.filtered.mean, aes(first_response_time)) +
	scale_fill_manual(name = "Layout",
						labels = c("layout 1", "layout 2"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(layout), fill=as.factor(layout)), alpha = 0.6) +
	xlab("First response time (s)") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# print(p1)

p2 <- ggplot(data.firstresponses.filtered.mean, aes(first_response_time)) +
	scale_fill_manual(name = "Chats",
						labels = c("3 chats", "4 chats"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_density(aes(group=as.factor(chats), fill=as.factor(chats)), alpha = 0.6) +
	xlab("First response time (s)") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),
		  axis.title=element_text(size=16, face="bold")) +
	theme(legend.position = c(0.25, 0.85),
		  legend.title = element_text(size=16, face="bold"),
		  legend.text = element_text(size=16, face="bold"),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# print(p2)

p3 <- ggplot(data.firstresponses.filtered.mean %>%
	group_by(layout) %>%
	summarise(sd = sd(first_response_time), response_time = mean(first_response_time), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = response_time - se, se.max = response_time + se,
			   ci.min = response_time - ci, ci.max = response_time + ci),
		aes(as.factor(layout), response_time)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Layout") +
    ylab("First response time (s)") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# print(p3)

p4 <- ggplot(data.firstresponses.filtered.mean %>%
	group_by(chats) %>%
	summarise(sd = sd(first_response_time), response_time = mean(first_response_time), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = response_time - se, se.max = response_time + se,
			   ci.min = response_time - ci, ci.max = response_time + ci),
		aes(as.factor(chats), response_time)) +
    geom_bar(stat = "identity", width = 0.7, fill = "deepskyblue") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max, width = 0.3)) +
    xlab("Chats") +
    ylab("First response time (s)") +
    theme_minimal() +
    theme(axis.text=element_text(size=16, face="bold"),
          axis.title=element_text(size=16, face="bold"))
# dev.new()
# print(p4)