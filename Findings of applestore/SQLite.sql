create table appleStore_description_union AS
select * from appleStore_description1
union all 
select * from appleStore_description2
union all 
select * from appleStore_description3
union all 
select * from appleStore_description3
union all 
select * from appleStore_description4

**Explotary Data Analysis**
--CHECK THE NUMBER OF UNIQUE APPS IN BOTH tablesapplestore
select count(DISTINCT id) as UniqueAppleId
from AppleStore
select count(DISTINCT id) as UniqueAppleId
from appleStore_description_union

--check any missing values key fields of the tables
select count(*) as missingvalues 
from AppleStore
where track_name is null or user_rating is null or prime_genre is null 

select count(*) as missingvalues 
from appleStore_description_union
where app_desc is NULL

--Find out the number of apps per genre 
select prime_genre, count(*) as NOofApps
from AppleStore
group by prime_genre
order by NOofApps DESC

--Get an overview of the apps ratings
select min(user_rating) as minrating,
max(user_rating) as maxrating,
avg(user_rating) as avgrating
from AppleStore


**Data Analysis**
--Determine whether paid apps gave higher ratings than free apps
select CASE
when price > 0 then 'Paid'
else 'free'
end as App_Type,
avg(user_rating) as Avg_Rating
from AppleStore
group by App_Type


--Check if Apps with more supported languages have higher ratings
select case 
when lang_num < 10 then '<10 languages'
when lang_num between 10 and 30 then '10-30 languages'
else '>30 languages'
end as language_list,
avg(user_rating) as Avgratings
from AppleStore
group by language_list
order by Avgratings


--Check genre with low ratings
select prime_genre,
avg(user_rating) as Avgratings
from AppleStore
group by prime_genre
order by Avgratings ASC
limit 10


--Check if there is a correlation between the length of the app and the user ratings
select case 
when length(B.app_desc) <500 then 'Short'
when length(B.app_desc) between 500 and 1000 then 'Average'
Else 'Long'
end as Description_Length_Type,
avg(A.user_rating) as Avgratings
from 
AppleStore as A
join 
appleStore_description_union as B 
on 
a.id = b.id
group by Description_Length_Type
order by Avgratings desc


--Check the Top rated Apps for each Genre
select prime_genre,
user_rating,
track_name
from(
SELECT
  prime_genre,
  user_rating,
  track_name,
  rank() over(partition by prime_genre order by user_rating desc, rating_count_tot desc) as rank
  from 
  AppleStore)
  as a 
  where 
  a.rank=1




























