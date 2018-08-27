library(dplyr)
library(tidyr)
library(psych)
library(lme4)
library(lmerTest)
library(ggplot2)
library(lattice)
library(corrplot)
library(gridExtra)

data.questionnaires <- read.table("csv/questionnaires.csv", header = T, sep = ";", dec = ".")

# Take questions columns from data
data.questions <- data.questionnaires[6:10]
#print(data.questions)
data.layout <- data.questionnaires[, 'layout']
data.chats <- data.questionnaires[, 'chats']
data.condition <- data.questionnaires[, 'condition']

# factanal <- factanal(data.questions, 2, rotation="varimax")
# print(factanal)
# print(factanal, digits=2, cutoff=.4, sort=TRUE)

# alpha <- psych::alpha(data.questions, check.keys=TRUE)
# print(alpha)
# print(alpha$total$std.alpha)

# # Cronbach's alpha for both factors
# factor1 <- data.questions[, c("stress", "frustration", "memory")]
# factor2 <- data.questions[, c("efficiency", "control")]

# factor1.alpha <- psych::alpha(factor1, check.keys=TRUE)
# factor2.alpha <- psych::alpha(factor2)
# print(factor1.alpha)
# print(factor1.alpha$total$std.alpha)
# print(factor2.alpha)
# print(factor2.alpha$total$std.alpha)

# EFFICIENCY
data.questionnaires %>%
	group_by(condition) %>%
	summarise(val1=sum(efficiency==1), val2 = sum(efficiency==2), val3=sum(efficiency==3), val4=sum(efficiency==4), val5=sum(efficiency==5)) %>%
	print(n=4)

data.efficiency <- data.questionnaires[, 'efficiency']

# Chi-squared tests
m1 <- chisq.test(data.layout, data.efficiency)
print(m1)
m2 <- chisq.test(data.chats, data.efficiency)
print(m2)

# Mann-Whitney tests
m3 <- wilcox.test(data.questionnaires$efficiency[data.questionnaires$layout==1], data.questionnaires$efficiency[data.questionnaires$layout==2])
print(m3)
m4 <- wilcox.test(data.questionnaires$efficiency[data.questionnaires$chats==3], data.questionnaires$efficiency[data.questionnaires$chats==4])
print(m4)

