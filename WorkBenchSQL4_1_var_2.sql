DROP DATABASE IF EXISTS MyDB;
CREATE DATABASE IF NOT EXISTS MyDB;
USE MyDB;

-- о товаре (id, наименование, описание, количество в магазине, цена за шт, категория);
create table Product(
Product_id int primary key auto_increment,
Product_name varchar(30),
Product_description varchar(30),
Amount int,
Price_by_one varchar(30),
Category varchar(30)
);
-- о потерях (№ потери, id_товара, дата, причина, количество);
create table Loses(
Lose_id int primary key auto_increment,
Product_id int,
Lose_date date,
Cause varchar(30),
Amount int
);
-- о продажах (№продажи, id_товара, дата продажи, количество, скидка ).
create table Sales(
Sale_id int primary key auto_increment,
Product_id int,
Sale_date date,
Amount int,
Discount int
);
-- о товаре (id, наименование, описание, количество в магазине, цена за шт, категория);
insert into Product values
(1,"Название А","Описание А",11,11,"Категория А"),
(2,"Название Б","Описание Б",22,22,"Категория Б"),
(3,"Название В","Описание В",33,33,"Категория В"),
(4,"Название Г","Описание Г",44,44,"Категория Г");
-- о потерях (№ потери, id_товара, дата, причина, количество);
insert into Loses values
(1,1,"2022.08.01","Причина А",11),
(2,2,"2022.04.01","Причина Б",22),
(3,3,"2022.06.01","Причина В",33);
-- о продажах (№продажи, id_товара, дата продажи, количество, скидка ).
insert into Sales values
(2,1,"2021.06.01",4,2),
(3,2,"2022.06.02",5,3),
(4,3,"2022.06.03",33,4);
alter table Loses add foreign key(Product_id) references Product(Product_id) on update cascade on delete cascade;
alter table Sales add foreign key(Product_id) references Product(Product_id) on update cascade on delete cascade;

select * from Sales;

-- 1) Вычислить сумму каждой продажи с учетом скидки.
select Sale_id, (Product.Price_by_one * Sales.Amount - Product.Price_by_one / 100 * Discount )  from Sales, Product;

-- 2) Название и описание товаров, проданных в количестве больше 5 шт в одной продаже.
select Product_name, Product_description, Sales.Amount from Product inner join Sales where Sales.Amount > 5 group by Sales.Product_id;

-- 3) Название и категорию товаров, которых потеряно максимальное и минимальное количество. where Product.Product_id = (select Product_id, min(Loses.Amount), max(Loses.Amount) from Loses); 
select Product_name, Category, Loses.Amount from Product, Loses where Loses.Amount in (select max(Loses.Amount) from Loses) or Loses.Amount in (select min(Loses.Amount) from Loses);

-- 4) Название и описание товара, потери которого больше 1, и ценой за шт. не более 20000
select Product_name, Product_description, Loses.Amount, Price_by_one from Product, Loses where Loses.Amount > 1 and Price_by_one < 200000;

-- 5) Вывести наименование и категории всех товаров и информацию о их потерях. Если потерь для товара не существует, значения полей из таблицы Потери должны быть не определены.
select Product_name, Product_description, Loses.* from Product, Loses where Loses.Amount > 0;

-- 6) Вывести наименование товаров и все возможные причины потери товаров. Выводить только товары, количество которых в магазине больше 5 шт.
select Product_name, Loses.Cause from Product, Loses where Product.Amount > 5;

-- 7) Общее количество потерь по каждому наименованию товара.
Select sum(Loses.Amount), Product_name from Product, Loses group by Product_name;

-- 8) Количестве и сумму продаж на каждую дату. Выводить только те даты, когда сумма продаж составила меньше 10000.
select sum(Sales.Amount), sum(Sales.Amount * Product.Price_by_one) from Product, Sales where Sale_date in (select Sale_date from Sales where Sales.Amount < 10000 group by Sale_date) group by Sale_date; 

-- 9) О товарах, для которых отсутствуют продажи.
select Product.* from Sales right join Product on Product.Product_id = Sales.Product_id where Sale_id is NULL;

-- 10) Для каждой категории товара показать общее количество товаров данной категории, которое
-- имеется в наличии и количество проданного товара.
select Category, count(Product.Product_id), Sales.Amount from Product, Sales where Product.Amount > 0 group by Category;