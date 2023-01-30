create database DB_LR4_10
use DB_LR4_10


--Вариант 1

--База данных «Спортинвентарь»
--База данных предназначена для ведения учета спортивного инвентаря выдаваемого в прокат.
--В базе данных должна храниться информация:
--- о спортивном инвентаре (id, наименование, описание, количество, стоимость одного часа проката, категория);
create table Inventory(
Inventory_id int primary key,
Inventory_name varchar(30),
Inventory_description varchar(30),
Amount int,
Price_for_hour int,
Category varchar(30)
);
--- о клиенте (номер паспорта, фамилия, телефон, адрес, размер залога, активен (логическое));
create table Clients(
Client_id int primary key,
Client_surname varchar(30),
Phone varchar(30),
Adress varchar(30),
Amount_of_loan int,
Active bit
);
--- о заказе (№заказа, дата заказа, id_инвентарь, номер паспорта, количество часов проката, скидка ).
create table Orders(
Order_id int primary key,
Order_date date,
Inventory_id int,
Client_id int,
Rent_hours int,
Discount int,

Foreign key(Inventory_id) references Inventory(Inventory_id) on delete cascade,
Foreign key(Client_id) references Clients(Client_id) on delete cascade
);


--- о спортивном инвентаре (id, наименование, описание, количество, стоимость одного часа проката, категория);
insert into Inventory values
(1,'Гантеля','Для рук',10,11,'Спортивное'),
(2,'Штанга','Тяжелая',20,12,'Спортивное'),
(3,'Коврик','Широкий',30,13,'Спортивное');
--- о клиенте (номер паспорта, фамилия, телефон, адрес, размер залога, активен (логическое));
insert into Clients values
(1,'Харитонов','111111111111','там то',0,0),
(2,'Александров','222222222222','Здесь то',22,1),
(3,'Холмс','333333333333','туда то',33,1);
--- о заказе (№заказа, дата заказа, id_инвентарь, номер паспорта, количество часов проката, скидка ).
insert into Orders values
(1,'09.13.2022',1,1,36,10),
(2,'09.07.2022',3,3,37,12),
(3,'03.14.2022',2,1,38,13),
(4,'03.14.2022',3,2,39,14);

select * from Inventory;
select * from Clients;
select * from Orders;




--1. Написать хранимые процедуры для добавления значений во все таблицы.
select * from Inventory;

GO
CREATE PROCEDURE Add_inventory(@Ni_id int, @Ni_name varchar(30), @Ndescription varchar(30), @Namount int , @Nprice int, @Ncategory varchar(30)) AS
insert into Inventory values(@Ni_id, @Ni_name, @Ndescription, @Namount, @Nprice, @Ncategory);

exec Add_inventory 4,'эспандер','Тягучий',30,14,'Спортивное';

select * from Inventory;

select * from Clients;

GO
CREATE PROCEDURE Add_clients(@Nc_id int, @Nc_name varchar(30), @Nphone varchar(30), @Nadress varchar(30) , @Namount int, @Nactive bit) AS
insert into Clients values(@Nc_id, @Nc_name, @Nphone, @Nadress, @Namount, @Nactive);

exec Add_clients 4,'Деточкин','444444444444','оттуда то',44,1;

select * from Clients;

select * from Orders;

GO
CREATE PROCEDURE Add_orders(@No_id int, @Ndate date, @Ni_id int, @Nc_id int , @Nhours int, @Ndiscount int) AS
insert into Orders values(@No_id, @Ndate, @Ni_id, @Nc_id, @Nhours, @Ndiscount);

exec Add_orders 5,'10.11.2022',2,4,55,15;

select * from Orders;

--2. Написать хранимую процедуру вычисляющую общее количество инвентаря выбранной
--категории. Категория передается в процедуру в качестве параметра. Если инвентаря такой
--категории нет, то вывести соответствующее сообщение.
--3. Написать процедуру, которая устанавливает количество часов проката 0 для всех заказов,
--дата которых еще не наступила.
--4. Написать процедуру, которая устанавливает скидку 10%, если количество часов проката
--инвентаря в заказе более 8, и 0% - ессли количество часов проката менее двух часов. id
--инвентаря передаются в процедуру в качестве параметра.
--5. Написать триггер, который срабатывает при добавлении или обновлении таблицы заказы,
--если у клиента оказалось более десяти часов проката, то увеличить его скидку в два раза.
--6. Написать триггер, который при добавлении заказа удаляет интентарь из таблицы
--инвентарь, если количество его заказов превысило 4.
--7. Написать триггер, который в случае удаления клиента вместо удаления ставит в поле
--Активен False.
--8. Написать триггер, который в случае добавления нового клиента создает для него заказ с
--количеством часов проката 1 и сегодняшней датой.
--9. Продемонстрируйте работу всех триггеров и процедур.