library(ggplot2)
library(data.table)


dt.grd <- data.table(read.table('../code/gremlinContacts_962-1345.txt',header = TRUE))

dt.grd[,i:=i+961]
dt.grd[,j:=j+961]


dt.grd <- symmetrize(dt.grd)
  
ggplot(dt.grd.sym[1:300]) + geom_point(aes(x=i,y=j,colour=-prob)) 

library(rbokeh)
last.value = 300
dt.plot <- dt.grd[1:last.value]
n <- nrow(dt.plot)
ramp <- colorRampPalette(c("red", "blue"))(n)
p <- figure() %>%
  ly_points(i, j, data = dt.plot,
            color = ramp, size = 13*prob,
            hover = list(i, j))
p