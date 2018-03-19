'''
R 語言探索性資料分析與資料視覺化
資料操作: data.table
'''
# 載入 data.table package
library(data.table)

### 基本操作 - 創建 data.table ====

# 創建一個 data.table
DT <- data.table(
  V1=c(1L,2L),
  V2=LETTERS[1:3],
  V3=round(rnorm(4),4), 
  V4=1:12)

# 將其他物件轉為 data.table
# DT <- as.data.table(iris)

### 基本操作 - 讀寫資料 ====

# 將 data.table 寫入 csv
fwrite(DT, file="data.csv")
file.exists("data.csv")

# 讀取資料，使用 ?fread 查詢更多說明
DT <- fread('data.csv')

### 基本操作 - 觀察 ====

# 檢查類型
class(DT)

# 欄位名稱
names(DT)

# 資料的 row 數
nrow(DT)

# 資料的 column 數
ncol(DT)

# 印出第 2 筆資料
DT[2]
DT[2, ]

# 印出第 3 個 column 的資料
DT[, 3]

# 印出第 3 個 column 的值
DT[[3]]

n <- 5
# 取出前 n 筆資料
head(DT, n)

# 取出後 n 筆資料
tail(DT, n)

# 在 R-Studio 腳本區觀察資料
View(DT)
