# functions!

library(data.table)

#' symmetrize
#' 
#' @param your.dt a data.table generated from the txt file exported by Gremlin.  
#' Must have columns 'i', 'j', 'i_id', 'j_id', and 'prob' 
#'   
#' @return a data.table that is now includes a symmetric list of contacts
#' 
#' @export
#' 
#' @examples 
#' a <- symmetrize(dt)
symmetrize <- function(your.dt)
{
   inverted.dt <- copy(your.dt)
   inverted.dt[,c("j","i") := .(i,j)]
   inverted.dt[,c("j_id","i_id") := .(i_id,j_id)]
   combined.dt <- rbind(your.dt,inverted.dt)
   combined.dt <- combined.dt[order(-prob)]
}