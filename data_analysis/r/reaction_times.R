library(dplyr)
library(tidyr)
library(psych)
library(lme4)
library(lmerTest)
library(ggplot2)
library(lattice)
library(corrplot)
library(gridExtra)

data.reactions <- read.table("csv/reaction_times.csv", header = T, sep = ";", dec = ",")

# dev.new()
# plot(densityplot(data.reactions$reaction_time))

data.reactions.pienihetki <- aggregate(data.reactions$is_pienihetki,
	by = list(data.reactions$participant, data.reactions$condition, data.reactions$layout, data.reactions$chats),
	FUN = function(x){NROW(x) - sum(x)}
)
colnames(data.reactions.pienihetki) <- c("participant", "condition", "layout", "chats", "pienihetki")

# Statistics
data.reactions.pienihetki %>%
	group_by(condition) %>%
	summarise(mean=mean(pienihetki), median=median(pienihetki), sd=sd(pienihetki), min=min(pienihetki),max=max(pienihetki)) %>%
	print(n=4)

# Linear mixed model
m1 <- lmer(reaction_time ~ as.factor(layout) * as.factor(chats) + (1|participant), data = data.reactions)
print(summary(m1))

m2 <- lmer(pienihetki ~ as.factor(layout) * as.factor(chats) + (1|participant), data = data.reactions.pienihetki)
print(summary(m2))

# Statistics
data.reactions %>%
	group_by(condition) %>%
	summarise(mean=mean(reaction_time), sd = sd(reaction_time), min=min(reaction_time),max=max(reaction_time)) %>%
	print(n=4)

# # Plots
# p1 <- ggplot(data.reactions, aes(reaction_time)) +
# 	ggtitle("Reaction time density") +
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

# p2 <- ggplot(data.reactions %>%
# 	group_by(layout, chats) %>%
# 	summarise(sd = sd(reaction_time), reaction_time = mean(reaction_time), n = n()) %>%
# 		mutate(se = sd / sqrt(n), ci = 1.96*se) %>%
# 		mutate(se.min = reaction_time - se, se.max = reaction_time + se,
# 			   ci.min = reaction_time - ci, ci.max = reaction_time + ci),
# 		aes(as.factor(layout), reaction_time, fill = as.factor(chats))) +
# 	theme_minimal() +
# 	scale_fill_manual(name = "chats",
# 					  labels = c("3", "4"),
#  					  values = c("#F79E9B", "#62D2D4")) +
#   	geom_bar(stat="identity", position = "dodge") +
#     geom_errorbar(aes(ymin=ci.min, ymax=ci.max), width=0.2, position=position_dodge(.9)) +
# 	xlab("layout") +
#     ylab("time (s)") +
# 	ggtitle("Mean reaction time in seconds") +

# dev.new()
# plot(p2)

# # Boxplot
# p3 <- ggplot(data.reactions %>%
#        group_by(participant,layout,chats) %>%
#        summarise(reaction_time = mean(reaction_time)),
#        aes(as.factor(layout), reaction_time, fill = as.factor(chats))) +
#     geom_boxplot() +
# 	theme_minimal() +
# 	xlab("layout") +
#     ylab("time (s)") +
# 	scale_fill_manual(name = "chats",
# 					  labels = c("3", "4"),
#  					  values = c("#F79E9B", "#62D2D4"))
# dev.new()
# plot(p3)
