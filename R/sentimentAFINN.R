# sentimentAFINN
# http://www2.imm.dtu.dk/pubdb/views/publication_details.php?id=6010

library(stringr)
library(sqldf)
library(tm)
library(ggplot2)



#REMOVE before package creation
setwd("~/R/sentimentAFINN/")


#might need to remove the 'data/'
load("data/AFINN-111.RData")

sentiment <- function(input_file) {

# create place holder for sentiments

n <- length(input_file)
sentimentdf <- data.frame("DocNum"=1:n,
                          "SentimentScore"=rep(0,n),
                          "SentimentScoreNormalized"=rep(0,n))

input_file <- tm_map(input_file,tolower)
input_file <- tm_map(input_file,removePunctuation)
input_file <- tm_map(input_file,removeWords, stopwords("english"))
input_file <- tm_map(input_file,stripWhitespace)

sentimentdf$docContents <- as.character(input_file)

for (i in 1:n) {
  words <- unlist(str_split(sentimentdf$docContents[i],'\\s+'))
  wordsInDict <- match(words,sentDict$Word)
  sentiments <- sentDict$SentimentScore[wordsInDict]
  sentimentdf$SentimentScore[i] <- sum(sentiments,na.rm=TRUE)
  wordCount <- length(wordsInDict)
  if(wordCount < 1) {
    wordCount <- 1
  }
  sentimentdf$SentimentScoreNormalized[i] <- sentimentdf$SentimentScore[i] / wordCount
}

return(sentimentdf)
}


contentCorp <- Corpus(VectorSource(bibleCorp[["content"]]))
answer <- sentiment(contentCorp)
summary(answer)
answer[[1]]

hist(answer$SentimentScore,nclass=40)
hist(answer$SentimentScoreNormalized,nclass=40)

bottom10 <- sqldf("select *
                from 
                (select * from
                 answer
                 order by SentimentScore)
                limit 10")

top10 <- sqldf("select *
                from 
                (select * from
                 answer
                 order by SentimentScore desc)
                limit 10")

bibleCorp[["content"]][top10$DocNum]
bibleCorp[["content"]][1]





