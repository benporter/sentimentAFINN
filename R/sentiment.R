
library(stringr)
library(sqldf)
library(tm)
library(ggplot2)

#this might need to remove the
load("data/AFINN-111.RData")

n <- length(tweets)

tweetDF <- twListToDF(tweets)

head(tweetDF)

# read in sentiment dictionary
sentDir <- "~/R/sentiment-R/"
sentDict <- read.delim(paste(sentDir,"AFINN-111.txt",sep=""), header=FALSE)
names(sentDict) <- c("Word","SentimentScore")
commentSentiment <- data.frame("Comment"=1:n,
                               "SentimentScore"=rep(0,n),
                               "SentimentScoreNormalized"=rep(0,n))

tweetDF$SentimentScore <- rep(0,n)
tweetDF$SentimentScoreNormalized <- rep(0,n)

#use the corpus data type to apply TM functions
tweetCorp <- tm_map(tweetCorp,tolower)
tweetCorp <- tm_map(tweetCorp,removePunctuation)
tweetCorp <- tm_map(tweetCorp,removeWords, stopwords("english"))
tweetCorp <- tm_map(tweetCorp,stripWhitespace)
#tweetCorp <- tm_map(tweetCorp,stemDocument) #stems words (requires snowball package)

tweetDF$text_clean <- as.character(tweetCorp)

for (i in 1:n) {
  words <- unlist(str_split(tweetDF$text_clean[i],'\\s+'))
  wordsInDict <- match(words,sentDict$Word)
  sentiments <- sentDict$SentimentScore[wordsInDict]
  tweetDF$SentimentScore[i] <- sum(sentiments,na.rm=TRUE)
  wordCount <- length(wordsInDict)
  if(wordCount < 1) {
    wordCount <- 1
  }
  tweetDF$SentimentScoreNormalized[i] <- tweetDF$SentimentScore[i] / wordCount
}
names(tweetDF)
tweetDF$HourMin <- format(strptime(tweetDF$created, "%Y-%m-%d %H:%M:%OS"),"%H:%M")
tweetDF$date <- format(strptime(tweetDF$created, "%Y-%m-%d %H:%M:%OS"),"%Y-%m-%d")

durationsDF$HourMin <- format(strptime(durationsDF$executionTime, "%Y-%m-%d %H:%M:%OS"),"%H:%M")
durationsDF$DayOfWeek <- weekdays(strptime(durationsDF$executionTime, "%Y-%m-%d %H:%M:%OS"))
durationsDF$Weekend <- as.factor(ifelse(durationsDF$DayOfWeek=="Saturday" | durationsDF$DayOfWeek=="Sunday",1,0))
durationsDF$DurationMin <- durationsDF$travelDuration / 60
durationsDF <- subset(durationsDF,DurationMin < 200)



hist(tweetDF$SentimentScore,nclass=40)
head(tweetDF)
g5 <- ggplot(tweetDF,aes(x=percent_discount,y=SentimentScore)) + geom_point(shape=1)
g5 <- g5 + geom_smooth()
g5 <- g5 + xlab("Percentage Discount") + ylab("log(Total Sales)")
g5

(tweetDF$created)
