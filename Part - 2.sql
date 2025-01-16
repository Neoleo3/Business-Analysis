-- Task 1.1 --Identified the top 10 customers by credit limit to highlight high-value clients.
select customerNumber, customerName, creditLimit from customers order by creditLimit desc;

-- Task 1.2--2. Calculated the average credit limit per country to understand regional purchasing power
select avg(creditLimit) as average_Credit_Limit, country from customers group by country;

-- Task 1.3 --Counted the number of customers in each state for geographic distribution insights.
select count(customerNumber) as Number_Of_Customers, state from customers group by state;

-- Task 1.4 --Identified customers without orders to target potential engagement strategies.
select * from customers;
select * from orderdetails;
select * from orders;
select customers.customerNumber, customers.customerName from customers
left join orders o on customers.customerNumber=o.customerNumber where o.customerNumber is null;

-- Task 1.5 --Summed total sales per customer to evaluate individual contribution to revenue
SELECT 
    c.customerNumber, 
    c.customerName, 
    o.orderNumber, 
    SUM(od.quantityOrdered * od.priceEach) AS Total_Amount
FROM 
    customers c
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY 
    c.customerNumber, 
    c.customerName, 
    o.orderNumber;

-- Task 1.6 --Mapped customers to sales representatives for relationship tracking and analysis.
select * from customers;
select * from orderdetails;
select * from orders;
select * from employees;
select c.customerName, concat(e.firstname,' ',e.lastname) as Sales_representative from customers c join employees e on c.salesRepEmployeeNumber=e.employeeNumber;


-- Task 1.7 --Retrieved recent payment details for understanding timely transactions.
select * from customers;
select * from payments;
select c.customerNumber, c.customerName, p.checkNumber, p.paymentDate, p.amount from customers c
join payments p on c.customerNumber=p.customerNumber;

-- Task 1.8 --Flagged customers exceeding credit limits to mitigate financial risks.
select c.customerNumber, c.customerName, SUM(od.quantityOrdered * od.priceEach) AS Total_Amount from customers c
join orders o on c.customerNumber = o.customerNumber
join orderdetails od ON o.orderNumber = od.orderNumber
group by  c.customerNumber, c.customerName
having Total_Amount > c.creditLimit;

-- Task 1.9--Listed customers who ordered from specific product lines for targeted marketing.
select * from orders;
select * from productlines;
select * from products;
select * from orderdetails;
select * from customers;
SELECT 
    DISTINCT c.customerName
FROM 
    customers c
JOIN 
    orders o ON c.customerNumber = o.customerNumber
JOIN 
    orderdetails od ON o.orderNumber = od.orderNumber
JOIN 
    products p ON od.productCode = p.productCode
WHERE 
    p.productLine = 'Classic Cars';

-- Task 1.10 --  Found customers who purchased the most expensive product to analyze premium buyers
SELECT 
    o.orderNumber, 
    c.customerName 
FROM 
    orders o
JOIN 
    customers c ON o.customerNumber = c.customerNumber
join 
   orderdetails od ON o.orderNumber = od.orderNumber
WHERE 
    od.productCode = (SELECT productCode FROM products ORDER BY MSRP DESC LIMIT 1);
    
-- Task 2.1 -- Counted employees per office to gauge workforce distribution.
select * from offices;
select * from employees;
select count(employeeNumber) as Number_Of_Employees, officeCode from employees group by officeCode;

-- Task 2.2 -- Identified offices with fewer employees to detect understaffed locations.
SELECT 
    officeCode, 
    COUNT(employeeNumber) AS number_Of_employees 
FROM 
    employees 
GROUP BY 
    officeCode 
HAVING 
    COUNT(employeeNumber) < 4;
    
-- Task 2.3 -- Listed offices with their territories to analyze operational coverage.
select * from offices;
select officeCode, territory from offices;

-- Task 2.4 -- Found offices without employees to assess resource allocation inefficiencies.
select * from employees;
select * from offices;
select o.officeCode from offices o
left join employees e on o.officeCode=e.officeCode
where e.employeeNumber is null;

-- Task 2.5 -- Identified the most profitable office by sales to evaluate performance.
select * from orders;
select * from productlines;
select * from products;
select * from orderdetails;
select * from customers;
SELECT 
    o.officeCode,
    o.city,
    o.country,
    SUM(od.quantityOrdered * od.priceEach) AS total_sales
FROM
    offices o
JOIN
    employees e ON o.officeCode = e.officeCode
JOIN
    customers c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN
    orders r ON c.customerNumber = r.customerNumber
