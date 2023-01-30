
use DB_LR4_8
-- вариант 8
drop table Sales;
drop table Toys;
drop table Categories;


--База данных предназначена для ведения учета товара в магазине. В базе данных должна храниться информация:
-- о категориях (id_категории, название категории, гарантийный срок (месяцев), правила ухода, возраст);
create table Categories(
Category_id int primary key,
Category_name varchar(30),
Varanty int,
Rules varchar(30),
Age int
);
-- об игрушках (id_категории, id_игрушки ,название игрушки, производитель, цена, количество на складе);
create table Toys(
Category_id int,
Toy_id int primary key,
Toy_name varchar(30),
Producer varchar(30),
Price int,
Amount_in_store int

Foreign key(Category_id) references Categories(Category_id) on update cascade
);
--drop table Toys;
--drop table Sales;

-- о продажах (№продажи, id_игрушки, количество, скидка, дата).
create table Sales(
Sale_id int primary key,
Toy_id int,
Sale_amount int,
Discount int,
Sale_date date,

Foreign key(Toy_id) references Toys(Toy_id) on delete cascade
);

-- о категориях (id_категории, название категории, гарантийный срок (месяцев), правила ухода, возраст);
insert into Categories values
(1,'Маленькие',10,'Аккуратно',12),
(2,'Большие',20,'Аккуратно',3),
(3,'Для девочек',30,'Аккуратно',6),
(4,'Для мальчиков',30,'Аккуратно',6);
-- об игрушках (id_категории, id_игрушки ,название игрушки, производитель, цена, количество на складе);
insert into Toys values
(1,2,'Игрушка_один','Китай',11,11),
(2,1,'Игрушка_два','Россия',12,22),
(3,3,'Игрушка_три','Китай',13,33),
(4,4,'Игрушка_четыре','Россия',14,44);
-- о продажах (№продажи, id_игрушки, количество, скидка, дата).
insert into Sales values
(1,1,11,1,'09.13.2022'),
(2,3,12,2,'09.07.2022'),
(3,2,13,3,'03.14.2022'),
(4,3,14,4,'03.14.2022');

select * from Categories;
select * from Toys;
select * from Sales;





--1. Написать хранимые процедуры для добавления значений во все таблицы.
-- о категориях (id_категории, название категории, гарантийный срок (месяцев), правила ухода, возраст);
select * from Categories;
--drop procedure Add_Category;


GO
CREATE PROCEDURE Add_Category(@Nc_id int, @Nc_name varchar(30), @Nvaranty int, @Nrules varchar(30), @Nage int) AS
insert into Categories values(@Nc_id, @Nc_name, @Nvaranty, @Nrules, @Nage);

exec Add_Category 5,'унисекс',15,'аккуратно',6;

select * from Categories;
-----------------------------------------------------------------------------------------
select * from Toys;

-- об игрушках (id_категории, id_игрушки ,название игрушки, производитель, цена, количество на складе);
GO
CREATE PROCEDURE Add_Toy(@Nc_id int, @Nt_id int, @Nname varchar(30), @Nproducer varchar(30), @Nprice int, @Namount int) AS
insert into Loses values(@Nc_id, @Nt_id, @Nname, @Nproducer, @Nprice, @Namount);

exec Add_Toy 3,5,'Игрушка_пять','Россия', 15, 55;

select * from Toys;
-----------------------------------------------------------------------------------------
select * from Sales;

-- о продажах (№продажи, id_игрушки, количество, скидка, дата).
GO
CREATE PROCEDURE Add_Sales(@Ns_id int, @Nt_id int, @Namount varchar(30), @Ndiscount int, @Ndate date) AS
insert into Sales values(@Ns_id, @Nt_id, @Namount, @Ndiscount, @Ndate);

exec Add_Sales 5,1,15,5,'01.11.2022';
select * from Sales;
--2. Написать триггер, который срабатывает при добавлении или обновлении таблицы Продажи, если игрушка продана более 3 раз, то добавить ей скидку +10.

go
create trigger trigga1
on Sales
after insert,update
as
if((select sum(Sale_amount) from Sales where Toy_id = (select Toy_id from inserted)) > 3) update Sales set Discount = Discount + 10 where Toy_id = (select Toy_id from inserted)

select * from Sales;
exec Add_Sales 5,1,15,5,'01.11.2022';
select * from Sales;

-- 3. Написать триггер, который при удалении информации из таблицы Продажи удаляет эту игрушку из таблицы Игрушки, если эта игрушка продана менее 2 раз.
drop trigger trigga2;
go
create trigger trigga2
on Sales
after delete
as
if((select sum(Sale_amount) from Sales where Toy_id = (select Toy_id from deleted)) < 2) delete from Toys where Toy_id = (select Toy_id from deleted);




insert into Sales values (2,2,1,1,'09.13.2022');
insert into Sales values (1,2,20,10,'09.13.2022');
insert into Toys values (4,2,'Игрушка_двадва','Китай',11,11);
delete from Toys where Toy_id = 2;
select * from Toys;
select * from Sales;
delete from Sales where Toy_id = 4;
select * from Toys;
select * from Sales;
delete from Sales where Toy_id = 1;
-- 4. Написать триггер, который в случае добавления новой категории создает для нее игрушку с названием Игрушка, нулевым количеством и скидкой и сегодняшней датой.

drop procedure Toy;
go
create procedure Toy
@id_Cat int,
@id_Toy int,
@name_Toy varchar(20),
@proiz_Toy varchar(20),
@price_Toy int,
@count_Toy int
as
insert into Toys(Category_id,Toy_id, Toy_name,Producer,Price,Amount_in_store)
values(@id_Cat,@id_Toy,@name_Toy,@proiz_Toy,@price_Toy,@count_Toy);


go
create trigger trigga3
on Categories
after insert
as
declare @id int
set @id = (select Category_id from inserted);
declare @date date
set @date = getdate();
exec Toy @id,5,'Игрушка','', 0, 0

select * from Categories;
select * from Toys;

insert into Categories values ( 5,'',0,'',0 );

select * from Categories;
select * from Toys;



--5. Написать триггер, который в случае удаления услуги вместо удаления категории ставит в поле название НЕДОСТУПНО.

select * from Categories;
select* from Toys;
select * from Sales;

go
create trigger trigga4
on Toys
instead of delete
as
update Categories
set Category_name = 'недоступно'
where Category_id = (select Category_id from deleted)


select * from Categories;
select* from Toys;
select * from Sales;

delete from Toys where Toy_id = 2;

select * from Categories;
select* from Toys;
select * from Sales;