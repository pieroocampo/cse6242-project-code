library(ggplot2)
library(Hmisc)
library(caret)
library(glmnet)

df <-read.csv('project_data.csv')

df <- subset(df, PRICE >= 100000 & PRICE <= 2000000)
keeps <- c('AC','AYB','BATHRM','BEDRM','CENSUS_TRACT','CNDTN','EYB','EXTWALL','FIREPLACES','HEAT','INTWALL','LANDAREA','MILES_TO_CLOSEST_CAFETERIA','MILES_TO_CLOSEST_GROCERY_STORE','MILES_TO_CLOSEST_METRO',
           'QUADRANT','QUALIFIED','ROOMS','STRUCT','PRICE')



df <- df[keeps]
df<- na.omit(df)

x <- model.matrix(PRICE~., df)[,-1]
y <- df$PRICE
lambda <- 10^seq(10, -2, length = 100)

set.seed(489)
train = sample(1:nrow(x), nrow(x)/2)
test = (-train)
ytest = y[test]
#Fit your models.

#OLS
lm <- lm(PRICE~., data = df)
coef(lm)

ridge.mod <- glmnet(x, y, alpha = 0, lambda = lambda)
predict(ridge.mod, s = 0, exact = TRUE,x=x, y=y, type = 'coefficients')

lm <- lm(PRICE~., data = df, subset = train)
ridge.mod <- glmnet(x[train,], y[train], alpha = 0, lambda = lambda)
#find the best lambda from our list via cross-validation
cv.out <- cv.glmnet(x[train,], y[train], alpha = 0)
## Warning: Option grouped=FALSE enforced in cv.glmnet, since < 3 observations
## per fold
bestlam <- cv.out$lambda.min
#make predictions
ridge.pred <- predict(ridge.mod, s = bestlam, newx = x[test,])
s.pred <- predict(lm, newdata = df[test,])
#check MSE
mean((s.pred-ytest)^2)
## [1] 106.0087
mean((ridge.pred-ytest)^2)

#a look at the coefficients
out = glmnet(x[train,],y[train],alpha = 0)
predict(ridge.mod, type = "coefficients", s = bestlam)#[1:6,]

lasso.mod <- glmnet(x[train,], y[train], alpha = 1, lambda = lambda)
lasso.pred <- predict(lasso.mod, s = bestlam, newx = x[test,])
mean((lasso.pred-ytest)^2)

lasso.coef  <- predict(lasso.mod, type = 'coefficients', s = bestlam)#[1:6,]