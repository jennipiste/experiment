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

data.durations <- read.table("csv/chat_durations.csv", header = T, sep = ";", dec = ",")

dev.new()
plot(densityplot(data.durations$duration))

dev.new()
qqp(data.durations$duration, "norm")

# Linear mixed model
m1 <- lmer(duration ~ as.factor(layout) * as.factor(chats) + (1|participant), data = data.durations)
print(summary(m1))

m2 <- lmer(scale(duration) ~ as.factor(layout) * as.factor(chats) + (1|participant), data = data.durations)
print(summary(m2))

# Intraclass correlation
print(icc(m1))
print(icc(m2))

# Statistics
data.durations %>%
	group_by(condition) %>%
	summarise(mean=mean(duration), median=median(duration), sd=sd(duration), min=min(duration),max=max(duration)) %>%
	print(n=4)

# Plots
# p1 <- ggplot(data.durations, aes(duration)) +
# 	ggtitle("Chat duration density") +
# 	scale_fill_manual(name = "chats",
# 						labels = c("3", "4"),
# 						values = c("#F79E9B", "#62D2D4")) +
# 	geom_density(aes(group=as.factor(chats), fill=as.factor(chats)), alpha = 0.6) +
# 	facet_grid(. ~ layout, labeller = label_both) +
# 	xlab("time (s)") +
# 	theme_minimal() +
# 	theme(legend.position = c(0.5, 0.85),
# 		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# plot(p1)

# p2 <- ggplot(data.durations %>%
# 	group_by(layout, chats) %>%
# 	summarise(sd = sd(duration), duration = mean(duration), n = n()) %>%
# 		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
# 		mutate(se.min = duration - se, se.max = duration + se,
# 			   ci.min = duration - ci, ci.max = duration + ci),
# 		aes(as.factor(layout), duration, fill = as.factor(chats))) +
# 	theme_minimal() +
# 	scale_fill_manual(name = "chats",
# 					  labels = c("3", "4"),
#  					  values = c("#F79E9B", "#62D2D4")) +
#   	geom_bar(stat="identity", position = "dodge") +
#     geom_errorbar(aes(ymin=ci.min, ymax=ci.max), width=0.2, position=position_dodge(.9)) +
# 	xlab("layout") +
#     ylab("time (s)") +
# 	ggtitle("Mean chat duration in seconds") +
# dev.new()
# plot(p2)

# Boxplot
# p3 <- ggplot(data.durations %>%
#        group_by(participant,layout,chats) %>%
#        summarise(duration = mean(duration)),
#        aes(as.factor(layout), duration, fill = as.factor(chats))) +
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

p4 <- ggplot(data.durations %>%
		group_by(participant, chats, layout) %>%
		summarise(duration = mean(duration)),
 		aes(as.factor(chats), duration, fill = as.factor(layout))) +
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

# p5 <- ggplot(data.durations %>%
# 		group_by(participant, chats, layout) %>%
# 		summarise(duration = mean(duration)),
#  		aes(as.factor(chats), duration, fill = as.factor(layout))) +
#     geom_boxplot() +
#     ylab("Time (s)") +
#     xlab("Chats") +
#     theme_minimal() +
#     scale_fill_manual(name = "Layout",
# 					  labels = c("1", "2"),
# 					  values=c("skyblue", "darkseagreen")) +
#     theme(axis.text=element_text(size=16, face="bold"),  # axis numbers larger
#           axis.title=element_text(size=16, face="bold"),  # axis labels larger
# 		  legend.title=element_text(size=16, face="bold"),
# 		  legend.text=element_text(size=16))
# dev.new()
# plot(p5)

# p6 <- ggplot(data.durations %>%
# 		group_by(participant, chats) %>%
# 		summarise(duration = mean(duration)),
#  		aes(as.factor(chats), duration)) +
#     geom_boxplot(fill="skyblue") +
# 	ggtitle("Chat duration") +
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

# p7 <- ggplot(data.durations %>%
# 		group_by(participant, layout) %>%
# 		summarise(duration = mean(duration)),
#  		aes(as.factor(layout), duration)) +
#     geom_boxplot(fill="skyblue") +
# 	ggtitle("Chat duration") +
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
