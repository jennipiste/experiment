library(dplyr)
library(tidyr)
library(psych)
library(lme4)
library(lmerTest)
library(ggplot2)
library(lattice)
library(corrplot)
library(gridExtra)
library(MASS)
library(scales)

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


data <- data.questionnaires %>%
    gather(var, val, efficiency:memory)

t_shift <- scales::trans_new("shift",
                             transform = function(x) {x-1},
                             inverse = function(x) {x+1})

p1 <- ggplot(data %>%
       group_by(chats,layout,var) %>%
       summarise(val = mean(val)),
       aes(as.factor(chats),val,fill = as.factor(layout))) +
    geom_bar(stat = "identity", position = "dodge") +
	scale_y_continuous(trans = t_shift,
                       limits = c(1, 5),
                       breaks = c(1, 2, 3, 4, 5)) +
	facet_grid(. ~ var) +
	theme_minimal() +
    theme(axis.text=element_text(size=20),
          axis.title=element_text(size=20),
		  legend.text=element_text(size=20),
		  legend.title=element_text(size=20),
          strip.text.x=element_text(size=20)) +
	coord_cartesian(ylim = c(1, 5)) +
    theme(axis.text=element_text(size=16, face="bold"),  # axis numbers larger
          axis.title=element_text(size=16, face="bold"),  # axis labels larger
		  legend.title=element_text(size=16, face="bold"),
		  legend.text=element_text(size=16),
          strip.text.x=element_text(size=16)) +
	scale_fill_manual(name = "Layout",
					  labels = c("windowed", "tabbed"),
					  values = c("#F79E9B", "skyblue")) +
	xlab("Chats") +
	ylab("Rating")
dev.new()
plot(p1)

# p2 <- ggplot(data %>%
#        group_by(chats,layout,var) %>%
#        summarise(val = mean(val)),
#        aes(as.factor(chats),val,fill = as.factor(layout))) +
#     geom_bar(stat = "identity", position = "dodge") +
# 	scale_y_continuous(trans = t_shift,
#                        limits = c(1, 5),
#                        breaks = c(1, 2, 3, 4, 5)) +
# 	facet_grid(. ~ var) +
# 	theme_minimal() +
#     theme(axis.text=element_text(size=20),
#           axis.title=element_text(size=20),
# 		  legend.text=element_text(size=20),
# 		  legend.title=element_text(size=20),
#           strip.text.x=element_text(size=20)) +
# 	coord_cartesian(ylim = c(1, 5)) +
#     theme(axis.text=element_text(size=16, face="bold"),  # axis numbers larger
#           axis.title=element_text(size=16, face="bold"),  # axis labels larger
# 		  legend.title=element_text(size=16, face="bold"),
# 		  legend.text=element_text(size=16),
#           strip.text.x=element_text(size=16)) +
# 	scale_fill_manual(name = "Layout",
# 					  labels = c("1", "2"),
# 					  values = c("skyblue", "darkseagreen")) +
# 	xlab("Chats") +
# 	ylab("Rating")
# dev.new()
# plot(p2)

for (var.a in unique(data$var)) {
    chats1 <- subset(data,var==var.a & chats == 3)
    chats1 <- chats1 %>%
        dplyr::select(-condition,-part) %>%
        spread(layout,val)
	print(paste(var.a, "3"))
    print(wilcox.test(chats1$"1",chats1$"2"))
    chats2 <- subset(data,var==var.a & chats == 4, paired=TRUE)
    chats2 <- chats2 %>%
        dplyr::select(-condition,-part) %>%
        spread(layout,val)
	print(paste(var.a,"4"))
    print(wilcox.test(chats2$"1",chats2$"2", paired=TRUE))
}

for (var.a in unique(data$var)) {
    layout1 <- subset(data,var==var.a & layout == 1)
    layout1 <- layout1 %>%
        dplyr::select(-condition,-part) %>%
        spread(chats,val)
    print(paste(var.a,"1"))
	print(wilcox.test(layout1$"3",layout1$"4", paired=TRUE))
    layout2 <- subset(data,var==var.a & layout == 2)
    layout2 <- layout2 %>%
        dplyr::select(-condition,-part) %>%
        spread(chats,val)
    print(paste(var.a,"2"))
	print(wilcox.test(layout2$"3",layout2$"4", paired=TRUE))
}

# # EFFICIENCY
# data.efficiency <- data.questionnaires[, 'efficiency']

# data.questionnaires %>%
# 	group_by(condition) %>%
# 	summarise(val1=sum(efficiency==1), val2 = sum(efficiency==2), val3=sum(efficiency==3), val4=sum(efficiency==4), val5=sum(efficiency==5)) %>%
# 	print(n=4)

# m3 <- wilcox.test(data.questionnaires$efficiency[data.questionnaires$layout==1], data.questionnaires$efficiency[data.questionnaires$layout==2])
# print(m3)
# m4 <- wilcox.test(data.questionnaires$efficiency[data.questionnaires$chats==3], data.questionnaires$efficiency[data.questionnaires$chats==4])
# print(m4)

# p1 <- ggplot(data.questionnaires, aes(x=efficiency, group=as.factor(chats), fill=as.factor(chats))) +
# 	scale_fill_manual(name = "chats",
# 						labels = c("3", "4"),
# 						values = c("#F79E9B", "#62D2D4")) +
# 	geom_histogram(position=position_dodge(), binwidth=0.5) +
# 	facet_grid(. ~ layout, labeller = label_both) +
# 	xlim(1, NA) +
# 	theme_minimal() +
# 	theme(legend.position = c(0.1, 0.85),
# 		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# plot(p1)

