'
R 語言探索性資料分析與資料視覺化
資料型態與向量操作 (Data types and vector operation)
'

# 將此行轉向你的程式碼放置路徑
setwd("~/ai-academy/aia-lab-r-eda-data-viz")

### Numberic (數值型態) and Character (字元型態)

this.is.a.numeric_item <- 101
this.is.a.numeric_item2 <- c(101, 201, 301, 101)

# 要定義文字變數，可使用單引號或雙引號
this.is.a.character_item <- '101'
this.is.a.character_item2 <- "abcbabd"

'
function: typeof
列出一個變數 (物件) 的資料型態
'
typeof(this.is.a.numeric_item)
typeof(this.is.a.numeric_item2)
typeof(this.is.a.character_item)
typeof(this.is.a.character_item2)

# 只有數值變數才可以進行數學運算
this.is.a.numeric_item + 101
this.is.a.numeric_item2[2] + 101   # 索引值從1開始
print(this.is.a.character_item)
this.is.a.character_item + 101     # 這行會報錯

print(this.is.a.numeric_item)
print(this.is.a.character_item)
this.is.a.numeric_item + 
  this.is.a.character_item         # 這行會報錯

# 數字型的字串變數可以被轉為數值變數, 非數字型文字會變成 NA
print(this.is.a.character_item)
this.is.a.numeric_item.from.character <- as.numeric(this.is.a.character_item)
print(this.is.a.numeric_item.from.character)
print(this.is.a.character_item2)
this.is.a.numeric_item2.from.character2 <- as.numeric(this.is.a.character_item2)
print(this.is.a.numeric_item2.from.character2)

typeof(this.is.a.numeric_item.from.character)
typeof(this.is.a.numeric_item2.from.character2) # 不過，NA 仍會被視為 double

this.is.a.numeric_item + this.is.a.numeric_item.from.character

### 警告: 任何數字跟 NA 進行數學運算，都將回傳 NA
1 + NA
print(this.is.a.numeric_item)
print(this.is.a.numeric_item2.from.character2)
this.is.a.numeric_item + this.is.a.numeric_item2.from.character2

this.is.a.numeric_list <- c(1,2,3,4)
this.is.a.numeric_list2 <- c(1,2,3,4, NA)

sum(this.is.a.numeric_list)
sum(this.is.a.numeric_list2)
sum(this.is.a.numeric_list2, na.rm=TRUE)

# 檢視變數列表中，是否有 NA (以及 NA 在哪)
print(this.is.a.numeric_list2)
is.na(this.is.a.numeric_list2)
which(is.na(this.is.a.numeric_list2))

# 字串可以用任意字符切開
print(this.is.a.character_item2)
strsplit(x=this.is.a.character_item2, split="b")

# 尋找特定字眼是否出現在變數列表中
temp <- strsplit(x = this.is.a.character_item2, split = "b")[[1]]
print(temp)
"c" %in% temp
"C" %in% temp               # 字串比對會看大小寫
tolower("C") %in% temp

### Factor (因子)
'
Factor 的主要目的: 省空間 -- numeric vector + levels
'
this.is.a.character_list <- c("A","B","C","B","A","A")
this.is.a.character_to_factor <- factor(this.is.a.character_list)

str(this.is.a.character_to_factor)
levels(this.is.a.character_to_factor)

# 因子可以是有順序性的，只要加上 ordered = TRUE
this.is.a.character_to_factor2 <- 
  factor(x=this.is.a.character_list, 
         ordered = TRUE,
         levels = c("C","B","A"))

str(this.is.a.character_to_factor2)
levels(this.is.a.character_to_factor2)

### List (列表)
# 建立一個含有多種資料型態在內的 list 

this.is.a.list <- list(100,
                       c(200,300,400),
                       'a',
                       c('cat','dog'))
print(this.is.a.list)

# 用 [[ ]] 取得 list 中的 element
for (i in seq(length(this.is.a.list))) {
  # 印出 list 的第 i 個元素
  print(this.is.a.list[[i]]) 
}

### data.frame (資料框)
mtcars

# 檢視資料集的前 n 列與後 n 列
head(mtcars, n=5)
tail(mtcars)       # n 預設值為 6

# 檢視資料的列名稱與欄名稱
rownames(mtcars)
colnames(mtcars)

# 檢視資料框中，每個欄位的資料型態
typeof(mtcars$mpg)
typeof(mtcars['mpg'])

?sapply
sapply(mtcars, typeof)

# 檢視資料框的基本資訊及摘要
str(mtcars)
summary(mtcars)

# 資料框中的某欄數值可以透過 $ 記號取得，或是用 ["var"]
mtcars$mpg       # 以向量形式回傳
mtcars[, "mpg"]  # 以向量形式回傳
mtcars["mpg"]    # 以 data.frame 形式回傳

# 也可以透過 $ 創造新的欄位
mtcars$hp.mpg <- mtcars$hp / mtcars$mpg
print(head(mtcars[c("hp", "mpg", "hp.mpg")]))

# 選取特定列與欄資料
mtcars[5, ]        # 顯示 data.frame 的第 5 列
mtcars[c(2,3,4), ] # 顯示 data.frame 的第 2,3,4 列

mtcars[c(2,3,4), c("mpg","cyl")] # 顯示指定列欄的交集

### END  ==== 

rm(list = ls()) # clear all variables

