library(dplyr)
library(tidyr)
library(psych)
library(lme4)
library(lmerTest)
library(ggplot2)
library(lattice)
library(corrplot)
library(gridExtra)
library(car)
library(MASS)
library(sjstats)

data.lastresponses <- read.table("csv/last_response_times.csv", header = T, sep = ";", dec = ",")

dev.new()
plot(densityplot(data.lastresponses$last_response_time), xlab="last response time")

dev.new()
plot(densityplot(log(data.lastresponses$last_response_time)), xlab="log(last response time)")

data.lastresponses %>%
	group_by(condition) %>%
	summarise(mean=mean(last_response_time), median=median(last_response_time), sd = sd(last_response_time), min=min(last_response_time),max=max(last_response_time)) %>%
	print(n=4)

# test gamma
gamma <- fitdistr(log(data.lastresponses$last_response_time), "Gamma")
dev.new()
qqp(log(data.lastresponses$last_response_time), "gamma", shape = gamma$estimate[[1]], rate = gamma$estimate[[2]])

# Generalized linear mixed model
# Not filtered
m1 <- glmer(last_response_time ~ as.factor(layout) + as.factor(chats) + (1|participant), data = data.lastresponses, family=Gamma(link = "log"))
print(summary(m1))

# Intraclass correlation
print(icc(m1))

# Filtered
# m2 <- glmer(last_response_time ~ as.factor(layout) * as.factor(chats) + (1|participant), data = data.lastresponses %>% filter(last_response_time < 60), family=Gamma(link = "log"))
# print(summary(m2))

# Densityplot
# p1 <- ggplot(data.lastresponses, aes(last_response_time)) +
# 	ggtitle("Last response time density") +
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

# Histogram with error bars
# p2 <- ggplot(data.lastresponses %>%
# 	group_by(layout, chats) %>%
# 	summarise(sd = sd(last_response_time), last_response_time = mean(last_response_time), n = n()) %>%
# 		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
# 		mutate(se.min = last_response_time - se, se.max = last_response_time + se,
# 			   ci.min = last_response_time - ci, ci.max = last_response_time + ci),
# 		aes(as.factor(layout), last_response_time, fill = as.factor(chats))) +
# 	theme_minimal() +
# 	scale_fill_manual(name = "chats",
# 					  labels = c("3", "4"),
#  					  values = c("#F79E9B", "#62D2D4")) +
#   	geom_bar(stat="identity", position = "dodge") +
#     geom_errorbar(aes(ymin=ci.min, ymax=ci.max), width=0.2, position=position_dodge(.9)) +
# 	xlab("layout") +
#     ylab("time (s)") +
# 	ggtitle("Mean last response time in seconds")
# dev.new()
# plot(p2)

# Boxplot
p3 <- ggplot(data.lastresponses %>%
       group_by(participant,layout,chats) %>%
       summarise(last_response_time = mean(last_response_time)),
       aes(as.factor(layout), last_response_time, fill = as.factor(chats))) +
    geom_boxplot() +
	theme_minimal() +
	theme(axis.text=element_text(size=20),
          axis.title=element_text(size=20),
		  legend.text=element_text(size=20),
		  legend.title=element_text(size=20)) +
	xlab("layout") +
    ylab("time (s)") +
	scale_fill_manual(name = "chats",
					  labels = c("3", "4"),
 					  values = c("#F79E9B", "#62D2D4"))
dev.new()
plot(p3)

p4 <- ggplot(data.lastresponses %>%
		group_by(participant, chats, layout) %>%
		summarise(last_response_time = mean(last_response_time)),
 		aes(as.factor(chats), last_response_time, fill = as.factor(layout))) +
    geom_boxplot() +
    ylab("Time (s)") +
    xlab("Chats") +
    theme_minimal() +
    scale_fill_manual(name = "Layout",
					  labels = c("1", "2"),
					  values=c("#F79E9B", "#62D2D4")) +
    theme(axis.text=element_text(size=16, face="bold"),  # axis numbers larger
          axis.title=element_text(size=16, face="bold"),  # axis labels larger
		  legend.title=element_text(size=16, face="bold"),
		  legend.text=element_text(size=16))
dev.new()
plot(p4)