-- create database 
create database OnlineBookstore;
use Onlinebookstore;
-- books table
create table books(
Book_ID int primary key,
Title varchar(100),
Author varchar(100),
Genre varchar(50),
Published_Year int,
Price numeric(10,2),
Stock int
);
-- customers table
create table Customers(
Customer_id int primary key,
Name varchar(100),
Email varchar(100),
Phone varchar(15),
City varchar(50),
Country varchar(150)
);
-- orders table
create table Orders(
Order_ID int primary key,
Customer_id int references Customers(Customer_id),
Book_ID int references books(Book_ID),
Order_Date DATE,
Quantity int,
Total_Amount numeric(10,2)
);
select*from books;
select*from customers;
select*from orders;
 -- 1) retrieve all books in the "fiction" genre:
 select * from books
where genre = "fiction";
-- 2) find books published after the year 1950:
select * from books 
where published_year > 1950;
-- 3) list all customers from the canada
select * from customers
where country = "canada";
-- 4) show orders placed in november 2023
select * from orders
where order_date between '2023-11-01' and '2023-11-30';
-- 5) retrieve the total stock of books available:
select sum(stock) as total_stock
 from books;
-- 6) find the details of most expensive book
select * from books
where  price = (select max(price) from books); 
-- or select * from books order by price desc limit 1
-- 7)show all customers who ordered more than 1quantity of a book
select * from customers 
where customer_id in (select customer_id from orders where quantity > 1); 
-- 8) retrieve all orders where the total amount exceeds $20
select * from orders
where total_amount > 20;
-- 9) list all genres available in the books table 
 select distinct genre from books;
 -- 10) find the books with the lowest stock 
 select * from books
 where stock = (select min(stock) from books);
 -- 11) calculate the total revenue generated from all orders:
 select sum(total_amount) as total_revenue
 from orders;
 -- ADVANCE QUESTIONS :
 -- 1) Retrieve the total number of books sold  for all genre :
 select b.genre,sum(o.quantity) as total_books_sold
 from orders o
 join books b on b.book_id = o.book_id
 group by b.genre;
 -- 2) find the average price of books which genre is fantasy :
 select avg(price) from books 
 where genre = 'fantasy';
 -- 3)list customers who have placed at least 2 orders :
 select o.customer_id,c.name,count(o.order_id) as order_count
 from orders as o
 join customers as c
 on o.customer_id = c.customer_id
 group by customer_id
 having count(order_id) >= 2;
 -- 4) find the most frequently ordered book :
 select o.book_id,b.title,count(o.order_id) as order_count
 from orders as o
 join books as b
 on o.book_id = b.book_id
 group by o.book_id  
 order by count(o.order_id) desc limit 1;
 -- 5) show the top 3 most expensive books of 'fantasy' genre :
 select * from books 
 where genre = 'fantasy'
 order by price desc limit 3;
 -- 6) retrieve the total quantity of books sold by each author :
 select b.author ,sum(o.quantity) as total_books_sold
 from books as b
 join orders as o
 on b.book_id = o.order_id
 group by b.author
 ;
  -- 7) list the cities where customers who spent over $30 are located :
   select * from customers;
   select * from orders;
   select  distinct c.city, sum(o.total_amount) as total_spent
   from customers as c
   join orders as o
   on c.customer_id = o.customer_id
   group by city 
   having sum(o.total_amount) > 30;
-- 8) find the customer who spent the most on orders;
select c.name, sum(o.total_amount) as total_spent
from customers as c
join orders as o
on c.customer_id = o.customer_id
group by c.name
order by sum(o.total_amount) desc limit 1;
-- 9) calculate the stock remaining after fulfilling all orders :
select * from orders;
select * from books;
select b.book_id,b.title,b.stock,coalesce(sum(o.quantity),0) as order_quantity,
b.stock - coalesce(sum(o.quantity),0) as remaining_quantity
from books b
left join orders o 
on b.book_id = o.book_id
group by b.book_id order by b.book_id;
