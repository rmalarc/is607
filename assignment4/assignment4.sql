/*
Mauricio Alarcon
IS606 - Week 4 Assignment
mauricio.alarcon_balan@spsmail.cuny.edu

Organization Chart
===================================
SUMMARY: This database represent an org structure of a given organization 

DETAILS: Please create an organization chart for a real or imagined organization, implemented in a single SQL table. 
Your deliverable script should:

1. Create the table. Each row should minimally include the person’s name, the person’s supervisor, and the person’s job title. Using ID columns is encouraged.
2. Populate the table with a few sample rows.
3. Provide a single SELECT statement that displays the information in the table,showing who reports to whom.

You might have an organization with a depth of three levels. For example: there could be a CEO, two vice presidents that report 
to the CEO, and two managers that report to each of the two vice presidents. An assistant might also report directly to the CEO. 
Your table should be designed so that the reporting hierarchy could go to any practical depth.


*/

-- ########################
-- # DATABASE DEFINITION
-- ########################

DROP TABLE IF EXISTS org_chart;
create table org_chart (
  id serial,
  employee_name varchar(100),
  title varchar(25),
  supervisor_id int
);



-- ########################
-- # SAMPLE DATA
-- ########################

-- part of apple's org chart
insert into org_chart (id, employee_name, title, supervisor_id) 
values (1, 'Steve Jobs','CEO',NULL)
	,(2,'Tim Cook', 'Chief Operating Officer',1)
	,(3,'Jeff Williams', 'SVP, Operations',1)
	,(4,'Jonathan Ive', 'SVP Industrial Design',1)
	,(5,'Ron Johnson','SVP Retail',1)
	,(6,'Scott Forstall','SVP IOS Software',1)
	,(7,'Michael Fenger','VP, Iphone Sales',2)
	,(8,'Douglas Beck','VP, Apple Japan',2)
	,(9,'Jenn Bailey','VP, Online Stores',2)
	,(10,'Will Fredrick','VP Fulfillment',3)
	,(11,'Rita Lane','VP, Operations',3)
	,(12,'Jerry Mcdougal','VP Retail',5)
	,(13,'HEnri Lamiraux','VP Engineering IOS Apps',6)
	,(14,'Isabel De Mane','VP, IOS Wireless Software',6)
	,(15,'Kim Vorrath','VP Program Management',6);



-- ########################
-- # SAMPLE QUERIES
-- # Provide a single SELECT statement that displays the information in the table,showing who reports to whom.
-- ########################
select employee.employee_name||' - '||employee.title employee
	, reports_to.employee_name||' - '||reports_to.title reports_to
from org_chart employee
left join org_chart reports_to 
	on employee.supervisor_id = reports_to.id

