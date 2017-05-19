# functions!

library(data.table)

#' This function takes a list of pairwise contacts where i < j and doubles the
#' list by adding pairs such that i > j.   It is akin to symmetrizing a matrix
#' by reflecting across the diagonal.
#' 
#' @param your.dt a data.table generated from the txt file exported by Gremlin. 
#'   Must have columns 'i', 'j', 'i_id', 'j_id', and 'prob'.
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