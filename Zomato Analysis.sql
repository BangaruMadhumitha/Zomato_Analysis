Create database Zomato_Analytics;
use Zomato_Analytics;
show tables;
select * from main_data;
desc main_data;


# Q1 Build a country Map Table
select * from main_data;
select 
	countryid, countryname, 
    avg(longitude) as avg_longitude, avg(latitude) as avg_latiude
    from main_data m left join country c 
    on m.countrycode=c.countryid
group by m.countrycode, c.countryname
;


# Q2.Build a Calendar Table using the Column Datekey

select * from calendar;

create table calendar as
select datekey_opening from main_data;

alter table calendar
add(Year int,
    Monthno int,
    Monthfullname varchar(15),
    Quarter varchar(5),
    YearMonth varchar(10),
    Weekdayno int,
    Weekdayname varchar(15),
    FinancialMonth varchar(5),
    Financialquarter varchar(5)
    );
    
update calendar set
year=year(datekey_opening),
monthno=month(datekey_opening),
monthfullname
=monthname(datekey_opening),
quarter=quarter(datekey_opening),
yearmonth=date_format(datekey_opening,"%Y-%b"),
weekdayno=dayofweek(datekey_opening),
weekdayname=date_format(datekey_opening,"%W"),
financialmonth=case
when month(datekey_opening)=4 then "FM1"
when month(datekey_opening)=5 then "FM2"
when month(datekey_opening)=6 then "FM3"
when month(datekey_opening)=7 then "FM4"
when month(datekey_opening)=8 then "FM5"
when month(datekey_opening)=9 then "FM6"
when month(datekey_opening)=10 then "FM7"
when month(datekey_opening)=11 then "FM8"
when month(datekey_opening)=12 then "FM9"
when month(datekey_opening)=1 then "FM10"
when month(datekey_opening)=2 then "FM11"
when month(datekey_opening)=3 then "FM12"
end,
financialquarter=case
when month(datekey_opening) in (4,5,6) then "FQ1"      -- 
when month(datekey_opening) in (7,8,9) then "FQ2"
when month(datekey_opening) in (10,11,12) then "FQ3"
when month(datekey_opening) in (1,2,3) then "FQ4"
end;

select * from calendar;


# Q3 Find the Numbers of Resturants based on City and Country.

select Countryname, count(restaurantid) as No_of_restaurant from main_data m
left join Country c on m.countrycode=c.countryid
group by countryname;

select City, count(restaurantid) as No_of_restaurant from main_data
group by city;



# Q4 Numbers of Resturants opening based on Year , Quarter , Month
select 
	year(datekey_opening) as Year, 
    count(restaurantid) from main_data
group by year 
order by Year;
select 
	Quarter(datekey_opening) as Quarter, 
	count(restaurantid) from main_data
group by Quarter 
order by Quarter;
select 
    year(datekey_opening) as year,
    month(datekey_opening) as month,
    count(restaurantid) as No_of_restaurant
from main_data
GROUP BY Year, Month
order by year, month;


# Q5. Count of Resturants based on Average Ratings
select 
	    Rating,
        count(*) as No_of_restaurant from main_data
group by rating
order by rating;


# Q6 Create buckets based on Average Price of reasonable size and find out how many resturants falls in each buckets

SELECT 
    CASE 
        WHEN Average_Cost_for_two <= 500 THEN '0-500'
        WHEN Average_Cost_for_two BETWEEN 501 AND 1000 THEN '501-1000'
        ELSE '1000+'
    END AS PriceBucket,
    COUNT(RestaurantID) AS No_of_restaurant
FROM main_data
GROUP BY PriceBucket;


# 7.Percentage of Resturants based on "Has_Table_booking"

SELECT 
    Has_Table_booking,
    COUNT(*) AS No_of_restaurant,
    ROUND((COUNT(*) / (SELECT COUNT(*) FROM main_data)) *100, 2) AS Percentage
FROM
   main_data
GROUP BY
   Has_Table_booking;


# 8.Percentage of Resturants based on "Has_Online_delivery"

SELECT
     Has_Online_delivery,
     COUNT(*) AS No_of_restaurant,
     ROUND((COUNT(*) / (SELECT COUNT(*) FROM main_data)) *100, 2) AS Percentage
FROM 
    main_data
GROUP BY
    Has_Online_delivery;



# Q9 Show the most popular cuisines based on the number of restaurants offering them.

select Cuisines, count(*) as number_of_restaurant 
from main_data 
group by cuisines limit 10;
 