use LR4_6
-- вариант 2


--База данных «Зоомагазин»
--База данных предназначена для ведения учета товара в зоомагазине. В базе данных должна
--храниться информация:
--- о товаре (id, наименование, описание, количество в магазине, цена за шт, категория);
create table Product(
Product_id int primary key,
Product_name varchar(30),
Product_description varchar(30),
Product_amount int,
Price_for_one int ,
Category varchar(30)
);

--- о потерях (№ потери, id_товара, дата, причина, количество);
create table Losses(
Loss_id int primary key,
Product_id int,
Loss_date date,
Cause varchar(30),
Loss_amount int,

Foreign key(Product_id) references Product(Product_id) on delete cascade
);

--- о продажах (№продажи, id_товара, дата продажи, количество, скидка ).
create table Sales(
Sale_id int primary key,
Product_id int,
Sale_date date,
Sale_amount int,
Discount int,

Foreign key(Product_id) references Product(Product_id) on delete cascade
);


--- о товаре (id, наименование, описание, количество в магазине, цена за шт, категория);
insert into Product values
(1,'Собачий корм','Корм',10,11,'Еда'),
(2,'Игрушка-жевалка','Игрушка',20,30000,'Развлечение'),
(3,'Счетка для шерсти','Для шерсти',30,33,'Гигиена');

--- о потерях (№ потери, id_товара, дата, причина, количество);
insert into Losses values
(1,3,'09.13.2022','Брак',11),
(2,3,'09.07.2022','Брак',22),
(3,2,'03.14.2022','Брак',33),
(4,1,'03.14.2022','Просрочено',44);

--- о продажах (№продажи, id_товара, дата продажи, количество, скидка ).
insert into Sales values
(1,2,'09.13.2022',10,10),
(2,3,'09.07.2022',12,12),
(3,2,'03.14.2022',13,13),
(4,1,'03.14.2022',4,14);

select * from Product;
select * from Losses;
select * from Sales;

--Реализуйте возможность поиска следующей информации:
--1) Вычислить сумму каждой продажи с учетом скидки.
select Sale_id, ((Sale_amount * Price_for_one) - (Sale_amount * Price_for_one) / 100 * Discount) from Product join Sales on Sales.Product_id = Product.Product_id;

--2) Название и описание товаров, проданных в количестве больше 5 шт в одной продаже.
select Product_name, Product_description from Product where Product_id in (select Product_id from Sales where Sale_amount > 5);

--3) Название и категорию товаров, которых потеряно максимальное и минимальное количество.
select Product_name, Category from Product where Product_id in (select Product_id from Losses where Loss_amount in (select MIN(Loss_amount) from Losses) or Loss_amount in (select MAX(Loss_amount) from Losses));

--4) Название и описание товара, потери которого больше 1, и ценой за шт. не более 20000.
select Product_name, Product_description from Product where Product_id in (select Product_id from Losses where Loss_amount > 1) and Price_for_one < 20001;

--5) Вывести наименование и категории всех товаров и информацию о их потерях. Если потерь
--для товара не существует, значения полей из таблицы Потери должны быть не определены.
select Product_name, Category, Cause from Product join Losses on Losses.Product_id = Product.Product_id;

--6) Вывести наименование товаров и все возможные причины потери товаров. Выводить только
--товары, количество которых в магазине больше 5 шт.
select Product_name, Cause, Product_amount from Product join Losses on Losses.Product_id = Product.Product_id where Product_amount > 5;

--7) Общее количество потерь по каждому наименованию товара.
select Product.Product_name, sum(Loss_amount) from Product join Losses on Losses.Product_id = Product.Product_id group by Product_name;


--8) Количестве и сумму продаж на каждую дату. Выводить только те даты, когда сумма продаж
--составила меньше 10000.
select count(Sale_id) ,sum(Sale_amount * Price_for_one), Sale_date from Product join Sales on Sales.Product_id = Product.Product_id where (Sale_amount * Price_for_one) > 10000 group by Sale_date;

--9) О товарах, для которых отсутствуют продажи.
select * from Product join Sales on Sales.Product_id = Product.Product_id where Sale_id is NULL;

--10) Для каждой категории товара показать общее количество товаров данной категории, которое
--имеется в наличии и количество проданного товара.
select Category, sum(Product_amount), sum(Sale_amount) from Product join Sales on Sales.Product_id = Product.Product_id where Product_amount > 0 group by Category;