p1 <- ggplot(data.questionnaires, aes(x=efficiency, group=as.factor(chats), fill=as.factor(chats))) +
	scale_fill_manual(name = "chats",
						labels = c("3", "4"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_histogram(position=position_dodge(), binwidth=0.5) +
	facet_grid(. ~ layout, labeller = label_both) +
	xlim(1, NA) +
	theme_minimal() +
	theme(legend.position = c(0.1, 0.85),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
dev.new()
plot(p1)

# STRESS
data.questionnaires %>%
	group_by(condition) %>%
	summarise(val1=sum(stress==1), val2 = sum(stress==2), val3=sum(stress==3), val4=sum(stress==4), val5=sum(stress==5)) %>%
	print(n=4)

data.stress <- data.questionnaires[, 'stress']

m1 <- chisq.test(data.layout, data.stress)
print(m1)
m2 <- chisq.test(data.chats, data.stress)
print(m2)

# Mann-Whitney tests
m3 <- wilcox.test(data.questionnaires$stress[data.questionnaires$layout==1], data.questionnaires$stress[data.questionnaires$layout==2])
print(m3)
m4 <- wilcox.test(data.questionnaires$stress[data.questionnaires$chats==3], data.questionnaires$stress[data.questionnaires$chats==4])
print(m4)

p1 <- ggplot(data.questionnaires, aes(x=stress, group=as.factor(chats), fill=as.factor(chats))) +
	scale_fill_manual(name = "chats",
						labels = c("3", "4"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_histogram(position=position_dodge(), binwidth=0.5) +
	facet_grid(. ~ layout, labeller = label_both) +
	xlim(1, NA) +
	theme_minimal() +
	theme(legend.position = c(0.85, 0.85),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
dev.new()
plot(p1)

# CONTROL
data.questionnaires %>%
	group_by(condition) %>%
	summarise(val1=sum(control==1), val2 = sum(control==2), val3=sum(control==3), val4=sum(control==4), val5=sum(control==5)) %>%
	print(n=4)

data.control <- data.questionnaires[, 'control']

m1 <- chisq.test(data.layout, data.control)
print(m1)
m2 <- chisq.test(data.chats, data.control)
print(m2)

# Mann-Whitney tests
m3 <- wilcox.test(data.questionnaires$control[data.questionnaires$layout==1], data.questionnaires$control[data.questionnaires$layout==2])
print(m3)
m4 <- wilcox.test(data.questionnaires$control[data.questionnaires$chats==3], data.questionnaires$control[data.questionnaires$chats==4])
print(m4)

p1 <- ggplot(data.questionnaires, aes(x=control, group=as.factor(chats), fill=as.factor(chats))) +
	scale_fill_manual(name = "chats",
						labels = c("3", "4"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_histogram(position=position_dodge(), binwidth=0.5) +
	facet_grid(. ~ layout, labeller = label_both) +
	xlim(1, NA) +
	theme_minimal() +
	theme(legend.position = c(0.1, 0.85),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
dev.new()
plot(p1)

# FRUSTRATION
data.questionnaires %>%
	group_by(condition) %>%
	summarise(val1=sum(frustration==1), val2 = sum(frustration==2), val3=sum(frustration==3), val4=sum(frustration==4), val5=sum(frustration==5)) %>%
	print(n=4)

data.frustration <- data.questionnaires[, 'frustration']

m1 <- chisq.test(data.layout, data.frustration)
print(m1)
m2 <- chisq.test(data.chats, data.frustration)
print(m2)

# Mann-Whitney tests
m3 <- wilcox.test(data.questionnaires$frustration[data.questionnaires$layout==1], data.questionnaires$frustration[data.questionnaires$layout==2])
print(m3)
m4 <- wilcox.test(data.questionnaires$frustration[data.questionnaires$chats==3], data.questionnaires$frustration[data.questionnaires$chats==4])
print(m4)

p1 <- ggplot(data.questionnaires, aes(x=frustration, group=as.factor(chats), fill=as.factor(chats))) +
	scale_fill_manual(name = "chats",
						labels = c("3", "4"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_histogram(position=position_dodge(), binwidth=0.5) +
	facet_grid(. ~ layout, labeller = label_both) +
	xlim(1, NA) +
	theme_minimal() +
	theme(legend.position = c(0.85, 0.85),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
dev.new()
plot(p1)

# MEMORY
data.questionnaires %>%
	group_by(condition) %>%
	summarise(val1=sum(memory==1), val2 = sum(memory==2), val3=sum(memory==3), val4=sum(memory==4), val5=sum(memory==5)) %>%
	print(n=4)

data.memory <- data.questionnaires[, 'memory']

m1 <- chisq.test(data.layout, data.memory)
print(m1)
m2 <- chisq.test(data.chats, data.memory)
print(m2)

# Mann-Whitney tests
m3 <- wilcox.test(data.questionnaires$memory[data.questionnaires$layout==1], data.questionnaires$memory[data.questionnaires$layout==2])
print(m3)
m4 <- wilcox.test(data.questionnaires$memory[data.questionnaires$chats==3], data.questionnaires$memory[data.questionnaires$chats==4])
print(m4)

p1 <- ggplot(data.questionnaires, aes(x=memory, group=as.factor(chats), fill=as.factor(chats))) +
	scale_fill_manual(name = "chats",
						labels = c("3", "4"),
						values = c("#F79E9B", "#62D2D4")) +
	geom_histogram(position=position_dodge(), binwidth=0.5) +
	facet_grid(. ~ layout, labeller = label_both) +
	xlim(1, NA) +
	theme_minimal() +
	theme(legend.position = c(0.1, 0.85),
		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
dev.new()
plot(p1)
