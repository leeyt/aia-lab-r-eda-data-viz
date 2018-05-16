'
R 語言探索性資料分析與資料視覺化
ggplot 與常用統計指令 (ggplot and common used statistics commands)
'
library(data.table)
library(ggplot2)
library(scales)
library(stringi)

load("data/data_table_finished.RData")

# show the variables in your environment
ls()

# 處理資料內的 encoding problem: iconv
# Before EDA, we found that the encoding problem in the data: with iconv
df.allshop.info[, shop.summary := iconv(shop.summary, from = "UTF-8", to = "UTF-8")]

### ggplot2 section 1====
# Barplot - 早餐類各個子類別的個數 
# Barplot - how many items in each sub-categories
ggplot(df.allshop.info, aes(x = cate.minor)) +
  geom_bar(fill = "royalblue2") + 
  theme_bw() + 
  coord_flip() +
  labs(x = "minor category") +
  ggtitle("Numbers of Sub-categories in breakfast") +
  theme(text = element_text(family = "BiauKai"))

# bar plot - 早餐類各個子類別的比例
# bar plot - how many items in each sub-categories (with percentage)
ggplot(df.allshop.info, aes(x = cate.minor)) +
  geom_bar(fill = "royalblue2", 
           aes(y = (..count..)/sum(..count..))) + 
  theme_bw() + 
  coord_flip() +
  scale_y_continuous(labels = percent) +
  labs(x = "minor category", y = "percentage") +
  ggtitle("Percentage of Sub-categories in breakfast") +
  theme(text = element_text(family = "BiauKai"))

# hist and ecdf - 各類型早餐的金額落點
# hist and ecdf - the cumulative density function of the average cost for each sub-categories
ggplot(df.allshop.info, aes(x = avg.cost)) +
  geom_histogram(aes(fill = cate.minor), 
                 alpha = 0.8, 
                 bins = 50) +
  theme_bw() + 
  labs(y = "cumulative n") +
  theme(text = element_text(family = "BiauKai"))

# 用 facet_wrap 將類別拆開
# split histogram by facet
ggplot(df.allshop.info, aes(x = avg.cost)) +
  geom_histogram(aes(fill = cate.minor), 
                 alpha = 0.8, 
                 bins = 50) +
  theme_bw() + 
  labs(y = "cumulative n") +
  facet_wrap(~cate.minor, scales = "free") +
  theme(text = element_text(family = "BiauKai"))
# show avg.cost = 0?

# 也可以畫 density plot
# with density plot
ggplot(df.allshop.info, aes(x = avg.cost)) + 
  geom_density(aes(fill = cate.minor)) + 
  facet_wrap(~cate.minor, scales = "free") +
  theme_bw() +
  theme(text = element_text(family = "BiauKai"))

# 盒鬚圖
# boxplot
ggplot(df.allshop.info, 
       aes(x = cate.minor, y = avg.cost)) + 
  geom_boxplot(aes(fill = cate.minor)) + 
  scale_y_continuous(breaks = seq(0,1000, 100)) +
  coord_flip() +
  theme_bw() +
  theme(text = element_text(family = "BiauKai"))

ggplot(df.allshop.info, aes(x = avg.cost)) +
  stat_ecdf(aes(color = factor(cate.minor)), geom = "line") +
  geom_hline(yintercept = 0.5, lty = 2, color = "red") +
  theme_bw() + 
  labs(y = "cumulative n") +
  scale_y_continuous(labels = percent) +
  scale_color_discrete("cate.minor") +
  theme(text = element_text(family = "BiauKai"))

# 各類型早餐的平均金額/中位數/標準差
# get the mean/median/sd of avg.cost by the sub-category
df.breakfast <- df.allshop.info[, 
                                .(mean.avg.cost = mean(avg.cost, na.rm = T),
                                  med.avg.cost = as.numeric(median(avg.cost, na.rm = T)),
                                  sd.avg.cost = sd(avg.cost, na.rm = T),
                                  n = .N), 
                                .(cate.minor)]

df.breakfast$cate.minor <- factor(df.breakfast$cate.minor,
                                  levels = df.breakfast[order(mean.avg.cost, decreasing = T),]$cate.minor)

ggplot(df.breakfast, aes(x = cate.minor, y = mean.avg.cost)) +
  geom_bar(stat = "identity", fill = "royalblue2") + 
  geom_text(aes(label = round(mean.avg.cost,2) )) +
  theme_bw() +
  theme(text = element_text(family = "BiauKai"))

# 練習題
# 1) 請用長條圖畫出在資料中平均消費超過 100 元的店佔資料中的多少比例？
#    以及在各類型的早餐店中所佔的比例？
df.allshop.info[, is.larger.100 := ifelse(avg.cost > 100, 1, 0)]
ggplot(df.allshop.info, aes(as.factor(is.larger.100))) +
  geom_bar(aes(y = ..count.. / sum(..count..))) +
  xlab('平均消費超過 100 元？') +
  ylab('所佔比例') +
  scale_y_continuous(labels = percent, breaks = seq(0, 1, 0.1)) +
  theme_bw(base_family = "BiauKai")

