library("RPostgreSQL")

# Establish connection to PoststgreSQL using RPostgreSQL
drv <- dbDriver("PostgreSQL")

# Full version of connection seetting
con <- dbConnect(drv, dbname="flights"
                ,host="localhost"
                ,user="postgres",password="")


## Submits a statement
rs <- dbSendQuery(con, "
  select f.year*10000+f.month*100+f.day as dateserial
    , f.origin,carrier
  	,(select temp 
                  from weather w 
                  where w.origin in ('EWR')  -- weather observations are missing for LGA & JFK, use EWR instead
                  and f.year = w.year 
                  and f.month = w.month 
                  and f.day = w.day
                  and f.hour >= w.hour
                  order by hour desc
                  limit 1
      ) as temp
    ,dep_delay
    ,arr_delay
    ,air_time
    ,seats 
from flights f
inner join planes p on p.tailnum = f.tailnum 
where f.origin in ('JFK','LGA','EWR') 
      and f.dest in ('LAX')
      and f.year*10000+f.month*100+f.day between 20130223 and 20130301")

## fetch all elements from the result set and store into flights_analysis dataframe
flights_analysis <- fetch(rs,n=-1)
View(flights_analysis)

## Closes the connection
dbDisconnect(con)

## Frees all the resources on the driver
dbUnloadDriver(drv)