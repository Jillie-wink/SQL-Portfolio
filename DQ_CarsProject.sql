WITH
--Q1: Calculating relative demand of a product as (demand/supply),
--where demand is SUM(quantityOrdered), and supply is quantityInStock.
--Then, narrowing down to 10 products with highest relative demand (which would be products that are in low stock).
productsLowStock AS (
	 SELECT  *
		 FROM		(SELECT  p.productCode, p.productName, p.productLine,
												ROUND(SUM(od.quantityOrdered)*1.0/p.quantityInStock*1.0, 2) AS relativeDemand
								 FROM  orderdetails AS od
								   JOIN  products AS p
										ON  od.ProductCode = p.productCode
						GROUP BY  p.productCode)
ORDER BY  relativeDemand
		LIMIT  10
),

--Q1: Calculating product performance as (demand*profit),
--where demand is SUM(quantityOrdered) and profit is (priceEach - buyPrice).
--Then, narrowing down to 10 products with highest product performance.
productsPerformance AS (
	 SELECT  od.productCode, p.productName, p.productLine,
						SUM(1.0*od.quantityOrdered*(od.priceEach - p.buyPrice)) AS productPerformance
		 FROM  orderdetails AS od
		   JOIN  products AS p
				ON  od.productCode = p.productCode
GROUP BY  od.productCode
ORDER BY  productPerformance DESC
		LIMIT 10
),

--ANSWER Q1: Top 10 products for priority restock, listing highest performing products and their relative stock.
productsPriorityRestock AS (
	 SELECT  pls.productCode, pls.productName, pls.productLine, pls.relativeStock, pp.productPerformance
		 FROM  productsLowStock AS pls
		   JOIN  productsPerformance AS pp
			   ON  pls.productCode = pp.productCode
	 WHERE  pls.productCode IN (SELECT productCode
																   FROM productsPerformance)
ORDER BY  pls.productCode
),

--Q2/Q3: Calculating profit per customer as SUM(product profits)
profitsPerCustomer AS (
	  SELECT o.customerNumber,
						SUM(od.quantityOrdered * (od.priceEach - p.buyPrice)) AS profit
		  FROM products AS p
			JOIN orderdetails AS od
				ON p.productCode = od.productCode
			JOIN orders AS o
				ON od.orderNumber = o.orderNumber
		    JOIN customers AS c
				ON c.customerNumber = o.customerNumber
GROUP BY o.customerNumber
),

--ANSWER Q2: Five customers who produce most profit.
mostEngagedCustomersTopFive AS (
	  SELECT  c.contactLastName, c.contactFirstName, c.city, c.country, ppc.profit
		  FROM  customers AS c
			JOIN  profitsPerCustomer AS ppc
				ON  c.customerNumber = ppc.customerNumber
ORDER BY  profit DESC
		LIMIT  5
),

--ANSWER Q2: Five customers who produce least profit.
leastEngagedCustomersTopFive AS (
	  SELECT  c.contactLastName, c.contactFirstName, c.city, c.country, ppc.profit
		  FROM  customers AS c
			JOIN  profitsPerCustomer AS ppc
				ON  c.customerNumber = ppc.customerNumber
ORDER BY  profit
		LIMIT  5
),

--ANSWER Q3: What is the average lifetime value of a customer?
avgCustomerLTV AS (
	  SELECT ROUND(AVG(profit), 2) AS avgCustomerProfit
		 FROM profitsPerCustomer
)

SELECT * FROM avgCustomerLTV