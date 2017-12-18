### Twitter Text Mining - Required Libraries
library(twitteR)
library(ROAuth)
library(RCurl)
library(httr)

library(stringr)
library(plyr)
library(dplyr)
library(tm)

#library(ggmap)
#library(wordcloud)

### Establishing A Connection - Direct Method

key=" "
secret=" "

atoken =  " "
asecret = " "

setup_twitter_oauth(key, secret, atoken, asecret)

searchTwitter("Samsung")

### Sentiment Score Function - approach after J. Breen

library("stringr")

library("plyr")

# Function is called sentimentfun
sentimentfun = function(tweettext, pos, neg, .progress='non')
{
  # Parameters
  # tweettext: vector of text to score
  # pos: vector of words of postive sentiment
  # neg: vector of words of negative sentiment
  # .progress: passed to laply() 4 control of progress bar
  
  # create simple array of scores with laply
  scores = laply(tweettext,
                 function(singletweet, pos, neg)
                 {
                   # remove punctuation - using global substitute
                   singletweet = gsub("[[:punct:]]", "", singletweet)
                   # remove control characters
                   singletweet = gsub("[[:cntrl:]]", "", singletweet)
                   # remove digits
                   singletweet = gsub("\\d+", "", singletweet)
                   
                   # define error handling function when trying tolower
                   tryTolower = function(x)
                   {
                     # create missing value
                     y = NA
                     # tryCatch error
                     try_error = tryCatch(tolower(x), error=function(e) e)
                     # if not an error
                     if (!inherits(try_error, "error"))
                       y = tolower(x)
                     # result
                     return(y)
                   }
                   # use tryTolower with sapply 
                   singletweet = sapply(singletweet, tryTolower)
                   
                   # split sentence into words with str_split (stringr package)
                   word.list = str_split(singletweet, "\\s+")
                   words = unlist(word.list)
                   
                   # compare words to the dictionaries of positive & negative terms
                   pos.matches = match(words, pos)
                   neg.matches = match(words, neg)
                   
                   # get the position of the matched term or NA
                   # we just want a TRUE/FALSE
                   pos.matches = !is.na(pos.matches)
                   neg.matches = !is.na(neg.matches)
                   
                   # final score
                   score = sum(pos.matches) - sum(neg.matches)
                   return(score)
                 }, pos, neg, .progress=.progress )
  
  # data frame with scores for each sentence
  sentiment.df = data.frame(text=tweettext, score=scores)
  return(sentiment.df)
}

### Using searchTwitter for our project 

# terms = apple+iphone, samsung+galaxy
## geocode: 
#lats=c(40.7,51.5,34.1,43.7)

#lons=c(-74,-0.1,-118.2,-79.4)

#cities = Seattle, Austin, New York, Los Angeles
# Seattle "47.606,-122.332,200mi"
# Austin "30.267,-97.743,200mi"
# New York "40.713,-74.006,200mi"
#     Los Angeles "34.052,-118.244,200mi"

# scraping the tweets with searchTwitter
#   Los Angeles
#tweets = searchTwitter("apple+iphone", n=2000, 
#                       lang="en", 
#                       geocode="34.052,-118.244,200mi",
#                       since = "2017-12-04")
#   New York
#tweets =searchTwitter("apple+iphone", n=2000, 
#                      lang="en", 
#                      geocode="40.713,-74.006,200mi",
#                      since = "2017-12-04")
#   Austin
#tweets =searchTwitter("apple+iphone", n=2000, 
#                      lang="en", 
#                      geocode="30.267,-97.743,500mi",
#                      since = "2017-12-04")
#  Seattle
#tweets =searchTwitter("apple+iphone", n=2000, 
#                      lang="en", 
#                      geocode="47.606,-122.332,500mi",
#                      since = "2017-12-04")
#   Los Angeles
#tweets = searchTwitter("samsung+galaxy", n=2000, 
#                       lang="en", 
#                       geocode="34.052,-118.244,200mi",
#                       since = "2017-12-04")
# New York
#tweets =searchTwitter("samsung+galaxy", n=2000, 
#                      lang="en", 
#                      geocode="40.713,-74.006,200mi",
#                      since = "2017-12-04")
# Austin
#tweets =searchTwitter("samsung+galaxy", n=2000, 
#                      lang="en", 
#                      geocode="30.267,-97.743,500mi",
#                      since = "2017-12-04")
# Seattle
tweets =searchTwitter("samsung+galaxy", n=2000, 
                      lang="en", 
                      geocode="47.606,-122.332,500mi",
                      since = "2017-12-04")

searchTwitter("from:Udemy") # user specific

searchTwitter("apple+iphone", n = 100, 
              since = "2017-12-04",
              lang = "en") # time specific

# extracting the text
tweettext = sapply(tweets, function(x) x$getText())

## first cleaning stage

tweettext=lapply(tweettext, function(x) iconv(x, "latin1", 
                                              "ASCII", sub=""))
tweettext=lapply(tweettext, function(x) gsub("htt.*",' ',x))
tweettext=lapply(tweettext, function(x) gsub("#",'',x))
tweettext=unlist(tweettext)


# getting the opinion lexicons from working directory
pos = readLines("positive_words.txt")
neg = readLines("negative_words.txt")

neg2 = c(neg, "bearish", "fraud"); tail(neg2)

## apply function score.sentiment
scores = sentimentfun(tweettext, pos, neg, .progress='text')

## extracting further elements (besides text) for the export csv
tweetdate=lapply(tweets, function(x) x$getCreated())
tweetdate=sapply(tweetdate,function(x) strftime(x, format="%Y-%m-%d %H:%M:%S",tz = "UTC"))

isretweet=sapply(tweets, function(x) x$getIsRetweet())

retweetcount=sapply(tweets, function(x) x$getRetweetCount())

favoritecount=sapply(tweets, function(x) x$getFavoriteCount())

## Creating the Data Frame
data=as.data.frame(cbind(ttext=tweettext,
                         date=tweetdate,
                         isretweet=isretweet, 
                         retweetcount=retweetcount,
                         favoritecount=favoritecount,
                         score = scores$score,
                         product = "Samsung Galaxy",
                         city = "Seattle", country = "USA"))

## remove duplicates
data2 = duplicated(data[,1])

data$duplicate = data2

## create file to wd
write.csv(data, file= "samsung_seattle.csv")

### gsub example

x = "This #Samsung is a great tablet http:\\amazon.com\33456frer45"

gsub("htt.*"," ",x)

gsub("#","",x)