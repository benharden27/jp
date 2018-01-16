# Code reads in pre-selected cruises and exports to R data object.
# There is a step missing between processCTD and processCTD_edits 
# where a manual filtering of the data has occured


library(oce)
library(sea)
library(ocedata)
library(wordcloud)
data(coastlineWorldFine)


rootfold <- "~/data/SEA/jpdata_edit"
cruiseIDs <- c("C187B","C193A","C199A","C205G","C211A","C218A","C223A","C230A","C235A","C241A","C248B")
plotfold <- "~/Documents/SEA/jp/plots/SEAarchive_edit"


ran <- c(39.5,41,-71.3,-70.6)

iplotfold <- file.path(plotfold,cruiseIDs)
for (i in which(file.exists(iplotfold)==F)) {
  dir.create(iplotfold[i])
}




for (ID in cruiseIDs) {
  
  fold <- file.path(rootfold,ID,"cnv")
  foldcsv <- file.path(rootfold,ID,"csv")
  plotfold2 <- file.path(rootfold,ID)
  files <- list.files(path=fold, pattern="*.cnv")
  
  CTDs <- NULL
  x <- NULL
  y <- NULL
  filenames <- NULL
  dep <- NULL
  
  for (i in 1:length(files)) {
    
    # which file
    cat(files[i],"\n")
    
    X<-readLatLon(filein=file.path(fold,files[i]))
    r <- X$r
    lon <- X$lon
    lon[lon>0] = -lon
    lat <- X$lat
    
    depline <- r[grep("Depth",r)]
    dep[i] <- as.double(tail(strsplit(depline,'h')[[1]],1))
    
    if(!is.na(X)[1] & lat>ran[1] & lat<ran[2] & lon>ran[3] & lon<ran[4]) {
      

      # Read in CTD and smooth
      CTDs <- append(CTDs,read.ctd(paste(fold,files[i],sep="/")))
      lst <- length(CTDs)
      CTDs[[lst]] <- ctdDecimate(ctdTrim(CTDs[[lst]],parameters=list(pmin=2)),p=1)
      
      
  
      x[lst] <- lon
      y[lst] <- lat
      
      # Find water depth from cnv
      line <- grep("Water Depth",r)[1]
      depth <- as.numeric(strsplit(r[12],'h')[[1]][2])
      
      # Assign the longitude and latitude to the appropriate fields in d
      CTDs[[lst]]@metadata$longitude <- lon
      CTDs[[lst]]@metadata$latitude <- lat
      stn <- strsplit(files[lst],'[-._]')[[1]][2]
      stn <- strsplit(stn,"[A-Za-z]")[[1]][1]
      CTDs[[lst]]@metadata$station <- as.numeric(stn)
      CTDs[[lst]]@metadata$waterDepth <- depth
      CTDs[[lst]]@metadata$filename <- files[i]
      filenames[lst] <- files[i]
      
      # plot profiles
      pngout <- gsub(".cnv",".png",files[i])
      outname <- file.path(iplotfold[cruiseIDs==ID],pngout)
      png(filename=outname,height=7,width=7,units='in',res=300,type='cairo') # set up the png file to print to
      plot(CTDs[[lst]])
      dev.off()

      outname <- gsub(".cnv", ".csv", files[i])
      cat(lst)
      writedata <- CTDs[[lst]]@data
      for (n in 1:length(writedata)) {
        writedata[[n]][is.na(writedata[[n]])] <- -9999
      }
      write.csv(writedata,file=file.path(foldcsv,outname),row.names = F)
      
      
      
    }
  }
  
 outname <- file.path(plotfold,paste0('CTD_locs_',ID,'.png'))
 png(filename=outname,height=7,width=7,units='in',res=300,type='cairo') # set up the png file to print to
  # # plot(topo,xlim=ran[3:4],ylim=ran[1:2],main=ID,ylab="lat",xlab="lon",water.z=c(-3000,-2000,-1000,-500,seq(-200,0,50)),col.water='lightgrey',location='none')
 plot(x,y,xlim=c(ran[3],ran[4]+.5),ylim=ran[1:2],main=ID,ylab="lat",xlab="lon",col='red',pch=19)
 textplot(x,y,filenames,pos=4,offset=0,new=F,cex=1.2)
 dev.off()

  dep[is.na(dep)] <- -99999;
  outname = paste0(ID,"dep.csv")
  write.csv(dep,file=file.path(rootfold,ID,outname),row.names = F)
  
  lon <- lat <- NULL
  for (i in 1:length(CTDs)) {
    lon <- append(lon,CTDs[[i]]@metadata$longitude)
    lat <- append(lat,CTDs[[i]]@metadata$latitude)
  }
  
  data <- NULL
  data$lon <- lon
  data$lat <- lat
  data$x <- geodDist(lon,lat,alongPath = T)
  outname = paste0(ID,"lonlat.csv")
  write.csv(data,file=file.path(rootfold,ID,outname),row.names = F)
  
  save(CTDs,file=file.path(rootfold,ID,paste0(ID,".Rdata")))
  
  
}


