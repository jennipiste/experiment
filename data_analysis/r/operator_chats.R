library(dplyr)
library(tidyr)
library(lattice)

# Current chats
data.operatorchats <- read.table("csv/operator_chats.csv", header = T, sep = ";", dec = ",")

data.operatorchats.stats <- data.operatorchats %>%
	summarise(sd = sd(chat_count), max=max(chat_count), min=min(chat_count), median=median(chat_count), mean=mean(chat_count))

print(data.operatorchats.stats)

data.operatorchats.operators.stats <- data.operatorchats %>%
	summarise(sd = sd(operator_count), max=max(operator_count), min=min(operator_count), median=median(operator_count), mean=mean(operator_count))

print(data.operatorchats.operators.stats)
