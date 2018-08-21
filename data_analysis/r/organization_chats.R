library(dplyr)
library(tidyr)
library(lattice)

# Current chats
data.orgchats <- read.table("csv/organization_chats.csv", header = T, sep = ";", dec = ",")

data.orgchats.mean <- aggregate(data.orgchats$chat_count,
	by = list(data.orgchats$organization_id),
	FUN = mean
)
colnames(data.orgchats.mean) <- c("organization_id", "chat_count")
# print(data.orgchats.mean)

dev.new()
plot(densityplot(data.orgchats.mean$chat_count))

data.orgchats.stats <- data.orgchats.mean %>%
	summarise(sd = sd(chat_count), max=max(chat_count), min=min(chat_count), median=median(chat_count), mean=mean(chat_count))

print(data.orgchats.stats)

# Chats two years ago
data.oldorgchats <- read.table("csv/old_organization_chats.csv", header = T, sep = ";", dec = ",")

data.oldorgchats.mean <- aggregate(data.oldorgchats$chat_count,
	by = list(data.oldorgchats$organization_id),
	FUN = mean
)
colnames(data.oldorgchats.mean) <- c("organization_id", "chat_count")
# print(data.oldorgchats.mean)

dev.new()
plot(densityplot(data.oldorgchats.mean$chat_count))

data.oldorgchats.stats <- data.oldorgchats.mean %>%
	summarise(sd = sd(chat_count), max=max(chat_count), min=min(chat_count), median=median(chat_count), mean=mean(chat_count))

print(data.oldorgchats.stats)

# Outliers
data.orgchats.iqr <- IQR(data.orgchats$chat_count)
data.orgchats.lowerq <- quantile(data.orgchats$chat_count)[[2]]
data.orgchats.upperq <- quantile(data.orgchats$chat_count)[[4]]

mild.threshold.upper <- (data.orgchats.iqr * 1.5) + data.orgchats.upperq
mild.threshold.lower <- data.orgchats.lowerq - (data.orgchats.iqr * 1.5)

print(mild.threshold.lower)
print(mild.threshold.upper)

data.orgchats.filtered <- data.orgchats[which(data.orgchats$chat_count <= mild.threshold.upper & data.orgchats$chat_count > mild.threshold.lower), ]
print(nrow(data.orgchats))
print(nrow(data.orgchats.filtered))

data.oldorgchats.iqr <- IQR(data.oldorgchats$chat_count)
data.oldorgchats.lowerq <- quantile(data.oldorgchats$chat_count)[[2]]
data.oldorgchats.upperq <- quantile(data.oldorgchats$chat_count)[[4]]

mild.threshold.upper <- (data.oldorgchats.iqr * 1.5) + data.oldorgchats.upperq
mild.threshold.lower <- data.oldorgchats.lowerq - (data.oldorgchats.iqr * 1.5)

print(mild.threshold.lower)
print(mild.threshold.upper)

data.oldorgchats.filtered <- data.oldorgchats[which(data.oldorgchats$chat_count <= mild.threshold.upper & data.oldorgchats$chat_count > mild.threshold.lower), ]
print(nrow(data.oldorgchats))
print(nrow(data.oldorgchats.filtered))

# Current chats
data.orgchats.filtered.mean <- aggregate(data.orgchats.filtered$chat_count,
	by = list(data.orgchats.filtered$organization_id),
	FUN = mean
)
colnames(data.orgchats.filtered.mean) <- c("organization_id", "chat_count")
# print(data.orgchats.filtered.mean)

dev.new()
plot(densityplot(data.orgchats.filtered.mean$chat_count))

data.orgchats.filtered.stats <- data.orgchats.filtered.mean %>%
	summarise(sd = sd(chat_count), max=max(chat_count), min=min(chat_count), median=median(chat_count), mean=mean(chat_count))

print(data.orgchats.filtered.stats)

# Old chats
data.oldorgchats.filtered.mean <- aggregate(data.oldorgchats.filtered$chat_count,
	by = list(data.oldorgchats.filtered$organization_id),
	FUN = mean
)
colnames(data.oldorgchats.filtered.mean) <- c("organization_id", "chat_count")
# print(data.oldorgchats.filtered.mean)

dev.new()
plot(densityplot(data.oldorgchats.filtered.mean$chat_count))

data.oldorgchats.filtered.stats <- data.oldorgchats.filtered.mean %>%
	summarise(sd = sd(chat_count), max=max(chat_count), min=min(chat_count), median=median(chat_count), mean=mean(chat_count))

print(data.oldorgchats.filtered.stats)
