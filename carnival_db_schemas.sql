create table Dealerships (
  dealership_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  business_name VARCHAR(50),
  phone VARCHAR(50),
  city VARCHAR(50),
  state VARCHAR(50),
  website VARCHAR(1000),
  tax_id VARCHAR(50)
);

create table Customers (
  customer_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(50),
  phone VARCHAR(50),
  street VARCHAR(50),
  city VARCHAR(50),
  state VARCHAR(50),
  zipcode VARCHAR(50),
  company_name VARCHAR(50)
);

create table EmployeeTypes (
  employee_type_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  employee_type_name VARCHAR(20)
);

create table Employees (
  employee_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email_address VARCHAR(50),
  phone VARCHAR(50),
  employee_type_id INT,
  FOREIGN KEY (employee_type_id) REFERENCES EmployeeTypes (employee_type_id)
);

create table DealershipEmployees (
  dealership_employee_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  dealership_id INT,
  employee_id INT,
  FOREIGN KEY (employee_id) REFERENCES Employees (employee_id),
  FOREIGN KEY (dealership_id) REFERENCES Dealerships (dealership_id)
);

create table SalesTypes (
  sales_type_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  sales_type_name VARCHAR(8)
);

create table VehicleBodyType(
	vehicle_body_type_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	name VARCHAR(64)
);

create table VehicleModel(
	vehicle_model_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	name VARCHAR(64)
);

create table VehicleMake(
	vehicle_make_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	name VARCHAR(64)
);

create table VehicleTypes (
  vehicle_type_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  body_type VARCHAR(5),
  make VARCHAR(50),
  model VARCHAR(50)
);

alter table vehicletypes add column vehicle_body_type_id int
alter table vehicletypes add column vehicle_model_id int
alter table vehicletypes add column vehicle_make_id int

alter table vehicletypes 
add constraint vehicletypes_vehiclebodytypes
	FOREIGN KEY (vehicle_body_type_id) REFERENCES VehicleBodyType (vehicle_body_type_id)

alter table vehicletypes 
add constraint vehicletypes_vehiclemake
	FOREIGN KEY (vehicle_make_id) REFERENCES VehicleMake (vehicle_make_id)

alter table vehicletypes 
add constraint vehicletypes_vehiclemodel
	FOREIGN KEY (vehicle_model_id) REFERENCES VehicleModel (vehicle_model_id)

update vehicletypes
set vehicle_make_id = 
(select vehicle_make_id 
from vehiclemake where vehiclemake.name = vehicletypes.make);

update vehicletypes
set vehicle_model_id = 
(select vehicle_model_id 
from vehiclemodel where vehiclemodel.name = vehicletypes.model);

update vehicletypes
set vehicle_body_type_id = 
(select vehicle_body_type_id  
from vehiclebodytype where vehicleBodyType.name = vehicletypes.body_type);

alter table vehicletypes 
drop column body_type, 
drop column make, 
drop column model;

create table Vehicles (
  vehicle_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  vin VARCHAR(50),
  engine_type VARCHAR(2),
  vehicle_type_id INT,
  exterior_color VARCHAR(50),
  interior_color VARCHAR(50),
  floor_price INT,
  msr_price INT,
  miles_count INT,
  year_of_car INT,
  is_sold boolean,
  is_new boolean,
  dealership_location_id int,
  FOREIGN KEY (vehicle_type_id) REFERENCES VehicleTypes (vehicle_type_id),
  FOREIGN KEY (dealership_location_id) REFERENCES Dealerships (dealership_id)
);

create table Sales (
  sale_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  sales_type_id INT,
  vehicle_id INT,
  employee_id INT,
  customer_id INT,
  dealership_id INT,
  price DECIMAL(8, 2),
  deposit INT,
  purchase_date DATE,
  pickup_date DATE,
  invoice_number VARCHAR(50),
  payment_method VARCHAR(50),
  sale_returned boolean,
  FOREIGN KEY (sales_type_id) REFERENCES SalesTypes (sales_type_id),
  FOREIGN KEY (vehicle_id) REFERENCES Vehicles (vehicle_id),
  FOREIGN KEY (employee_id) REFERENCES Employees (employee_id),
  FOREIGN KEY (customer_id) REFERENCES Customers (customer_id),
  FOREIGN KEY (dealership_id) REFERENCES Dealerships (dealership_id)
);

