WITH
--Q1: Calculating relative demand of a product as (demand/supply),
--where demand is SUM(quantityOrdered), and supply is quantityInStock.
--Then, displaying products with more orders than currently stocked
--and products with twice as much stock as current orders.
productsRelativeDemand AS (
	SELECT	p.productCode, p.productName, p.productLine,
		ROUND(SUM(od.quantityOrdered)*1.0/p.quantityInStock*1.0, 2) AS relativeDemand
	  FROM	orderdetails AS od
	  JOIN	products AS p
	    ON	od.ProductCode = p.productCode
      GROUP BY	p.productCode
),
productsUnderStocked AS (
	SELECT	productCode, productName, relativeDemand
	  FROM	productsRelativeDemand
	 WHERE	relativeDemand > 1.0
      ORDER BY	relativeDemand
),
productsOverStocked AS (
	SELECT	productCode, productName, relativeDemand
	  FROM	productsRelativeDemand
	 WHERE	relativeDemand < 0.5
      ORDER BY	relativeDemand DESC

),

--Q2: Calculating product performance as (demand*profit),
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

--Q3: Calculating priority restock according to productPerformance.
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

--Q4: Calculating profit per customer as SUM(profit) from items ordered.
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

--Q5: Five customers who produce most profit.
mostEngagedCustomers AS (
	SELECT	c.contactLastName, c.contactFirstName, c.city, c.country, ppc.profit]
	  FROM	customers AS c
	  JOIN	profitsPerCustomer AS ppc
	    ON	c.customerNumber = ppc.customerNumber
      ORDER BY	profit DESC
	 LIMIT	5
),

--Q6: Five customers who produce least profit.
leastEngagedCustomers AS (
	SELECT	c.contactLastName, c.contactFirstName, c.city, c.country, ppc.profit
	  FROM	customers AS c
	  JOIN	profitsPerCustomer AS ppc
	    ON	c.customerNumber = ppc.customerNumber
      ORDER BY	profit
	 LIMIT	5
),

--Q7: What is the average lifetime value of a customer?
avgCustomerLTV AS (
	SELECT	ROUND(AVG(profit), 2) AS avgCustomerProfit
	  FROM	profitsPerCustomer
)
