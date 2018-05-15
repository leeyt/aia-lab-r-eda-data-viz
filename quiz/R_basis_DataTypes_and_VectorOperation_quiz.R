'
Quiz about Data type and vector operation
'
# 1-1
# 在向量 (1, 4, 2, NA, 7, 20, NA, 15, 10, 5) 中，以中位數填補 NA
numbers <- c(1, 4, 2, NA, 7, 20, NA, 15, 10, 5)
numbers[which(is.na(numbers))] <- median(numbers, na.rm = TRUE)

# 1-2
# 抓取資料後，請檢查所有欄位的資料型態
movies = read.csv('http://www.stat.berkeley.edu/classes/s133/data/movies.txt', 
                  sep='|',
                  stringsAsFactors=FALSE)
sapply(movies, typeof)

# 1-3
# 將金額的欄位 (票房(box)) 轉換成數值型態，並分別計算票房前 10 名與後 10 明的金額總和

# method1: with strsplit
movies$box.usd.1 <- as.numeric(sapply(movies$box, 
                                    function(x) strsplit(x, split = "\\$")[[1]][2]))

# method2: with gsub (string substitute)
movies$box.usd.2 <- as.numeric(gsub(movies$box, pattern = "\\$", replacement = ""))

# method3: with substr (we found that the format of box is the same)
movies$box.usd.3 <- as.numeric(substr(movies$box, start = 2, stop = 8))

movies <- movies[order(movies$box.usd.1, decreasing = T),]
sum(head(movies$box.usd.1, 10))
sum(tail(movies$box.usd.1, 10))

# 1-4
# 建立一個新欄位 "year.pass" 記錄自上映至今過了幾年，
# 再計算年平均票房，列出年平均票房最高的前 5 名電影
movies$on.year <- as.numeric(sapply(movies$date, 
                                    function(x) strsplit(x, split = ",")[[1]][2]))
movies$this.year <- 2018
movies$year.pass <- movies$this.year - movies$on.year
movies$avg.year.box <- movies$box.usd.1 / movies$year.pass

movies <- movies[order(movies$avg.year.box, decreasing = T),]
head(movies, 5)
