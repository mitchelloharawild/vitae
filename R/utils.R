add_class <- function(x, subclass){
  `class<-`(x, union(subclass, class(x)))
}
