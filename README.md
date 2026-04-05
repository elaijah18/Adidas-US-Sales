# Adidas-US-Sales

### Data Set
- This Adidas Sales dataset is a collection of mock data that includes information on the sales of Adidas products in the United States for 2020-21. It includes details such as the retailer, number of units sold, total sales revenue, location of sales, type of product sold, and other relevant information. Currency denomination is in USD. [Adidas US Sales](https://www.kaggle.com/datasets/sagarmorework/adidas-us-sales).

### Tools 
- MySQL Workbench for data analysis - View [SQL Script](https://github.com/elaijah18/Adidas-US-Sales/blob/main/Adidas_Sales.sql)
- Tableau for data visualization - View [dashboard](https://public.tableau.com/views/AdidasUSSales_17751390972440/Dashboard1?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link).

### Highlights
- New York, California, and Florida are the top 3 states that earn the highest revenue.
- Men's Street Footwear products have the highest turnover of sales, contrary to the lowest, which is the Women's Athletic Footwear.
- The West region accounts for 30% of total revenue in the United States, earning nearly $36 million—double the $16 million earned by the Midwest region.
- In most regions, Men's Street Footwear was the top-selling and most profitable product category, whereas Women's Athletic Footwear performed the poorest in both metrics.

### Data Wrangling
I conducted a simple data cleaning and data wrangling:
- Fixed the miscalculations in the "Total Sales" column.
- Convert the columns: "Price per Unit", "Units Sold", "Operating Profit", and "Operating Margin", into float types from object.
- Convert the "Invoice Date" column into date type.

Google Colab Script: [Notebook](https://colab.research.google.com/drive/1UkYW-79PpDRnWqVXkLFSEVQlil8y5AJU?usp=sharing)

### Visualization
![Dashboard Screenshot]([images/dashboard.png](https://github.com/elaijah18/Adidas-US-Sales/blob/main/Dashboard%201.png))
