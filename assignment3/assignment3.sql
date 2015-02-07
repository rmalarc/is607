/*
Mauricio Alarcon
IS606 - Assignment 3
mauricio.alarcon_balan@spsmail.cuny.edu

RVC Gym - Fitness Classes Database
===================================
Summary: This database helps RVC Gym nmanage their fitness class registration

Details: https://docs.google.com/presentation/d/1w5z3h6JoZAnH4UDiTxs2b3gL8mPV5IMibWcjKNCiSK0/edit?usp=sharing


*/

-- ########################
-- # DATABASE DEFINITION
-- ########################

DROP TABLE IF EXISTS members;
create table members (
  id serial,
  first_name varchar(100),
  last_name varchar(100),
  status varchar(1)
);


DROP TABLE IF EXISTS classes;
create table classes(
  id serial,
  class_name varchar(100),
  capacity int
);

DROP TABLE IF EXISTS instructor;
create table instructor (
  id serial,
  first_name varchar(100),
  last_name varchar(100)
);

DROP TABLE IF EXISTS class_schedule;
create table class_schedule(
  id serial,
  class_id int,
  instructor_id int,
  date_time timestamp,
  duration int,
  recurring varchar(1)
);

DROP TABLE IF EXISTS class_registration;
create table class_registration(
  id serial,
  class_schedule_id int,
  member_id int,
  date date
);


-- ########################
-- # SAMPLE DATA
-- ########################

-- Gym members
insert into members (id, first_name, last_name, status) 
values (1, 'Mauricio','Alarcon','A'),
	(2,'John','Smith','A'),
	(3,'Ken','Banderas','A');

-- Gym classes
insert into classes (id, class_name, capacity) 
values (1,'Spin',20),
	(2,'Zumba',15),
	(3,'Bootcamp',30),
	(4,'Yoga',25);

-- Gym instructors
insert into instructor (id, first_name, last_name) 
values (1,'Brian','Murdock'),
	(2,'Leslie','Oppenheimer'),
	(3,'Chris','Madoff'),
	(4,'Dianne','Macedo'),
	(5,'Chris','Brossnan'),
	(6,'Juliana','Fuentes');

-- Populate class schedule. Recurring can be Weekly, Monthly, '' - one off
insert into class_schedule (id,class_id,instructor_id,date_time,duration,recurring)
values (1,1,1,'2/6/2015 8:30',60,'W'),
	(2,1,5,'2/7/2015 9:30',60,'W'),
	(3,4,4,'2/4/2015 18:30',60,'W'),
	(4,3,5,'5/30/2015 18:30',90,''),
	(5,2,6,'2/4/2015 18:30',60,'W');
	
-- register member into classes. As with all gyms, members must register to EACH class occurence individually
insert into class_registration(class_schedule_id, member_id,date)
values (1,1,'2/13/2015'),
	(1,1,'2/27/2015'),
	(3,3,'2/11/2015'),
	(1,1,'3/27/2015');



-- ########################
-- # SAMPLE QUERIES
-- ########################

-- show classes with 0 registrations
select class_name
from classes c 
where id not in (
	select class_id 
	from class_schedule cs 
	inner join class_registration cr on cr.class_schedule_id = cs.id
	);

-- show most popular class/instructor by month
select EXTRACT(YEAR FROM date) "year"
	,EXTRACT(MONTH FROM date) "month"
	,class_name
	, first_name||' '||last_name instructor
	, count(*) as students_registered
from classes c 
inner join class_schedule cs on cs.class_id = c.id 
inner join class_registration cr on cr.class_schedule_id = cs.id
inner join instructor i on i.id = cs.instructor_id 
group by  EXTRACT(YEAR FROM date)
	,EXTRACT(MONTH FROM date)
	, class_name
	, first_name||' '||last_name;

-- show a list of members and their average number of classes per month
select m.id member_id
	,min(first_name) as first_name
	,min(last_name) as last_name
	,avg(classes_registered) as avg_classes_registered_per_month
from members m
inner join (
	select EXTRACT(YEAR FROM date) "year"
		,EXTRACT(MONTH FROM date) "month"
		,member_id
		, count(*) as classes_registered
	from class_schedule cs
	inner join class_registration cr on cr.class_schedule_id = cs.id
	group by  EXTRACT(YEAR FROM date)
		,EXTRACT(MONTH FROM date)
		, member_id
	) month_avg on month_avg.member_id = m.id
group by m.id;