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
library(car)
library(MASS)
library(sjstats)

data.questions <- read.table("csv/q&a.csv", header = T, sep = ";", dec = ",")

###########################
# Question response times #
###########################

# Statistics
data.questions %>%
	group_by(condition) %>%
	summarise(mean=mean(wait_time), median=median(wait_time), sd=sd(wait_time), min=min(wait_time),max=max(wait_time)) %>%
	print(n=4)

dev.new()
plot(densityplot(data.questions$wait_time))

dev.new()
plot(densityplot(log(data.questions$wait_time)))

# Test distributions
gamma <- fitdistr(log(data.questions$wait_time), "Gamma")
dev.new()
qqp(log(data.questions$wait_time), "gamma", shape = gamma$estimate[[1]], rate = gamma$estimate[[2]])

# Not filtered
m1 <- glmer(wait_time ~ as.factor(layout) * as.factor(chats) + (1|participant), data = data.questions, family=Gamma(link="log"))
print(summary(m1))

# Intraclass correlation
print(icc(m1))

# p1 <- ggplot(data.questions, aes(wait_time)) +
# 	ggtitle("Question response time density") +
# 	scale_fill_manual(name = "chats",
# 						labels = c("3", "4"),
# 						values = c("#F79E9B", "#62D2D4")) +
# 	geom_density(aes(group=as.factor(chats), fill=as.factor(chats)), alpha = 0.6) +
# 	facet_grid(. ~ layout, labeller = label_both) +
# 	xlab("time (s)") +
# 	theme_minimal() +
# 	theme(legend.position = c(0.85, 0.85),
# 		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# plot(p1)

# p2 <- ggplot(data.questions %>%
# 	group_by(layout, chats) %>%
# 	summarise(sd = sd(wait_time), wait_time = mean(wait_time), n = n()) %>%
# 		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
# 		mutate(se.min = wait_time - se, se.max = wait_time + se,
# 			   ci.min = wait_time - ci, ci.max = wait_time + ci),
# 		aes(as.factor(layout), wait_time, fill = as.factor(chats))) +
# 	theme_minimal() +
# 	scale_fill_manual(name = "chats",
# 					  labels = c("3", "4"),
#  					  values = c("#F79E9B", "#62D2D4")) +
#   	geom_bar(stat="identity", position = "dodge") +
#     geom_errorbar(aes(ymin=ci.min, ymax=ci.max), width=0.2, position=position_dodge(.9)) +
# 	xlab("layout") +
#     ylab("time (s)") +
# 	ggtitle("Mean question response time in seconds") +
# dev.new()
# plot(p2)

# p3 <- ggplot(data.questions %>%
#        group_by(participant,layout,chats) %>%
#        summarise(wait_time = mean(wait_time)),
#        aes(as.factor(layout), wait_time, fill = as.factor(chats))) +
#     geom_boxplot() +
# 	theme_minimal() +
# 	theme(axis.text=element_text(size=20),
#           axis.title=element_text(size=20),
# 		  legend.text=element_text(size=20),
# 		  legend.title=element_text(size=20)) +
# 	xlab("layout") +
#     ylab("time (s)") +
# 	scale_fill_manual(name = "chats",
# 					  labels = c("3", "4"),
#  					  values = c("#F79E9B", "#62D2D4"))
# dev.new()
# plot(p3)

p4 <- ggplot(data.questions %>%
		group_by(participant, chats, layout) %>%
		summarise(wait_time = mean(wait_time)),
 		aes(as.factor(chats), wait_time, fill = as.factor(layout))) +
    geom_boxplot() +
    ylab("Time (s)") +
    xlab("Chats") +
    theme_minimal() +
    scale_fill_manual(name = "Layout",
					  labels = c("windowed", "tabbed"),
					  values=c("#F79E9B", "skyblue")) +
   theme(axis.text=element_text(size=16, face="bold"),  # axis numbers larger
          axis.title=element_text(size=16, face="bold"),  # axis labels larger
		  legend.title=element_text(size=16, face="bold"),
		  legend.text=element_text(size=16))
dev.new()
plot(p4)

# p5 <- ggplot(data.questions %>%
# 		group_by(participant, chats, layout) %>%
# 		summarise(wait_time = mean(wait_time)),
#  		aes(as.factor(chats), wait_time, fill = as.factor(layout))) +
#     geom_boxplot() +
#     ylab("Time (s)") +
#     xlab("Chats") +
#     theme_minimal() +
#     scale_fill_manual(name = "Layout",
# 					  labels = c("1", "2"),
# 					  values=c("skyblue", "darkseagreen")) +
#    theme(axis.text=element_text(size=16, face="bold"),  # axis numbers larger
#           axis.title=element_text(size=16, face="bold"),  # axis labels larger
# 		  legend.title=element_text(size=16, face="bold"),
# 		  legend.text=element_text(size=16))
# dev.new()
# plot(p5)

# p6 <- ggplot(data.questions %>%
# 		group_by(participant, chats) %>%
# 		summarise(wait_time = mean(wait_time)),
#  		aes(as.factor(chats), wait_time)) +
#     geom_boxplot(fill="skyblue") +
# 	ggtitle("Question response time") +
#     ylab("Time (s)") +
#     xlab("Chats") +
#     theme_minimal() +
#     theme(axis.text=element_text(size=16, face="bold"),  # axis numbers larger
#           axis.title=element_text(size=16, face="bold"),  # axis labels larger
# 		  legend.title=element_text(size=16, face="bold"),
# 		  legend.text=element_text(size=16),
# 		  plot.title = element_text(hjust=0.5))
# dev.new()
# plot(p6)

