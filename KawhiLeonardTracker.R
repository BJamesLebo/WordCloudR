install.packages(c("twitteR","httr","RCurl"))
library(twitteR)
library(httr)
library(RCurl)

#Setting up Twitter authorization to use their API
consumer_key <- "abcdefg12345678"
consumer_secret <- "abcdefg12345678"
access_token <- "abcdefg12345678-these.are.unique.to.you"
access_secret <- "abcdefg12345678"

#mining tweets
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)
tw = twitteR::searchTwitter('#Kawhi + #Kawhi Leonard', n = 500,
                            since = "2018-06-29", retryOnRateLimit = 450)
d = twitteR::twListToDF(tw)

#mining tweets a different way (prefer this way, used it for the wordcloud)
Kawhi_tweets <- searchTwitter("Kawhi",n=1000,lang="en")

install.packages("tm")
library(tm)
install.packages("wordcloud")
library(wordcloud)

#converting the list of tweets to character type
Kawhi_text <- sapply(Kawhi_tweets, function(x) x$getText())

Kawhi_corpus <- Corpus(VectorSource(Kawhi_text))

#cleaning up the word data                     
#remove punctuation
Kawhi_clean <- tm_map(Kawhi_corpus, removePunctuation)
#convert everything to lower case
Kawhi_clean <- tm_map(Kawhi_clean, content_transformer(tolower))
#remove stop words
Kawhi_clean <- tm_map(Kawhi_clean, removeWords, stopwords("english"))
#remove numbers
Kawhi_clean <- tm_map(Kawhi_clean, removeNumbers)
#remove empty space
Kawhi_clean <- tm_map(Kawhi_clean, stripWhitespace)
#removing Kawhi Leonard's name, obviously that's gonna be in every tweet
Kawhi_clean <- tm_map(Kawhi_clean, removeWords, c("kawhi","leonard"))

#creating the word cloud
wordcloud(Kawhi_clean)

#wordcloud function has many different parameters, play around with it, here's a few options below
wordcloud(Kawhi_clean, random.order = F, max.words=40)
wordcloud(Kawhi_clean, random.order=F,
          max.words=22,col=c("purple","yellow"),scale=c(2,0.5))
