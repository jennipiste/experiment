library(dplyr)
library(tidyr)
library(lattice)

# Current chats
data.membershipchats <- read.table("csv/membership_chats.csv", header = T, sep = ";", dec = ",")

data.membershipchats.stats <- data.membershipchats %>%
	summarise(sd = sd(chat_count), max=max(chat_count), min=min(chat_count), median=median(chat_count), mean=mean(chat_count))

print(data.membershipchats.stats)
