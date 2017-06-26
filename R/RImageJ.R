library(raster)

setwd("D:/Google Drive/TM/TM/Hackathon ITNT/ImageJ")
sink(paste(getwd(),"/macros/RawToJpg.ijm",sep = ""))
cat("run(\"Raw...\", \"open=[D:\\\\Google Drive\\\\TM\\\\TM\\\\Hackathon ITNT\\\\raw_pc_thermal_W240_H320_F1_I0.03.raw] image=[32-bit Real] width=240 height=320 little-endian\"); \n",file=paste(getwd(),"/macros/RawToJpg.ijm",sep = ""),append=TRUE)
cat("saveAs(\"Jpeg\", \"D:\\\\Google Drive\\\\TM\\\\TM\\\\Hackathon ITNT\\\\raw_grayscale.jpg\"); \n",file=paste(getwd(),"/macros/RawToJpg.ijm",sep = ""),append=TRUE)
cat("close(); \n",file=paste(getwd(),"/macros/RawToJpg.ijm",sep = ""),append=TRUE)
cat("run(\"Quit\"); \n",file=paste(getwd(),"/macros/RawToJpg.ijm",sep = ""),append=TRUE)
sink()

writeLines(readLines(paste(getwd(),"/macros/RawToJpg.ijm",sep = "")))

command = paste("ImageJ-win64.exe --headless  -macro RawToJpg.ijm",sep = "")
print(command)
system(command, intern = TRUE, wait = TRUE)

image <- readJPEG("D:/Google Drive/TM/TM/Hackathon ITNT/raw_grayscale.jpg", native = TRUE)
plot(0:1,0:1,type="n",ann=FALSE,axes=FALSE)
rasterImage(image,0,0,1,1)