# # STRESS
# data.questionnaires %>%
# 	group_by(condition) %>%
# 	summarise(val1=sum(stress==1), val2 = sum(stress==2), val3=sum(stress==3), val4=sum(stress==4), val5=sum(stress==5)) %>%
# 	print(n=4)

# data.stress <- data.questionnaires[, 'stress']

# m3 <- wilcox.test(data.questionnaires$stress[data.questionnaires$layout==1], data.questionnaires$stress[data.questionnaires$layout==2])
# print(m3)
# m4 <- wilcox.test(data.questionnaires$stress[data.questionnaires$chats==3], data.questionnaires$stress[data.questionnaires$chats==4])
# print(m4)

# p1 <- ggplot(data.questionnaires, aes(x=stress, group=as.factor(chats), fill=as.factor(chats))) +
# 	scale_fill_manual(name = "chats",
# 						labels = c("3", "4"),
# 						values = c("#F79E9B", "#62D2D4")) +
# 	geom_histogram(position=position_dodge(), binwidth=0.5) +
# 	facet_grid(. ~ layout, labeller = label_both) +
# 	xlim(1, NA) +
# 	theme_minimal() +
# 	theme(legend.position = c(0.85, 0.85),
# 		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# plot(p1)

# # CONTROL
# data.questionnaires %>%
# 	group_by(condition) %>%
# 	summarise(val1=sum(control==1), val2 = sum(control==2), val3=sum(control==3), val4=sum(control==4), val5=sum(control==5)) %>%
# 	print(n=4)

# data.control <- data.questionnaires[, 'control']

# m3 <- wilcox.test(data.questionnaires$control[data.questionnaires$layout==1], data.questionnaires$control[data.questionnaires$layout==2])
# print(m3)
# m4 <- wilcox.test(data.questionnaires$control[data.questionnaires$chats==3], data.questionnaires$control[data.questionnaires$chats==4])
# print(m4)

# p1 <- ggplot(data.questionnaires, aes(x=control, group=as.factor(chats), fill=as.factor(chats))) +
# 	scale_fill_manual(name = "chats",
# 						labels = c("3", "4"),
# 						values = c("#F79E9B", "#62D2D4")) +
# 	geom_histogram(position=position_dodge(), binwidth=0.5) +
# 	facet_grid(. ~ layout, labeller = label_both) +
# 	xlim(1, NA) +
# 	theme_minimal() +
# 	theme(legend.position = c(0.1, 0.85),
# 		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# plot(p1)

# # FRUSTRATION
# data.questionnaires %>%
# 	group_by(condition) %>%
# 	summarise(val1=sum(frustration==1), val2 = sum(frustration==2), val3=sum(frustration==3), val4=sum(frustration==4), val5=sum(frustration==5)) %>%
# 	print(n=4)

# data.frustration <- data.questionnaires[, 'frustration']

# m3 <- wilcox.test(data.questionnaires$frustration[data.questionnaires$layout==1], data.questionnaires$frustration[data.questionnaires$layout==2])
# print(m3)
# m4 <- wilcox.test(data.questionnaires$frustration[data.questionnaires$chats==3], data.questionnaires$frustration[data.questionnaires$chats==4])
# print(m4)

# p1 <- ggplot(data.questionnaires, aes(x=frustration, group=as.factor(chats), fill=as.factor(chats))) +
# 	scale_fill_manual(name = "chats",
# 						labels = c("3", "4"),
# 						values = c("#F79E9B", "#62D2D4")) +
# 	geom_histogram(position=position_dodge(), binwidth=0.5) +
# 	facet_grid(. ~ layout, labeller = label_both) +
# 	xlim(1, NA) +
# 	theme_minimal() +
# 	theme(legend.position = c(0.85, 0.85),
# 		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# plot(p1)

# # MEMORY
# data.questionnaires %>%
# 	group_by(condition) %>%
# 	summarise(val1=sum(memory==1), val2 = sum(memory==2), val3=sum(memory==3), val4=sum(memory==4), val5=sum(memory==5)) %>%
# 	print(n=4)

# data.memory <- data.questionnaires[, 'memory']

# m3 <- wilcox.test(data.questionnaires$memory[data.questionnaires$layout==1], data.questionnaires$memory[data.questionnaires$layout==2])
# print(m3)
# m4 <- wilcox.test(data.questionnaires$memory[data.questionnaires$chats==3], data.questionnaires$memory[data.questionnaires$chats==4])
# print(m4)

# p1 <- ggplot(data.questionnaires, aes(x=memory, group=as.factor(chats), fill=as.factor(chats))) +
# 	scale_fill_manual(name = "chats",
# 						labels = c("3", "4"),
# 						values = c("#F79E9B", "#62D2D4")) +
# 	geom_histogram(position=position_dodge(), binwidth=0.5) +
# 	facet_grid(. ~ layout, labeller = label_both) +
# 	xlim(1, NA) +
# 	theme_minimal() +
# 	theme(legend.position = c(0.1, 0.85),
# 		  legend.background = element_rect(fill = "white", colour = "black", linetype = "solid"))
# dev.new()
# plot(p1)