create table OilChangeLogs (
  oil_change_log_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  date_occured timestamp with time zone,
  vehicle_id int,
  FOREIGN KEY (vehicle_id) REFERENCES Vehicles (vehicle_id)
);

create table RepairTypes (
  repair_type_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  repair_type_name VARCHAR(50)
);

create table CarRepairTypeLogs (
  car_repair_type_log_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  date_occured timestamp with time zone,
  vehicle_id int,
  repair_type_id INT,
  FOREIGN KEY (vehicle_id) REFERENCES Vehicles (vehicle_id),
  FOREIGN KEY (repair_type_id) REFERENCES RepairTypes (repair_type_id)
);

select * from Vehicles;

select
	v.engine_type,
	v.floor_price,
	v.msr_price
from Vehicles v

select 
	d.business_name,
	d.city,
	d.state,
	d.website
from dealerships d; 

select 
	c.first_name,
	c.last_name,
	c.email
from customers c; 

select *
from sales 
where sales_type_id = 2;

select *
from sales s 
where s.purchase_date between '2018-01-01' and '2023-03-20'

select
s.customer_id, 
s.deposit, 
s.payment_method 
from sales s 
where s.deposit > 5000 or s.payment_method like 'American Express'
order by s.deposit ASC 

select 
	e.first_name
from employees e 
where first_name like 'M%' or first_name  like '%d'
order by first_name asc;

select 
	e.first_name,
	e.phone
from employees e 
where phone like '604%';

select 
	s.employee_id,
	s.customer_id,
	s.price,
	s2.name
from sales s 
right join salestypes s2
ON s.sales_type_id = s2.sales_type_id
order by name ASC

select 
	v.vin,
	concat(c.first_name, ' ', c.last_name) as CUSTOMER_NAME,
	concat(e.first_name, ' ', e.last_name) as EMPLOYEE_NAME,
	d.business_name,
	d.city,
	d.state
from sales s 
left join vehicles v
on s.vehicle_id = v.vehicle_id 
left join customers c
on s.customer_id = c.customer_id 
left join employees e 
on s.employee_id = e.employee_id 
left join dealerships d
on s.dealership_id = d.dealership_id

select 
	d.business_name,
	e.first_name,
	e.last_name
from dealershipemployees d2
left join dealerships d 
on d2.dealership_id = d.dealership_id 
left join employees e 
on d2.employee_id = e.employee_id
order by d.business_name asc;

select 
	v.vin,
	bt.name as body_type_name,
	ma.name as make_name,
	mo.name as model_name
from vehicles v
left join vehicletypes v2 
on v2.vehicle_type_id = v2.vehicle_type_id 
left join vehiclebodytype bt
on v2.vehicle_body_type_id = bt.vehicle_body_type_id 
left join vehiclemake ma
on v2.vehicle_make_id  = ma.vehicle_make_id
left join vehiclemodel mo
on v2.vehicle_model_id = mo.vehicle_model_id

-- Find employees who haven't made any sales and the name of the dealership they work at.
SELECT
    e.first_name,
    e.last_name,
    d.business_name,
    s.price
FROM employees e
INNER JOIN dealershipemployees de ON e.employee_id = de.employee_id
INNER JOIN dealerships d ON d.dealership_id = de.dealership_id
LEFT JOIN sales s ON s.employee_id = e.employee_id
WHERE s.price IS NULL;


-- Get all the departments in the database,
-- all the employees in the database and the floor price of any vehicle they have sold.
SELECT
    d.business_name,
    e.first_name,
    e.last_name,
    v.floor_price
FROM dealerships d
LEFT JOIN dealershipemployees de ON d.dealership_id = de.dealership_id
INNER JOIN employees e ON e.employee_id = de.employee_id
INNER JOIN sales s ON s.employee_id = e.employee_id
INNER JOIN vehicles v ON s.vehicle_id = v.vehicle_id;

