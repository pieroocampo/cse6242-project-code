library(dplyr)
library(ggplot2)
library(Hmisc)
library(caret)
library(GGally)

##Q-Q plot
df <-read.csv('project_data.csv')
p<- df$PRICE
p <- p[!is.na(p)]
qqnorm(p)

##basic scatter plot
df1 <- df %>%select(ROOMS, PRICE) %>% na.omit()

ggplot(df1, aes(ROOMS, PRICE)) + geom_point() + geom_smooth(method = lm, se = FALSE)
ggplot(df1, aes(ROOMS, log(PRICE))) + geom_point() + geom_smooth(method = lm, se = FALSE)

#grab subset of data where no more than 50% of rows are null and numeric
df_sub = df[,!sapply(df, function(x) mean(is.na(x)))>0.5]
df_sub<- dplyr::select_if(df_sub, is.numeric)

#correlation matrix example 1
cormat<- cor(df_sub,use="pairwise.complete.obs")

#correlation matrix example 2
correlationMatrix <- as.data.frame(rcorr(as.matrix(df_sub),type = "pearson")$P)
highlyCorrelated <- findCorrelation(cor(df_sub, use="pairwise.complete.obs"), cutoff = .70, verbose = FALSE)
important_var=colnames(df_sub[,-highlyCorrelated])
print(important_var)

#visualization of correlation -- this is too crowded/busy
ggcorr(df_sub[,-highlyCorrelated])

#another visualization of correlation
ggpairs(df_sub, 
        columns = c("GBA", "BATHRM", "FIREPLACES","PRICE"), 
        upper = list(continuous = wrap("cor", 
                                       size = 10)), 
        lower = list(continuous = "smooth"))




