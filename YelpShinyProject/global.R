
#Loading dependent packages  ----
rqrd_Pkg = c('shiny','tidyverse', 'leaflet')
for(p in rqrd_Pkg){
  if(!require(p,character.only = TRUE)) 
    install.packages(p);
  library(p,character.only = TRUE)
}


