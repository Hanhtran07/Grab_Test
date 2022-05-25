-- xem tất cả dữ liệu--
Select * from [Store Project].[dbo].[GRAB_RAWDATA] 
order by order_id
-- xem dữ liệu cột order_id có số liệu trùng nhau hay không?--
select distinct(order_id) from [Store Project].[dbo].[GRAB_RAWDATA] 
-- tìm những order_id xuất hiện 2 lần-- 
select order_id,  count(order_id) as soluong
from [Store Project].[dbo].[GRAB_RAWDATA] 
group by order_id
order by count(order_id) DESC 

-- how many unique users are active? with complete ride (-- active user- at least 1 complete ride)

select count(distinct (user_id)) as uniqueuser
from [Store Project].[dbo].[GRAB_RAWDATA] 
where Booking_state_simple= 'COMPLETED'


-- what are the top 5 merchants with highest earning in January? Earning merchant = basket_size- commission from merchant--
select TOP 5  merchant_id,(basket_size - commission_from_merchant)as earningmerchant               
from [Store Project].[dbo].[GRAB_RAWDATA] 
where Month(convert(Date,Time_Order))= '01'
order by (basket_size - commission_from_merchant) DESC 
-- cách 2--
select distinct merchant_id, rank()over(partition by merchant_id order by basket_size - commission_from_merchant DESC) as rank_row, (basket_size - commission_from_merchant)as earningmerchant
from [Store Project].[dbo].[GRAB_RAWDATA] 
where Month(convert(Date,Time_Order))= '01'
order by (basket_size - commission_from_merchant) DESC  
OFFSET 0 ROWS
FETCH FIRST 5 ROWS ONLY 

-- for those who have at least 2 transactions, find the 2nd highest transaction basket size value for each user--

With Rank_basket as (select order_id,user_id, Time_Order, basket_size,Rank() OVER(partition by order_id order by basket_size DESC) as rank_basket
from [Store Project].[dbo].[GRAB_RAWDATA])
select* from Rank_basket
where rank_basket=2
--cách 2-- 
With A as (
select order_id, user_id, Time_Order, basket_size, RANK() OVER(partition by user_id order by basket_size DESC) as rank_row
from [Store Project].[dbo].[GRAB_RAWDATA] )
select * from A where rank_row=2








