'
Quiz
R 語言探索性資料分析與資料視覺化
資料操作: data.table
'
library(data.table)

#### section 1 ====
# 1-1
# 請用 data.table 讀取店舖資料、細節檔、評論並觀察資料
df.allshop.info <- fread('data/shop_infos.csv', sep = ",", header = T, 
                         stringsAsFactors = F, encoding = 'UTF-8',
                         nrows = -1)
df.shop.details <- fread('data/shop_details.csv')
df.review.info <- fread('data/shop_reviews.csv')

## 自行觀察資料, eg: nrow, names, View, etc...

# 1-2
# 請練習用 merge 將店舖資料 (shop_infos.csv) 及細節檔 (shop_details.csv) 合併
df.allshop.info <- merge(df.allshop.info, df.shop.details, by = "id")

#### section 2 ====

## data.table 的通用格式
df.allshop.info[cate.minor != "情境主題餐廳", 
                .(max.avg.cost=max(avg.cost)), 
                by=cate.minor]

# 2-1
# 清除重複資料
# Hints: ?duplicated
i <- duplicated(df.allshop.info, by = "id")
df.allshop.info <- df.allshop.info[!i, ]
print(paste0("Check answer: ", ifelse(nrow(df.allshop.info)==2234, "pass", "failed")))

# 2-2
# 在資料包含的時段內，為每家店鋪新增一個 avg.n.lolipop 欄位，
# 記錄所有分享文的平均棒棒糖數
# Hints: j + by & merge
df.allshop.info <- merge(df.allshop.info, df.review.info[, .(avg.n.lolipop=mean(n.lolipop)), by=id], all.x=T)
df.allshop.info[is.na(avg.n.lolipop), avg.n.lolipop := 0] # rm na

#### section 3 ====

# 3-1
# 在 Given 縣市的狀況下，增加縣市的 one-hot encoding
# Hints: dcast, setnames, merge
library(stringi)

df.allshop.info[, `:=`(gov.area1 = stri_extract(addr, regex = ".+?[縣市]"))]
df.allshop.info[is.na(gov.area1) | nchar(gov.area1) > 3, gov.area1 := "國外"]

df.tmp <- df.allshop.info[, c("id", "gov.area1")]
df.tmp <- dcast(df.tmp, id ~ gov.area1, fun=length)
setnames(df.tmp, names(df.tmp)[-1], paste0("area_", names(df.tmp)[-1]))

df.allshop.info <- merge(df.allshop.info, df.tmp)

# 3-2 
# 將寬資料轉成長資料並儲存在 scoring.long
# Hints: melt
# melt practice for future
scoring.long <- melt(df.allshop.info, id.vars = c("id", "cate.minor"), measure.vars = grep("^scoring", names(df.allshop.info)))
scoring.long[, value := as.numeric(value)]
