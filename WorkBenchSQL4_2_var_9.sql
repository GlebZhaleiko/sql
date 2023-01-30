DROP DATABASE IF EXISTS MyDB;
CREATE DATABASE IF NOT EXISTS MyDB;
USE MyDB;

-- Вариант 5
-- База данных «Цветочный магазин»
-- База данных предназначена для ведения учета товара в цветочном магазине. В базе данных должна храниться информация:
-- - о продажах (Id_цветка, количество, дата продажи, скидка ).
create table Sales(
Sales_id int primary key auto_increment,
Flower_id int,
Amount int,
Sale_date date,
Discount int
);
-- - о цветах (Id_цветка, название, размер, срок реализации);
create table Flowers(
Flower_id int primary key auto_increment,
Flower_name varchar(30),
Size int,
Realization int
);
-- - о наличии в магазине (Id_цветка, цена, количество, дата поставки);
create table In_shop(
Info_id int primary key auto_increment,
Flower_id int,
Price int,
Amount int,
Delivery_date date
);
-- - о продажах (Id_цветка, количество, дата продажи, скидка ).
insert into Sales values
(1,1,11,"2021.06.01",11),
(2,2,22,"2021.05.02",22),
(3,3,33,"2021.04.03",33),
(4,2,22,"2021.04.03",33);
-- - о цветах (Id_цветка, название, размер, срок реализации);
insert into Flowers values
(1,"Роза",11,11),
(2,"Тюльпан",12,22),
(3,"Ромашка",13,33),
(4,"Сельдерей",14,44);
-- - о наличии в магазине (Id_цветка, цена, количество, дата поставки);
insert into In_shop values
(1,1,111,11,"2022.06.01"),
(2,2,222,22,"2022.05.02"),
(3,3,133,3,"2022.04.03"),
(4,2,444,60,"2022.03.04"),
(5,3,133,1,"2022.02.05"),
(6,4,133,60,"2022.02.05");


alter table In_shop add foreign key(Flower_id) references Flowers(Flower_id) on update cascade on delete cascade;
alter table Sales add foreign key(Flower_id) references Flowers(Flower_id) on update cascade on delete cascade;

select * from Sales;
select * from Flowers;
select * from In_shop;

-- - о продажах (Id_цветка, количество, дата продажи, скидка ).
DELIMITER //
create procedure addSales(SFlower_id int, SAmount int, SSale_date date, SDiscount int)
begin
insert into Sales(Flower_id, Amount, Sale_date, Discount)
values
(SFlower_id, SAmount, SSale_date, SDiscount);
end//
DELIMITER ;
-- - о цветах (Id_цветка, название, размер, срок реализации);
DELIMITER //
create procedure addFlowers(SFlower_id int, SFlower_name varchar(30), SSize int, SRealization int)
begin
insert into Flowers(Flower_name, Size, Realization)
values
(SFlower_name, SSize, SRealization);
end//
DELIMITER ;

-- 1. Написать хранимую процедуру вычисляющую общее количество поставленного
-- товара. ID_товара передается в процедуру в качестве параметра.
DELIMITER //
create procedure Sum_of_arrived_product(What_to_count_id int)
begin
select sum(Amount) from In_shop where Flower_id = What_to_count_id;
end//
DELIMITER ;
-- call Sum_of_arrived_product(2);

-- 2. Написать триггер на добавление который устанавливает для данного товара
-- скидку 15% при продаже, если общее количество поставленного товара больше 50.
DELIMITER //
create trigger on_insert before insert on Sales for each row
begin
declare fl_id, Arrived_amount int;
set fl_id = new.Flower_id;
set Arrived_amount = (select sum(Amount) from In_shop where Flower_id = fl_id);
if (Arrived_amount > 50)
then  set new.Discount = 15;
end if;
end//
DELIMITER ;
-- проверка on_insert
DELIMITER //
create procedure trigger_on_insert_verify()
begin
select * from Sales;
insert into Sales values (4,4,44,"2021.03.04",44);
select * from Sales;
end//
DELIMITER ;
-- call trigger_on_insert_verify();

-- 3. Написать триггер, срабатывающий при удалении поставки из таблицы
-- Поставки. Если общее количество поставленного товара меньше 5, то данный товар
-- должен быть удален из таблицы Товары.
DELIMITER //
create trigger on_delete after delete on In_shop for each row
begin
declare remove_id, sum_amount_arrived int;
set remove_id = old.Flower_id;
set sum_amount_arrived = (select sum(Amount) from In_shop where Flower_id = remove_id);
if (sum_amount_arrived < 5)
then delete from Flowers where Flower_id = remove_id;
end if;
end//
DELIMITER 
-- проверка тригера удаления
DELIMITER //
create procedure trigger_on_delete_verify(input int)
begin
select * from In_shop;
select * from Flowers;
delete from In_shop where Info_id = input;
select * from In_shop;
select * from Flowers;
end//
DELIMITER ;
-- call trigger_on_delete_verify(3);

-- 4. Создать представление, содержащее информацию о товарах и общем
-- проданного товара. Выбрать из представления информацию о товарах которых
-- продано максимальное количество.
create view _4(Product_id, Product_name, Sold) as
select Sales.Flower_id, Flowers.Flower_name, SUM(Sales.Amount) from Sales inner join Flowers on Flowers.Flower_id = Sales.Flower_id group by Sales.Flower_id;
select * from _4 where Sold in (select max(Sold) from _4);

-- 5. Написать триггер, который при добавлении нового товара, создает для него
-- продажу с нулевыми значениями полей.

select Flower_id from Flowers;

DELIMITER //
create trigger Insert_new_Sales after insert on Flowers for each row
begin
call addSales(new.Flower_id,0,"2021.04.03",0);
end//
DELIMITER ;
-- проверка на тригера на добаление в таблицу цветков
DELIMITER //
create procedure trigger_Insert_new_Flowers_verify()
begin
select * from Flowers;
select * from Sales;
call addFlowers(5,"Архидея",15,55);
select * from Flowers;
select * from Sales;
end //
DELIMITER ;
-- call trigger_Insert_new_Flowers_verify();
-- 6. Продемонстрировать работу всех созданных объектов.


