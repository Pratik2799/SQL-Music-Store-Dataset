use project
SELECT * FROM project.album22;
select * from album22
select * from customer
select * from employee1
select * from genre
select * from invoice
select * from invoice_line
select * from media_type
select * from playlist
select * from playlist_track
select * from track22
#Who is the senior most employee based on job title
select e.first_name,e.last_name,e.title,e.hire_date from employee1 e join(
SELECT  title,  MIN(hire_date) AS early_hire_date
FROM employee1
GROUP BY title
ORDER BY early_hire_date ASC) o
on e.title = o.title and e.hire_date= o.early_hire_date
order by e.hire_date

#Which countries have the most Invoices?
select * from invoice
select count(invoice_id),billing_country from invoice
group by billing_country
order by count(invoice_id) desc
limit 1

#What are top 3 values of total invoice? 
select total from invoice
order by total desc 
limit 3

4. Which city has the best customers? 
We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals 

select * from invoice
select sum(total) as total_sum ,billing_city
from invoice 
group by billing_city
order by sum(total) desc

5.Who is the best customer? The customer who has spent the most money will be declared the best customer.
 Write a query that returns the person who has spent the most money 
 
 select * from customer
 select * from invoice
 select a.customer_id,a.first_name,a.last_name,sum(b.total) as total
 from customer a join invoice b on a.customer_id=b.customer_id
 group by a.customer_id,a.first_name,a.last_name
 order by sum(b.total) desc 
 limit 1
 
 Project Phase II
1. Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A 

select * from customer
select * from genre
select distinct(email),first_name,last_name from customer a join invoice b
on a.customer_id=b.customer_id join invoice_line c on b.invoice_id=c.invoice_id 
where track_id in (select track_id from track22 t join genre g on t.genre_id=g.genre_id
where g.name = 'rock' and email like 'a%') order by email

2.#Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands 
select * from artist
select * from track22
select a.name,count(t.track_id) as count_all
from artist a join album22 b on a.artist_id=b.artist_id 
join track22 t on t.album_id = b.album_id 
join genre g on g.genre_id=t.genre_id
where g.name ='rock'
group by a.name
order by count_all desc
limit 10


3. Return all the track names that have a song length longer than the average song length.
 Return the Name and Milliseconds for each track. 
Order by the song length with the longest songs listed first

select milliseconds,name from track22
where milliseconds>(select avg(milliseconds) from track22)
order by 1 desc

select milliseconds,name from track22
where milliseconds> 393733
order by 1 desc

Project Phase III
1. Find how much amount spent by each customer on artists? 
Write a query to return customer name, artist name and total spent 

 select * from customer
 select * from invoice
 with cte as (
 select ar.name as art_name,ar.artist_id,sum(l.unit_price*l.quantity) as total_spend
 from customer c join invoice i on c.customer_id=i.customer_id
 join invoice_line l on i.invoice_id=l.invoice_id
 join track22 t on l.track_id=t.track_id
 join album22 a on t.album_id=a.album_id
 join artist ar on a.artist_id=ar.artist_id
 group by ar.name,ar.artist_id
 order by total_spend desc
 limit 1)
 
 select c.first_name, c.last_name, art_name , 
 sum(l.unit_price * l.quantity) as total_spent from customer c
join invoice i on i.customer_id = c.customer_id
join invoice_line l on l.invoice_id = i.invoice_id
join track22 t on t.track_id = l.track_id
join album22 a on a.album_id = t.album_id
join cte on cte.artist_id = a.artist_id
group by 1,2,3
order by total_spent  desc




2.We want to find out the most popular music Genre for each country.
We determine the most popular genre as the genre with the highest amount of purchases.
Write a query that returns each country along with the top Genre.
For countries where the maximum number of purchases is shared return all Genres

select * from invoice_line
with cte as(
select c.country,g.name,count(l.quantity) as max_purchase,
row_number() over (partition by c.country order by count(l.quantity) desc) as ranking 
from customer c join invoice i on c.customer_id=i.customer_id
join invoice_line l on l.invoice_id=i.invoice_id
join track22 t on l.track_id=t.track_id
join genre g on t.genre_id=g.genre_id
group by c.country,g.name
order by count(l.quantity) desc)

select * from cte where ranking=1

3. Write a query that determines the customer that has spent the most on music for each country.
 Write a query that returns the country along with the top customer and how much they spent. 
 For countries where the top amount spent is shared, provide all customers who spent this amount
 
 select * from customer
 select * from invoice
with cte as(
select concat(c.first_name,' ',c.last_name) as cust_name,i.billing_country,sum(i.total) as total_spent,
row_number() over (partition by i.billing_country order by sum(i.total) desc) as rnk
from customer c join invoice i  on c.customer_id=i.customer_id
group by c.first_name,c.last_name,i.billing_country
order by i.billing_country asc,sum(i.total) desc)

select * from cte where rnk =1



 