create database DB_LR4_7;
use DB_LR4_7;
-- вариант 3


--База данных «Магазин женской обуви»
--База данных предназначена для ведения учета товара в магазине. В базе данных должна храниться информация:

--- о категориях обуви (id_категории, наименование категории, гарантийный срок(месяцев), правила ухода);
create table Category(
Category_id int primary key,
Category_name varchar(30),
Varanty int,
Rules varchar(30)
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
Amount_in_storage int

Foreign key(Category_id) references Category(Category_id) on delete cascade
);
--- о продажах (№продажи, id_товара, размер, количество, скидка, дата).
create table Sales(
Sale_id int primary key,
Product_id int,
Size int check (Size = 36 or Size = 37 or Size = 38 or Size = 39 or Size = 40),
Sale_amount int,
Discount int,
Sale_date date

Foreign key(Product_id) references Products(Product_id) on delete cascade
);

--- о категориях обуви (id_категории, наименование категории, гарантийный срок(месяцев), правила ухода);
insert into Category values
(1,'Спортивная',10,'Быть аккуратным'),
(2,'Праздничная',20,'Быть аккуратным'),
(3,'Повседневная',30,'Быть аккуратным');

--- о товаре (id_товара, наименование товара, id_категории, производитель, материал, цвет,
--цена, количество на складе); считаем, что доступны все размеры с 36 по 40 в указанных количествах
insert into Products values
(1,'Кросовок',1,'Китай','Ткань','Черный',11,100),
(2,'Туфля',2,'Китай','Кожа','Красный',202,200),
(3,'Ботинок',3,'Америка','Кожа','Черный',33,300),
(4,'Кед',1,'Россия','Ткань','Серый',404,400);


--- о продажах (№продажи, id_товара, размер, количество, скидка, дата).
insert into Sales values
(1,2,36,10,10,'09.13.2022'),
(2,3,37,12,12,'09.07.2022'),
(3,2,38,13,13,'03.14.2022'),
(4,4,39,14,14,'03.14.2022');

select * from Category;
select * from Products;
select * from Sales;

drop table Sales;
drop table Category;
drop table Products;

--1. Написать хранимые процедуры для добавления значений во все таблицы.
select * from Category;

GO
CREATE PROCEDURE Add_Category(@NC_id int, @Nc_name varchar(30), @Nvaranty int, @Nrules varchar(30)) AS
insert into Category values(@NC_id, @Nc_name, @Nvaranty, @Nrules);

exec Add_Category 4,'сандаль', 44, 'Быть аккуратным';

select * from Category;


--2. Написать хранимую процедуру для удаления из таблицы Категории всех категорий,
--имеющих гарантийный срок более 12 месяцев.
select * from Category;

GO
CREATE PROCEDURE Delete_Category AS
delete from Category where Varanty > 12;

exec Delete_Category;

select * from Category;

--3. Написать хранимую процедуру вычисляющую общее количество товара выбранной
--категории. Категория передается в процедуру в качестве параметра. Если инвентаря такой
--категории нет, то вывести соответствующее сообщение.
GO 
CREATE PROCEDURE Count_Sum(@Category_id int) AS
select isnull('нету',sum(Amount_in_storage)) from Products where Category_id = @Category_id;

drop procedure Count_Sum; 

exec Count_Sum 2;
exec Count_Sum 1;

select * from Category;
select * from Products;


--4. Написать процедуру, которая устанавливает скидку 10 для всех продаж, в сентябре текущего
--года.
select * from Sales;

GO 
CREATE PROCEDURE Discounting AS
update Sales set discount = 10 where month(Sale_date) = 9;

exec Discounting;

select * from Sales;

--5. Написать хранимую процедуру вычисляющую минимальный размер проданного товара. id
--товара передается в процедуру в качестве параметра.
GO 
CREATE PROCEDURE Smoll(@Pr_id int) AS
select min(Size) from Sales where Product_id = @Pr_id;

exec Smoll 2;

--6. Написать процедуру, которая выводит количество продаж для заданного товара, если на
--складе имеются модели белого цвета. Если нет, вывести сообщение. id_товара передается в
--качестве параметра.
GO 
CREATE PROCEDURE White_amount(@Pr_id int) AS
select count(Sale_id) from Sales inner join Products on Sales.Product_id = Products.Product_id where Color = 'Серый';

exec White_amount 4;

--7. Написать процедуру, которая устанавливает скидку 5% при продаже товара, если средняя
--цена товаров на складе более 100. id товара передается в процедуру в качестве параметра.
GO 
CREATE PROCEDURE Smoll_discount(@Pr_id int) AS
update Sales set discount = 5 where Product_id = @Pr_id and (select Price from Products where Product_id = @Pr_id) > 100;
drop procedure Smoll_discount;

exec Smoll_discount 4;

select * from Sales;

--8. Вызовите все написанные процедуры и проанализируйте их работу.