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

#Price (Monthly)
price = data[11:13,]
colnames(price) <- price[1,]
price = price[-1,]

#Trade (Monthly)
trade = data[23:26,]
colnames(trade) <- trade[1,]
trade = trade[-1,]

##Menyimpan update data ke MongoDB Database
#Menyiapkan koneksi
connection_string = 'mongodb+srv://derikayz16:derYsaga123@cluster0.t9p0r.mongodb.net/admin?retryWrites=true&w=majority'

#Harga
harga = mongo(collection="Harga_Konsumen",
              db="Indikator_Ekonomi",
              url=connection_string)
harga$insert(price)

#Trade
perdagangan = mongo(collection="Perdagangan",
              db="Indikator_Ekonomi",
              url=connection_string)
perdagangan$insert(trade)

#Publish to Twitter
##Create Twitter token
indikator_token <- create_token(
  app = "Indikator Ekonomi",
  consumer_key =    "ObMiJ5y1aRrDbNIEbAQxfQ2fk",
  consumer_secret = "E7385ThAwfVvuIHnl9TDI4VR9tckHxyAb95yqEWrenEYQf0Od0",
  access_token =    "1498511089176571906-ChmN2VHYRkruY9cmSzsSosWq39vW0m",
  access_secret =   "WT1djx2I7p2IZWTLwQUoAbsYpZi7sBD8D4hf9gQCdvOrG")

##Tweet
###Price
harga_tweet <- paste0("Indikator Tingkat Harga Konsumen Indonesia",
                "\n",
                "\n",
                price[1,1], " periode ", price[1,2], " adalah ", price[1,3],
                " atau berubah sebesar ", 
                round(((as.numeric(price[1,3])-as.numeric(price[1,4]))/as.numeric(price[1,4])*100),2),
                " persen dari periode sebelumnya.",
                "\n",
                "\n",
                price[2,1], " periode ", price[2,2], " adalah ", price[2,3],
                " atau berubah sebesar ", 
                round(((as.numeric(price[2,3])-as.numeric(price[2,4]))/as.numeric(price[2,4])*100),2),
                " persen dari periode sebelumnya.")


## Post the image to Twitter
post_tweet(status = harga_tweet, token = indikator_token)

###Trade
trade_tweet <- paste0("Indikator Perdagangan Indonesia",
                "\n",
                "\n",
                trade[1,1], " periode ", trade[1,2], " adalah ", trade[1,3],
                " atau berubah sebesar ", 
                round(((as.numeric(sub(",", ".", trade[1,3], fixed = TRUE))
                        -as.numeric(sub(",", ".", trade[1,4], fixed = TRUE)))
                       /as.numeric(sub(",", ".", trade[1,4], fixed = TRUE))*100),2),
                " persen dari periode sebelumnya.",
                "\n",
                "\n",
                trade[2,1], " periode ", trade[2,2], " adalah ", trade[2,3],
                " atau berubah sebesar ", 
                round(((as.numeric(sub(",", ".", trade[2,3], fixed = TRUE))
                        -as.numeric(sub(",", ".", trade[2,4], fixed = TRUE)))
                       /as.numeric(sub(",", ".", trade[2,4], fixed = TRUE))*100),2),
                " persen dari periode sebelumnya.")

trade_tweet2 <- paste0("Indikator Perdagangan Indonesia",
                      "\n",
                      "\n",
                      trade[3,1], " periode ", trade[3,2], " adalah ", trade[3,3],
                      " atau berubah sebesar ", 
                      round(((as.numeric(sub(",", ".", trade[3,3], fixed = TRUE))
                              -as.numeric(sub(",", ".", trade[3,4], fixed = TRUE)))
                             /as.numeric(sub(",", ".", trade[3,4], fixed = TRUE))*100),2),
                      " persen dari periode sebelumnya.")

## Post the image to Twitter
post_tweet(status = trade_tweet, token = indikator_token)
post_tweet(status = trade_tweet2, token = indikator_token)

