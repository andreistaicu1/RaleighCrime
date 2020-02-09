crime<-read.csv('F:/Rprojects/RaleighCrime/Raleigh Crime Original Data.gz')


str(crime)
head(crime)
summary(crime)

unique(crime$crime_category)#returns all unique types in the column
##extracted burglary res and commerce

ix_r =which(crime$crime_category == "BURGLARY/RESIDENTIAL")
ix_c = which(crime$crime_category == "BURGLARY/COMMERCIAL")

#str(crime$reported_year) returns type of year (integer)

ix_year<- which(crime$reported_year== 2019)
ix <- intersect(c(ix_c, ix_r), ix_year)



C <-crime[ix,]
dim(C)
dim(crime)
length(ix_c)
unique(crime$reported_year)

xc <-matrix(0, 7, 24)
xr <-matrix(0, 7, 24)

#days_of_week= c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
days_of_week = unique(crime$reported_dayofwk)

for (i in 1:7){
  for (j in 0:23){
    ix_day=which(crime$reported_dayofwk == days_of_week[i])
    ix_hour = which(crime$reported_hour==j)
    xr[i,j+1] = length(intersect(intersect(ix_day, ix_hour), ix_r))
    xc[i,j+1] = length(intersect(intersect(ix_day, ix_hour), ix_c))
  }
}


write.csv(xr, file= "ResBurglaryCounts.csv")
write.csv(xc, file= "ComBurglaryCounts.csv")

#---------------------------------------------------------
#Isolating assaults for further analysis
#---------------------------------------------------------
ixconsolidated<-which(table(crime$crime_category)>1000)

indexes<-which(crime$crime_category %in% names(ixconsolidated))
consolidated <- crime[indexes,]


ixassault <-which(crime$crime_category == 'ASSAULT')
ixlocation <- which(crime$latitude!='NA')
assault_with_location<- intersect(ixassault, ixlocation)

assault<-crime[assault_with_location,]

length(unique(assault$longitude))
length(unique(assault$latitude))


plot(assault$longitude, assault$latitude)




# binning the lat, long.
assault$regionx = 0
assault$regiony = 0
assault$region =0
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


assault_counts = array(rep(0,625*7*24),c(625, 7, 24))#region, day of the week, time of day

for (i in 1:625){
  for (j in 1:7){
    for(k in 1:24){
      ix_region = which(assault$region == i)
      ix_day=which(assault$reported_dayofwk == days_of_week[j])
      ix_hour = which(assault$reported_hour==k-1)
      count =length(intersect(ix_region, intersect(ix_day, ix_hour)))
      assault_counts[i,j,k]=count
        
    }
  }
}

write.csv(assault_counts, file= "AssaultCounts2.csv")
#cant tell how the data is stored. the columns are temporal and the rows spatial, 
#but the days and hours were merged so it could be viewed 2D in a csv file
#i think it is basically in howr of the week format, but im not sure...


assault_hotspot_indexes =intersect(which((assault$regionx>=6&assault$regionx<=7)),which((assault$regiony>=3&assault$regiony<=5)))

assault_hotspot = assault[assault_hotspot_indexes,]

se = assault[which(assault$district=='Southeast'),]
d = assault[which(assault$district=='Downtown'),]
n = assault[which(assault$district=='North'),]
ne = assault[which(assault$district=='Northeast'),]
nw = assault[which(assault$district=='Northwest'),]
sw = assault[which(assault$district=='Southwest'),]

plot(assault$longitude, assault$latitude)
points(se$longitude, se$latitude, col ='light blue')
points(d$longitude, d$latitude, col='green')
points(n$longitude, n$latitude, col='blue')
points(ne$longitude, ne$latitude, col='red')
points(nw$longitude, nw$latitude, col='gray')
points(sw$longitude, sw$latitude, col='orange')




