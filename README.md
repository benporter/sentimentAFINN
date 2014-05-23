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

Download the King James Bible as a sqlite database.  You can do it manually, or use this R code.  I choose to save it to my "home/R/Text Mining/bible" directoary

        download.file(url="http://simoncozens.github.io/open-source-bible-data/cooked/sqlite/kjv.db","~/R/Text Mining/bible/kjv.db")

I leaned heavily on <a href="http://grumpylemming.com/blog/2012/12/27/accessing-sqlite-data-from-r/">The Grumpy Lemming blog post</a> for assistance with accessing a sqlite database from R.

Download and install the RSQLite package
        
        install.packages("RSQLite")
        library(RSQLite)

Establish a driver and connect to the database

        sqlite_driver <- dbDriver("SQLite")
        connectionToDB <- dbConnect(sqlite_driver, "~/R/Text Mining/bible/kjv.db")

List out the tables in the database and then list the fields in the "bible" database
        
        dbListTables(connectionToDB)
        [1] "bible"              "bible_fts"          "bible_fts_content"  "bible_fts_segdir"   "bible_fts_segments" "metadata"  
        
        dbListFields(connectionToDB, "bible")
        [1] "book"    "chapter" "verse"   "content"

## Misc

In order to use the load() command in the package to access the sentiment scores, I had to transform the AFINN-111.txt file to the .RData format. See below for the code I used to prepare the file.

    setwd("~/R/sentimentAFINN/data/")
    sentDict <- read.delim("AFINN-111.txt", header=FALSE)
    names(sentDict) <- c("Word","SentimentScore")
    save(sentDict,file="AFINN-111.RData")
    
Now the AFINN sentiment dictionary can be accessed from within the package using the load() command

    load("data/AFINN-111.RData")
