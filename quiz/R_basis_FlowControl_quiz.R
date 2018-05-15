'
Quiz about flow control
'
# 1a
# 建立一個函式 check_fizz_and_buzz(x)
# - 當 input 為 3 的倍數時，回傳 "Fizz"
# - 當 input 為 5 的倍數時，回傳 "Buzz"
# - 當 input 同時為 3 & 5 的倍數時，回傳 "FizzBuzz"
# - 當 input x 不為以上條件時
#   - 若 x 除以 7 的餘數小於 4，回傳 "Hi"
#   - 若 x 除以 7 的餘數大於或等於 4，回傳 "Bye"
check.mod7 <- function(x) {
  if (x %% 7 < 4) {
    out <- "Hi" 
  } else {
    out <- "Bye"
  }
  return(out) 
}

check.fizz_and_buzz <- function(x) {
  a <- x %% 3 == 0
  b <- x %% 5 == 0
  if (a | b) {
    if (a & b) {
      out <- "FizzBuzz"
    } else if (a) {
      out <- "Fizz"
    } else if (b) {
      out <- "Buzz"
    } else {
      out <- check.mod7(x)
    }
  } else {
    out <- check.mod7(x)
  }
  return(out)
}

# 1b
# 用迴圈印出 1 到 1000 呼叫 check.fizz_and_buzz 的結果

this.seq <- 1:1000
start.time <- proc.time()
for (x in this.seq) {
  print(check.fizz_and_buzz(x))
}
proc.time() - start.time

# 1c
# 請以 sapply 執行 check.fizz_and_buzz，範圍 1:1000，比較兩者速度
start.time  <- proc.time()
sapply(this.seq, function(x) print(check.fizz_and_buzz(x)))
proc.time() - start.time

# 2
# 找出 mtcars 中, disp 高於中位數的車款
unique(row.names(mtcars[which(mtcars$disp > median(mtcars$disp)),]))
