#Case Study 1 
 
create database ajaki;
use ajaki;
create table job_data(ds DATE, job_id int, actor_id int, event varchar(20), language varchar(20) , time_spent int , org varchar(10));

insert into job_data values("2020-11-30","21","1001","skip","English","15","A");
insert into job_data values("2020-11-30","22","1006","transfer","Arabic","25","B");
insert into job_data values("2020-11-29","23","1003","decision","Persian","20","C");
insert into job_data values("2020-11-28","23","1005","transfer","Persian","22","D");
insert into job_data values("2020-11-28","25","1002","decision","Hindi","11","B");
insert into job_data values("2020-11-27","11","1007","decision","French","104","D");
insert into job_data values("2020-11-26","23","1004","skip","Persian","56","A");
insert into job_data values("2020-11-25","20","1003","transfer","Italian","45","C");
select * from job_data;
#Calculate the number of jobs reviewed per hour per day for November 2020
select 
count(job_id)/(30*24) as num_jobs_reviewed
from job_data
where 
ds between "2020-11-01" and "2020-11-30";

#Let’s say the above metric is called throughput. Calculate 7 day rolling average of throughput? For throughput, do you prefer daily metric or 7-day rolling and why
select * from job_data;
select ds,
jobs_reviewed,
avg(jobs_reviewed)over(order by ds rows between 6 preceding and current row) as rolling_average
from
(
select ds,
count(distinct job_id) as jobs_reviewed
from job_data
where ds between "2020-11-01" and "2020-11-30"
group by ds
order by ds
)sub1;

#Calculate the percentage share of each language in the last 30 days
select * from job_data;
WITH Table1 AS (
SELECT language, COUNT(job_id) AS num_jobs
FROM job_data
WHERE event IN('transfer','decision')
AND ds BETWEEN '2020-11-01' AND '2020-11-30'
GROUP BY language),
total AS (
SELECT COUNT(job_id) AS total_jobs
FROM job_data
WHERE event IN('transfer','decision')
AND ds BETWEEN '2020-11-01' AND '2020-11-30'
GROUP BY language)
SELECT language, ROUND(100.0*num_jobs/total_jobs,2) AS perc_jobs
FROM Table1
CROSS jOIN total
ORDER BY perc_jobs DESC;

#Let’s say you see some duplicate rows in the data. How will you display duplicates from the table?
select * from
(
select *,row_number()over(partition by job_id) as rownum from job_data
)sub
 where rownum>1;
 

