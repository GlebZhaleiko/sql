create database DB_LR4_7;
use DB_LR4_7;
-- ������� 3


--���� ������ �������� ������� �����
--���� ������ ������������� ��� ������� ����� ������ � ��������. � ���� ������ ������ ��������� ����������:

--- � ���������� ����� (id_���������, ������������ ���������, ����������� ����(�������), ������� �����);
create table Category(
Category_id int primary key,
Category_name varchar(30),
Varanty int,
Rules varchar(30)
);
--- � ������ (id_������, ������������ ������, id_���������, �������������, ��������, ����,
--����, ���������� �� ������); �������, ��� �������� ��� ������� � 36 �� 40 � ��������� �����������
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
--- � �������� (��������, id_������, ������, ����������, ������, ����).
create table Sales(
Sale_id int primary key,
Product_id int,
Size int check (Size = 36 or Size = 37 or Size = 38 or Size = 39 or Size = 40),
Sale_amount int,
Discount int,
Sale_date date

Foreign key(Product_id) references Products(Product_id) on delete cascade
);

--- � ���������� ����� (id_���������, ������������ ���������, ����������� ����(�������), ������� �����);
insert into Category values
(1,'����������',10,'���� ����������'),
(2,'�����������',20,'���� ����������'),
(3,'������������',30,'���� ����������');

--- � ������ (id_������, ������������ ������, id_���������, �������������, ��������, ����,
--����, ���������� �� ������); �������, ��� �������� ��� ������� � 36 �� 40 � ��������� �����������
insert into Products values
(1,'��������',1,'�����','�����','������',11,100),
(2,'�����',2,'�����','����','�������',202,200),
(3,'�������',3,'�������','����','������',33,300),
(4,'���',1,'������','�����','�����',404,400);


--- � �������� (��������, id_������, ������, ����������, ������, ����).
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

--1. �������� �������� ��������� ��� ���������� �������� �� ��� �������.
select * from Category;

GO
CREATE PROCEDURE Add_Category(@NC_id int, @Nc_name varchar(30), @Nvaranty int, @Nrules varchar(30)) AS
insert into Category values(@NC_id, @Nc_name, @Nvaranty, @Nrules);

exec Add_Category 4,'�������', 44, '���� ����������';

select * from Category;


--2. �������� �������� ��������� ��� �������� �� ������� ��������� ���� ���������,
--������� ����������� ���� ����� 12 �������.
select * from Category;

GO
CREATE PROCEDURE Delete_Category AS
delete from Category where Varanty > 12;

exec Delete_Category;

select * from Category;

--3. �������� �������� ��������� ����������� ����� ���������� ������ ���������
--���������. ��������� ���������� � ��������� � �������� ���������. ���� ��������� �����
--��������� ���, �� ������� ��������������� ���������.
GO 
CREATE PROCEDURE Count_Sum(@Category_id int) AS
select isnull('����',sum(Amount_in_storage)) from Products where Category_id = @Category_id;

drop procedure Count_Sum; 

exec Count_Sum 2;
exec Count_Sum 1;

select * from Category;
select * from Products;


--4. �������� ���������, ������� ������������� ������ 10 ��� ���� ������, � �������� ��������
--����.
select * from Sales;

GO 
CREATE PROCEDURE Discounting AS
update Sales set discount = 10 where month(Sale_date) = 9;

exec Discounting;

select * from Sales;

--5. �������� �������� ��������� ����������� ����������� ������ ���������� ������. id
--������ ���������� � ��������� � �������� ���������.
GO 
CREATE PROCEDURE Smoll(@Pr_id int) AS
select min(Size) from Sales where Product_id = @Pr_id;

exec Smoll 2;

--6. �������� ���������, ������� ������� ���������� ������ ��� ��������� ������, ���� ��
--������ ������� ������ ������ �����. ���� ���, ������� ���������. id_������ ���������� �
--�������� ���������.
GO 
CREATE PROCEDURE White_amount(@Pr_id int) AS
select count(Sale_id) from Sales inner join Products on Sales.Product_id = Products.Product_id where Color = '�����';

exec White_amount 4;

--7. �������� ���������, ������� ������������� ������ 5% ��� ������� ������, ���� �������
--���� ������� �� ������ ����� 100. id ������ ���������� � ��������� � �������� ���������.
GO 
CREATE PROCEDURE Smoll_discount(@Pr_id int) AS
update Sales set discount = 5 where Product_id = @Pr_id and (select Price from Products where Product_id = @Pr_id) > 100;
drop procedure Smoll_discount;

exec Smoll_discount 4;

select * from Sales;

--8. �������� ��� ���������� ��������� � ��������������� �� ������.