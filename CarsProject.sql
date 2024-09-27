WITH
--Q1: Which products should we order more of? 
--Calculate relative demand of a product as (demand/supply),
--where demand is SUM(quantityOrdered), and supply is quantityInStock.
productsRelativeDemand AS (
	SELECT	p.productCode, p.productName,
		ROUND(SUM(od.quantityOrdered)*1.0/p.quantityInStock*1.0, 2) AS relativeDemand
	  FROM	orderdetails AS od
	  JOIN	products AS p
	    ON	od.ProductCode = p.productCode
      GROUP BY	p.productCode
),
--Produce table displaying all products in order of highest in demand
productsUnderStocked AS (
	SELECT	*
	  FROM	productsRelativeDemand
      ORDER BY	relativeDemand DESC
),
--Produce table displaying products with more demand than supply
productsNotStocked AS (
	SELECT	*
	  FROM	productsRelativeDemand
	 WHERE  relativeDemand > 1.0
      ORDER BY	relativeDemand DESC
),
	
--Q2: Which products should we order less of?
--Produce table displaying all products in order of lowest in demand
productsOverStocked AS (
	SELECT	*
	  FROM	productsRelativeDemand
      ORDER BY	relativeDemand
),

--Q3: Calculating product performance as (demand*profit),
--where demand is SUM(quantityOrdered) and profit is (priceEach - buyPrice).
--Then, narrowing down to 10 products with highest product performance.
productsPerformance AS (
	SELECT	od.productCode, p.productName, p.productLine,
		SUM(1.0*od.quantityOrdered*(od.priceEach - p.buyPrice)) AS productPerformance
	  FROM	orderdetails AS od
	  JOIN	products AS p
	    ON	od.productCode = p.productCode
      GROUP BY	od.productCode
      ORDER BY	productPerformance DESC
	 LIMIT	10
),

--Q4: Calculating priority restock according to productPerformance.
--Then, listing 10 highest performing products alongside their relativeDemand
productsPriorityRestock AS (
	SELECT	prd.productCode, prd.productName, prd.productLine, prd.relativeDemand, pp.productPerformance
	  FROM	productsRelativeDemand AS prd
	  JOIN	productsPerformance AS pp
	    ON	prd.productCode = pp.productCode
	 WHERE	prd.productCode IN (SELECT  productCode
				      FROM  productsPerformance)
      ORDER BY	prd.productCode
),

--Q5: Calculating profit per customer as SUM(profit) from items ordered.
profitsPerCustomer AS (
	SELECT	o.customerNumber, SUM(od.quantityOrdered * (od.priceEach - p.buyPrice)) AS profit
	  FROM	products AS p
	  JOIN	orderdetails AS od
	    ON	p.productCode = od.productCode
	  JOIN	orders AS o
	    ON	od.orderNumber = o.orderNumber
	  JOIN	customers AS c
	    ON	c.customerNumber = o.customerNumber
      GROUP BY	o.customerNumber
),

--Q6: Five customers who produce most profit.
mostEngagedCustomers AS (
	SELECT	c.contactLastName, c.contactFirstName, c.city, c.country, ppc.profit
	  FROM	customers AS c
	  JOIN	profitsPerCustomer AS ppc
	    ON	c.customerNumber = ppc.customerNumber
      ORDER BY	profit DESC
	 LIMIT	5
),

--Q7: Five customers who produce least profit.
leastEngagedCustomers AS (
	SELECT	c.contactLastName, c.contactFirstName, c.city, c.country, ppc.profit
	  FROM	customers AS c
	  JOIN	profitsPerCustomer AS ppc
	    ON	c.customerNumber = ppc.customerNumber
      ORDER BY	profit
	 LIMIT	5
),

--Q8: What is the average lifetime value of a customer?
avgCustomerLTV AS (
	SELECT	ROUND(AVG(profit), 2) AS avgCustomerProfit
	  FROM	profitsPerCustomer
)
