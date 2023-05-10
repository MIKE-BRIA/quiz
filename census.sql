select *
from censusproject. .Data1


select *
from censusproject. .Data2

----total number of rows present in our dataset

select count(*) from censusproject. .Data1
select count(*) from censusproject. .Data2

---dataset for jharkhand and bihar

select *
from censusproject. .Data1
where state in ('jharkhand', 'bihar')
order by district 

---calculation of total population of india

select SUM(population) as totalpopulation
from censusproject. .data2

---average growth of india

select AVG(growth)*100 as peravggrowth
from censusproject. .Data1

---average growth by state

select state, AVG(growth)*100 as avg_growthperstate
from censusproject. .Data1
group by state
order by state

--average sex ratio per state

select state, round(AVG(sex_ratio),0) as avg_sexratio
from censusproject. .Data1
group by state
order by avg_sexratio desc

--average literacy rate

select state, round(AVG(cast(literacy as int)),0) as avg_literacy
from censusproject. .Data1
--where avg(literacy) > 80
group by State
order by avg_literacy asc

---average literacy rate above 70

select state, round(AVG(literacy),1) as avg_literacy
from censusproject. .Data1
group by state
having AVG(literacy)>70
order by avg_literacy asc

---top 3 state showing highest growth ratio

select top 3 state, round(AVG(growth),6)*100 as avg_growth
from censusproject. .Data1
group by state
order by avg_growth desc

---bottom 3 state showing lowest sex ratio

select top 3 state, round(avg(sex_ratio),1) as avg_sexratio
from censusproject. .Data1
group by State
order by avg_sexratio asc

---top and bottom 3 states in literacy state

--1. create a new table
--topstates

drop table if exists topstates
create table topstates
( state nvarchar(255),
  topstate float
  )

  insert into topstates
  select state, round(AVG(literacy),1)as avg_literacy
  from censusproject. .Data1
  group by state
  order by avg_literacy

  select top 3 * from topstates 
  order by topstates.topstate desc

  ---bottomstates

  drop table if exists bottomstates
  create table bottomstates
  (state nvarchar(255),
   bottomstate float
   )

   insert into bottomstates
   select state, round(AVG(literacy),1)as avg_literacy
   from censusproject. .Data1
   group by state

   select top 3 * from bottomstates
   order by bottomstate asc


---joining the topstates and bottomstates into one table(union operator)

select * from (
select top 3 * from bottomstates 
order by bottomstates. bottomstate asc)b

union

select * from (
select top 3 * from topstates
order by topstates.topstate desc)a


---filter states that start with the letter a

select distinct state from censusproject. .Data1
where lower(state) like 'a%'

---finding males and females per district
---1.use inner join

select a.district, a.state, a.sex_ratio, b.population
from censusproject. .Data1 a inner join censusproject. .Data2 b on a.district = b.district

---sex ratio = total number of females/total number of males
---females + males = population

--males = population / (sex ratio + 1)
--females = (population * sex ratio) / (sex ratio + 1)


select d.district, sum(d.males) as total_males, sum(d.females) as total_females from
(select c.district, c.state, round(c.population/(c.sex_ratio+1),0) as males, round((c.population*c.sex_ratio)/(c.sex_ratio+1),0) as females
from (select a.district, a.state,a.sex_ratio/1000 as sex_ratio,b.population 
from censusproject. .Data1 a inner join censusproject. .Data2 b on a.district=b.district)c)d
group by d.district