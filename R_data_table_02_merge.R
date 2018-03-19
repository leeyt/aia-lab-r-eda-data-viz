'
R 語言探索性資料分析與資料視覺化
資料操作: data.table
'

# 載入 data.table package 
library(data.table)

### 合併資料集 ====

Employees <- data.table(
  id=1:3,
  name=c("Alice", "Bob", "Carla"), 
  department.id=c(11, 12, 14),
  salary=c(800, 900, 1000))
Departments <- data.table(
  department.id=c(11, 12, 99), 
  department.name=c("Production", "Sales", "Research"))

Employees
Departments

# inner join
merge(Employees, Departments, by = "department.id")

# left outer join
merge(Employees, Departments, by = "department.id", all.x = T)

# right outer join
merge(Employees, Departments, by = "department.id", all.y = T)

# outer join
merge(Employees, Departments, by = "department.id", all = T)

'
練習題
'

# 1. 請用 data.table 讀取店舖資料、細節檔、評論

shop.infos <- fread('data/shop_infos.csv')
head(shop.infos)
names(shop.infos)

shop.details <- fread('data/shop_details.csv')
head(shop.details)
names(shop.details)

shop.reviews <- fread('data/shop_reviews.csv')
head(shop.reviews)
names(shop.reviews)

# 2. 請練習將店舖基本資料和詳細資料合併

shop.infos.all <- merge(shop.infos, shop.details, by="id")
