########################################## simulated data ######################################################
##### several possible senarios #####
# 1. missing data in at ; total <5% of sample size
# 2. missing data in yt ; total <5% of sample size
# 3. server break down at=0  leads to horizontal yt trend ; 2.5% of sample size
# 4. outlier yt  ; 2.5% of sample size
# 5. seasonal at ; quarterly and monthly
# 6. autocorrelated yt
# 7. problematic data points at the tail part 
## We choose to include this senarios in one simulation data which is more realistic. 
## And control the total percent of problematic data less than 10% of the whole dataset.

##### scalability #####
# 10^2~10^6
# 1. 10^2~10^3 small data
# 2. 10^5~10^6 normal size data 

##### number of simulation #####
# To get the average accuracy and speed, we will simulate 30 times for each scale.

## libraries used in simulation and plotting
library("sarima")
library("forecast")
library("ggplot2")

### This file contains four functions to simulate data###
#1.  GenNonSeaData function generates nonseasonal data
#2.  GenSeaData function generate autocorrelated season data
#3.  GenData function to generate simulated data； pacakging the first two functions
#4.  GenModYou function to generate modified Youtube data; you need to put 'out_youtube.csv' into your home directory first



#### GenNonSeaData function generates nonseasonal data ####
#dist <- "Normal"
GenNonSeaData <- function(n,dist,percent){
  if(dist == "Chisq"){
    at <- rchisq(n,df =1)
  }else if (dist == "Normal"){
    at <- rnorm(n,mean = 40, sd= 5)
  }else{
    print("Invalid input of dist parameter!")
  }
  at[sample(1:length(at),n*0.25*percent)] <- 0 # 1. missing data(fake NA) in at, since 5+NA=NA in r
  at[sample(1:length(at),n*0.25*percent)] <- 0  # 3. server break down at=0
  # at[(length(at)-n*0.25*percent):length(at)] <- 0 # 7. problematic data at the tail part
  yt <- rep(0,length(at))
  for (i in 1:length(at)) {
    yt[i] <- sum(at[1:i])   # yt is the cumulative value of at
  }
  yt[sample(1:length(yt),n*0.25*percent)] <- NA # 2. missing data in yt
  yt[sample(1:length(yt),n*0.25*percent)] <- 0  # 4. outliers yt
  return(yt)
}
# test code
# GenNonSeaData(n,dist = "Normal",percent = 0.1)


#### GenSeaData function generate autocorrelated season data ####
GenSeaData <- function(n,period){
  orderSet  <- matrix(c(1,0,0,0,0,1,1,0,1,1,1,1),nrow = 4,ncol = 3,byrow = TRUE)   # set of common order cases of autocorrelated seasonal data parameters
  combSet <- unique(t(combn(rep(1:4,2),2)))  # index of all possible combinations of orders of parameters sets; to choose from orderSet
  # dim of combSet is 16*2, 16 = 4*4
  mlnum <- sample(1:16, 1) # choose a single model
  if(period == 4){
    # total 16 possible senarios of autocorrelated quarterly seasonal data
    ml <- arima(ts(rnorm(100),frequency = 4),order = orderSet[combSet[mlnum,1],],seasonal = list(order=orderSet[combSet[mlnum,2],],period = 4))    
  }else if (period == 12){
    # total 16 possible senarios of autocorrelated monthly seasonal data
    ml <- arima(ts(rnorm(100),frequency = 12),order = orderSet[combSet[mlnum,1],],seasonal = list(order=orderSet[combSet[mlnum,2],],period = 12))    
  }else{
    print("Invalid seasonal period parameter")
  }
  yt <- simulate(ml, nsim=n)  # flawless data
  yt[sample(1:length(yt),n*0.025)] <- NA # 2. missing data in yt
  yt[sample(1:length(yt),n*0.025)] <- 0  # 4. outliers yt
  return(as.vector(yt))
}
# test code 
# GenSeaData(4)

#### GenData function to generate simulated data ####
GenData <- function(n, dist="Normal", percent=0.10,period="None"){
  #### parameters ####
  # n : simulated sample size
  # dist : distribution of at；normal / chisquare; N(0,1) / Chisquare(1)  and choose N(0,1) by default
  # percent : numeric float (0,0.10], percent of problematic data to the total number of data; averagely distributed to 4 senarios; no more than 0.10
  # period : parameter for seasonal data ; 4 / 12 / None; None by default
  
  #### examples ####
  
  #### main code ####
  if (percent>0.10 | percent<0 | n<0 | n==0){
    print("Invalid input of n and/or percent!")
  }else if (period == "None"){
    GenNonSeaData(n,dist,percent)
  }else{
    GenSeaData(n,period)
  }
}
# test code
# GenData(1000,dist = "Chisq", percent = 0.2, period = 4)
# GenData(1000,dist = "Chisq", percent = 0.2, period = 5)
# GenData(-1000,dist = "Chisq", percent = 0.1, period = 12)
# SimData <- GenData(100,dist = "Chisq", percent = 0.10, period = 4)
# SimData <- GenData(200,dist = "Chisq", percent = 0.10, period = 12)


#### plot simulated data
# data <- data.frame(timestamps = 1:length(SimData),data = SimData)
# ggplot(data,aes(x= timestamps,y = SimData)) + geom_point()+xlab("")

#### GenModYou function to generate modified Youtube data ####
GenModYou <- function(){
  youtube <- read.csv("out_youtube.csv")  
  yt<-youtube$y_t
  for (i in 200:1000) {
    yt[i]<-yt[i]+(i/3)^2
  }
}




