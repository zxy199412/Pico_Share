# 读取数据
sales <- read.csv('C:\\Users\\Administrator\\Desktop\\Advertising.csv')

# 数据的描述性统计
summary(sales)

# 抽样
set.seed(1234)
index <- sample(1:nrow(sales), size = 0.8*nrow(sales))

train <- sales[index,]
test <- sales[-index,]

# 建模
fit <- lm(sales ~ ., data = sales)
# 模型概览信息
summary(fit)

# 模型预测
vars <- c('TV','radio','newspaper')
pred <- predict(fit, newdata = test[, vars])

# 模型修正
fit2 <- lm(sales ~ TV + radio, data = sales)
# 模型概览信息
summary(fit2)

# 模型预测
vars <- c('TV','radio')
pred2 <- predict(fit2, newdata = test[, vars])

# 预测效果评估 RMSE
RMSE <- function(x,y){
  sqrt(mean((x-y)^2))
}

RMSE1 <- RMSE(test$sales, pred)
RMSE2 <- RMSE(test$sales, pred2)

RMSE1;RMSE2

# 绘图
plot(test$sales,pred2, type = 'p', pch = 20, col = 'steelblue',
     xlab = '真实值', ylab = '预测值', main = '真实值VS.预测值')
lines(x = c(min(test$sales),max(test$sales)), 
     y = c(min(pred2), max(pred2)), 
     lty=2, col = 'red', lwd = 2)
