'
R 語言探索性資料分析與資料視覺化
資料操作: data.table
'

# 載入 data.table package
library(data.table)

DT <- data.table(iris)

### 基本操作 - i ====

# 篩選第 3 ~ 5 筆資料

DT[3:5, ]
DT[3:5]

# 篩選 Species 欄位中所有值是 'setosa' 且 Sepal.Length > 5 的 rows
DT[Species == "setosa" & Sepal.Length > 5]

# 篩選所有 Sepal.Length 數值介於 5 ~ 5.2 的 rows
DT[Sepal.Length %between% c(5, 5.2)]
DT[Sepal.Length >= 5 & Sepal.Length <= 5.2]

# 搭配 eval 及 parse 以字串控制篩選條件
# Our goal: Sepal.Length < median(Sepal.Length) | Sepal.Width < median(Sepal.Width)
# [1] "Sepal.Length" "Sepal.Width"
c.names <- paste0("Sepal.", c("Length", "Width"))
# [1] "Sepal.Length < median(Sepal.Length)" "Sepal.Width < median(Sepal.Width)"
condition_list <- paste0(c.names, " < median(", c.names, ")")
# [1] "Sepal.Length < median(Sepal.Length) | Sepal.Width < median(Sepal.Width)"
or.condition <- paste0(condition_list, collapse = " | ") 
DT[eval(parse(text = or.condition))]

# 搭配 order() 用於排序
DT[order(Sepal.Length, -Sepal.Width)]

## 基本操作 - j ====

# 篩選欄位 & with = FALSE
DT[, 1] # same as DT[, .(Sepal.Length)]
DT[[1]] # same as DT[, Sepal.Length]
DT[, c(1, 3)] # same as DT[, .(Sepal.Length, Petal.Length)]
DT[, grep("Length", names(DT))]         # not what we desired
# 篩選出欄位名稱含有 "Length"
DT[, grep("Length", names(DT)), with=F] 
# 篩選出欄位名稱不含有 "Length"
DT[, -grep("Length", names(DT)), with=F]

# 增加/更新欄位
# 如果尚未存在，新增 "prod.SL.SW" 欄位
# 否則更新該欄位的值
DT[, prod.SL.SW := Sepal.Length * Sepal.Width] 
                                     
# 同時新增/更新多個欄位
DT[, c("prod.SL.SW", "prod.PL.PW") := 
     list(Sepal.Length * Sepal.Width, Petal.Length * Petal.Width)] 

# 另外一種做法
DT[, ':=' (prod.SL.SW=Sepal.Length * Sepal.Width, 
           prod.PL.PW=Petal.Length * Petal.Width)]

# 刪除 "prod.SL.SW" 欄位 (設值成 NULL)
DT[, prod.SL.SW := NULL] 

c.names <- c("prod.PL.PW")
DT[, c.names := NULL]
# 欄位名稱存放於變數中的更新方式
DT[, (c.names) := NULL]

# 對欄進行計算
DT[, mean(Sepal.Length)]
# same as DT[, list(mean(Sepal.Length), sum(Sepal.Width))]
DT[, .(mean(Sepal.Length), sum(Sepal.Width))] 
DT[, .(avg.SL=mean(Sepal.Length), sum.SW=sum(Sepal.Width))]
DT[Species == 'setosa', .(avg.SL=mean(Sepal.Length), sum.SW=sum(Sepal.Width))]

# .SD (data.table 子集) 的範例
# same as DT[, .SD, .SDcols = c("Sepal.Length", "Sepal.Width")]
DT[, .SD, .SDcols = c(1, 2)] 
DT[, .SD[1:10]]

# 用 lapply & 計算每個 .SD 欄位 mean
DT[, lapply(.SD, mean), .SDcols=-c("Species")]

norm <- function(x) {
  (x-mean(x))/sd(x)
}

c.names <- names(DT)[1:4]
DT[, (paste0("norm.", c.names)) := lapply(.SD, norm), .SDcols=c.names]
DT[, (paste0("norm.", c.names)) := NULL]

### 基本操作 - by ====

# 搭配 j, 對 by 中的欄位/條件進行分組計算
DT[, .SD[1:2], by=.(Species)]
DT[, lapply(.SD, mean), by=.(S=Species)]
DT[, lapply(.SD, mean), by=.(is.setosa=Species=="setosa")]
DT[, lapply(.SD, mean), .SDcols=-c("Species"),
   by=.(is.setosa=Species=="setosa", is.big.sepal=Sepal.Width > mean(Sepal.Width))]
DT[, SL.by.group := norm(Sepal.Length), by=.(Species)]

#### 以上的操作都可以直接搭配 i ####
#### operations above all work with i ####

# 搭配 .N 可以計數
# work with .N for counting
DT[, .(count=.N), by=.(Species)]
DT[, .(avg.SL=mean(Sepal.Length[1:.N-1])), by=.(Species)]

# 連鎖操作
# chaining operation
# Which species is the biggest under condition of Sepal.Length > 5?
DT[Sepal.Length > 5, .(count=.N), by=.(Species)][count==max(count)]

#### Note ====
# use copy(DT) if you don't want DT2 is just a reference of DT!
DT2 <- DT 
head(DT2)
DT[, test := "test"]
head(DT2)
DT[, test := NULL]

#### extra ====
# use index as filter
id.with.outlier <- lapply(DT[, -5], function(x) which(x > quantile(x, 0.95)))
DT[-unique(unlist(id.with.outlier))]

# vectorized function is required while updating column using j
DT[, species.split := strsplit(Species, "o")] # should meet error

mystrsplit <- function(x, split, i=1){
  strsplit(x, split)[[1]][i]
}
vector.strsplit <- function(x, split, i = 1){
  sapply(x, FUN = mystrsplit, split=split, i = i)
}
DT[, species.split := vector.strsplit(as.character(Species), "o")]