-- Use a self join to list all sales that will be picked up on the same day,
-- including the full name of customer picking up the vehicle. .
SELECT
    CONCAT  (c.first_name, ' ', c.last_name) AS last_name,
    s1.invoice_number,
    s1.pickup_date
FROM sales s1
INNER JOIN sales s2
    ON s1.sale_id <> s2.sale_id 
    AND s1.pickup_date = s2.pickup_date
INNER JOIN customers c
   ON c.customer_id = s1.customer_id;
  
-- Get employees and customers who have interacted through a sale.
-- Include employees who may not have made a sale yet.
-- Include customers who may not have completed a purchase.

SELECT
    e.first_name AS employee_first_name,
    e.last_name AS employee_last_name,
    c.first_name AS customer_first_name,
    c.last_name AS customer_last_name
FROM employees e
FULL OUTER JOIN sales s ON e.employee_id = s.employee_id
FULL OUTER JOIN customers c ON s.customer_id = c.customer_id;

-- Get a list of all dealerships and which roles each of the employees hold.
SELECT
    d.business_name,
    et.name
FROM dealerships d
LEFT JOIN dealershipemployees de ON d.dealership_id = de.dealership_id
INNER JOIN employees e ON de.employee_id = e.employee_id
RIGHT JOIN employeetypes et ON e.employee_type_id = et.employee_type_id;

-- Get a list of every dealership, the number of purchases done by each, and number of lases done by each.
select 
	d.business_name,
	COUNT (s2.sales_type_name) count_of_sold
from dealerships d 
left join sales s
on d.dealership_id = s.dealership_id 
left join salestypes s2
on s.sales_type_id = s2.sales_type_id
where s2.sales_type_name = 'Lease'
group by business_name;

select 
	d.business_name,
	count(distinct s1.sale_id) purchases,
	count(distinct s2.sale_id) leases
from dealerships d 
inner join sales s1 --purchases
on d.dealership_id = s1.dealership_id 
inner join sales s2 --leases
on d.dealership_id = s2.dealership_id
where s2.sales_type_id = 2 and s1.sales_type_id = 1
group by d.business_name 



-- a report that determines the most popular vehicle model that is leased
-- first have a list of the vehicles models
--then join the vehicles that were leased
--then count the times each model was leaseed
--then pick the max count that mas leased from the models

--Leased Type

select
	vm."name",
	count(distinct s.sale_id) as leased_sales
from vehicles v
	left join sales s
	on v.vehicle_id = s.vehicle_id 
	left join vehicletypes vt
	on v.vehicle_type_id = vt.vehicle_type_id
	inner join vehiclemodel vm 
	on vt.vehicle_model_id = vm.vehicle_model_id
	where s.sales_type_id = 2
	group by vm."name"
	order by leased_sales desc
	limit 1
	
--What is the most popular vehicle make in terms of number of sales?
	
select 
	vm."name",
	COUNT(distinct s.sale_id) as sales_interms_ofmake
from sales s 
	left join vehicles v ON v.vehicle_id = s.vehicle_id  
	left join vehicletypes vt on v.vehicle_type_id = vt.vehicle_type_id
	left join vehiclemake vm on vt.vehicle_make_id = vm.vehicle_make_id 
	group by vm.vehicle_make_id
	order by sales_interms_ofmake desc 
	limit 1

	
--Which employee type sold the most of that make?
select 
	vm."name",
	e.first_name,
	e.last_name, 
	COUNT(distinct s.employee_id) as sales_interms_of_employee
from sales s 
	left join vehicles v ON v.vehicle_id = s.vehicle_id 
	left join employees e on s.employee_id = e.employee_id 
	left join vehicletypes vt on v.vehicle_type_id = vt.vehicle_type_id
	left join vehiclemake vm on vt.vehicle_make_id = vm.vehicle_make_id 
--	group by vm.vehicle_make_id 
--	order by sales_interms_of_employee desc 
-- getting an error with vm.same must appear in group by clause
	
	
	
	







