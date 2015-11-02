drop table if exists orders;
drop table if exists catalog;
drop table if exists parts;
drop table if exists suppliers;

create table suppliers(
	id 			integer primary key,
	name 		varchar(255),
	address varchar(255),
	phone		varchar(13)
);
	
insert into suppliers values(2238, 'Home Depot', '2139 Westfield Way', '(310)239-4837');
insert into suppliers values(4965, 'Virgil''s', '248 Northbound Drive', '(323)895-5675');
insert into suppliers values(4353, 'Costco', '1212 Los Feliz Blvd', '(323)231-4235');
insert into suppliers values(293, 'Reds', '2428 Red Blvd', '(231)426-4233');
-- ---------------------------------------------------------------------
		
create table parts(
	id 		integer primary key,
	name 	varchar(255),
	color varchar(255)
);
		
insert into parts values(34, 'Washer', 'silver');
insert into parts values(264, 'Shovel', 'brown');
insert into parts values(12, 'Hammer', 'purple');
insert into parts values(867, 'Axe', 'red');
insert into parts values(492, 'Saw', 'red');
insert into parts values(222, 'Glue', 'transparent');
		
-- ---------------------------------------------------------------------
	
create table catalog(
	supplier_id	integer references suppliers(id),
	part_id			integer references parts(id),
	price				float
);

insert into catalog values(293, 867, 12.00);
insert into catalog values(293, 492, 13.00);
insert into catalog values(2238, 34, 1.00);
insert into catalog values(2238, 867, 10.00);
insert into catalog values(2238, 12, 5.00);

insert into catalog values(4965, 264, 25.00);
insert into catalog values(4965, 34, 100.00);
insert into catalog values(4965, 264, 100.00);
		
-- ---------------------------------------------------------------------
	
create table orders(
	id						integer primary key,
	supplier_id		integer references suppliers(id),
	part_id				integer references parts(id),
	quantity			integer,
	date_ordered	date,
	date_received	date
);

insert into orders values(1, 2238, 34, 4, '2014-03-13', '2014-03-24');
insert into orders values(2, 4965, 12, 4, '2014-06-27', '2014-06-30');
insert into orders values(3, 4965, 264, 1, '2015-10-12', '2015-10-20');
insert into orders values(4, 2238, 34, 4, '2015-10-15', '2015-10-22');
insert into orders values(5, 2238, 34, 3, '2015-06-15', '2015-06-23');
insert into orders values(6, 2238, 34, 4, '2015-06-15', '2015-06-24');
insert into orders values(7, 4353, 34, 8, '2015-10-13', null);

-- ---------------------------------------------------------------------