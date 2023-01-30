use LR4_6
-- ������� 2


--���� ������ �����������
--���� ������ ������������� ��� ������� ����� ������ � �����������. � ���� ������ ������
--��������� ����������:
--- � ������ (id, ������������, ��������, ���������� � ��������, ���� �� ��, ���������);
create table Product(
Product_id int primary key,
Product_name varchar(30),
Product_description varchar(30),
Product_amount int,
Price_for_one int ,
Category varchar(30)
);

--- � ������� (� ������, id_������, ����, �������, ����������);
create table Losses(
Loss_id int primary key,
Product_id int,
Loss_date date,
Cause varchar(30),
Loss_amount int,

Foreign key(Product_id) references Product(Product_id) on delete cascade
);

--- � �������� (��������, id_������, ���� �������, ����������, ������ ).
create table Sales(
Sale_id int primary key,
Product_id int,
Sale_date date,
Sale_amount int,
Discount int,

Foreign key(Product_id) references Product(Product_id) on delete cascade
);


--- � ������ (id, ������������, ��������, ���������� � ��������, ���� �� ��, ���������);
insert into Product values
(1,'������� ����','����',10,11,'���'),
(2,'�������-�������','�������',20,30000,'�����������'),
(3,'������ ��� ������','��� ������',30,33,'�������');

--- � ������� (� ������, id_������, ����, �������, ����������);
insert into Losses values
(1,3,'09.13.2022','����',11),
(2,3,'09.07.2022','����',22),
(3,2,'03.14.2022','����',33),
(4,1,'03.14.2022','����������',44);

--- � �������� (��������, id_������, ���� �������, ����������, ������ ).
insert into Sales values
(1,2,'09.13.2022',10,10),
(2,3,'09.07.2022',12,12),
(3,2,'03.14.2022',13,13),
(4,1,'03.14.2022',4,14);

select * from Product;
select * from Losses;
select * from Sales;

--���������� ����������� ������ ��������� ����������:
--1) ��������� ����� ������ ������� � ������ ������.
select Sale_id, ((Sale_amount * Price_for_one) - (Sale_amount * Price_for_one) / 100 * Discount) from Product join Sales on Sales.Product_id = Product.Product_id;

--2) �������� � �������� �������, ��������� � ���������� ������ 5 �� � ����� �������.
select Product_name, Product_description from Product where Product_id in (select Product_id from Sales where Sale_amount > 5);

--3) �������� � ��������� �������, ������� �������� ������������ � ����������� ����������.
select Product_name, Category from Product where Product_id in (select Product_id from Losses where Loss_amount in (select MIN(Loss_amount) from Losses) or Loss_amount in (select MAX(Loss_amount) from Losses));

--4) �������� � �������� ������, ������ �������� ������ 1, � ����� �� ��. �� ����� 20000.
select Product_name, Product_description from Product where Product_id in (select Product_id from Losses where Loss_amount > 1) and Price_for_one < 20001;

--5) ������� ������������ � ��������� ���� ������� � ���������� � �� �������. ���� ������
--��� ������ �� ����������, �������� ����� �� ������� ������ ������ ���� �� ����������.
select Product_name, Category, Cause from Product join Losses on Losses.Product_id = Product.Product_id;

--6) ������� ������������ ������� � ��� ��������� ������� ������ �������. �������� ������
--������, ���������� ������� � �������� ������ 5 ��.
select Product_name, Cause, Product_amount from Product join Losses on Losses.Product_id = Product.Product_id where Product_amount > 5;

--7) ����� ���������� ������ �� ������� ������������ ������.
select Product.Product_name, sum(Loss_amount) from Product join Losses on Losses.Product_id = Product.Product_id group by Product_name;


--8) ���������� � ����� ������ �� ������ ����. �������� ������ �� ����, ����� ����� ������
--��������� ������ 10000.
select count(Sale_id) ,sum(Sale_amount * Price_for_one), Sale_date from Product join Sales on Sales.Product_id = Product.Product_id where (Sale_amount * Price_for_one) > 10000 group by Sale_date;

--9) � �������, ��� ������� ����������� �������.
select * from Product join Sales on Sales.Product_id = Product.Product_id where Sale_id is NULL;

--10) ��� ������ ��������� ������ �������� ����� ���������� ������� ������ ���������, �������
--������� � ������� � ���������� ���������� ������.
select Category, sum(Product_amount), sum(Sale_amount) from Product join Sales on Sales.Product_id = Product.Product_id where Product_amount > 0 group by Category;
