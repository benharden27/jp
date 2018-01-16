# Code reads in JP data from main archive and exports to new folders

library(oce)
library(sea)
load("~/Documents/projects/SEA/data/etopo5")

rootfold <- "~/data/SEA/CTDdata"
mvfold <- "~/data/SEA/jpdata"
cruiseIDs <- c("C187bcdefg","C193","C199A","C205FGHI","C211A","C216A-EandC218AWHOI-MIT","C223AWHOI_MIT","C230a","C235AWHOI_MIT","C241A","C248B")
cruiseIDs2 <- c("C187B","C193A","C199A","C205G","C211A","C218A","C223A","C230A","C235A","C241A","C248B")
plotfold <- "~/Documents/SEA/jp/plots/SEAarchive"


ran <- c(39.5,41,-71.3,-70.6)

iplotfold <- file.path(plotfold,cruiseIDs2)
for (i in which(file.exists(iplotfold)==F)) {
  dir.create(iplotfold[i])
}

imvfold <- file.path(mvfold,cruiseIDs2)
for (i in which(file.exists(imvfold)==F)) {
  dir.create(imvfold[i])
  dir.create(file.path(imvfold[i],'cnv'))
}

for (ID in cruiseIDs) {
  
  fold <- file.path(rootfold,ID,"cnv")
  plotfold2 <- file.path(rootfold,ID)
  files <- list.files(path=fold, pattern="*.cnv")
  
  CTDs <- NULL
  x <- NULL
  y <- NULL
  filenames <- NULL
  
  for (i in 1:length(files)) {
    
    # which file
    cat(files[i],"\n")
    
    X<-readLatLon(filein=file.path(fold,files[i]))
    r <- X$r
    lon <- X$lon
    lat <- X$lat
    
    if(!is.na(X)[1] & X$lat>ran[1] & X$lat<ran[2] & X$lon>ran[3] & X$lon<ran[4]) {
      
      file.copy(file.path(fold,files[i]),file.path(imvfold[which(cruiseIDs==ID)],'cnv/'))
      
      # Read in CTD and smooth
      CTDs <- append(CTDs,read.ctd(paste(fold,files[i],sep="/")))
      lst <- length(CTDs)
      CTDs[[lst]] <- ctdDecimate(ctdTrim(CTDs[[lst]],parameters=list(pmin=5)))
      
      
  
      x[lst] <- lon
      y[lst] <- lat
      
      # Find water depth from cnv
      line <- grep("Water Depth",r)[1]
      depth <- as.numeric(strsplit(r[12],'h')[[1]][2])
      
      # Assign the longitude and latitude to the appropriate fields in d
      CTDs[[lst]]@metadata$longitude <- lon
      CTDs[[lst]]@metadata$latitude <- lat
      CTDs[[lst]]@metadata$station <- as.numeric(strsplit(files[lst],'-')[[1]][2]) # have to do this to make makeSection work
      CTDs[[lst]]@metadata$waterDepth <- depth
      CTDs[[lst]]@metadata$filename <- files[i]
      filenames[lst] <- files[i]
      
#       # plot profiles
#       pngout <- gsub(".cnv",".png",files[i])
#       outname <- file.path(iplotfold[cruiseIDs==ID],pngout)
#       png(filename=outname,height=7,width=7,units='in',res=300,type='cairo') # set up the png file to print to
#       plot(CTDs[[lst]])
#       dev.off()
    }
  }
  
  outname <- file.path(plotfold,paste0('CTD_locs_',cruiseIDs2[cruiseIDs==ID],'.png'))
  png(filename=outname,height=7,width=7,units='in',res=300,type='cairo') # set up the png file to print to
  # plot(topo,xlim=ran[3:4],ylim=ran[1:2],main=ID,ylab="lat",xlab="lon",water.z=c(-3000,-2000,-1000,-500,seq(-200,0,50)),col.water='lightgrey',location='none')
  plot(x,y,xlim=c(ran[3],ran[4]+.5),ylim=ran[1:2],main=cruiseIDs2[cruiseIDs==ID],ylab="lat",xlab="lon",col='red',pch=19)
  textplot(x,y,filenames,pos=4,offset=0,new=F,cex=1.2)
  dev.off()

}