is.larger.100.by.cate <- df.allshop.info[, 
                                         .(n = .N),
                                         .(cate.minor, is.larger.100)]
is.larger.100.by.cate[, n.pct := n / sum(n), .(cate.minor)]

ggplot(is.larger.100.by.cate, aes(x = as.factor(is.larger.100))) +
  geom_bar(stat = 'identity', aes(y = n.pct)) +
  xlab("平均消費超過 100 元？") +
  ylab("所佔比例") +
  scale_y_continuous(labels = percent, breaks = seq(0, 1, 0.2)) +
  theme_bw(base_family = "BiauKai") +
  facet_wrap(~cate.minor, scales = "free_y")

# 2) 請畫出各類型早餐店的點閱率 ECDF (Empirical CDF)
ggplot(df.allshop.info, aes(x = n.view)) + 
  stat_ecdf(aes(color = factor(cate.minor)), geom = 'line') + 
  scale_x_log10(labels = log10) +
  theme_bw(base_family = "BiauKai") +
  xlab("n.view (log10)") +
  ylab("ecdf") + 
  scale_y_continuous(labels = percent) +
  scale_color_discrete("早餐店類型")

# 3) 請畫出各類型早餐店的平均消費之中位數
ggplot(df.breakfast, aes(cate.minor, med.avg.cost)) +
  geom_bar(stat = "identity", fill = "blue") + 
  theme_bw(base_family = "BiauKai")

# 4) 請移除平均消費為 0 的資料後，再重新畫圖檢視各類型早餐店的平均消費
#    與點閱數等特徵
df.allshop.info <- df.allshop.info[avg.cost != 0, ]

ggplot(df.allshop.info, aes(x = avg.cost)) +
  stat_ecdf(aes(color = factor(cate.minor)), geom = "line") +
  theme_bw(base_family = "BiauKai") + 
  ylab("cumulative n") +
  geom_hline(yintercept = 0.5, lty = 2, color = "red") +
  scale_y_continuous(labels = percent) +
  scale_color_discrete("cate.minor")

### ggplot2 section 2====

# scatter plot: 觀看數與收藏數的關係
# scatter plot: Inspect the relationship between #view and #favorite 

ggplot(df.allshop.info, aes(n.view + 1, n.favorite + 1)) +
  geom_point(aes(color = cate.minor)) + 
  scale_x_log10() + scale_y_log10() +
  theme_bw(base_family = "BiauKai")
# to use log, recommend you to +1 (or log(0) will become -Inf)

ggplot(df.allshop.info, aes(n.favorite + 1, n.share + 1)) +
  geom_point(aes(color = cate.minor)) + 
  theme_bw(base_family = "BiauKai") + 
  scale_x_log10() + scale_y_log10() +
  stat_smooth() + 
  facet_wrap(~cate.minor)

# T 檢定
# simple t-test
t.test(df.allshop.info[cate.minor == "中式早餐",]$scoring.atom,
       df.allshop.info[cate.minor == "西式早餐",]$scoring.atom)

# one-way ANOVA
summary(aov(scoring.atom ~ cate.minor, 
            df.allshop.info[cate.minor %in% c("中式早餐","西式早餐","早午餐")]))

ggplot(df.allshop.info[cate.minor %in% c("中式早餐", "西式早餐", "早午餐")], 
       aes(x = scoring.atom)) +
  stat_ecdf(aes(color = cate.minor)) +
  theme_bw(base_family = "BiauKai")

# tile & correlation matrix: 各變數間的相關矩陣
# tile & correlation matrix: correlation between variables
# 計算相關前, 欄位需全部為 numeric type
# to compute correlation, columns must be numeric
cor.colname <- c("avg.cost", "n.scoring", "scoring.mix", "scoring.delicious",
                 "scoring.atom", "n.view", "n.favorite", "n.share")
df.allshop.info[,
                (cor.colname) := lapply(.SD, function(x) as.numeric(as.character(x))),
                .SDcols = cor.colname]
# run 1 by 1 correlation with built-in function
with(df.allshop.info, cor.test(avg.cost, n.scoring))

# 使用 psych 套件計算變數間的相關性
# use package: psych
cor.matrix <- psych::corr.test(df.allshop.info[, cor.colname, with = F])
View(cor.matrix$r)

cor.matrix.r <- cor.matrix$r
cor.matrix.p <- cor.matrix$p
head(cor.matrix.r)

# ggplot 無法直接利用這個相關矩陣，需要轉成 pair data
# ggplot can only draw pair data
plt.r <- melt(data = cor.matrix.r, id.vars = "avg.cost", value.name = "cor")
plt.p <- melt(data = cor.matrix.p, id.vars = "avg.cost", value.name = "sig")
plt.tmp <- merge(plt.r, plt.p, by = c("Var1", "Var2"))
head(plt.tmp)
rm(plt.r, plt.p)

