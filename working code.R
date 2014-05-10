
sentDir <- "~/R/sentimentAFINN/data/"
setwd(sentDir)

sentDict <- read.delim(paste(sentDir,"AFINN-111.txt",sep=""), header=FALSE)
names(sentDict) <- c("Word","SentimentScore")

save(sentDict,file="AFINN-111.RData")

install.packages("roxygen2")