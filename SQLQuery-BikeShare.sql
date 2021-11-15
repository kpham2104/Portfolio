

In this case, I am a data analyst working for Cyclists, which is a fictional company in Chicago. Since its inception in 2016, Cyclists has grown to a fleet of 5,824 bicycles that are geotracked and locked into a network of 692 stations across Chicago. The bikes can be unlocked from one station and returned to any other station in the system anytime. There are two types of customers: casual riders and annual members.
I have been tasked to analyze how annual members and casual riders use Cylistic bikes differently based on a bike-share company’s data of its customer’s trip details from November 2020 to October 2021 to help the company maximize the number of annual memberships. 
The dataset used in this case study is actual public data made by Motivate International Inc. under this following link https://divvy-tripdata.s3.amazonaws.com/index.html.



create table one_year (
	ride_id varchar(255),
	rideable_type varchar (255),
	started_at varchar (255),
	ended_at varchar (255),
	start_station_name varchar (255),
	start_station_id varchar (255),
	end_station_name varchar (255),
	end_station_id varchar (255),
	member_casual varchar (255)
);


insert into
	one_year (ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, end_station_id, member_casual)

select ride_id, rideable_type, started_at, ended_at, start_station_name, cast(start_station_id as varchar(255)), end_station_name, cast(end_station_id as varchar(255)), member_casual
from dbo.['202011-divvy-tripdata$']
Union All

select ride_id, rideable_type, started_at, ended_at, start_station_name, cast(start_station_id as varchar(255)), end_station_name, cast(end_station_id as varchar(255)), member_casual
from dbo.['202012-divvy-tripdata$']
Union All

select ride_id, rideable_type, started_at, ended_at, start_station_name, cast(start_station_id as varchar(255)), end_station_name, cast(end_station_id as varchar(255)), member_casual
from dbo.['202101-divvy-tripdata$']
Union All

select ride_id, rideable_type, started_at, ended_at, start_station_name, cast(start_station_id as varchar(255)), end_station_name, cast(end_station_id as varchar(255)), member_casual
from dbo.['202102-divvy-tripdata$']
Union All

select ride_id, rideable_type, started_at, ended_at, start_station_name, cast(start_station_id as varchar(255)), end_station_name, cast(end_station_id as varchar(255)), member_casual
from dbo.['202103-divvy-tripdata$']
Union All

select ride_id, rideable_type, started_at, ended_at, start_station_name, cast(start_station_id as varchar(255)), end_station_name, cast(end_station_id as varchar(255)), member_casual
from dbo.['202104-divvy-tripdata$']
Union All

select ride_id, rideable_type, started_at, ended_at, start_station_name, cast(start_station_id as varchar(255)), end_station_name, cast(end_station_id as varchar(255)), member_casual
from dbo.['202105-divvy-tripdata$']
Union All

select ride_id, rideable_type, started_at, ended_at, start_station_name, cast(start_station_id as varchar(255)), end_station_name, cast(end_station_id as varchar(255)), member_casual
from dbo.['202106-divvy-tripdata$']
Union All

select ride_id, rideable_type, started_at, ended_at, start_station_name, cast(start_station_id as varchar(255)), end_station_name, cast(end_station_id as varchar(255)), member_casual
from dbo.['202107-divvy-tripdata$']
Union All

select ride_id, rideable_type, started_at, ended_at, start_station_name, cast(start_station_id as varchar(255)), end_station_name, cast(end_station_id as varchar(255)), member_casual
from dbo.['202108-divvy-tripdata$']
Union All

select ride_id, rideable_type, started_at, ended_at, start_station_name, cast(start_station_id as varchar(255)), end_station_name, cast(end_station_id as varchar(255)), member_casual
from dbo.['202109-divvy-tripdata$']
Union All

select ride_id, rideable_type, started_at, ended_at, start_station_name, cast(start_station_id as varchar(255)), end_station_name, cast(end_station_id as varchar(255)), member_casual
from dbo.['202110-divvy-tripdata$']
Union All


select *
from one_year


--Total number of trips taken during period Nov 2020 - Oct 2021
Select count(ride_id) as Total_Number_of_Trips_Taken
from one_year

--Calculate the percentage of trips taken of both users
SELECT member_casual, 
		COUNT(RIDE_ID) as Number_of_Trip,
		ROUND((COUNT(*) / CAST(SUM(COUNT(*)) over () as float)*100), 2) as Percentage_of_Number_of_Trip
from one_year
GROUP BY member_casual


--Calculate average daily ride length in minutes
SELECT 
Convert(date, started_at) as Date, AVG(datediff(minute, started_at, ended_at)) as AverageTime
from one_year
where member_casual = 'member'
group by Convert(date, started_at)  
order by Convert(date, started_at) 


SELECT 
Convert(date, started_at) as Date, AVG(datediff(minute, started_at, ended_at)) as AverageTime
from one_year
where member_casual = 'casual'
group by Convert(date, started_at)  
order by Convert(date, started_at) 


--Calculate average ride length
SELECT 
AVG(datediff(minute, started_at, ended_at)) as AverageRidingTimeofMemberUsers
from one_year
where member_casual = 'member'

select
AVG(datediff(minute, started_at, ended_at)) as AverageRidingTimeofCasualUsers
from one_year
where member_casual = 'casual'

SELECT 
AVG(datediff(minute, started_at, ended_at)) as AverageTime
from one_year


--Most 5 common starting station and ending station of casual users
select top (5)
start_station_name,
count (*)
from one_year
where start_station_name is not null
AND member_casual = 'casual'
group by start_station_name
order by count (*) desc

select top (5)
end_station_name,
count (*)
from one_year
where end_station_name is not null
AND member_casual = 'casual'
group by end_station_name
order by count (*) desc

--Most 5 common start stations and ending stations of member users
select top (5)
start_station_name,
count (*)
from one_year
where start_station_name is not null
AND member_casual = 'member'
group by start_station_name
order by count (*) desc

select top (5)
end_station_name,
count (*)
from one_year
where end_station_name is not null
AND member_casual = 'member'
group by end_station_name
order by count (*) desc

--Busiest day of the week  
SELECT count(ride_id) as NumberofRideTaken,
DATENAME(dw, started_at) as Day
from one_year
where member_casual = 'casual'
group by DATENAME(dw, started_at)
order by count(ride_id) desc

SELECT count(ride_id) as NumberofRideTaken,
DATENAME(dw, started_at) as Day
from one_year
where member_casual = 'member'
group by DATENAME(dw, started_at)
order by count(ride_id) desc


--Showing the preference for the rideable type for members and casuals
select
rideable_type,
count (*)
from one_year
where member_casual = 'casual'
group by rideable_type
order by count(*) desc


select
rideable_type,
count (*)
from one_year
where member_casual = 'member'
group by rideable_type
order by count(*) desc




