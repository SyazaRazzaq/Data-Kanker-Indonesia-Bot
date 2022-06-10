##Library
library(dplyr)
library(rvest)
library(rtweet)
library(mongolite)

##Scraping Data
urlPT <- "https://www.economy.com/indonesia/indicators"
data <- urlPT %>% read_html() %>% html_table
data <- data[[1]]
View(data)

#GDP (Quarterly)
gdp = data[1:8,]
View(gdp)
##Menyimpan update data ke MongoDB Database
#Menyiapkan koneksi
connection_string = Sys.getenv('MONGODB_CONNECTION')

#GDP
gdpcollect = mongo(collection="GDP",
                   db="Indikator_Ekonomi",
                   url=connection_string)
gdpcollect$insert(gdp)

# Publish to Twitter
## Create Twitter token
indikator_token <- create_token(
  app = "Indikator Ekonomi",
  consumer_key =    Sys.getenv("TWITTER_CONSUMER_API_KEY"),
  consumer_secret = Sys.getenv("TWITTER_CONSUMER_API_SECRET"),
  access_token =    Sys.getenv("TWITTER_ACCESS_TOKEN"),
  access_secret =   Sys.getenv("TWITTER_ACCESS_TOKEN_SECRET")

##Tweet
gdp_tweet <- paste0("Update GDP Indonesia",
                     "\n",
                     "\n",
                     gdp[5,1], " periode ", gdp[5,2], " adalah ", gdp[5,3], " dalam satuan ",
                     gdp[5,5]," di mana pada periode sebelumnya adalah ",gdp[5,4],
                     " dalam satuan ",gdp[5,5])

gdp_tweet2 <- paste0("Update Komponen GDP Indonesia",
                    "\n",
                    "\n",
                    gdp[2,1], " periode ", gdp[2,2], " adalah ", gdp[2,3], " dalam satuan ",
                    gdp[2,5]," di mana pada periode sebelumnya adalah ",gdp[2,4],
                    " dalam satuan ",gdp[2,5])

gdp_tweet3 <- paste0("Update Komponen GDP Indonesia",
                     "\n",
                     "\n",
                     gdp[3,1], " periode ", gdp[3,2], " adalah ", gdp[3,3], " dalam satuan ",
                     gdp[3,5]," di mana pada periode sebelumnya adalah ",gdp[3,4],
                     " dalam satuan ",gdp[3,5])
gdp_tweet4 <- paste0("Update Komponen GDP Indonesia",
                     "\n",
                     "\n",
                     gdp[4,1], " periode ", gdp[4,2], " adalah ", gdp[4,3], " dalam satuan ",
                     gdp[4,5]," di mana pada periode sebelumnya adalah ",gdp[4,4],
                     " dalam satuan ",gdp[4,5])

## Post the image to Twitter
post_tweet(status = gdp_tweet, token = indikator_token)
post_tweet(status = gdp_tweet2, token = indikator_token)
post_tweet(status = gdp_tweet3, token = indikator_token)
post_tweet(status = gdp_tweet4, token = indikator_token)
