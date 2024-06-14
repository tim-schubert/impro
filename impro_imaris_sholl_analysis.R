## Important: This only works if there are two files per animal, otherwise the code needs to be adjusted
# one would need to change files_per_animal and add new code to read the additional files
# into single_sholl_data variables
# this would then also need to be added to the rbind command which combines
# the single_sholl_data into one big dataframe for the animal


library(writexl)
library(readxl)
library(dplyr)
library(stringr)
library(tidyr)

wd <- "/Users/timschubert/Documents/R Projects/Promotion/Filaments Magel2 Rat"
setwd(wd)
all_files<-list.files(path=wd,pattern=".xlsx")
animal_name_length<-c(4)


## Creating the DataFrame all_data ----
# the following creates a dataframe called all_data with columns Radius and all the animal names

all_animal_names<-unique(c(str_sub(all_files,1,animal_name_length)))
radius_range <- 0:100
all_data <- data.frame(matrix(nrow=(101),ncol=(length(all_animal_names)+1)))
colnames(all_data) <-  c("Radius",all_animal_names)
all_data$Radius<-radius_range
c = 1 # später benötigt um eine Variable zu haben, die sich im großen For Loop jeweils um 1 und nicht um 2 erhöht

## for loop loops per animal (thats why there is the seq)
for(a in seq(1,length(all_animal_names))){
  animal_name <- all_animal_names[a]
  animal_files<-all_files[grep(x=all_files,pattern=paste(animal_name,"_",sep=""))]
  animal_sholl_data<-data.frame(matrix())
  animal_sholl_data<-read_excel(path=paste(wd,"/",animal_files[1],sep=""),sheet="Filament No. Sholl Intersec-10", skip=1)
  for(b in seq(2,length(animal_files))){
    
    animal_sholl_data<-rbind(animal_sholl_data, read_excel(path=paste(wd,"/",animal_files[b],sep=""),sheet="Filament No. Sholl Intersec-10", skip=1) )
    
  }

  # the maximum radius in the current file is calculated to know how often the small loop has to run
  # this is also important to not get errors when calculating means where no data exists
  curr_radius <- 0:max(select(animal_sholl_data,Radius))
  
  for(i in curr_radius){
    # for each Radius in the range of radii for the current animal,
    # the data is filtered (rows with this radius i) and then the column
    # with the number of Sholl Intersections is selected
    # the mean is calculated and then put in a variable
    mean_no_sholl_intersections<-(mean(filter(animal_sholl_data,Radius == i) %>% select("Filament No. Sholl Intersections") %>% unlist))
    # next, the mean is stored in the dataframe all_data
    # to get the appropriate row, we use i+1 (because i and radius in general starts
    # at 0, but rows start at 1)
    # to get the correct column we use c+1 because we want to skip the first column with the radius
    all_data[i+1,c+1] <- mean_no_sholl_intersections # schreibt die Daten in die 2. Spalte und in Reihe i+1 (dadurch passt es dazu, dass der Radius bei 0 anfängt, der dataframe aber ab 1 gezählt wird)
  }
  c=c+1
  print(paste("successfully read animal: ",animal_name[a]," files:",length(animal_files)))
}

all_data[is.na(all_data)]<-0 # damit werden alle NAs (wo es keine Werte gibt) durch 0 ersetzt
write_xlsx(all_data,path=paste(wd,"/Sholl_Data_pooled.xlsx", sep=""))

## Overview Plot ----
# for a broad overview, all data is pooled and plotted:
vec<-c()
for(d in 0:100){
 vec<-c(vec,mean((all_data[d+1,] %>% select(-c("Radius")))%>%unlist))
}
plot(0:100,vec,type="l")