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

The sentimentAFINN package is currently only on github and not cran yet.  To install the package from github, use the install_guthub() function from the devtools package.  You only have to do this once on your machine, then you can just call the library() function to load the sentimentAFINN package.

        install.packages("devtools")
        library(devtools)
        install_github("benporter/sentimentAFINN")
        

## Usage

load the library

        library(sentimentAFINN)

Use the <i>sentiment</i> function from the sentiment library

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
        
Create an R dataframe of the four columnes in the bible table

        results <- dbGetQuery(connectionToDB, "select book, chapter, verse, content from bible")

Make sure the query worked by printing the top 6 records

        head(results)
        
Output from the head(results) function
        
        book chapter verse
        1  Gen       1     1
        2  Gen       1     2
        3  Gen       1     3
        4  Gen       1     4
        5  Gen       1     5
        6  Gen       1     6
       content
        1                                                                                                <verse num="1">In the beginning God created the heaven and the earth.</verse>
        2 <verse num="2">And the earth was without form, and void; and darkness <i>was</i> upon the face of the deep. And the Spirit of God moved upon the face of the waters.</verse>
        3                                                                                                <verse num="3">And God said, Let there be light: and there was light.</verse>
        4                                                          <verse num="4">And God saw the light, that <i>it was</i> good: and God divided the light from the darkness.</verse>
        5                                   <verse num="5">And God called the light Day, and the darkness he called Night. And the evening and the morning were the first day.</verse>
        6                                      <verse num="6">And God said, Let there be a firmament in the midst of the waters, and let it divide the waters from the waters.</verse>
        > 

Notice the xml and html style markup.  Let's use some friendly neighborhood regex to delete the <> characters and everything in between.

        results$content <-gsub("<[^>]+>","",results$content)

Now that the data is ready to create a corpus object from.  Load the tm package to enable the Corpus() function.  Remember, the sentimentAFINN package only accepts Corpus objects for now.

        library(tm)

Create a corpus from our results dataframe.  Notice that I used the VectorSource() reader function despite the fact that the class of my results object is a dataframe.  I'm not sure why this works, but that makes it easier for me to subset out just the "contents" column later.

        bibleCorp <- Corpus(x=VectorSource(results))
        
Here are a few commands to inspect your data to make sure that the corpus was created the way you intended.  I know there are ~31,036 verses in the sqlite databse, so I should expect that many documents; however I four, which corresponds to the number of columns I read in.  Use the length() function to see the number of documents.

        length(bibleCorp)
        [1] 4

Use the names function to see the document names.

        names(bibleCorp)
        [1] "book"    "chapter" "verse"   "content"
        
Here is how you see the first verse.

        bibleCorp[["content"]][1]
        [1] "In the beginning God created the heaven and the earth."

Finally, here is the last step to create a corpus from the content column.  When you use the bibleCorp[["content"]] to get just the verses, it drops the class down to PlainTextDocument and does not preserve it as a Corpus class.  So we need to create a corpus from that document.

        example <- bibleCorp[["content"]]
        class(example)
        [1] "PlainTextDocument" "TextDocument"      "character" 

        contentCorp <- Corpus(VectorSource(bibleCorp[["content"]]))
        class(contentCorp)
        [1] "VCorpus" "Corpus"  "list" 

The contentCorp is of the right class to send to the sentiment function from the sentimentAFINN package.  The sentiment function returns a four column dataframe, so you can use any dataframe function on it, such as the summary() function.

        answer <- sentiment(contentCorp)
        
        summary(answer)
                DocNum      SentimentScore     SentimentScoreNormalized docContents       
        Min.   :    1   Min.   :-17.0000   Min.   :-1.66667         Length:31036      
        1st Qu.: 7760   1st Qu.:  0.0000   1st Qu.: 0.00000         Class :character  
        Median :15518   Median :  0.0000   Median : 0.00000         Mode  :character  
        Mean   :15518   Mean   :  0.2219   Mean   : 0.01733                           
        3rd Qu.:23277   3rd Qu.:  1.0000   3rd Qu.: 0.08696                           
        Max.   :31036   Max.   : 25.0000   Max.   : 2.00000                           

Create histograms of the sentiment and normalized sentiment

        hist(answer$SentimentScore,nclass=40)
        hist(answer$SentimentScoreNormalized,nclass=40)

Get the document number for the highest sentiment verses and print those verses from the original corpus.

        library(sqldf)
        top10 <- sqldf("select *
                from 
                (select * from
                 answer
                 order by SentimentScore desc)
                limit 10")
        bibleCorp[["content"]][top10$DocNum]
        
## Misc

In order to use the load() command in the package to access the sentiment scores, I had to transform the AFINN-111.txt file to the .RData format. See below for the code I used to prepare the file.

    setwd("~/R/sentimentAFINN/data/")
    sentDict <- read.delim("AFINN-111.txt", header=FALSE)
    names(sentDict) <- c("Word","SentimentScore")
    save(sentDict,file="AFINN-111.RData")
    
Now the AFINN sentiment dictionary can be accessed from within the package using the load() command

    load("data/AFINN-111.RData")
