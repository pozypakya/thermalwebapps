library(fields) # should be loaded imported when installing Thermimage
library(Thermimage)
library(ggplot2)
#library(magick)
#library(adimpro)
library(jpeg)
#http://www.sno.phy.queensu.ca/~phil/exiftool/install.html
#https://cran.rstudio.com/web/packages/Thermimage/README.html
setwd("D:/Google Drive/TM/TM/Hackathon ITNT")
imagefile <- paste("pc_thermal.jpg",sep = "")
img<-readflirJPG(imagefile, exiftoolpath="installed" )
dim(img)

imagefile <- paste0(getwd(),"/pc_thermal.jpg")
df_imginfo<- as.data.frame(flirsettings(imagefile, exiftool="installed", camvals=""))


h<-df_imginfo$Info.RawThermalImageHeight
w<-df_imginfo$Info.RawThermalImageWidth
IRWinTran<-df_imginfo$Info.IRWindowTransmission
RH<-df_imginfo$Info.RelativeHumidity
AtmosT <- df_imginfo$Info.AtmosphericTemperature
OD <- df_imginfo$Info.ObjectDistance
PlanckR1 <- df_imginfo$Info.PlanckR1
PlanckR2 <- df_imginfo$Info.PlanckR2
PlanckB <- df_imginfo$Info.PlanckB
ReflT <- df_imginfo$Info.ReflectedApparentTemperature
PlanckF <- df_imginfo$Info.PlanckF
PlanckO <- df_imginfo$Info.PlanckO
ObjectEmissivity <- df_imginfo$Info.Emissivity
IRWinT <- df_imginfo$Info.IRWindowTemperature

temperature<-raw2temp(img, ObjectEmissivity, OD, ReflT, AtmosT, IRWinT, IRWinTran, RH,
                      PlanckR1, PlanckB, PlanckF, PlanckO, PlanckR2)

#writeFlirBin(as.vector(temperature), Interval = 0.03, templookup=NULL, w=w, h=h, rootname="raw_pc_thermal" )
writeFlirBin(as.vector(t(temperature)), Interval = 0.03, templookup=NULL, w=w, h=h, rootname="raw_pc_thermal" )

matplot(temperature)

library(tidyverse)
dat2 <- temperature %>%
  tbl_df() %>%
  rownames_to_column('Var1') %>%
  gather(Var2, value, -Var1) %>%
  mutate(
    Var1 = factor(Var1, levels=1:76800),
    Var2 = factor(gsub("V", "", Var2), levels=1:76800)
  )
ggplot(dat2, aes(Var1, Var2)) +
  geom_tile(aes(fill = value)) + 
  scale_fill_gradient(low = "white", high = "red") 


library(plotly)
library(pracma)

#The sequential palettes names are 
#Blues BuGn BuPu GnBu Greens Greys Oranges OrRd PuBu PuBuGn PuRd Purples RdPu Reds YlGn YlGnBu YlOrBr YlOrRd
#BrBG PiYG PRGn PuOr RdBu RdGy RdYlBu RdYlGn Spectral

#d <- plot_ly(z = rot90(temperature,2), type = "heatmap",colors = "Blues")
d <- plot_ly(z = rot90(temperature,2), type = "heatmap",colors = "Spectral")

hotspot <- which( as.matrix(rot90(temperature,2)) ==  max(as.matrix(rot90(temperature,2))) , arr.ind=T )
hotspot <- as.data.frame(hotspot)

#ada bugs !!!!!

d <- layout(d, title = 'Thermal Images Outlier',
            shapes = list(
              list(type = 'circle', x0 = hotspot$col, x1 = hotspot$col+1 ,  y0 = hotspot$row,
                  y1 = hotspot$row+1,
                   fillcolor = 'rgb(255, 255, 75)', line = list(color = 'rgb(255, 255, 0)'),
                   opacity = 0.8)))
d

mean(as.matrix(temperature))
max(as.matrix(temperature))
min(as.matrix(temperature))

library("pracma")
which( as.matrix(rot90(temperature,2)) ==  max(as.matrix(temperature)) , arr.ind=T )

image.plot(matrix((data=img), ncol=240, nrow=320))

#the best
plotTherm(main = "Test", t(temperature), w=w, h=h, minrangeset = min(temperature), maxrangeset = max(temperature), trans="rotate180.matrix" , thermal.palette=flirpal)
plotTherm(t(temperature), w=w, h=h, minrangeset = min(temperature), maxrangeset = max(temperature), trans="rotate180.matrix" , thermal.palette=rainbowpal)
plot(temperature, type="l", xlab="Raw Binary 16 bit Integer Value", ylab="Estimated Temperature (C)")
plotTherm(t(temperature), w=w, h=h, minrangeset = min(temperature), maxrangeset = max(temperature), trans="rotate180.matrix" , thermal.palette=glowbowpal)
plotTherm(t(temperature), w=w, h=h, minrangeset = min(temperature), maxrangeset = max(temperature), trans="rotate180.matrix" , thermal.palette=midgreypal)
plotTherm(t(temperature), w=w, h=h, minrangeset = min(temperature), maxrangeset = max(temperature), trans="rotate180.matrix" , thermal.palette=greyredpal)
plotTherm(t(temperature), w=w, h=h, minrangeset = min(temperature), maxrangeset = max(temperature), trans="rotate180.matrix" , thermal.palette=midgreenpal)
plotTherm(t(temperature), w=w, h=h, minrangeset = min(temperature), maxrangeset = max(temperature), trans="rotate180.matrix" , thermal.palette=hotironpal)


