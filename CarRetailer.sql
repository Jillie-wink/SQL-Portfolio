-- Q1: Which products should we order more of or less of?
-- Query calculates relative demand as demand/supply.

  WITH  productsRelativeDemand AS (
SELECT  p.productName, p.productCode,
        ROUND(SUM(od.quantityOrdered) * 1.0 / p.quantityInStock * 1.0, 2) AS relativeDemand
  FROM  orderdetails AS od
  JOIN  products as p
    ON  od.productCode = p.productCode
 GROUP  BY p.productCode)

SELECT  *
  FROM  productsRelativeDemand

-- Q2: What are our top 10 overstocked products?

CREATE  VIEW top10overstock AS
SELECT  *
  FROM  productsRelativeDemand
 ORDER  BY relativeDemand
 LIMIT  10

-- Q3: What are our top 10 understocked products?

CREATE  VIEW top10understock AS
SELECT  *
  FROM  productsRelativeDemand
 ORDER  BY relativeDemand DESC
 LIMIT  10

-- Q4: What is the product performance of each of our products?
-- Query calculates product performance as demand*profit.

  WITH  productsPerformance AS (
SELECT  p.productName, od.productCode,
        SUM(od.quantityOrdered * 1.0 * (od.priceEach - p.buyPrice)) AS productPerformance
  FROM  orderdetails AS od
  JOIN  products AS p
    ON  od.productCode = p.productCode
 GROUP  BY od.productCode)

SELECT  *
  FROM  productsPerformance


-- Q5: What are our top 10 performing products?

SELECT  *
  FROM  productsPerformance
 ORDER  BY productPerformance DESC
 LIMIT  10
	  
-- Q6: Which 10 products should we prioritize restocking?

SELECT	pp.productPerformance, pp.productCode, pp.productName, p.productLine, prd.relativeDemand
  FROM	productsPerformance as pp
  JOIN	products AS p
    ON	pp.productCode = p.productCode
  JOIN	productsRelativeDemand AS prd
    ON	prd.productCode
 ORDER	BY pp.productPerformance DESC, prd.relativeDemand DESC
 LIMIT	10
	  
-- Q7: What are our profits per customer?
-- Query calculates profit total as the sum of profits made from all items customer has purchased.

  WITH  profitsPerCustomer AS (
SELECT  o.customerNumber,
        SUM(od.quantityOrdered * (od.priceEach - p.buyPrice)) AS profits
  FROM  products AS p
  JOIN  orderdetails AS od
    ON  p.productCode = od.productCode
  JOIN  orders AS o
    ON  od.orderNumber = o.orderNumber
  JOIN  customers AS c
    ON  c.customerNumber = o.customerNumber
 GROUP  BY o.customerNumber)
      
SELECT  *
  FROM  profitsPerCustomer

-- Q8: What is the mailing information for our top 5 customers?

SELECT	c.customerNumber, c.customerName, c.addressLine1, c.addressLine2,
        c.city || ", " || c.state || ", " || c.postalCode AS addressLine3,
        c.country AS addressLine4
  FROM  customers AS c
  JOIN	profitsPerCustomer AS ppc
    ON	c.customerNumber = ppc.customerNumber
 ORDER  BY ppc.profits DESC
 LIMIT  5

-- Q9: What is the average lifetime value of a customer?

SELECT  ROUND(AVG(profit), 2) AS avgCustomerLTV
  FROM  profitsPerCustomer
