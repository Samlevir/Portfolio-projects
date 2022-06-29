use [Portfolio Project ]
select * from ['new-vehicles-type-area$']
Where code is not null
order by 3, 4

select * from ['fuel-efficiency-new-vehicles$']
order by 3, 4


select Country, Y, Electric_battery_amt, petrol_use
from ['new-vehicles-type-area$']
order by 1,2 

-- Looking at total petrol_use vs. diesel_use
-- Comparing Petrol and Diesel use in 2019

select Country, Y, petrol_use, diesel_use, (petrol_use/diesel_use)*100 AS PetrolUse
from ['new-vehicles-type-area$']
--Where Y = 2019
Where code is not null
order by 1,2 

-- Total Petrol use in Italy


select sum(Petrol_use) as Gas
from ['new-vehicles-type-area$']
where country = 'Italy' 

-- Looking at Countries with Highest Petrol use compared to Diesel use

select Country, Y, MAX(Petrol_use) AS Highest_Petroluse, MAX((Petrol_use/Diesel_use))*100 AS PercentPetroluse
from ['new-vehicles-type-area$']
--Where Y = 2019
Where code is not null
group by country, Y
order by PercentPetroluse desc

-- showing the countries with the highest amount of electric battery usage

select Country, Y, MAX(cast(Electric_battery_amt as int)) AS Highest_electric_batteryuse
from ['new-vehicles-type-area$']
--Where Y = 2019
Where code is not null
group by country, Y
order by Highest_electric_batteryuse desc

-- showing the countries with highest Diesel_use

select Country, Y, MAX(cast(Diesel_use as int)) AS Highest_Diesel_Use
from ['new-vehicles-type-area$']
--Where Y = 2019
Where code is not null
group by country, Y
order by Highest_Diesel_Use desc

-- Total Numbers

select max( Electric_battery_amt) as Electric_cars, max(Plugin_hybrid_amt) as Hybrid_cars, max(Full_mild_hybrid_amt) as Mild_hybrids, max(Petrol_use) as Gas_cars, max(Diesel_use) as Diesel_cars
from ['new-vehicles-type-area$']
Where Country in (select distinct Country from ['new-vehicles-type-area$'] where Code is not null)
--group by country

-- Total Number by Country

select Country,  max( Electric_battery_amt) as Electric_cars, max(Plugin_hybrid_amt) as Hybrid_cars, max(Full_mild_hybrid_amt) as Mild_hybrids, max(Petrol_use) as Gas_cars, max(Diesel_use) as Diesel_cars
from ['new-vehicles-type-area$']
Where Country in (select distinct Country from ['new-vehicles-type-area$'] where Code is not null)
group by country

-- Total electric Cars vs total fuel effciency

select nvt.Country, nvt.Y, nvt.Electric_battery_amt, fev.Fuel_Efficiency_perkm
,SUM(Convert(int,nvt.Electric_battery_amt)) over (partition by nvt.country order by nvt.country, nvt.Y) as Rolling_Electriccars
--,(Rolling_Electriccars/Fuel_Efficiency_perkm)*100
from ['new-vehicles-type-area$'] as nvt
join ['fuel-efficiency-new-vehicles$'] as fev
on nvt.Country = fev.Country and nvt.Y = fev.Y
where nvt.Code is not null
order by 1,2,3



-- USE CTE 
With ElectricCarvsEfficiency (Country, Y, Electric_battery_amt, Fuel_efficiency_perkm, Rolling_Electriccars)
as
(
select nvt.Country, nvt.Y, nvt.Electric_battery_amt, fev.Fuel_Efficiency_perkm
, SUM(Convert(int,nvt.Electric_battery_amt)) over (partition by nvt.country order by nvt.country, nvt.Y) as Rolling_Electriccars
from ['new-vehicles-type-area$'] as nvt
join ['fuel-efficiency-new-vehicles$'] as fev
on nvt.Country = fev.Country and nvt.Y = fev.Y
where nvt.Code is not null
--Order by 1,2,3
)
select *
from ElectricCarvsEfficiency






-- Temp Table


drop table if exists #Total_electric_Carsvstotal_fuel_effciency
Create Table #Total_electric_Carsvstotal_fuel_effciency
(
Country nvarchar (255),  
Year int, 
Electric_battery_amt int,
Fuel_efficiency_perkm float, 
Rolling_Electriccars numeric
)

Insert into #Total_electric_Carsvstotal_fuel_effciency
select nvt.Country, nvt.Y, nvt.Electric_battery_amt, fev.Fuel_Efficiency_perkm
, SUM(Convert(int,nvt.Electric_battery_amt)) over (partition by nvt.country order by nvt.country, nvt.Y) as Rolling_Electriccars
from ['new-vehicles-type-area$'] as nvt
join ['fuel-efficiency-new-vehicles$'] as fev
on nvt.Country = fev.Country and nvt.Y = fev.Y
where nvt.Code is not null
--Order by 1,2,3

select *
from #Total_electric_Carsvstotal_fuel_effciency


-- Creating view for later visulizations 

Create view Totals as
select Country,  max( Electric_battery_amt) as Electric_cars, max(Plugin_hybrid_amt) as Hybrid_cars, max(Full_mild_hybrid_amt) as Mild_hybrids, max(Petrol_use) as Gas_cars, max(Diesel_use) as Diesel_cars
from ['new-vehicles-type-area$']
Where Country in (select distinct Country from ['new-vehicles-type-area$'] where Code is not null)
group by country


























