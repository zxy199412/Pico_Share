# 加载第三方包
library(readxl)
library(GGally)

# 读取数据
ccpp <- read_excel(path = file.choose())
summary(ccpp)

# 绘制各变量之间的散点图与相关系数
ggpairs(ccpp)


# 建模
fit <- lm(PE ~ AT + V + AP, data = ccpp)
summary(fit)

# 计算模型的RMSE值
RMSE = sqrt(mean(fit$residuals**2))
RMSE


# 多重共线性检验
vif(fit)

# 异常点检验
# 高杠杆值点（帽子矩阵）
leverage <- hatvalues(fit)
head(leverage)

# dffits值
Dffits <- dffits(fit)
head(Dffits)

# 学生化残差
resid_stu <- Dffits/sqrt(leverage/(1-leverage))
head(resid_stu)

# cook距离
cook <- cooks.distance(fit)
head(cook)

# covratio值
Covratio <- covratio(fit)
head(Covratio)

# 将上面的几种异常值检验统计量与原始数据集合并
ccpp_outliers <- cbind(ccpp, data.frame(leverage, Dffits, resid_stu, cook, Covratio))
head(ccpp_outliers)


# 计算异常值数量的比例
outliers_ratio = sum(abs(ccpp_outliers$resid_stu)>2)/nrow(ccpp_outliers)
outliers_ratio

# 删除异常值
ccpp_outliers = ccpp_outliers[abs(ccpp_outliers$resid_stu)<=2,]

# 重新建模
fit2 = lm(PE~AT+V+AP,data = ccpp_outliers)
summary(fit2)

# 计算模型的RMSE值
RMSE2 = sqrt(mean(fit2$residuals**2))
RMSE2


# 正态性检验
#绘制直方图
hist(x = fit2$residuals, freq = FALSE,
     breaks = 100, main = 'x的直方图',
     ylab = '核密度值',xlab = NULL, col = 'steelblue')

#添加核密度图
lines(density(fit2$residuals), col = 'red', lty = 1, lwd = 2)

#添加正态分布图
x <- fit2$residuals[order(fit2$residuals)]
lines(x, dnorm(x, mean(x), sd(x)),
      col = 'blue', lty = 2, lwd = 2.5)

#添加图例
legend('topright',legend = c('核密度曲线','正态分布曲线'),
       col = c('red','blue'), lty = c(1,2),
       lwd = c(2,2.5), bty = 'n')


# PP图
real_dist <- ppoints(fit2$residuals)
theory_dist <- pnorm(fit2$residuals, mean = mean(fit2$residuals), 
                     sd = sd(fit2$residuals))
# 绘图
plot(sort(theory_dist), real_dist, col = 'steelblue', 
     pch = 20, main = 'PP图', xlab = '理论正态分布累计概率', 
     ylab = '实际累计概率')

# 添加对角线作为参考线
abline(a = 0,b = 1, col = 'red', lwd = 2)


# QQ图
qqnorm(fit2$residuals, col = 'steelblue', pch = 20,
       main = 'QQ图', xlab = '理论分位数', 
       ylab = '实际分位数')

# 绘制参考线
qqline(fit2$residuals, col = 'red', lwd = 2)


# shapiro正态性检验
# shapiro <- shapiro.test(fit2$residuals)
# shapiro

# K-S正态性检验
ks <- ks.test(fit2$residuals, 'pnorm', 
              mean = mean(fit2$residuals), 
              sd = sd(fit2$residuals))
ks



# 加载第三方包
library(ggplot2)
library(gridExtra)
library(lmtest)
library(nlme)

# 异方差性检验
# ====== 图示法完成方差齐性的判断 ======
# 标准化误差
std_err <- scale(fit2$residuals)
# 绘图
ggplot(data = NULL, mapping = aes(x = fit2$fitted.values, y = std_err)) + 
  geom_point(color = 'steelblue') + 
  geom_hline(yintercept = 0, color = 'red', size = 1.5) + # 水平参考线
  labs(x = '预测值', y = '标准化残差')


# ====== 统计法完成方差齐性的判断 ======
# Breusch-Pagan
bptest(fit2)


# 自变量与残差的关系
p1 <- ggplot(data = NULL, mapping = aes(x = ccpp_outliers$AT, y = std_err)) + 
  geom_point(color = 'steelblue') +
  geom_hline(yintercept = 0, color = 'red', size = 1.5) + # 水平参考线
  labs(x = 'AT', y = '标准化残差')
  
p2 <- ggplot(data = NULL, mapping = aes(x = ccpp_outliers$V, y = std_err)) + 
  geom_point(color = 'steelblue') +
  geom_hline(yintercept = 0, color = 'red', size = 1.5) + # 水平参考线
  labs(x = 'V', y = '标准化残差')

p3 <- ggplot(data = NULL, mapping = aes(x = ccpp_outliers$AP, y = std_err)) + 
  geom_point(color = 'steelblue') +
  geom_hline(yintercept = 0, color = 'red', size = 1.5) + # 水平参考线
  labs(x = 'AP', y = '标准化残差')

p4 <- ggplot(data = NULL, mapping = aes(x = ccpp_outliers$AT**2, y = std_err)) + 
  geom_point(color = 'steelblue') +
  geom_hline(yintercept = 0, color = 'red', size = 1.5) + # 水平参考线
  labs(x = 'AT^2', y = '标准化残差')

p5 <- ggplot(data = NULL, mapping = aes(x = ccpp_outliers$V**2, y = std_err)) + 
  geom_point(color = 'steelblue') +
  geom_hline(yintercept = 0, color = 'red', size = 1.5) + # 水平参考线
  labs(x = 'V^2', y = '标准化残差')

p6 <- ggplot(data = NULL, mapping = aes(x = ccpp_outliers$AP**2, y = std_err)) + 
  geom_point(color = 'steelblue') +
  geom_hline(yintercept = 0, color = 'red', size = 1.5) + # 水平参考线
  labs(x = 'AP^2', y = '标准化残差')

grid.arrange(p1,p2,p3,p4,p5,p6,ncol = 3)




# 三种权重
w1 = 1/abs(fit2$residuals)
w2 = 1/fit2$residuals**2

ccpp_outliers['loge2'] = log(fit2$residuals**2)
model = lm('loge2~AT+V+AP', data = ccpp_outliers)
w3 = 1/(exp(model$fitted.values))

# WLS的应用
fit3 = lm('PE~AT+V+AP', data = ccpp_outliers, weights = w1)
summary(fit3)

# 异方差检验
het3 = bptest(fit3)
# 模型AIC值
extractAIC(fit3)


fit4 = lm('PE~AT+V+AP', data = ccpp_outliers, weights = w2)
summary(fit4)

het4 = bptest(fit4)
extractAIC(fit4)


fit5 = lm('PE~AT+V+AP', data = ccpp_outliers, weights = w3)
summary(fit5)

het5 = bptest(fit5)
extractAIC(fit5)

summary(fit2)
het2 = bptest(fit2)
extractAIC(fit2)


# 残差独立性检验
library(car)
durbinWatsonTest(fit4)

ggplot(data = NULL, mapping = aes(fit4$fitted.values, ccpp_outliers$PE)) + 
  geom_point() + 
  geom_smooth(method = 'lm') +
  labs(x = '预测值', y = '实际值')

