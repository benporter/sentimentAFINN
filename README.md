sentimentAFINN
==============

R package for computing document sentiment using the Finn Årup Nielsen word listing

## Credit

Dictionary file with words and sentiment scores from <a href="http://www2.imm.dtu.dk/pubdb/views/publication_details.php?id=6010">Finn Årup Nielsen</a>

## Usage

Packages accepts dataframes and corpus objects


## Misc

In order to use the load() command in the package to access the sentiment scores, I had to transform the AFINN-111.txt file to the .RData format. See below for the code I used to prepare the file.

    setwd("~/R/sentimentAFINN/data/")
    sentDict <- read.delim("AFINN-111.txt", header=FALSE)
    names(sentDict) <- c("Word","SentimentScore")
    save(sentDict,file="AFINN-111.RData")
    
Now the AFINN sentiment dictionary can be accessed from within the package using the load() command

        load("data/AFINN-111.RData")
