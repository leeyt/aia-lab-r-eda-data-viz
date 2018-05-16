'
Practice: ggplot2 and eda
'
library(data.table)
library(ggplot2)
library(scales)

### section 1 ====
# 1-1
# 請用長條圖畫出在資料中平均消費超過 100 元的店佔資料中的多少比例？
# 以及在各類型的早餐店中所佔的比例？
df.allshop.info[, `:=`(is.larger.100 = ifelse(avg.cost > 100,
                                              1,
                                              0))]
ggplot(df.allshop.info, aes(x = as.factor(is.larger.100))) +
  geom_bar(aes(y = ..count.. / sum(..count..)),
           fill = 'tomato3') +
  labs(x = "is larger than 100?", y = "percent") +
  scale_y_continuous(labels = percent, breaks = seq(0,1,0.1)) +
  theme_bw()

ggplot(df.allshop.info, aes(x = as.factor(is.larger.100))) +
  geom_bar(aes(y = ..count.. / sum(..count..)),
           fill = 'tomato3') +
  labs(x = "is larger than 100?", y = "percent") +
  scale_y_continuous(labels = percent, breaks = seq(0,1,0.05)) +
  theme_bw() +
  facet_wrap(~cate.minor, scales = "free_y") +
  ggtitle("this is a wrong example") # 0 + 1 != 100%

tmp.plot <- df.allshop.info[, .(n = .N), .(cate.minor, is.larger.100)]
tmp.plot[, n.pct := n / sum(n), .(cate.minor)]
ggplot(tmp.plot, aes(x = as.factor(is.larger.100))) +
  geom_bar(stat = 'identity', aes(y = n.pct),
           fill = 'tomato3') +
  labs(x = "is larger than 100?", y = "percent") +
  scale_y_continuous(labels = percent, breaks = seq(0,1,0.2)) +
  theme_bw() +
  facet_wrap(~cate.minor, scales = "free_y") +
  ggtitle("this is a correct example")

# 1-2
# 請畫出各類型早餐店的點閱率 ECDF (Empirical CDF)
ggplot(df.allshop.info, aes(x = n.view)) + 
  stat_ecdf(aes(color = factor(cate.minor)), geom = 'line') + 
  scale_x_log10(labels = log10) +
  theme_bw() +
  labs(x = "n.view (log10)", y = "ecdf") + 
  scale_y_continuous(labels = percent) +
  scale_color_discrete("sub category")

# 1-3
# 請畫出各類型早餐店的平均消費之中位數
ggplot(df.breakfast, aes(cate.minor, med.avg.cost)) +
  geom_bar(stat = "identity", fill = "blue") + 
  theme_bw()

# 1-4
# 請移除平均消費為 0 的資料後，再重新畫圖檢視各類型早餐店的平均消費
# 與點閱數等特徵
df.allshop.info <- df.allshop.info[avg.cost != 0, ]
ggplot(df.allshop.info, aes(x = avg.cost)) +
  stat_ecdf(aes(color = factor(cate.minor)), geom = "line") +
  theme_bw() + 
  labs(y = "cumulative n") +
  geom_hline(yintercept = 0.5, lty = 2, color = "red") +
  scale_y_continuous(labels = percent) +
  scale_color_discrete("cate.minor")

### section 2 ====
# 2-1
# 請以 scatter plot 檢視店鋪的平均客單價與氣氛評價分數的關係
ggplot(df.allshop.info, aes(scoring.delicious + 1, avg.cost + 1)) +
  geom_point(aes(color = cate.minor)) + 
  scale_x_log10() + scale_y_log10() +
  theme_bw()

# 2-2a
# 請對 "西式早餐" 與 "早午餐" 的美味分數做 t 檢定
t.test(df.allshop.info[cate.minor == "西式早餐",]$scoring.delicious,
       df.allshop.info[cate.minor == "早午餐",]$scoring.delicious)

# 2-2b
# 對 "中式早餐", "西式早餐" 與 "早午餐" 的美味分數做 ANOVA 並畫出 ecdf
summary(aov(scoring.delicious ~ cate.minor, df.allshop.info[cate.minor %in% c("中式早餐","西式早餐","早午餐")]))
ggplot(df.allshop.info[cate.minor %in% c("中式早餐", "西式早餐", "早午餐")], 
       aes(x = scoring.delicious)) +
  stat_ecdf(aes(color = cate.minor)) +
  theme_bw()

# 2-3
# 請以迴圈的方式計算倆倆變數間的關係並畫出相關矩陣
df.cor <- data.table()
for (i in cor.colname) {
  for (j in cor.colname) {
    k <- cor.test(df.allshop.info[[i]], df.allshop.info[[j]])
    print(paste("correlation between", i, "and", j, "is", k$estimate))
    df.tmp <- data.table(i,j,k$estimate)
    df.cor <- rbind(df.cor, df.tmp)
  }
}
head(df.cor)
ggplot(df.cor, aes(i, j, fill = V3)) + 
  geom_tile() + theme_bw() +
  geom_text(aes(label = paste0(sprintf("%.2f", round(V3,3))))) +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red")

# 2-4
# 請使用在 data.table 重鑄資料的練習中創建的 scoring.long 畫出以下 ecdf 的圖
ggplot(scoring.long, aes(value, col=cate.minor)) +
  stat_ecdf() +
  facet_wrap(~variable, scales = "free") +
  theme_bw()

### section 3 ====
# 3-1
# 請建立一個 "gov.area2" 欄位，取得地址的鄉鎮市區
df.allshop.info[, `:=`(gov.area2 = stri_extract(addr, regex = ".+?[縣市].+?[鄉鎮市區]")
)]

# 3-2
# 將 df.review.info 中期他還是亂碼的欄位也轉回正常顯示
unique(df.review.info$r.service)
m2 <- c("非常不滿意", "很不滿意", "不滿意", "一般", "滿意", "很滿意", "非常滿意")
df.review.info[, r.service := iconv(r.service, from = "UTF-8", to = "UTF-8")]

# 3-3 & 3-4 請自由發揮