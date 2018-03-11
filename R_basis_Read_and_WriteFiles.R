'
R 語言探索性資料分析與資料視覺化
檔案讀寫 (save and read files)
'
setwd("~/ai-academy/aia-lab-r-eda-data-viz")

### 讀取文字或逗點分隔檔

# 純文字檔可以用 readLines 讀入
readin.txt1 <- readLines("examples/python_pkgs1.txt") # 會變成字元向量
typeof(readin.txt1)
print(readin.txt1[2:5])

# 純文字檔也可以用 read.csv 讀入
## 會轉換成 data.frame 格式
readin.txt2 <- read.csv(
  file="examples/python_pkgs1.txt", # 檔名
  header=FALSE,                     # 有欄位名稱？
  stringsAsFactors = FALSE          # 轉換成因子?
)
tail(readin.txt2)

readin.csv1 <- read.csv(
  file="examples/DL_toolkits_results_google.csv",
  header=TRUE, 
  sep = ",",
  stringsAsFactors = FALSE
)
head(readin.csv1)

# 網路上的文字檔也可以直接讀取
readin.csv2 <- read.csv(
  file='http://www.stat.berkeley.edu/classes/s133/data/movies.txt', 
  sep='|',
  stringsAsFactors=FALSE
)
head(readin.csv2)

### 儲存檔案 (to csv)

# 新增欄位後儲存
readin.csv1$log.search_results <- log(readin.csv1$search_results + 1) # 加 1 以避免 -Inf
head(readin.csv1, n=4)
write.csv(readin.csv1, file="tmp.csv", row.names=FALSE)

x <- read.csv("tmp.csv", header=TRUE)
head(x, n=4)

### 儲存檔案 (to rds, rda)
saveRDS(readin.csv1, file="one_file_one_var.rds")
save(readin.csv1, readin.csv2, file="one_file_multi_vars.rda")

# 測試
rm(list=ls())  # 先移除所有環境變數

x <- readRDS(file="one_file_one_var.rds")
head(x, n=4)

rm(list=ls())

load(file="one_file_multi_vars.rda")
ls()

# 練習

## 比較 read.csv 和 readRDS 的速度

start.time <- proc.time()
x <- read.csv(file="tmp.csv")
stop.time <- proc.time()
time.read.csv <- stop.time - start.time

start.time <- proc.time()
x <- readRDS(file="one_file_one_var.rds")
stop.time <- proc.time()
time.read.rds <- stop.time - start.time

print(time.read.csv)
print(time.read.rds)
