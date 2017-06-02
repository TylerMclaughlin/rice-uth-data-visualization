library(ggplot2)
library(data.table)
source('./code/dataVizUtil/R/functions.R')

dt <- data.table(read.table('data/gremlinContacts_962-1345.txt',header = TRUE))
head(dt)

#symmetrize matrix
dt <- symmetrize(dt)
head(dt)
setnames(dt,"i","a")
setnames(dt,"j","b")

# fix amino acid numbering
dt[, a := a+961]
dt[, b := b+961]

# scale these values for better plotting
dt[,r_sco := r_sco*200]
dt[,s_sco := s_sco*10]
dt[,prob := prob*20]


ggplot(dt) + geom_point(aes(x = a,y = b,colour = -prob)) 

# too much overplotting, let's index the data
# also, colors look bad...
last.value = 300
ggplot(dt[1:last.value]) + geom_point(aes(x = a,y = -b,colour = -prob))  + scale_color_gradient(low='red',high='blue')


# try plotting with rbokeh instead
library(rbokeh)

dt.plot <- dt[1:last.value]
n <- nrow(dt.plot)
are.equal(n,last.value)
ramp <- colorRampPalette(c("red", "blue"))(n)

p <- figure() %>%
  ly_points(a,b,data=dt.plot,hover=list(a,b),size=r_sco,color=ramp) %>% 
p

p <- p  %>%
  x_range(c(957,1350)) %>%
  y_range(c(1350,957)) %>%  
  x_axis(label="amino acid i") %>% 
  y_axis(label="amino acid j")