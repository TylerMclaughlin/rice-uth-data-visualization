library(ggplot2)
library(data.table)
library(GGally)

df <- read.csv('./data/anscombe.csv')
anscombe <- data.table(df)

# or more compactly: 
#anscombe <- data.table(read.csv('./data/anscombe.csv'))

setnames(anscombe,X,'index')

ggplot(anscombe) + geom_point(aes(x=x,y=y)) + facet_wrap(~ set)

ggplot(anscombe) + geom_point(aes(x=x,y=y,color=factor(d))) +geom_smooth(aes(x=x,y=y),color="black",method="lm") + facet_wrap(~ set)

ggpairs(anscombe)

anscombe[,.(avg.x = mean(x)),by = set]
anscombe[,.(mean.y = mean(y), my.mean.x = mean(x)),.(set)]
anscombe[,.(sd.y = mean(y), sd.x = sd(x)),.(set)]
anscombe[,.(cor(y,x)),.(set)]
anscombe[,coef(lm(y~x))[2],.(set)]