JOIN
    orderdetails od ON r.orderNumber = od.orderNumber
WHERE
    r.status = 'Shipped'
GROUP BY
    o.officeCode, o.city, o.country
ORDER BY
    total_sales DESC
LIMIT 1;

-- Task 2.6 -- Highlighted the office with the most employees for workforce management.
select * from employees;
select officeCode, count(employeeNumber) as Number_of_Employees from employees 
group by officeCode
order by number_of_employees desc 
limit 1; 

-- Task 2.7-- Calculated the average customer credit limit for offices to compare customer profiles
select * from customers;
SELECT 
    o.officeCode,
    o.city,
    o.country,
    AVG(c.creditLimit) AS average_credit_limit
FROM
    offices o
JOIN
    employees e ON o.officeCode = e.officeCode
JOIN
    customers c ON e.employeeNumber = c.salesRepEmployeeNumber
GROUP BY
    o.officeCode, o.city, o.country
ORDER BY
    average_credit_limit DESC;
    
    -- Task 3.1 --Counted products in each product line to understand catalog diversity.
select * from products;
select count(productCode) as number_of_products, productline from products 
group by productLine;

-- Task 3.2 --Found the product line with the highest average price for premium segmentation.
select productline, avg(buyPrice) as Highest_Average_Price from products group by productline 
order by Highest_average_Price desc
limit 1;

-- Task 3.3 -- Filtered products based on price thresholds to analyze affordability.
select productCode, productName, productLine, MSRP from products where MSRP between 50 and 100 order by MSRP;

-- Task 3.4 -- Summed sales for each product line to identify top performers.
select * from orderdetails;
select od.productCode, sum(od.quantityOrdered*od.priceEach) as total_amount, products.productname as product_name from orderdetails od 
join products on products.productcode = od.productCode
group by od.productCode;

-- task 3.5 -- Flagged products with low inventory for replenishment strategies.
select * from products;
select productCode, productName, productline from products where quantityInStock < 10;

-- Task 3.6 -- Retrieved the most expensive product for luxury market analysis.
select productCode, productName, MSRP from products
 order by MSRP
 desc limit 1;
 
 -- Task 3.7 -- Summed sales per product for individual performance insights
 select * from orderdetails;

 select od.productCode, p.productline, sum(od.quantityOrdered*od.priceEach) as Total_amount from orderdetails od
 join products p on od.productCode=p.productCode
 group by productCode;
 
 -- Task 3.8 --  Identified top-selling products based on quantity to optimize stock levels.
 DELIMITER \\
CREATE PROCEDURE GetTopSellingProducts(IN topN INT)
BEGIN
    SELECT 
        p.productCode,
        p.productName,
        SUM(od.quantityOrdered) AS total_quantity
    FROM 
        products p
    JOIN 
        orderdetails od ON p.productCode = od.productCode
    GROUP BY 
        p.productCode, p.productName
    ORDER BY 
        total_quantity DESC
    LIMIT 
        topN;
END \\
DELIMITER ;

-- Task 3.9 -- Retrieved low-stock products in specific lines for targeted restocking.
select * from products;
select productCode, productName, quantityInStock from products 
where quantityInStock < 10 and productLine in ('Motorcycles','Classic Cars');

-- Task 3.10 -- Listed products ordered by more than 10 customers to find popular items.
select * from orderdetails;
select * from orders;
SELECT 
    p.productName,
    COUNT(DISTINCT o.customerNumber) AS customer_count
FROM 
    products p
JOIN 
    orderdetails od ON p.productCode = od.productCode
JOIN 
    orders o ON od.orderNumber = o.orderNumber
GROUP BY 
    p.productCode, p.productName
HAVING 
    customer_count > 10;
    
-- Task 3.11 -- Found products ordered above the average number of times to assess bestsellers.
WITH ProductOrders AS (
    SELECT 
        p.productLine,
        p.productCode,
        p.productName,
        COUNT(od.orderNumber) AS order_count
    FROM 
        products p
    JOIN 
        orderdetails od ON p.productCode = od.productCode
    GROUP BY 
        p.productLine, p.productCode, p.productName
),
AverageOrders AS (
    SELECT 
        productLine,
        AVG(order_count) AS avg_orders
    FROM 
        ProductOrders
    GROUP BY 
        productLine
)
SELECT 
    po.productName,
    po.productLine,
    po.order_count,
    ao.avg_orders
FROM 
    ProductOrders po
JOIN 
    AverageOrders ao ON po.productLine = ao.productLine
WHERE 
    po.order_count > ao.avg_orders;