ggplot(plt.tmp, aes(Var1, Var2, fill = cor)) + 
  geom_tile() +
  theme_bw(base_family = "BiauKai") +
  geom_text(aes(label = paste0(sprintf("%.2f", round(cor,3)), 
                               "\n", 
                               sprintf("%.2f", round(sig,3))))) +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red")

# let p-value become stars & plot it
plt.tmp$p.star <- cut(plt.tmp$sig, 
                      breaks = c(-Inf, 0.001, 0.01, 0.05, 1),
                      labels = c("***", "**", "*", ""), 
                      include.lowest = F, right = T)

ggplot(plt.tmp, aes(Var1, Var2, fill = cor)) + 
  geom_tile() + 
  theme_bw(base_family = "BiauKai") +
  geom_text(aes(label = paste0(sprintf("%.2f", round(cor,3)), 
                               p.star))) +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red")

# Practice
# 1) 請以 scatter plot 檢視店鋪的平均消費與氣氛評價分數的關係

ggplot(df.allshop.info, aes(scoring.delicious + 1, avg.cost + 1)) +
  geom_point(aes(color = cate.minor)) + 
  scale_x_log10() + scale_y_log10() +
  theme_bw(base_family = "BiauKai")

# 2a) 請對 "西式早餐" 與 "早午餐" 的美味分數做 t 檢定

t.test(df.allshop.info[cate.minor == "西式早餐",]$scoring.delicious,
       df.allshop.info[cate.minor == "早午餐",]$scoring.delicious)

# 2b) 對 "中式早餐", "西式早餐" 與 "早午餐" 的美味分數做 ANOVA 並畫出 ecdf
summary(aov(scoring.delicious ~ cate.minor, df.allshop.info[cate.minor %in% c("中式早餐","西式早餐","早午餐")]))

ggplot(df.allshop.info[cate.minor %in% c("中式早餐", "西式早餐", "早午餐")], 
       aes(x = scoring.delicious)) +
  stat_ecdf(aes(color = cate.minor)) +
  theme_bw(base_family = "BiauKai")

# 3) 請以迴圈的方式計算倆倆變數間的關係並畫出相關矩陣
df.cor <- data.table()
for (i in cor.colname) {
  for (j in cor.colname) {
    k <- cor.test(df.allshop.info[[i]], df.allshop.info[[j]])
    print(paste("correlation between", i, "and", j, "is", k$estimate))
    df.tmp <- data.table(i, j, k$estimate)
    df.cor <- rbind(df.cor, df.tmp)
  }
}
head(df.cor)

ggplot(df.cor, aes(i, j, fill = V3)) + 
  geom_tile() +
  theme_bw(base_family = "BiauKai") +
  geom_text(aes(label = paste0(sprintf("%.2f", round(V3,3))))) +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red")

# 4) 請使用在 data.table 重鑄資料的練習中創建的 scoring.long 畫出以下 ecdf 的圖
ggplot(scoring.long, aes(value, col=cate.minor)) +
  stat_ecdf() +
  facet_wrap(~variable, scales = "free") +
  theme_bw(base_family = "BiauKai")

### Other common used data preprocessing tech ====
# So, what's next? Create more features and do more EDA! -- feature engineering
# 地址-縣市區
# ...etc
# review 的篇數, 平均給分, 閱讀總數 

## 從原本的 df.allshop.info 產生, (simple regular expression)
head(df.allshop.info[, .(addr)])
df.allshop.info[, `:=`(scoring.sum = scoring.delicious + scoring.service + scoring.atom,
                       gov.area1 = stri_extract(addr, regex = ".+?[縣市]"))]
head(df.allshop.info[, .(addr, gov.area1)])

# 從 df.review 產生新的特徵
# Create new features by numeric data in the df.review
df.tmp <- df.review.info[, 
                         .(n.review.post = .N,
                           avg.review.view = mean(n.view),
                           mid.review.view = as.double(median(n.view)),
                           avg.reiview.pics = mean(r.nImgs),
                           avg.useful_view = mean(n.useful/n.view)), 
                         by = "id"]

# 評分轉換 - 先檢視大致的評分法
# convert comments scoring to factor
head(df.review.info[, .(r.delicious, r.service, r.atom)])
# iconv first
df.review.info[, `:=`(r.delicious = iconv(r.delicious, from = "UTF-8", to = "UTF-8"),
                      r.atom = iconv(r.atom, from = "UTF-8", to = "UTF-8"))]
head(df.review.info[, .(r.delicious, r.atom)])

unique(df.review.info$r.delicious)

m1 <- c("非常差", "很差", "差", "一般", "好", "很好", "非常好")

df.review.info$r.delicious <- factor(df.review.info$r.delicious, 
                                     levels = m1, ordered = T)
head(df.review.info$r.delicious)
