SELECT  Branch, AVG(Rating) as `Average Rating`
FROM sales
WHERE Customer_type = 'Member'
GROUP BY Branch
ORDER BY `Average Rating`DESC;
# Branch C has the highest average rating from the member customers at 7.05

SELECT AVG(Rating) as `Average Rating`, Customer_type
FROM sales
GROUP BY Customer_type;
# Since the member customers have a lower rating on average than the normal customers, the membership does not depend on rating


SELECT Customer_type, COUNT(Customer_type) AS `Number of Customers`, ROUND(100*SUM(gross_income)/(SELECT SUM(gross_income) 
                                                FROM sales),0) AS `Gross Income Percentage`
      FROM sales
      GROUP BY Customer_type;

SELECT Payment, 
      ROUND(100*COUNT(Payment)/(SELECT COUNT(Payment)
                      FROM sales), 0) AS `Percentage of Payments`,
      ROUND(100*SUM(gross_income)/(SELECT SUM(gross_income)
                                    FROM sales), 0) AS `Percentage of Gross Income`
FROM sales
GROUP BY Payment;
# Since the proportions of customer types and the percentages of each custoemr's gross income are relatively equal the gross income does not depend on
# the loyalty program. Similarly with the payment methods. 

SELECT t2.Gender, t2.Product_line, t2.n AS `Total Purchases`, t2.n/total.n AS Percentage
FROM (SELECT Gender, Product_line, SUM(Quantity) AS n
      FROM sales
      GROUP BY Gender, Product_line) t2
JOIN (SELECT Gender, SUM(Quantity) AS n
      FROM sales
      GROUP BY Gender) total
  ON t2.Gender = total.Gender
  ORDER BY Percentage DESC;
# Women were more likely to buy fashion, food, home, and sports related products 
# where as men were more likely to buy health and electronic related products

SELECT Product_line, ROUND(SUM(gross_income),0) AS `Gross Income`
FROM sales
GROUP BY Product_line
ORDER BY `Gross Income` DESC;
# Food and beverages acrued the most income of all the product categories
