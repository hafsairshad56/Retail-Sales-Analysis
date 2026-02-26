CREATE TABLE sales (
    sales_id UNIQUEIDENTIFIER PRIMARY KEY,
    product_category VARCHAR(50),
    sales_amount DECIMAL(10,2),
    discount DECIMAL(10,2),
    date_of_sale DATE,
    customer_age INT,
    customer_gender VARCHAR(10),
    sales_rep VARCHAR(100),
    region_id INT  -- Foreign key to the store/region table
);
CREATE TABLE stores (
    region_id INT PRIMARY KEY,
    sales_region VARCHAR(100)
);
CREATE TABLE features (
    feature_id INT PRIMARY KEY IDENTITY(1,1),
    product_category VARCHAR(50),
    average_discount DECIMAL(5,2)
);
USE RetailSalesDB;
GO
SELECT name 
FROM sys.tables
ORDER BY name;


SELECT 
    s.sales_region,
    SUM(sa.sales_amount) AS total_sales
FROM 
    dbo.sales sa
JOIN 
    dbo.stores s ON sa.region_id = s.region_id
GROUP BY 
    s.sales_region
ORDER BY 
    total_sales DESC;


	SELECT 
    FORMAT(date_of_sale, 'yyyy-MM') AS sales_month,
    SUM(sales_amount) AS monthly_sales
FROM 
    dbo.sales
GROUP BY 
    FORMAT(date_of_sale, 'yyyy-MM')
ORDER BY 
    sales_month;

	SELECT TOP 5
    st.sales_region,
    AVG(weekly_data.weekly_sales) AS avg_weekly_sales
FROM (
    SELECT 
        region_id,
        DATEPART(YEAR, date_of_sale) AS sales_year,
        DATEPART(WEEK, date_of_sale) AS sales_week,
        SUM(sales_amount) AS weekly_sales
    FROM dbo.sales
    GROUP BY region_id, DATEPART(YEAR, date_of_sale), DATEPART(WEEK, date_of_sale)
) AS weekly_data
JOIN dbo.stores st ON weekly_data.region_id = st.region_id
GROUP BY st.sales_region
ORDER BY avg_weekly_sales DESC;


SELECT 
    f.product_category,
    f.average_discount,
    AVG(s.sales_amount) AS avg_sales_amount
FROM 
    dbo.features f
JOIN 
    dbo.sales s ON f.product_category = s.product_category
GROUP BY 
    f.product_category, f.average_discount
ORDER BY 
    f.average_discount DESC;