#only in hotspot region
se = assault_hotspot[which(assault_hotspot$district=='Southeast'),]
d = assault_hotspot[which(assault_hotspot$district=='Downtown'),]
n = assault_hotspot[which(assault_hotspot$district=='North'),]
ne = assault_hotspot[which(assault_hotspot$district=='Northeast'),]
nw = assault_hotspot[which(assault_hotspot$district=='Northwest'),]
sw = assault_hotspot[which(assault_hotspot$district=='Southwest'),]

plot(assault$longitude, assault$latitude)
points(se$longitude, se$latitude, col ='light blue')
points(d$longitude, d$latitude, col='green')
points(n$longitude, n$latitude, col='blue')
points(ne$longitude, ne$latitude, col='red')
points(nw$longitude, nw$latitude, col='gray')
points(sw$longitude, sw$latitude, col='orange')


for (i in 0:9){
  abline(h=(maxlat-minlat)*i/9 +minlat, col='black')
  abline(v=(maxlong-minlong)*i/9 +minlong, col='black')
  
}

#------------------------------------------Heatmap
model= read.csv("F://Rprojects/RaleighCrime/10x10 assault model.csv", header = FALSE)

u1=matrix(model[,1], 10,10, byrow=TRUE)
u1=u1[10:1,]

rotate <- function(x) t(apply(x, 2, rev))
u1=rotate(u1)
image(u1)

u1min = min(u1)
u1max = max(u1)

ubins=seq(u1min, u1max, length.out=10)

cc<-colorRampPalette(c('blue', 'red'))(10)
colors= matrix(0, 10,10)
colors=cc[10]
colors[which(u1<ubins[9])]=cc[9]
colors[which(u1<ubins[8])]=cc[8]
colors[which(u1<ubins[7])]=cc[7]
colors[which(u1<ubins[6])]=cc[6]
colors[which(u1<ubins[5])]=cc[5]
colors[which(u1<ubins[4])]=cc[4]
colors[which(u1<ubins[3])]=cc[3]
colors[which(u1<ubins[2])]=cc[2]
colors[which(u1<ubins[1])]=cc[1]


plot(assault$longitude, assault$latitude, col = colors)


head(assault)

rcf<-read.csv("F://Rprojects/RaleighCrime/25x25 assault model.csv", header = FALSE)
lambda=c(1.5921,0.7749,0.3740,0.3413)
freq=c()
str(rcf$V1)
rcf$V1
for(j in 1:625){
  freq[j]=rcf$V1[j]*lambda[1]+rcf$V2[j]*lambda[2]+rcf$V3[j]*lambda[3]+rcf$V4[j]*lambda[4]
}

sim_crimes= sample(1:625,size=1000, prob=freq, replace = TRUE)

sim_counts=c(rep(0,625))
for (i in 1:1000){
  sim_counts[sim_crimes[i]]=sim_counts[sim_crimes[i]]+1
}

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
dim(sim_assaults)

freq_2D=matrix(freq, nrow=25, ncol=25, byrow = FALSE)
assaults_df=data.frame(lat=sim_assaults[,1], long=sim_assaults[,2], tint=)
library(ggmap)
#Set your API Key
ggmap::register_google(key = "")
lon=median(sim_assaults[,2])
lat = median(sim_assaults[,1])
#map<-get_stamenmap(c(left=minlong, bottom=minlat, right=maxlong, top=maxlat), zoom = 5, maptype = "terrain", scale = 2)
map<-get_map(location = c(lon = lon, lat = lat),
                   zoom = 10, size = c(640, 640), scale = 4, format = "png8", maptype = "roadmap",
                   color = c("color", "bw"))
ggmap(map, extent = "panel", maprange = FALSE,
legend = "right", padding = 0.02, darken = c(0, "black"))+plot(assaults_df$long, assaults_df$lat)+
  geom_density2d(data = assaults_df, aes(x=assaults_df$long,y=assaults_df$lat),size = 0.3)





plot(assaults_df$long, assaults_df$lat, xlim=c(min(sim_assaults[,2]), min(sim_assaults[,2])+.5), ylim=c(max(sim_assaults[,1])-.5, max(sim_assaults[,1])))
