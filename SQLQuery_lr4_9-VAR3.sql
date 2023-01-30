 use DB_LR4_9

--Вариант 3
--Индивидуальное задание:
--База данных «Магазин женской обуви»
--База данных предназначена для ведения учета товара в магазине. В базе данных должна
--храниться информация:
--- о категориях обуви (id_категории, наименование категории, гарантийный срок, правила ухода);
create table Categories(
Category_id int primary key,
Category_name varchar(30),
Varanty int,
Rules varchar(30),
);
--- о товаре (id_товара, наименование товара, id_категории, производитель, материал, цвет,
--цена, количество на складе); считаем, что доступны все размеры с 36 по 40 в указанных количествах
create table Products(
Product_id int primary key,
Product_name varchar(30),
Category_id int,
Manufacturer varchar(30),
Material varchar(30),
Color varchar(30),
Price int,
Amount_in_storage int,

Foreign key(Category_id) references Categories(Category_id) on delete cascade
);
--- о продажах (№продажи, id_товара, размер, количество, скидка, дата).
create table Sales(
Sale_id int primary key,
Product_id int,
Size int,
Sale_amount int,
Discount int,
Sale_date date,

Foreign key(Product_id) references Products(Product_id) on delete cascade
);

--- о категориях обуви (id_категории, наименование категории, гарантийный срок, правила ухода);
insert into Categories values
(1,'Зимнее',10,'Быть аккуратным'),
(2,'Спортивное',20,'Быть аккуратным'),
(3,'Модное',30,'Быть аккуратным');
--- о товаре (id_товара, наименование товара, id_категории, производитель, материал, цвет,
--цена, количество на складе); считаем, что доступны все размеры с 36 по 40 в указанных количествах
insert into Products values
(1,'Туфля',3,'Россия','Латекс','Красный',111,11),
(2,'Кед',2,'Америка','Ткань','Серый',222,22),
(3,'Ботинок',1,'Китай','Кожа','Черный',222,22);
--- о продажах (№продажи, id_товара, размер, количество, скидка, дата).
insert into Sales values
(1,1,36,36,10,'09.13.2022'),
(2,3,37,37,12,'09.07.2022'),
(3,2,39,38,13,'03.14.2022'),
(4,3,38,39,14,'03.14.2022');

select * from Categories;
select * from Products;
select * from Sales;


--Создайте представления:
--1) Категорию, наименование и гарантийный срок всех товаров.
--Выберите из представления информацию обо всех
--товарах с гарантийным сроком более 30 дней.
GO
CREATE VIEW View_1 AS 
SELECT Products.Category_id, Products.Product_name, Categories.Varanty FROM Products join Categories on Products.Category_id = Categories.Category_id;

select * from View_1 where Varanty >= 30;

--2) Название товара, материал и даты всех продаж. Выберите из представления
--информацию обо всех продажах в текущем месяце.
GO
CREATE VIEW View_2 AS 
SELECT Products.Product_name, Products.Material, Sales.Sale_date FROM Products join Sales on Products.Product_id = Sales.Product_id;

select * from View_2 where MONTH(Sale_date) = MONTH('09.13.2022') and Year(Sale_date) = Year('09.13.2022');

--3) Название категории обуви и минимальную цену в каждой категории. Выберите
--из представления информацию обо всех категориях для которых минимальная
--цена меньше 100.
GO
CREATE VIEW View_3 AS 
SELECT Categories.Category_name as cat_name, MIN(Products.Price) as minimal FROM Products join Categories on Categories.Category_id = Products.Category_id group by Category_name;

select * from View_3 where minimal < 120;

--4) Общее количество обуви, проданных за каждый день. Выберите из
--представления информацию обо всех датах, где было продано более 10 штук.
GO
CREATE VIEW View_4 AS 
SELECT Sales.Sale_date as sale_date, sum(Sales.Sale_amount) as Sum_sold from Sales group by Sales.Sale_date;
select * from View_4 where Sum_sold > 10;

--5) Название и цену обуви, для которых не было продаж. Выберите из
--представления информацию обо всех товарах, у которых максимальная цена.
GO
CREATE VIEW View_5 AS
SELECT Product_name as Name_of_not_sold, Price as Price from Products where Product_id not in (select Product_id from Sales);

select * from View_5 where Price = (select max(Price) from Products);