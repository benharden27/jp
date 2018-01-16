library(oce)
source("~/code/Rutil/readLatLon.R")
source("~/code/Rutil/plotFunctions.R")
library(ocedata)
data(coastlineWorldFine)

rootfold <- "~/data/SEA/jpdata_edit"
cruiseIDs <- c("C187B","C193A","C199A","C205G","C211A","C218A","C223A","C230A","C235A","C241A","C248B")
plotfold <- "~/Documents/SEA/jp/plots/sections"


for (ID in cruiseIDs) {
load(file=file.path(rootfold,ID,paste0(ID,".Rdata")))

  ord = 1:length(CTDs)
# Reorganize as neccessary
  if(ID == "C187B") {
    w <- c(1,7)
    c <- c(7,12)
    e <- c(12,length(CTDs))
  }
  if(ID == "C193A") {
    w <- c(1,9)
    c <- c(9,12)
    e <- c(12,length(CTDs))
  }
  if(ID == "C199A") {
    w <- c(1,7)
    c <- c(7,11)
    e <- c(12,length(CTDs))
  }
  if(ID == "C205G") {
    w <- c(1,7)
    c <- c(7,12)
    e <- c(12,length(CTDs))
    ord <- c(2,6:17,4,5,3,1)
  }
  if(ID == "C211A") {
    ord <- c(1:12,14,13,15:19)
    ord <- rev(ord)
    w <- c(1,8)
    c <- c(8,14)
    e <- c(14,length(CTDs))
  }
  if(ID == "C218A") {
    w <- c(1,8)
    c <- c(8,13)
    e <- c(14,length(CTDs))
  }
  if(ID == "C223A") {
    w <- c(1,7)
    c <- c(7,12)
    e <- c(12,length(CTDs))
  }
  if(ID == "C230A") {
    w <- NULL
    c <- NULL
    e <- c(1,length(CTDs))
  }
  if(ID == "C235A") {
    w <- c(1,5)
    c <- c(5,9)
    e <- c(9,length(CTDs))
    ord <- c(1:13,15,14)
  }
  if(ID == "C241A") {
    w <- c(1,9)
    c <- c(9,12)
    e <- c(12,length(CTDs))
  }
  if(ID == "C248B") {
    w <- c(1,8)
    c <- c(8,13)
    e <- c(13,length(CTDs))
  }


#   # Plot map and T and S
#   outname <- file.path(plotfold,paste0(ID,'_section.png'))
#   png(filename=outname,height=9,width=7,units='in',res=300,type='cairo') # set up the png file to print to
#   plotmapTS(CTDs[ord])
#   dev.off()
# 
  # Plot map, T, S and Density
  outname <- file.path(plotfold,paste0(ID,'_section.png'))
  png(filename=outname,height=7,width=9,units='in',res=300,type='cairo') # set up the png file to print to
  plotmap3sec(CTDs[ord])
  dev.off()
  
  # Plot Western branch
  if(!is.null(w)) {
    outname <- file.path(plotfold,paste0(ID,'_section_w.png'))
    png(filename=outname,height=7,width=9,units='in',res=300,type='cairo') # set up the png file to print to
    plotmap3sec(CTDs[ord[w[1]:w[2]]])
    dev.off()
  }
  
  # Plot Eastern branch
  if(!is.null(e)) {
    outname <- file.path(plotfold,paste0(ID,'_section_e.png'))
    png(filename=outname,height=7,width=9,units='in',res=300,type='cairo') # set up the png file to print to
    plotmap3sec(rev(CTDs[ord[e[1]:e[2]]]))
    dev.off()
  }
  
  # Plot central branch
  if(!is.null(c)) {
    outname <- file.path(plotfold,paste0(ID,'_section_c.png'))
    png(filename=outname,height=7,width=9,units='in',res=300,type='cairo') # set up the png file to print to
    plotmap3sec(CTDs[ord[c[1]:c[2]]])
    dev.off()
  }

}