library(gplots)
temperature[temperature > 31] <- NA
heatmap.2(temperature, trace = "none", na.color = "Green" , dendrogram="none")

#https://bioconductor.statistik.tu-dortmund.de/packages/3.1/bioc/vignettes/ComplexHeatmap/inst/doc/ComplexHeatmap.html#toc_0
library(ComplexHeatmap)
Heatmap(mat, col = colorRamp2(c(-3, 0, 3), c("green", "white", "red")))

m <- matrix(c(1, 5, 1, 2, 4, 500, 4, 3, 5, 2, 2, 4, 5, 3, 2), 
            ncol=5)

#bolehlah
heatmap((temperature>35.22685)+0, scale="none", Rowv=NA, Colv=NA , dendrogram="none")

library(DMwR)
outlier.scores <- lofactor(img, k=5)
plot(density(outlier.scores))
outliers <- order(outlier.scores, decreasing=T)[1:5]
print(outliers)

n <- nrow(img)
labels <- 1:n
labels[-outliers] <- "."
biplot(prcomp(img), cex=.3, xlabs=labels)


pch <- rep(".", n)
pch[outliers] <- "+"
col <- rep("black", n)
col[outliers] <- "red"
pairs(img, pch=pch, col=col)

library(Rlof)
outlier.scores <- lof(temperature, k=5)
plot(outlier.scores)
outlier.scores <- lof(temperature, k=c(5:10))
plot(outlier.scores)

library(outliers)
set.seed(1234)
y=rnorm(100)
outlier(y)
#> [1] 2.548991

#boleh pakai buat presentation
plot(outlier(temperature))

# matrix to DF
df_matrix <- data.frame(x=numeric(),y=numeric(),val=double())
for(i in 1:nrow(temperature)) {
  for(j in 2:ncol(temperature)) {
    
    df_matrix =  rbind(df_matrix,data.frame(x = i ,  y = j , val = temperature[i,j]))
    #print(paste("x->",i," y->",j," value=",temperature[i,j]))
  }
}
row.names(df_matrix) <- NULL
print("abis")
plot(df_matrix)



library(mvoutlier)
mvOutlier(img, qqplot = TRUE, alpha = 0.5, tol = 1e-25, method = c("quan", "adj.quan"),  label = TRUE, position = NULL, offset = 0.5)




source("VoronoiPlotly.R")
library(deldir)
set.seed(12345)
nClust <- 12 # Number of clusters
nPoints <- 2000  # Number of data points
ds <- data.frame(x = rnorm(nPoints), y = rnorm(nPoints))
fit <- kmeans(ds, centers = nClust)
ds <- cbind(ds, cluster = as.factor(fit$cluster))
VoronoiPlotly(fit, ds, n.sd.x = 3, n.sd.y = 3, print.ggplot = F)


# 
# library(tiff)
# 
# readTIFF("raw_FLIRjpg_W640_H480_F1_I.raw")
# read.raw("raw_FLIRjpg_W640_H480_F1_I.raw")
# readJPEG("raw_FLIRjpg_W640_H480_F1_I.raw",native = T)
# readJPEG(source, native = FALSE)
# 
# readBin("raw_FLIRjpg_W640_H480_F1_I.raw",numeric(), size = 4, endian = "swap")
# 
# 
# source("http://bioconductor.org/biocLite.R")
# biocLite()
# biocLite("EBImage")
# 
# library("EBImage")
# Image <- readImage("raw_FLIRjpg.jpg")
# display(Image)
# 
# library("raster")
# onMac <- raster('raw_FLIRjpg_W640_H480_F1_I.raw')
# 
# 
# library(RImageJ)
# tiger <- image_read('raw_FLIRjpg_W640_H480_F1_I.raw')
# 
# Sys.setenv(JAVA_HOME='C:/java32/Java') # for 32-bit version
# Sys.setenv(JAVA_HOME='C:/Program Files/Java/jre1.8.0_121') # for 32-bit version
# library(rJava)
# install.packages("RImageJ_0.3-144.tar.gz", repos = "http://cran.us.r-project.org" , type = "binary" , configure.args = "--no-multiarch")
# #install.packages("rJava",configure.args = "--no-multiarch")
# 
# #https://cran.r-project.org/src/contrib/Archive/RImageJ/
# system("java -version")  
# require(devtools)
# install_version("RImageJ", version = "0.3-144", repos = "http://cran.us.r-project.org")
# Sys.getenv("JAVA_HOME")
# 
# install_github("jefferis/rimagej", subdir="pkg")


