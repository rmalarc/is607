/*
1. Which destination in the flights database is the furthest distance away?
*/

select dest,avg(distance) as avg_distance
from  flights
where origin in ('EWR','JFK','LGA')
group by dest
order by avg_distance desc;



--create index faa on airports(faa);
-- Extra credit question:  two airports that are furthest apart
/*
BEWARE OF BAD DATA: MYF airport's latitude and longitude is incorrect. 

It appears as:
"MYF";"Montgomery Field";32.4759;117.759;17;-8;"A"
It should be:
"MYF";"Montgomery Field";32.4759;-117.759;17;-8;"A"
*/
SELECT A0.FAA ORIGIN_FAA
	,A0.NAME ORIGIN
	,A1.FAA DEST_FAA
	,A1.NAME DEST
	,A0.TZ
	,A1.TZ
	,SQRT((A1.LAT-A0.LAT)^2
		+(CASE WHEN A1.LON >0 THEN -180 - (180+A1.LON) ELSE A1.LON END-
		  CASE WHEN A0.LON >0 THEN -180 - (180+A0.LON) ELSE A0.LON END)^2) DISTANCE
	,A0.LON
	,CASE WHEN A0.LON >0 THEN 180 - (180+A0.LON) ELSE A0.LON END 
	,A1.LON
	,CASE WHEN A1.LON >0 THEN 180 - (180+A1.LON) ELSE A1.LON END
FROM airports A0
INNER JOIN airports A1 ON A1.FAA > A0.FAA
ORDER BY DISTANCE DESC;

/*
2. What are the different numbers of engines in the planes table? For each number of engines, which aircraft have
the most number of seats?
*/
select ps.engines, type, manufacturer, model, seats
from planes p
inner join (
	select engines,max(seats) max_seats 
	from planes
	group by engines
	) ps on p.engines = ps.engines and p.seats = ps.max_seats
order by engines,model, seats;

/*
3. What weather conditions are associated with New York City departure delays?
*/
--select d.*,w.temp,dewp,humid,wind_dir,wind_speed,wind_gust,precip,pressure,visib 
select CASE 
		WHEN dep_delay_disc >300 then 300 
		ELSE dep_delay_disc 
	END as dep_delay
	, count(*) as flights
	, avg(temp) temperature
	, avg(dewp) dewp
	, avg(humid) humid
	,avg(wind_dir) wind_dir
	,avg(wind_speed) wind_speed
	,avg(wind_gust) wind_gust
	,avg(precip) precip
	,avg(pressure) pressure
	,avg(visib) visib
from (
	select origin
		,year
		,month
		,day
		,(dep_delay/30)*30 as dep_delay_disc  -- discretize the delay in 30-min buckets
		,dep_time / 100 as hour  -- convert full time to hour
	from flights 
	where origin in ('EWR','JFK','LGA')
) d
INNER join weather w on 
	d.origin = w.origin and d.year = w.year and d.month = w.month and d.day = w.day and d.hour = w.hour
group by 
	CASE 
		WHEN dep_delay_disc >300 then 300 
		ELSE dep_delay_disc 
	END -- if it's greater than a 300 min delay, make it all 300+
order by dep_delay;



/*
4. Are older planes more likely to be delayed?
*/

select engine,f.year - p.year,avg(dep_delay),avg(arr_delay), count(*)
from flights f
inner join planes p on p.tailnum = f.tailnum
group by engine,f.year - p.year
order by 1,2;

/*
Ask (and if possible answer) a question that also requires joining information from two or more tables in the
flights database, and/or assumes that additional information can be collected in advance of answering your question.

- What are the aircraft that travel the greatest distances?
*/

select manufacturer,type,engine,model, avg(engines) engines, avg(seats) seats,max(distance) max_distance,avg(distance),count(*) as flights
from flights f
inner join planes p on p.tailnum = f.tailnum
group by manufacturer,type,engine,model
order by max_distance desc;