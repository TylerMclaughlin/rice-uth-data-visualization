# functions!

library(data.table)

#' Title
#'
#' @param your.dt a data.table generated from the txt file exported by Gremlin.
#'
#' @return
#' @export
#'
#' @examples
symmetrize <- function(your.dt)
{
   inverted.dt <- copy(your.dt)
   inverted.dt[,c("j","i") := .(i,j)]
   inverted.dt[,c("j_id","i_id") := .(i_id,j_id)]
   combined.dt <- rbind(your.dt,inverted.dt)
   combined.dt <- combined.dt[order(-prob)]
}