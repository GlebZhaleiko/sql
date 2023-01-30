create database DB_LR4_10
use DB_LR4_10


--������� 1

--���� ������ ����������������
--���� ������ ������������� ��� ������� ����� ����������� ��������� ����������� � ������.
--� ���� ������ ������ ��������� ����������:
--- � ���������� ��������� (id, ������������, ��������, ����������, ��������� ������ ���� �������, ���������);
create table Inventory(
Inventory_id int primary key,
Inventory_name varchar(30),
Inventory_description varchar(30),
Amount int,
Price_for_hour int,
Category varchar(30)
);
--- � ������� (����� ��������, �������, �������, �����, ������ ������, ������� (����������));
create table Clients(
Client_id int primary key,
Client_surname varchar(30),
Phone varchar(30),
Adress varchar(30),
Amount_of_loan int,
Active bit
);
--- � ������ (�������, ���� ������, id_���������, ����� ��������, ���������� ����� �������, ������ ).
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


--- � ���������� ��������� (id, ������������, ��������, ����������, ��������� ������ ���� �������, ���������);
insert into Inventory values
(1,'�������','��� ���',10,11,'����������'),
(2,'������','�������',20,12,'����������'),
(3,'������','�������',30,13,'����������');
--- � ������� (����� ��������, �������, �������, �����, ������ ������, ������� (����������));
insert into Clients values
(1,'���������','111111111111','��� ��',0,0),
(2,'�����������','222222222222','����� ��',22,1),
(3,'�����','333333333333','���� ��',33,1);
--- � ������ (�������, ���� ������, id_���������, ����� ��������, ���������� ����� �������, ������ ).
insert into Orders values
(1,'09.13.2022',1,1,36,10),
(2,'09.07.2022',3,3,37,12),
(3,'03.14.2022',2,1,38,13),
(4,'03.14.2022',3,2,39,14);

select * from Inventory;
select * from Clients;
select * from Orders;




--1. �������� �������� ��������� ��� ���������� �������� �� ��� �������.
select * from Inventory;

GO
CREATE PROCEDURE Add_inventory(@Ni_id int, @Ni_name varchar(30), @Ndescription varchar(30), @Namount int , @Nprice int, @Ncategory varchar(30)) AS
insert into Inventory values(@Ni_id, @Ni_name, @Ndescription, @Namount, @Nprice, @Ncategory);

exec Add_inventory 4,'��������','�������',30,14,'����������';

select * from Inventory;

select * from Clients;

GO
CREATE PROCEDURE Add_clients(@Nc_id int, @Nc_name varchar(30), @Nphone varchar(30), @Nadress varchar(30) , @Namount int, @Nactive bit) AS
insert into Clients values(@Nc_id, @Nc_name, @Nphone, @Nadress, @Namount, @Nactive);

exec Add_clients 4,'��������','444444444444','������ ��',44,1;

select * from Clients;

select * from Orders;

GO
CREATE PROCEDURE Add_orders(@No_id int, @Ndate date, @Ni_id int, @Nc_id int , @Nhours int, @Ndiscount int) AS
insert into Orders values(@No_id, @Ndate, @Ni_id, @Nc_id, @Nhours, @Ndiscount);

exec Add_orders 5,'10.11.2022',2,4,55,15;

select * from Orders;

--2. �������� �������� ��������� ����������� ����� ���������� ��������� ���������
--���������. ��������� ���������� � ��������� � �������� ���������. ���� ��������� �����
--��������� ���, �� ������� ��������������� ���������.
--3. �������� ���������, ������� ������������� ���������� ����� ������� 0 ��� ���� �������,
--���� ������� ��� �� ���������.
--4. �������� ���������, ������� ������������� ������ 10%, ���� ���������� ����� �������
--��������� � ������ ����� 8, � 0% - ����� ���������� ����� ������� ����� ���� �����. id
--��������� ���������� � ��������� � �������� ���������.
--5. �������� �������, ������� ����������� ��� ���������� ��� ���������� ������� ������,
--���� � ������� ��������� ����� ������ ����� �������, �� ��������� ��� ������ � ��� ����.
--6. �������� �������, ������� ��� ���������� ������ ������� ��������� �� �������
--���������, ���� ���������� ��� ������� ��������� 4.
--7. �������� �������, ������� � ������ �������� ������� ������ �������� ������ � ����
--������� False.
--8. �������� �������, ������� � ������ ���������� ������ ������� ������� ��� ���� ����� �
--����������� ����� ������� 1 � ����������� �����.
--9. ����������������� ������ ���� ��������� � ��������.