-- Covid 19 Data Exploration Project
-- Selecting Covid19 Deaths Data


select location, date, total_cases, new_cases, total_deaths, population
from Covid19_DE..deaths
order by 1,2


-- Total Cases vs Total Deaths
-- Displays the chances of passing away after contracting covid

select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from Covid19_DE..deaths
where location like '%india%'
order by 1,2

-- Total Cases vs Population
-- Displays the number of people infected with the disease

select location, date, Population, total_cases,  (total_cases/population)*100 as Percent_Population_Infected
from Covid19_DE..deaths
order by 1,2


-- Countries with Highest Infection Rate with respect to Population

select location, population, MAX(total_cases) as Highest_Infection_Count,  Max((total_cases/population))*100 as Percent_Population_Infected
from Covid19_DE..deaths
group by location, population
order by Percent_Population_Infected desc


-- Countries with Highest Death Count per Population

select location, MAX(cast(Total_deaths as int)) as Total_Death_Count
from Covid19_DE..deaths 
group by Location
order by Total_Death_Count desc

-- Displaying continents with the highest death count per population

select continent, MAX(cast(Total_deaths as int)) as Total_Death_Count
from Covid19_DE..deaths 
where continent is not null 
group by continent
order by Total_Death_Count desc

-- Global death percentage

select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as Death_Percentage
from Covid19_DE..deaths 
where continent is not null 
order by 1,2


-- Displaying Percentage of Population that has recieved at least one Covid Vaccine

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as Rolling_People_Vaccinated
from Covid19_DE..deaths dea
Join Covid19_DE..vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- Using CTE on the previous query
with PopvsVac (Continent, Location, Date, Population, New_Vaccinations, Rolling_People_Vaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as Rolling_People_Vaccinated
from Covid19_DE..deaths dea
Join Covid19_DE..vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
select *, Rolling_People_Vaccinated/Population as Percentage_Vac
From PopvsVac



