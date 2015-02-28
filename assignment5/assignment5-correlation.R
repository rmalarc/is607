library("RPostgreSQL")

# Establish connection to PoststgreSQL using RPostgreSQL
drv <- dbDriver("PostgreSQL")

# Full version of connection seetting
con <- dbConnect(drv, dbname="flights"
                ,host="localhost"
                ,user="postgres",password="")

## fetch all elements from the result set and store into flights_analysis dataframe
rs <- dbSendQuery(con, "select dep_delay
,temp
  ,dewp
	,humid
	,wind_dir
	,wind_speed
	,wind_gust
	,precip
	,pressure
	,visib
from flights d 
INNER join weather w on 
	d.origin = w.origin and d.year = w.year and d.month = w.month and d.day = w.day and d.hour = w.hour
	where d.origin in ('EWR','JFK','LGA')")

delays_nyc <- fetch(rs,n=-1)
View(delays_nyc)

cor(delays_nyc, use="complete.obs")

## Closes the connection
dbDisconnect(con)

## Frees all the resources on the driver
dbUnloadDriver(drv)