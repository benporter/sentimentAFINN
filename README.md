sentimentAFINN
==============

R package for computing document sentiment using the Finn Årup Nielsen word listing

## Credit

Dictionary file with words and sentiment scores from <a href="http://www2.imm.dtu.dk/pubdb/views/publication_details.php?id=6010">Finn Årup Nielsen</a>

## Input/Output

Packages accepts a corpus object from the tm (text mining) package
Packages returns a dataframe of four columns:

1) Document index, 1 through n, from original corpus
2) Sentiment score for the document
3) Normalized sentiment score: sentiment score / non-trivial words
4) Transformed document, post tm mapping transformations

## Installing the sentimentAFINN package

The sentimentAFINN package is currently only on github and not cran yet.  To install the package from github, use the install_guthub() function from the devtools package.  You only have to do this once, then you can just call the library() function to load the sentimentAFINN package.

        install.packages("devtools")
        library(devtools)
        install_github("benporter/sentimentAFINN")
        

## Usage

load the library

        library(sentimentAFINN)

Use the <i>sentiment</i> function from the package library

        mySentimentScores <- sentiment(myCorpus)

See below for a more complete example

## Example:  Finding the sentiment of Bible verses

## Misc

In order to use the load() command in the package to access the sentiment scores, I had to transform the AFINN-111.txt file to the .RData format. See below for the code I used to prepare the file.

    setwd("~/R/sentimentAFINN/data/")
    sentDict <- read.delim("AFINN-111.txt", header=FALSE)
    names(sentDict) <- c("Word","SentimentScore")
    save(sentDict,file="AFINN-111.RData")
    
Now the AFINN sentiment dictionary can be accessed from within the package using the load() command

    load("data/AFINN-111.RData")
