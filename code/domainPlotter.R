library(ggplot2)
library(data.table)
source('code/functions.R')

dt.grd <- data.table(read.table('data/gremlinContacts_962-1345.txt',header = TRUE))

# fix amino acid numbering
dt.grd[,i := i+961]
dt.grd[,j := j+961]

dt.grd.sym <- symmetrize(dt.grd)
  
ggplot(dt.grd.sym) + geom_point(aes(x = i,y = j,colour = -prob)) 

# too much overplotting, let's index the data
last.value = 300
ggplot(dt.grd.sym[1:last.value]) + geom_point(aes(x = i,y = j,colour = -prob)) 


# try plotting with rbokeh instead
library(rbokeh)
dt.plot <- dt.grd.sym[1:last.value]
n <- nrow(dt.plot)
ramp <- colorRampPalette(c("red", "blue"))(n)


# normally we would write :
# ly_points(figure(),i,j,data=dt.plot,color=ramp,size=13*prob,hover=list(i,j)) 
# let's use the pipe %>% from the magrittr package to write this differently:

p <- figure() %>%
  ly_points(i, j, data = dt.plot,
            color = ramp, size = 13*prob,
            hover = list(i, j))
p