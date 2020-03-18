crime<-read.csv('F:/Rprojects/RaleighCrime/Raleigh Crime Original Data.gz')
                  #import initial data into a data frame


#Isolating assaults for further analysis
#---------------------------------------------------------

ixassault <-which(crime$crime_category == 'ASSAULT')#returns index of all assaults
ixlocation <- which(crime$latitude!='NA')           #returns index of all crimes with location
assault_with_location<- intersect(ixassault, ixlocation) #returns only assaults that also have location data

assault<-crime[assault_with_location,]

#str(assault)#30,822 observations of 27 variables


#create basic scatterplot of the data points
plot(assault$longitude, assault$latitude)

#add colors to represent the districts given in the data set. these are insufficient for thurough 
#analysis and are subjective as they overlap as a result, next a new spatial grid is created
se = assault[which(assault$district=='Southeast'),]
d = assault[which(assault$district=='Downtown'),]
n = assault[which(assault$district=='North'),]
ne = assault[which(assault$district=='Northeast'),]
nw = assault[which(assault$district=='Northwest'),]
sw = assault[which(assault$district=='Southwest'),]

plot(assault$longitude, assault$latitude, main='Assault Latitude and Longitude', xlab='Longitude', ylab='Latitude',cex.axis=1.5, cex.lab=1.6, cex.main=1.8,font=2)
points(se$longitude, se$latitude, col ='#800080', font=2)
points(d$longitude, d$latitude, col='green', font=2)
points(n$longitude, n$latitude, col='blue', font=2)
points(ne$longitude, ne$latitude, col='red', font=2)
points(nw$longitude, nw$latitude, col='black', font=2)
points(sw$longitude, sw$latitude, col='orange', font=2)

#these lines show where the bins were divided
for (i in 0:24){
  abline(h=(maxlat-minlat)*i/24 +minlat, col='black')
  abline(v=(maxlong-minlong)*i/24 +minlong, col='black')
  
}


# divide lat, long. into a 25x25 grid of bins. Should be small enough to capture the patterns in the 
#difference between different locations. all bins will divide the lattitude and longitude where data exists
#evenly. in other words, the minimum lattitude will be the edge of the first y region

#initializes all data to be in region (0,0)
assault$regionx = 0 
assault$regiony = 0
assault$region =0 #the region combines region x and y into one dimension in a row major fashion
minlat = min(assault$latitude)
maxlat = max(assault$latitude)
minlong = min(assault$longitude)
maxlong = max(assault$longitude)

#normalize latitude and store as regiony 0 through 24
for (i in 1:length(assault$latitude)){
  reg = ((assault$latitude[i]-minlat)/(maxlat-minlat))*24
  assault$regiony[i] = floor(reg)
}

#normalize longitude and store as regionx 1 through 25
for (i in 1:length(assault$longitude)){
  reg = ((assault$longitude[i]-minlong)/(maxlong-minlong))*24+1
  assault$regionx[i] = floor(reg)
}

#create region from regionx and region y
#region should be from 1 to 625 and as (y)*10+x (row major)
for (i in 1:length(assault$regionx)){
  assault$region[i]= assault$regionx[i]+(assault$regiony[i])*25
}


assault_counts = array(rep(0,625*7*24),c(625, 7, 24))#store as ordered triple:
                                                    #(region, day of the week, time of day)
                                                    #initialize all values to 0

for (i in 1:625){
  for (j in 1:7){
    for(k in 1:24){
      ix_region = which(assault$region == i)
      ix_day=which(assault$reported_dayofwk == days_of_week[j])
      ix_hour = which(assault$reported_hour==k-1)
      count =length(intersect(ix_region, intersect(ix_day, ix_hour)))
      assault_counts[i,j,k]=count #stores the number of assaults at each position in the data cube
        
    }
  }
}

write.csv(assault_counts, file= "AssaultCounts2.csv")#this ends up compressing the day and hour dimensions
                                                      #it is essentially the same as hour of the week
                                                      #this data was further analyzed in matlab




