
setwd("~/R/sentimentAFINN/data/")
sentDict <- read.delim("AFINN-111.txt", header=FALSE)
names(sentDict) <- c("Word","SentimentScore")
save(sentDict,file="AFINN-111.RData")

