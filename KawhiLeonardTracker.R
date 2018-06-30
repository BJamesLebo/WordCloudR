install.packages(c("twitteR","httr","RCurl"))
library(twitteR)
library(httr)
library(RCurl)

#Setting up Twitter authorization to use their API
consumer_key <- "vm9t6zkw3ONSML5jondFngbIY"
consumer_secret <- "ArmuCR98C4YjPvZRRbeWDVG5mlXhynpjuy655PO2SgB37a4FmT"
access_token <- "872276736414801920-3Vd1tuCxlYAfufsCNU51K2scjUxT6pz"
access_secret <- "KoGP5EWYfoacutwZmpBf6AnhDTOYsJBDj75WpleMYANHN"

#mining tweets
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)
tw = twitteR::searchTwitter('#Kawhi + #Kawhi Leonard', n = 500,
                            since = "2018-06-29", retryOnRateLimit = 450)
d = twitteR::twListToDF(tw)

#mining tweets a different way
Kawhi_tweets <- searchTwitter("Kawhi",n=1000,lang="en")

install.packages("tm")
install.packages("wordcloud")

#converting the list of tweets to character type
Kawhi_text <- sapply(Kawhi_tweets, function(x) x$getText())

Kawhi_corpus <- Corpus(VectorSource(Kawhi_text))

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

wordcloud(Kawhi_clean, random.order = F, max.words=40)
wordcloud(Kawhi_clean, random.order=F,
          max.words=22,col=c("purple","yellow"),scale=c(2,0.5))