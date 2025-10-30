#1 Total sales
select round(sum(quantityOrdered * priceEach),2) as total_sales
from orderdetails;

#2 Monthly sales trends
select date_format(orderDate,'%Y-%m') as month,
round(sum(quantityOrdered * priceEach),2) as total_sales
from orders o
join orderdetails od on o.orderNumber=od.orderNumber
group by month
order by month;

#3 Top 5 products by sales
select p.productName,
round(SUM(od.quantityOrdered * od.priceEach),2) as total_sales
from orderdetails od 
join products p on od.productCode=p.productCode
group by p.productName
order by total_sales desc
limit 5;

# 4.Revenue by productline
SELECT pl.productLine,
       ROUND(SUM(od.quantityOrdered * od.priceEach), 2) AS total_revenue
FROM orderdetails od
JOIN products p ON od.productCode = p.productCode
JOIN productlines pl ON p.productLine = pl.productLine
GROUP BY pl.productLine
ORDER BY total_revenue DESC;

# 5.Top 10 Customers by Total Spend
SELECT c.customerName,
       ROUND(SUM(od.quantityOrdered * od.priceEach), 2) AS total_spent
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY c.customerName
ORDER BY total_spent DESC
LIMIT 10;

#6.Average Order Value (AOV) per Customer
SELECT c.customerName,
       ROUND(AVG(o2.total_amount), 2) AS avg_order_value
FROM customers c
JOIN (
    SELECT o.customerNumber, SUM(od.quantityOrdered * od.priceEach) AS total_amount
    FROM orders o
    JOIN orderdetails od ON o.orderNumber = od.orderNumber
    GROUP BY o.orderNumber
) o2 ON c.customerNumber = o2.customerNumber
GROUP BY c.customerName;
# 7.Top Performing Sales Representative
SELECT e.firstName, e.lastName,
       ROUND(SUM(od.quantityOrdered * od.priceEach), 2) AS total_sales
FROM employees e
JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY e.employeeNumber
ORDER BY total_sales DESC;

#8.Sales by Office Location
SELECT o.city, o.country,
       ROUND(SUM(od.quantityOrdered * od.priceEach), 2) AS total_sales
FROM offices o
JOIN employees e ON o.officeCode = e.officeCode
JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN orders ord ON c.customerNumber = ord.customerNumber
JOIN orderdetails od ON ord.orderNumber = od.orderNumber
GROUP BY o.city, o.country
ORDER BY total_sales DESC;

#9.Most Ordered product
SELECT p.productName, SUM(od.quantityOrdered) AS total_quantity
FROM orderdetails od
JOIN products p ON od.productCode = p.productCode
GROUP BY p.productName
ORDER BY total_quantity DESC
LIMIT 5;

#10.Top customer by payment amount
SELECT c.customerName, ROUND(SUM(p.amount), 2) AS total_paid
FROM payments p
JOIN customers c ON p.customerNumber = c.customerNumber
GROUP BY c.customerName
ORDER BY total_paid DESC
LIMIT 10;
