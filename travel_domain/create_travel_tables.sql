create table air_quality (
state_name VARCHAR(30),
county_name VARCHAR(30),
AQI INT(3),
Category VARCHAR(50),
defining_param VARCHAR(10),
day INT(2),
month INT(2),
year INT(4),
PRIMARY KEY (state_name, county_name, day, month, year)
);


create table cities (
city VARCHAR(50),
state_id VARCHAR(2),
state_name VARCHAR(30),
county_name VARCHAR(50),
lat DOUBLE,
lng DOUBLE,
population DOUBLE,	
density DOUBLE,
timezone VARCHAR(30),
zips LONGTEXT,
PRIMARY KEY (city, state_id, county_name)
);

create table flights (
ID INT(100) PRIMARY KEY,
PASSENGERS DOUBLE,
DISTANCE DOUBLE,
AIR_TIME DOUBLE,
UNIQUE_CARRIER_NAME LONGTEXT,
ORIGIN VARCHAR(3),
ORIGIN_CITY_NAME VARCHAR(50),
ORIGIN_STATE_ABR VARCHAR(2),
ORIGIN_STATE_NM VARCHAR(50),
ORIGIN_COUNTRY VARCHAR(3),
ORIGIN_COUNTRY_NAME VARCHAR(40),
DEST VARCHAR(3),
DEST_CITY_NAME VARCHAR(50),
DEST_STATE_ABR VARCHAR(2),
DEST_STATE_NM VARCHAR(50),
DEST_COUNTRY VARCHAR(3),
DEST_COUNTRY_NAME VARCHAR(40),
YEAR INT(4),
QUARTER INT(1),
MONTH INT(2)
);

create table gasoline (
state VARCHAR(30),
price_per_btu DOUBLE,
expenditures_mln_dlr DOUBLE,
year INT(4),
PRIMARY KEY (state,year)
);

create table public_transport (
name VARCHAR(100),
city VARCHAR(30),
state VARCHAR(30),
bus INT(9),
rail INT(9),
van INT(9),
cutaway INT(9),
automobile INT(9),
minivan INT(9),
trolleybus INT(9),
locomotive INT(9),
streetcar INT(9),
monorail INT(9),
cable_car INT(9),
ferryboat INT(9),
other INT(9),
total INT(9),
PRIMARY KEY (name,city,state)
);