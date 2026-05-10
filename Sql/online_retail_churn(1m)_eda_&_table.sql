select * 
from oneline_retail_churn
limit 100;
select max(invoice_date) from oneline_retail_churn;
select min (invoice_date) from oneline_retail_churn;
select count(*)
from oneline_retail_churn;
select count(distinccustomer_id) from oneline_retail_churn;
select count(*)
from oneline_retail_churn;
select count(*) from oneline_retail_churn
where customer_id is null;
select count(distinct customer_id) from oneline_retail_churn;
select count(distinct invoice) as distinct_invoices from oneline_retail_churn ;
select max(quantity) as max_quantity, min(quantity) as min_quantity, max(price) as max_price, min(price) as min_price
from oneline_retail_churn;
select distinct customer_id,max(invoice_date) over (partition by customer_id) as last_transaction
from oneline_retail_churn
limit 100;
select max(invoice_date)-interval '6 months' as observation_date from oneline_retail_churn;
----for churned customer (no purchase in last 6 months)
with churned as (
select distinct customer_id,max(invoice_date) over (partition by customer_id) as last_transaction
from oneline_retail_churn
where customer_id is not null 
) 
select * from churned 
limit 100;
---------CTE again (the one up there is not right, dead wrong)
with cutoff as (
select max(invoice_date)-interval '6 months' as cutoff_date from oneline_retail_churn),
last_transaction as (
select distinct customer_id,max(invoice_date) over (partition by customer_id) as last_transaction
from oneline_retail_churn
where customer_id is not null
) 
select lt.customer_id, lt.last_transaction,c.cutoff_date as cutoff_date,
case when lt.last_transaction>c.cutoff_date then 0 else 1 end as churn
from last_transaction lt,cutoff c
;
-------churn EDA
with cutoff as (
select max(invoice_date)-interval '4 months' as cutoff_date from oneline_retail_churn),
last_transaction as (
select distinct customer_id,max(invoice_date) over (partition by customer_id) as last_transaction
from oneline_retail_churn
where customer_id is not null
) 
select count(lt.customer_id) as total_customers,
count(lt.customer_id)-(sum(case when lt.last_transaction>c.cutoff_date then 0 else 1 end)) as active_customers,
sum(case when lt.last_transaction>c.cutoff_date then 0 else 1 end) as churned_customers
from last_transaction lt,cutoff c
;
select customer_id, count(invoice) as transaction_count, count(distinct stock_code) as unique_purchases,
sum(quantity*price) as revenue
from oneline_retail_churn
where quantity>0 and price > 0
group by customer_id
;
----------some more columns
with 
	cutoff as (
select max(invoice_date)-interval '4 months' as cutoff_date from oneline_retail_churn),
	last_transaction as (
select distinct customer_id,max(invoice_date) over (partition by customer_id) as last_transaction,
min(invoice_date)over(partition by customer_id) as first_transaction
from oneline_retail_churn
where customer_id is not null), 
	customer_metrics as(select customer_id, count(distinct invoice) as transactions, count(distinct stock_code) as 
	unique_products,country,sum(quantity) as total_products,
sum(quantity*price) as revenue
from oneline_retail_churn group by customer_id,country
),
	final_table as( 
	select lt.customer_id,lt.last_transaction,cm.transactions,cm.unique_products,cm.revenue,
lt.last_transaction-lt.first_transaction as total_days, c.cutoff_date-lt.last_transaction as days_inactive,
(lt.last_transaction-lt.first_transaction)/nullif(cm.transactions,0) as frequency,cm.revenue/nullif(cm.transactions,0)
as AOV,cm.country,cm.total_products,
case when lt.last_transaction>c.cutoff_date then 0 else 1 end as churn
	
from last_transaction lt 
cross join cutoff c
join customer_metrics cm on lt.customer_id=cm.customer_id
)
select * from final_table;

select distinct country from oneline_retail_churn;
select distinct invoice_date::date as invoice_date, country, sum(price*quantity) as Revenue,
count(distinct invoice) as transaction_count
from oneline_retail_churn
where price>0
group by 1,2;








