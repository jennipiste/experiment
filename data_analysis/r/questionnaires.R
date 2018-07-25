library(psych)

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
factor1 <- data.questions[, c("Stress", "Frustration", "Memory")]
factor2 <- data.questions[, c("Efficiency", "Control")]

factor1.alpha <- psych::alpha(factor1, check.keys=TRUE)
factor2.alpha <- psych::alpha(factor2)
#print(factor1.alpha)
#print(factor1.alpha$total$std.alpha)
#print(factor2.alpha)
#print(factor2.alpha$total$std.alpha)

# TODO: What should really be done on factanal????

# Anova
data.questionnaires <- read.table("csv/questionnaires.csv", header = T, sep = ";", dec = ".")

data.questionnaires.efficiency.aov <- with(data.questionnaires,
	aov(Efficiency ~ as.factor(Layout) * as.factor(Chats) + Error(Participant / (as.factor(Layout) * as.factor(Chats))))
)
print(summary(data.questionnaires.efficiency.aov))

data.questionnaires.stress.aov <- with(data.questionnaires,
	aov(Stress ~ as.factor(Layout) * as.factor(Chats) + Error(Participant / (as.factor(Layout) * as.factor(Chats))))
)
print(summary(data.questionnaires.stress.aov))

data.questionnaires.control.aov <- with(data.questionnaires,
	aov(Control ~ as.factor(Layout) * as.factor(Chats) + Error(Participant / (as.factor(Layout) * as.factor(Chats))))
)
print(summary(data.questionnaires.control.aov))

data.questionnaires.frustration.aov <- with(data.questionnaires,
	aov(Frustration ~ as.factor(Layout) * as.factor(Chats) + Error(Participant / (as.factor(Layout) * as.factor(Chats))))
)
print(summary(data.questionnaires.frustration.aov))

data.questionnaires.memory.aov <- with(data.questionnaires,
	aov(Memory ~ as.factor(Layout) * as.factor(Chats) + Error(Participant / (as.factor(Layout) * as.factor(Chats))))
)
print(summary(data.questionnaires.memory.aov))