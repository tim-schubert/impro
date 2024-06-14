## This script produces the mean area and mean volume of all cells of a specific animal.
# Specify your working directory and the length of the animal names below:

wd <- "your_working_dir"
animal_name_length <- c(4)


library(writexl)
library(readxl)
library(dplyr)
library(stringr)
library(tidyr)

setwd(wd)
all_files<-list.files(path=wd,pattern=".xlsx")
all_animal_names<-unique(c(str_sub(all_files,1,animal_name_length)))
all_data <- data.frame(matrix(nrow=(2),ncol=length(all_animal_names)))
colnames(all_data) <-  c(all_animal_names)
rownames(all_data)<- c("Mean Area","Mean Volume")

for (b in seq(1,length(all_animal_names))) {

    animal_name <- all_animal_names[b]
  animal_files<-all_files[grep(x=all_files,pattern=paste(animal_name,"_",sep=""))]

  single_file_area_vector_animalX<-c()
  single_file_mean_area_animalX<-c()
  all_area_data_animalX<-c()
  mean_area_animalX<-c()
  single_file_volume_vector_animalX<-c()
  single_file_mean_volume_animalX<-c()
  all_volume_data_animalX<-c()
  mean_volume_animalX<-c()
  
  for(a in seq(1,length(animal_files))){
    single_file_area_animalX<-read_excel(path=paste(wd,"/",animal_files[a],sep=""),sheet="Area",skip = 1) %>% select(Area) %>% unlist
    single_file_mean_area_animalX<-mean(single_file_area_animalX)
    all_area_data_animalX<-c(all_area_data_animalX,single_file_mean_area_animalX)
    mean_area_animalX<-mean(all_area_data_animalX)
    single_file_volume_animalX<-read_excel(path=paste(wd,"/",animal_files[a],sep=""),sheet="Volume",skip = 1) %>% select(Volume) %>% unlist
    single_file_mean_volume_animalX<-mean(single_file_volume_animalX)
    all_volume_data_animalX<-c(all_volume_data_animalX,single_file_mean_volume_animalX)
    mean_volume_animalX<-mean(all_volume_data_animalX)
    print(paste("read file:",animal_files[a]))
  }
  print(paste("read all files for animal:",animal_name))
  print(paste("number of files read:",length(animal_files)))
  all_data[1,b]<-mean_area_animalX
  all_data[2,b]<-mean_volume_animalX
}


all_data <- tibble::rownames_to_column(all_data, "Measure")

write_xlsx(all_data,path=paste(wd,"/Area_Volume_data_",Sys.Date(),".xlsx",sep=""))
