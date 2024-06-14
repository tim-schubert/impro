## IMPRO Imaris Sholl Analysis

# Input your working directory below.
# The script assumes that the samples are identified by the first numbers in the file name. 
# Specify the name length below for accurate results (e.g. if your samples are named "001, 002, ...", animal_name_length would be 3).
# This script works independently of the number of files per animal.

wd <- "/your_working_dir"
animal_name_length<-c(3)

library(writexl)
library(readxl)
library(dplyr)
library(stringr)
library(tidyr)

setwd(wd)
all_files<-list.files(path=wd,pattern=".xlsx")


## Creating the DataFrame all_data ----
# the following creates a dataframe called all_data with columns Radius and all the animal names

all_animal_names<-unique(c(str_sub(all_files,1,animal_name_length)))
radius_range <- 0:100
all_data <- data.frame(matrix(nrow=(101),ncol=(length(all_animal_names)+1)))
colnames(all_data) <-  c("Radius",all_animal_names)
all_data$Radius<-radius_range
c = 1 

# A summary excel sheet is being prepared. The rows represent the increasing circle radius.
# Each column corresponds to one animal. 
# In this column, the mean number of intersections at a specific circle radius is calculated.

for(a in seq(1,length(all_animal_names))){
  animal_name <- all_animal_names[a]
  animal_files<-all_files[grep(x=all_files,pattern=paste(animal_name,"_",sep=""))]
  animal_sholl_data<-data.frame(matrix())
  animal_sholl_data<-read_excel(path=paste(wd,"/",animal_files[1],sep=""),sheet="Filament No. Sholl Intersec-10", skip=1)
  for(b in seq(2,length(animal_files))){
    
    animal_sholl_data<-rbind(animal_sholl_data, read_excel(path=paste(wd,"/",animal_files[b],sep=""),sheet="Filament No. Sholl Intersec-10", skip=1) )
    
  }
  
  
  curr_radius <- 0:max(select(animal_sholl_data,Radius))
  
  for(i in curr_radius){
    # for each Radius in the radius range for the current animal,
    # the data is filtered (rows with this radius i), the column
    # with the corresponding number of sholl intersections is selected, and
    # the mean calculated for this animal.
    mean_no_sholl_intersections<-(mean(filter(animal_sholl_data,Radius == i) %>% select("Filament No. Sholl Intersections") %>% unlist))
    # next, the mean is stored in the dataframe all_data
    all_data[i+1,c+1] <- mean_no_sholl_intersections
  }
  c=c+1
  # feedback is being provided per animal:
  print(paste("read animal: ",animal_name[a]," files:",length(animal_files)))
}

all_data[is.na(all_data)]<-0 # all NAs are being replaced by 0

# Output: excel sheet containing the summarized information for all animals
write_xlsx(all_data,path=paste(wd,"/Sholl_Data_pooled.xlsx", sep=""))

## Overview Plot ----
# To check whether the pipeline generally worked, all data is pooled and plotted:
vec<-c()
for(d in 0:100){
  vec<-c(vec,mean((all_data[d+1,] %>% select(-c("Radius")))%>%unlist))
}
plot(0:100,vec,type="l")

# Subsequently, the excel sheets can be used to easily perform sholl analysis in your preferred statistics programm or, of course, in R.