#create elevation map of the spatial component of assaults
library(ggmap)
#Set your API Key
#ggmap::register_google(key = "AIzaSyB7SOHnpbF2R4vZWdlcaDGf8er1wS0m76Y") #UNCOMMENT THIS LINE TO RUN-----------------------------------------------------
lon=median(assault$longitude)
lat = median(assault$latitude)
map<-get_map(location = c(lon = lon, lat = lat),zoom = 11, size = c(640, 640), scale = 4,
             format = "png8", maptype = "roadmap", color = c("color", "bw"))
ggmap(map, extent = "panel", maprange = FALSE,legend = "right", padding = 0.02, darken = c(0, "black"),
      cex.lab=5, cex.axis=5)+plot(assault$longitude, assault$latitude)+
      geom_density2d(data = assault, aes(x=assault$longitude,y=assault$latitude),size = 0.9)






#------------------------------------------Imported from Matlab------------------------------
#array of assault probabilities in each ordered triple of the data cube
rcf<-read.csv("F://Rprojects/RaleighCrime/25x25 assault model.csv", header = FALSE)
lambda=c(1.5921,0.7749,0.3740,0.3413)#weightings of each tensor in the approximation
freq=c() # the probability of an assault in the ith region is the product of the coefficient (lambda) and the value in the ith position of each tensor
str(rcf$V1)
rcf$V1
for(j in 1:625){
  freq[j]=rcf$V1[j]*lambda[1]+rcf$V2[j]*lambda[2]+rcf$V3[j]*lambda[3]+rcf$V4[j]*lambda[4]
}

sim_crimes= sample(1:625,size=1000, prob=freq, replace = TRUE)#simulate 1000 assaults 

sim_counts=c(rep(0,625))
for (i in 1:1000){
  sim_counts[sim_crimes[i]]=sim_counts[sim_crimes[i]]+1
}

#store crime counts in 2d matrix
sim_counts_2D=matrix(sim_counts, nrow=25, ncol=25, byrow = FALSE)

latrange=maxlat-minlat
longrange=maxlong-minlong

sim_coord_lat=matrix(data=rep(0,625), nrow=25, ncol=25)
sim_coord_long=matrix(data=0, nrow=25, ncol=25)

sim_assaults=matrix(data=0, nrow=0, ncol=2)
for (j in 1:25){
  for(i in 1:25){
    sim_coord_lat[i,j]=((j-1)*latrange)/25 +minlat
    sim_coord_long[i,j]=((i-1)*longrange)/25 +minlong
    if(sim_counts_2D[i,j]!=0){
      for(k in 1: sim_counts_2D[i,j]-1){
        sim_assaults=rbind(sim_assaults,c(sim_coord_lat[i,j]+runif(1,0,latrange/25),sim_coord_long[i,j]+runif(1,0,longrange/25)))
        
      }
    }
  }
}



freq_2D=matrix(freq, nrow=25, ncol=25, byrow = FALSE)
assaults_df=data.frame(lat=sim_assaults[,1], long=sim_assaults[,2])

#generate elevation map with simulated data
library(ggmap)
#Set your API Key
#ggmap::register_google(key = "AIzaSyB7SOHnpbF2R4vZWdlcaDGf8er1wS0m76Y") #UNCOMMENT THIS LINE TO RUN------------------------------------------------
lon=median(sim_assaults[,2])
lat = median(sim_assaults[,1])
map<-get_map(location = c(lon = lon, lat = lat),
                   zoom = 11, size = c(640, 640), scale = 4, format = "png8", maptype = "roadmap",
                   color = c("color", "bw"))
ggmap(map, extent = "panel", maprange = FALSE,
legend = "right", padding = 0.02, darken = c(0, "black"),cex.lab=5, cex.axis=5)+plot(assaults_df$long, assaults_df$lat)+
  geom_density2d(data = assaults_df, aes(x=assaults_df$long,y=assaults_df$lat),size = 0.9)
