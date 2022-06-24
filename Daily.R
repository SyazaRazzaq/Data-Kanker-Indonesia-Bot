#Library
library(dplyr)
library(rvest)
library(rtweet)
library(mongolite)
library(twitteR)
library(purrr)

##Scraping Data
urlPT <- "https://www.worldometers.info/coronavirus/"
data <- urlPT %>% read_html() %>% html_table
data <- data[[2]]
View(data)



#Index Kematian
Data_covid = data[1:6,2:9]

View(Data_covid)
Data_covid_Asia<-Data_covid[1,2]
##Menyimpan update data ke MongoDB Database
#Menyiapkan koneksi



connection_string = Sys.getenv("MONGODB_CONNECTION")

#Index Kematian
Index = mongo(collection="Data_covid_Asia",
              db="CovidAsia")
Index$insert(Data_covid_Asia)

Data_covid_Asia_twit<-Data_covid_Asia[1,1]
Data_covid_Asia_twit<-as.character(Data_covid_Asia_twit)
class(Data_covid_Asia_twit)


#REPLACE '####' with the appropriate values from your twitter app
consumerKey='F68HEDWP6uhu9FNEAw3KfeMkV'
consumerSecret='sf4sLshmjJwCkADIg8Ofx8SpCdbba8zU1aCpONo7Kd2iytMi3x'
accessToken='1493744457337901066-33bCMfVLQ7mW46WmcU1iOEyi1qTL9p'
accessTokenSecret= 's1JR3nahtMLUqbAHJImjQhuUiMyD6WIS1rwrUV5kPt60H'

#Connect to twitter
setup_twitter_oauth(consumerKey,consumerSecret,accessToken,accessTokenSecret)


#Post Tweet !
tweet(paste0("Dataa Jumlah Kematian di Asia Akibat Covid-19 hari ini sebanyak","\n", Data_covid_Asia_twit))


