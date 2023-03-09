# Case Study 2 

#Calculate the weekly user engagement
select * from events;
select 
extract(week from occurred_at) as weeklynum,
count(distinct user_id) from events
group by weeklynum;

# Calculate the user growth for product?

select 
year,
weeknum,
num_active_user,
sum(num_active_user) over(order by year,weeknum rows between unbounded preceding and current row) as cum_active_user
from(select extract(year from activated_at) as year,
extract(week from activated_at)as weeknum,
count(distinct user_id) as num_active_user
from 
opusersa where state="active" 
group by year,
weeknum order by year,weeknum
)sub1;

#Calculate the weekly retention of users-sign up cohort
select extract(year from occurred_at)as year,
extract(week from occurred_at)as week,
device,
count(distinct user_id)
from events 
where event_type="engagement" 
group by year,week,device 
order by year,week,device;

#Calculate the weekly engagement per device?

SELECT EXTRACT(week FROM occurred_at) AS week, 
COUNT(DISTINCT e.user_id) AS weekly_active_users, 
COUNT(DISTINCT CASE WHEN e.device 
IN('macbook pro','lenovo thinkpad','macbook air','dell inspiron notebook','asus chromebook','dell inspiron desktop','acer aspire notebook','hp pavilion desktop','acer aspire desktop','mac mini') 
THEN e.user_id ELSE NULL END) AS computer, 
COUNT(DISTINCT CASE WHEN e.device 
IN('iphone 5','samsung galaxy s4','nexus 5','iphone 5s','iphone 4s','nokia lumia 635','htc one','samsung galaxy note','amazon fire phone') 
THEN e.user_id ELSE NULL END) AS phone, 
COUNT(DISTINCT CASE WHEN e.device 
IN('ipad air','nexus 7','ipad mini','nexus 10','kindle fire','windows surface','samsung galaxy tablet') 
THEN e.user_id ELSE NULL END) AS  tablet 
FROM events e 
WHERE e.event_type = 'engagement' AND e.event_name = 'login' 
GROUP BY 1  
ORDER BY 1 
LIMIT 100;

#Calculate the email engagement metrics
SELECT COUNT(user_id),
SUM(CASE WHEN retention_week = 1 THEN 1 ELSE 0 END) as week_1 
FROM ( SELECT s.user_id, a.signup_week, b.engagement_week, b.engagement_week - a.signup_week AS retention_weekly
FROM ( (SELECT DISTINCT user_id, EXTRACT(week FROM occurred_at) AS signup_week 
FROM events WHERE event_type = 'signup_flow' AND event_name = 'complete_signup' AND EXTRACT(week from occurred_at) = 18 ) a 
LEFT JOIN ( SELECT DISTINCT user_id, EXTRACT(week FROM occurred_at) AS engagement_week from events WHERE event_type = 'engagement' ) b ON a.user_id = b.user_id ) 
ORDER BY a.user_id )a