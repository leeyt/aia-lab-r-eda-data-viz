'
R 語言探索性資料分析與資料視覺化
流程控制 (Flow control)
'

setwd("~/ai-academy/aia-lab-r-eda-data-viz")

### Loop (迴圈)

# 建立一個從 1 到 10000，間隔 2 的數值變數
a <- seq(from=1, to=10000, by=2)
print(a[1:20])  # 列印前 20 個元素

# 每個數值都平方，使用 "for loop"
start.time <- proc.time()
for (number in a) {
  print(number^2)
}
end.time <- proc.time()
time.loop.for <- end.time - start.time
print(time.loop.for)

# 每個數值都平方，使用 "while" loop
start.time <- proc.time()
index <- 1
while(index <= length(a)) {
  print(a[index]^2)
  index <- index + 1
}
end.time <- proc.time()
time.loop.while <- end.time - start.time
print(time.loop.while)

# 每個數值都平方，使用 vector
start.time <- proc.time()
print(a^2)
end.time <- proc.time()
time.noloop <- end.time - start.time
print(time.noloop)

print(time.loop.for)
print(time.loop.while)
print(time.noloop)

### Condition control (條件控制)

# 條件式
# 基本用法: 用於數字向量 (>, == , < , or: |, and: &)
this.is.a.numeric_vec <- c(1,2,3,4,5)
x <- this.is.a.numeric_vec > 3
print(x)
this.is.a.numeric_vec[this.is.a.numeric_vec > 3]
this.is.a.numeric_vec[this.is.a.numeric_vec < 3 | this.is.a.numeric_vec > 3]
this.is.a.numeric_vec[this.is.a.numeric_vec > 2 & this.is.a.numeric_vec < 4]

# 條件式
# 基本用法: 用於文字向量
this.is.a.char_vec <- c("a","b","c","d","a","c")
x <- this.is.a.char_vec != "c"
print(x)
this.is.a.char_vec[this.is.a.char_vec != "c"]

# 用於 data.frame
head(mtcars)
mtcars["mpg" > mean(mtcars$mpg), ]

x <- which(mtcars$mpg > mean(mtcars$mpg) & mtcars$carb == 1)
print(x)
mtcars[x,]

# 條件判斷式
a <- sample(1:100, size=10, replace=FALSE)
print(a)
for (i in a) {
  if (i <= 10 ) {
    print(paste(i, " is less than or equal to 10", sep = "") )
  } else if (i > 10 & i < 50) {
    print(paste(i, "is larger than 10 and smaller than 50"))
  } else {
    print( paste(i, "is larger than 50"))
  }
}

### Custom function (自定函數)

# 自定義一個平方後加 1 的函數
square_add_1 <- function(x) {
  # 你可以在這裡做任何事
  result <- x^2 + 1
  
  # 你必須回傳才會有輸出
  return(result)
}
square_add_1(10)

# 將前面判斷大小的範例轉成以向量進行, 結合 sapply 與自定函數
check.status <- function(x) {
  if (x <= 10 ) {
    out <- paste(x, " is less than or equal to 10", sep = "")
  } else if (x > 10 & x < 50) {
    out <- paste(x, "is larger than 10 and smaller than 50")
  } else {
    out <- paste(x, "is larger than 50")
  }
  return(out)
}
sapply(a, check.status)

### 本節結束 
rm(list = ls())    # 清除所有變數

### 練習

# 1. FizzBuzz 問題的變形，比較 loop 和 sapply 的執行效率

check.fizz_and_buzz <- function(x) {
  if (x %% 15 == 0) {
    return("FizzBuzz")
  } else if (x %% 3 == 0) {
    return("Fizz")
  } else if (x %% 5 == 0) {
    return("Buzz")
  } else if (x %% 7 < 4) {
    return("Hi")
  } else {
    return("Bye")
  }
}

start.time <- proc.time()
for (i in 1:1000) {
  check.fizz_and_buzz(i)
}
stop.time <- proc.time()
time.loop <- stop.time - start.time

start.time <- proc.time()
sapply(1:1000, check.fizz_and_buzz)
stop.time <- proc.time()
time.sapply <- stop.time - start.time

# 2. 找出 mtcars 中，disp 高於中位數的車款

x <- which(mtcars$disp > median(mtcars$disp))
unique(rownames(mtcars[x,]))
