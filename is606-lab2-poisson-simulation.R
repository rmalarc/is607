
#setwd("/Users/malarcon/Google Drive/CUNY/IS606/labs")
#data<-read.csv("lab-data-file-poisson-applications.csv")
#stats.desc(data)
#ceiling(sapply(data, mean))

#lambdas<-sapply(data, mean)

# these lambdas are calculated based upon the data from the csv file....
# hardcoding them here for convenience
lambdas<- c( 10,8,6 )
names(lambdas)<-c("Nassau","SanJuan","KeyWest")

profit.of.sim.at.production.level <- function(simulation,cost,price,level) {
  profit<-sum(ifelse(simulation<level,simulation,level)*price - level*cost)/length(simulation)
  return(profit)
}

simulated.profit.for.destination <- function(destination_lambda,c,p){
  charters<-c(1:ceiling((sqrt(destination_lambda)*6)))
  sim_charter_demand <- rpois(10000, destination_lambda)
  sim_profits <- sapply(charters,profit.of.sim.at.production.level,simulation=sim_charter_demand,cost=c,price=p)
  names(sim_profits)<-charters  
  return(sim_profits)
}

sapply(lambdas,simulated.profit.for.destination,340,800)