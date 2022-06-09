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

#Financial Market (Daily)
market = data[42:44,]
colnames(market) <- market[1,]
market = market[-1,]

##Menyimpan update data ke MongoDB Database
#Menyiapkan koneksi
connection_string = 'mongodb+srv://derikayz16:derYsaga123@cluster0.t9p0r.mongodb.net/admin?retryWrites=true&w=majority'

#Markets
pasar = mongo(collection="Pasar_Keuangan",
              db="Indikator_Ekonomi",
              url=connection_string)
pasar$insert(market)

# Publish to Twitter
##Create Twitter token
indikator_token <- create_token(
  app = "Indikator Ekonomi",
  consumer_key =    "ObMiJ5y1aRrDbNIEbAQxfQ2fk",
  consumer_secret = "E7385ThAwfVvuIHnl9TDI4VR9tckHxyAb95yqEWrenEYQf0Od0",
  access_token =    "1498511089176571906-ChmN2VHYRkruY9cmSzsSosWq39vW0m",
  access_secret =   "WT1djx2I7p2IZWTLwQUoAbsYpZi7sBD8D4hf9gQCdvOrG")

##Tweet
market_tweet <- paste0("Indikator Pasar Keuangan Indonesia",
                       "\n",
                       "\n",
                       market[1,1], " periode ", market[1,2], " adalah ", market[1,3],
                       " atau berubah sebesar ", 
                       round(((as.numeric(market[1,3])-as.numeric(market[1,4]))/as.numeric(market[1,4])*100),2),
                       " persen dari periode sebelumnya.",
                       "\n",
                       "\n",
                       market[2,1], " periode ", market[2,2], " adalah ", market[2,3],
                       " atau berubah sebesar ", 
                       round(((as.numeric(sub(",", ".", market[2,3], fixed = TRUE))
                               -as.numeric(sub(",", ".", market[2,4], fixed = TRUE)))
                              /as.numeric(sub(",", ".", market[2,4], fixed = TRUE))*100),2),
                       " persen dari periode sebelumnya.")

## Post the image to Twitter
post_tweet(status = market_tweet, token = indikator_token)