# p7 <- ggplot(data.questions %>%
# 		group_by(participant, layout) %>%
# 		summarise(wait_time = mean(wait_time)),
#  		aes(as.factor(layout), wait_time)) +
#     geom_boxplot(fill="skyblue") +
# 	ggtitle("Question response time") +
#     ylab("Time (s)") +
#     xlab("Layout") +
#     theme_minimal() +
#     theme(axis.text=element_text(size=16, face="bold"),  # axis numbers larger
#           axis.title=element_text(size=16, face="bold"),  # axis labels larger
# 		  legend.title=element_text(size=16, face="bold"),
# 		  legend.text=element_text(size=16),
# 		  plot.title = element_text(hjust=0.5))
# dev.new()
# plot(p7)

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
	summarise(mean=mean(errors), median=median(errors), sd=sd(errors), min=min(errors),max=max(errors)) %>%
	print(n=4)

dev.new()
plot(densityplot(data.questions.errors$errors))

# Test distributions
poisson.test <- fitdistr(data.questions.errors$errors, "Poisson")
dev.new()
qqp(data.questions.errors$errors, "pois", lambda=0.66315789)

# Generalized mixed model
m2 <- glmer(errors ~ as.factor(layout) * as.factor(chats) + (1|participant), data=data.questions.errors, family=poisson(link = "log"))
print(summary(m2))

# Intraclass correlation
print(icc(m2))

# p5 <- ggplot(data.questions.errors %>%
# 	group_by(layout, chats) %>%
# 	summarise(sd = sd(errors), errors = mean(errors), n = n()) %>%
# 		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
# 		mutate(se.min = errors - se, se.max = errors + se,
# 			   ci.min = errors - ci, ci.max = errors + ci),
# 		aes(as.factor(layout), errors, fill = as.factor(chats))) +
# 	scale_fill_manual(name = "chats",
# 					  labels = c("3", "4"),
#  					  values = c("#F79E9B", "#62D2D4")) +
#   	geom_bar(position=position_dodge(), stat="identity") +
#     geom_errorbar(aes(ymin=ci.min, ymax=ci.max), width=0.2, position=position_dodge(.9)) +
# 	theme_minimal() +
# 	xlab("layout") +
#     ylab("errors") +
# 	ggtitle("Mean number of errors") +
# dev.new()
# plot(p5)

p6 <- ggplot(data.questions.errors %>%
	group_by(chats, layout) %>%
	summarise(sd = sd(errors), errors = mean(errors), n = n()) %>%
		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
		mutate(se.min = errors - se, se.max = errors + se,
			   ci.min = errors - ci, ci.max = errors + ci),
		aes(as.factor(chats), errors, fill = as.factor(layout))) +
	scale_fill_manual(name = "Layout",
					  labels = c("windowed", "tabbed"),
 					  values = c("#F79E9B", "skyblue")) +
  	geom_bar(position=position_dodge(), stat="identity") +
    geom_errorbar(aes(ymin=ci.min, ymax=ci.max), width=0.2, position=position_dodge(.9)) +
	xlab("Chats") +
    ylab("Number of errors") +
	theme_minimal() +
	theme(axis.text=element_text(size=16, face="bold"),  # axis numbers larger
          axis.title=element_text(size=16, face="bold"),  # axis labels larger
		  legend.title=element_text(size=16, face="bold"),
		  legend.text=element_text(size=16))
dev.new()
plot(p6)

# p7 <- ggplot(data.questions.errors %>%
# 	group_by(chats, layout) %>%
# 	summarise(sd = sd(errors), errors = mean(errors), n = n()) %>%
# 		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
# 		mutate(se.min = errors - se, se.max = errors + se,
# 			   ci.min = errors - ci, ci.max = errors + ci),
# 		aes(as.factor(chats), errors, fill = as.factor(layout))) +
# 	scale_fill_manual(name = "Layout",
# 					  labels = c("1", "2"),
#  					  values = c("skyblue", "darkseagreen")) +
#   	geom_bar(position=position_dodge(), stat="identity") +
#     geom_errorbar(aes(ymin=ci.min, ymax=ci.max), width=0.2, position=position_dodge(.9)) +
# 	xlab("Chats") +
#     ylab("Number of errors") +
# 	theme_minimal() +
# 	theme(axis.text=element_text(size=16, face="bold"),  # axis numbers larger
#           axis.title=element_text(size=16, face="bold"),  # axis labels larger
# 		  legend.title=element_text(size=16, face="bold"),
# 		  legend.text=element_text(size=16))
# dev.new()
# plot(p7)

# p7 <- ggplot(data.questions.errors %>%
#        group_by(participant,layout,chats) %>%
#        summarise(errors = mean(errors)),
#        aes(as.factor(layout), errors, fill = as.factor(chats))) +
#     geom_boxplot() +
# 	theme_minimal() +
# 	theme(axis.text=element_text(size=20),
#           axis.title=element_text(size=20),
# 		  legend.text=element_text(size=20),
# 		  legend.title=element_text(size=20)) +
# 	xlab("layout") +
#     ylab("errors") +
# 	scale_fill_manual(name = "chats",
# 					  labels = c("3", "4"),
#  					  values = c("#F79E9B", "#62D2D4"))
# dev.new()
# plot(p7)
