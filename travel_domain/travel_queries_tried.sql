select DISTINCT avg_gallons_by_state.state, avg_aqi_by_state.avg_aqi, (avg_gallons_by_state.avg_gallons/total_residents.total) as gas_per_person, pt_count, avg_dens
from (
		select aq.state_name, avg(AQI) as avg_aqi
		from air_quality as aq, (select distinct state_name from cities) as states
		where states.state_name = aq.state_name group by aq.state_name
	) as avg_aqi_by_state,
	(
		select g.state, round(avg((g.expenditures_mln_dlr/(g.price_per_btu/8.31)*1000000))) as avg_gallons
		from gasoline as g group by state
	) as avg_gallons_by_state,
	(
		select state, count(total) as pt_count from public_transport group by state
	) as public_transport_by_state,
	cities,
	total_residents,
	(select state_name, round(avg(density)) as avg_dens from cities group by state_name order by avg_dens desc) as state_density
where avg_gallons_by_state.state = avg_aqi_by_state.state_name
and public_transport_by_state.state = cities.state_id
and cities.state_name = avg_aqi_by_state.state_name
and cities.state_name = state_density.state_name
and total_residents.location = cities.state_name
order by avg_dens desc;


select state_name, count(departures.state), count(arrivals.state) from (select ORIGIN_STATE_NM as state from flights limit 0,10000) as departures, (select DEST_STATE_NM as state from flights limit 0,10000) as arrivals, cities where arrivals.state = state_name and departures.state = state_name group by state_name;

select DISTINCT avg_gallons_by_state.state, avg_aqi_by_state.avg_aqi, (avg_gallons_by_state.avg_gallons/total_residents.total) as gas_per_person, pt_count
from (
		select aq.state_name, avg(AQI) as avg_aqi
		from air_quality as aq, (select distinct state_name from cities) as states
		where states.state_name = aq.state_name group by aq.state_name
	) as avg_aqi_by_state,
	(
		select g.state, round(avg((g.expenditures_mln_dlr/(g.price_per_btu/8.31)*1000000))) as avg_gallons
		from gasoline as g group by state
	) as avg_gallons_by_state,
	(
		select state, count(total) as pt_count from public_transport group by state
	) as public_transport_by_state,
	cities,
	total_residents
where avg_gallons_by_state.state = avg_aqi_by_state.state_name
and public_transport_by_state.state = cities.state_id
and cities.state_name = avg_aqi_by_state.state_name
and total_residents.location = cities.state_name
order by gas_per_person desc;

select distinct arrivals.state , (arrivals.flights+departures.flights) as flights, avg_dens, wages.avg, avg_aqi_by_state.avg_aqi, total_residents.total from
(select ORIGIN_STATE_NM, YEAR as state, count(*) as flights from flights group by ORIGIN_STATE_NM, YEAR) as arrivals,
(select DEST_STATE_NM, YEAR as state, count(*) as flights from flights group by DEST_STATE_NM, YEAR) as departures,
(select aq.state_name, avg(AQI) as avg_aqi
from air_quality as aq, (select distinct state_name from cities) as states
where states.state_name = aq.state_name group by aq.state_name) as avg_aqi_by_state,
(select state_name, avg(mean) as avg from wages group by state_name) as wages,
(select state_name, round(avg(density)) as avg_dens from cities group by state_name order by avg_dens desc) as state_density,
total_residents,
cities
where arrivals.state = departures.state
and cities.state_name = arrivals.state
and cities.state_name = avg_aqi_by_state.state_name
and cities.state_name = state_density.state_name
and wages.state_name = cities.state_name
and total_residents.location = cities.state_name
order by avg_aqi_by_state.avg_aqi desc;






########### flights vs population
select distinct avg_flights.state , avg_flights.flights, total_residents.total from
(select flights_years.state as state, round(avg(flights_count)) as flights
from (select arrivals.state, arrivals.year, arrivals.flights+departures.flights as flights_count
from  (select ORIGIN_STATE_NM as state, YEAR as year, count(*) as flights
from flights group by ORIGIN_STATE_NM, YEAR) as arrivals,
(select DEST_STATE_NM as state, YEAR as year, count(*) as flights
from flights group by DEST_STATE_NM, YEAR) as departures 
where arrivals.state = departures.state and arrivals.year = departures.year) as flights_years
group by flights_years.state) as avg_flights,
total_residents
where avg_flights.state = total_residents.location
order by total_residents.total;


select county_aqi.state_name, county_aqi.county_name, avg_aqi, avg_dens from
(select state_name, county_name, avg(AQI) as avg_aqi, year from air_quality group by state_name, county_name) as county_aqi,
(select state_name, county_name, density as avg_dens from cities group by state_name, county_name) as county_dens
where county_aqi.state_name=county_dens.state_name
and county_aqi.county_name=county_dens.county_name
order by avg_aqi;


select county_aqi.state_name, county_aqi.county_name, avg_aqi, county_population from
(select state_name, county_name, avg(AQI) as avg_aqi, year from air_quality group by state_name, county_name) as county_aqi,
(select state_name, county_name, sum(population) as county_population from cities group by state_name, county_name) as county_pop
where county_aqi.state_name=county_pop.state_name
and county_aqi.county_name=county_pop.county_name
order by avg_aqi;

select county_aqi.state_name, county_aqi.county_name, avg_aqi, county_population from
(select state_name, county_name, avg(AQI) as avg_aqi, year from air_quality group by state_name, county_name) as county_aqi,
(select state_name, county_name, sum(population) as county_population from cities group by state_name, county_name) as county_pop
where county_aqi.state_name=county_pop.state_name
and county_aqi.county_name=county_pop.county_name
order by avg_aqi;


select stats.state_name, stats.county_name, round(avg(count)) from
(select state_name, county_name, count(*) as count, year from air_quality where AQI > 150 group by state_name, county_name, year) as stats
group by state_name, county_name, year;

############################################
select stat.state_name, stat.county_name, round(avg(count)) as ccount
from (select state_name, county_name, count(*) as count, year
from air_quality where AQI > 50 and year > 2015
group by state_name, county_name, year) as stat
group by state_name, county_name
having ccount > 182;


#############
# air vs population
select bad_days.state_name, bad_days.county_name, dcount, county_population from
(select stat.state_name, stat.county_name, round(avg(count)) as dcount
from (select state_name, county_name, count(*) as count, year
from air_quality where AQI > 50 and year > 2015
group by state_name, county_name, year) as stat
group by state_name, county_name) as bad_days,
(select state_name, county_name, sum(population) as county_population from cities group by state_name, county_name) as county_pop
where bad_days.state_name=county_pop.state_name
and bad_days.county_name=county_pop.county_name
order by dcount;
