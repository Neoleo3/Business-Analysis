-- Task 1.1 -- Find the total number of employees
select * from employees;
select count(Distinct employeeNumber) as Number_of_Employees from employees;

-- Task 1.2 -- List all employees with their basic information
select employeeNumber, firstName , lastName, officeCode from employees;

-- Task 1.3 -- Count the number of employees holding each job title
select count(employeeNumber) as numberOfEmployees, jobTitle from employees group by jobTitle;

-- Task 1.4 -- Find the employees who don’t have a manager (reportsTo is NULL)
select employeeNumber, firstname, lastname from employees where reportsTo is NULL;

-- Task 1.5 -- Calculate total sales generated by each sales representative
select * from employees;
select* from customers;
select * from orderdetails;
select * from orders;
select e.employeeNumber, e.firstName, e.lastName, SUM(od.quantityOrdered * od.priceEach) as TotalSales
from employees e
join 
    customers c on e.employeeNumber = c.salesRepEmployeeNumber
join 
    orders o on c.customerNumber = o.customerNumber
join 
    orderdetails od on o.orderNumber = od.orderNumber
GROUP BY 
    e.employeeNumber, e.firstName, e.lastName;
    
-- Task 1.6 -- Find the most profitable sales representative based on total sales
select e.employeeNumber, e.firstName, e.lastName,
    sum(od.quantityOrdered * od.priceEach) as TotalSales
from employees e
join 
    customers c on e.employeeNumber = c.salesRepEmployeeNumber
join 
    orders o on c.customerNumber = o.customerNumber
join 
    orderdetails od on o.orderNumber = od.orderNumber
group by 
    e.employeeNumber, e.firstName, e.lastName
order by
    TotalSales desc
limit 1;

-- Task 1.7 -- Find the names of employees who have sold more than the average sales amount for their office

with EmployeeSales as ( select e.employeeNumber, e.firstName, e.lastName, e.officeCode, sum(od.quantityOrdered * od.priceEach) as TotalSales
from employees e
join customers c on e.employeeNumber = c.salesRepEmployeeNumber
join orders o on c.customerNumber = o.customerNumber
join orderdetails od on o.orderNumber = od.orderNumber
group by e.employeeNumber, e.firstName, e.lastName, e.officeCode
),
OfficeAverageSales as (
    select 
        e.officeCode,
        avg(sum(od.quantityOrdered * od.priceEach)) over (partition by e.officeCode) as AverageOfficeSales
    from 
        employees e
    join 
        customers c on e.employeeNumber = c.salesRepEmployeeNumber
    join 
        orders o on c.customerNumber = o.customerNumber
    join 
        orderdetails od on o.orderNumber = od.orderNumber
    group by 
        e.officeCode, e.employeeNumber
)
select 
    es.firstName,
    es.lastName,
    es.TotalSales,
    oas.AverageOfficeSales
from 
    EmployeeSales es
join 
    OfficeAverageSales oas
on 
    es.officeCode = oas.officeCode
where 
    es.TotalSales > oas.AverageOfficeSales;

-- Task 2.1-- Find the average order amount for each customer
select * from orderdetails;
select * from orders;
select * from customers;
select od.ordernumber, avg(od.quantityOrdered * od.priceEach) as Average_amounts, o.customerNumber, c.customerName from  orderdetails od 
join orders o on o.orderNumber=od.orderNumber
join customers c on c.customerNumber=o.customerNumber
group by ordernumber;

-- Task 2.2 -- Find the number of orders placed in each month
select month(orderDate) as month, count(orderNumber) as number_of_Orders from orders group by month;

-- Task 2.3 -- Identify orders that are still pending shipment (status = ‘Pending’)
select ordernumber, status from orders where status='Pending';

-- Task 2.4 -- List orders along with customer details
select o.ordernumber, o.customernumber, c.customername from orders o
join customers c on c.customerNumber=o.customerNumber;

-- task 2.5 -- Retrieve the most recent orders (based on order date)
select * from orders order by orderDate desc;

-- task 2.6-- Calculate total sales for each order
select orderNumber, sum(quantityOrdered * priceEach) as total_sales from orderdetails group by orderNumber;

-- Task 2.7 -- Find the highest-value order based on total sales
select orderNumber, sum(quantityOrdered * priceEach) as total_sales from orderdetails group by orderNumber order by total_sales desc limit 1;

-- Task 2.8 --  List all orders with their corresponding product details
select o.ordernumber, od.productCode, od.quantityOrdered, od.priceEach, od.orderLineNumber from orders o
join orderdetails od on o.ordernumber = od.orderNumber;

-- task 2.9 -- List the most frequently ordered products
select p.productCode, p.productName,
    sum(od.quantityOrdered) as TotalQuantityOrdered
from products p
join
    orderdetails od on p.productCode = od.productCode
group by p.productCode, p.productName
order by TotalQuantityOrdered desc;
    
-- Task 2.10 -- Calculate total revenue for each order
select * from orders;
select * from orderdetails;
select * from products;
select ordernumber, sum(quantityOrdered*priceEach) as Total_revenue from orderdetails group by ordernumber;

-- Task 2.11 --
select ordernumber, sum(quantityOrdered*priceEach) as Total_revenue from orderdetails group by ordernumber order by total_revenue desc limit 1;
 
-- Task 2.12 --
select od.ordernumber, od.productcode, p.productName, p.productline from orderdetails od
join products p on p.productCode=od.productCode
group by od.orderNumber, od.productCode, p.productName, p.productLine;

-- Task 2.13 --
select * from orders;
select orderNumber, shippeddate, requireddate from orders where shippeddate>requireddate;

-- Task 2.14 --
select * from orderdetails;
select 
    od1.productCode as Product1,
    od2.productCode as Product2,
    COUNT(*) as Frequency
from 
    orderdetails od1
join 
    orderdetails od2 on od1.orderNumber = od2.orderNumber
where 
    od1.productCode < od2.productCode  -- Avoid duplicate pairs and self-pairing
group by 
    od1.productCode, od2.productCode
order by 
    Frequency desc
limit 10;

-- Task 2.15 --
select * from orderdetails;
select ordernumber, sum(quantityOrdered * priceEach)  as Total_revenue  from orderdetails group by ordernumber limit 10;

-- task 2.16 --
select * from customers;
select * from orderdetails;
select * from orders;
 
delimiter \\
create trigger SettingCreditLimit
after insert on orderdetails
for each row
begin
declare total_Order_Ampount decimal (10,2);
set total_Order_Ampount = new.quantityOrdered*new.priceEach;
update customers set creditLimit = total_order_amount where customerNumber = (
        SELECT customerNumber 
        FROM orders 
        WHERE orders.orderNumber = NEW.orderNumber
    );
    end \\
    delimiter ;
drop trigger SettingCreditLimit;

INSERT INTO orderdetails (orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber)
VALUES (10101, 'S10_1949', 5, 50.00, 4);
select * from orderdetails where orderlinenumber=4;

-- Task 2.17 --
select * from orderdetails;
select * from products;

delimiter \\
create trigger Update_Product_Quantity_Insert
AFTER INSERT ON orderdetails
for each row
begin
update products set quantityStock = quantityStock - new.quantityOrdered
where products.productcode=new.productcode;
end \\
delimiter ;

delimiter \\
create trigger Update_Product_Quantity_update
AFTER update ON orderdetails
for each row
begin
update products set quantityStock = quantityStock - new.quantityOrdered
where products.productcode=new.productcode;
end \\
delimiter ;

