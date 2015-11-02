-- Due to the difficulty of the exercises fellow colleagues and I made a study group so some of the exercises may seem similar. Although exact code was not shared, we spent hours talking about implementation and algorithms. About 12 hours was spent on this assignment.

-- 1. Assuming the phone numbers are in the format (###) ###-####, find the names of the suppliers who are located in the area code 323.
select name from suppliers where substring(phone, 2, 3) = '323';

-- 2. Find the number of parts ordered in June this year (you may not assume "this year" is 2015).
select sum(quantity) from orders 
  where extract(year from date_ordered) = extract(year from current_date)
  and extract(month from date_ordered) = 06;
  
-- 3. Find the id's of the orders that were placed two weeks ago but were not yet received.
select id from orders where date_received is null 
  and date_ordered = current_date - interval '2 weeks';

-- 4. List the total payment made to each supplier last year. The results should include supplier name and the total payment to the supplier ordered by payment in descending order.
select s.name, sum(c.price * o.quantity) as sum from suppliers s 
	inner join catalog c on c.supplier_id = s.id 
	inner join orders o on o.supplier_id = c.supplier_id
	-- link order part with catalog part
	and o.part_id = c.part_id
  -- make sure it's from last year
	where extract(year from o.date_ordered) = extract(year from current_date) - 1
	group by s.name
	order by sum desc;

-- 5. List the total payment made in each month this year. The results should include month (in full name like January, February ... instead of 1, 2, ...) and the total payment in the month ordered by month in ascending order.
select to_char(o.date_ordered, 'Month') as month, 
	sum(c.price) from orders o 
	inner join catalog c on o.part_id = c.part_id 
	group by month 
	order by month;

-- 6. Find the names of the parts for which there is at least one supplier.
select distinct p.name from parts p 
	inner join catalog c on c.part_id = p.id
	inner join suppliers s on s.id = c.supplier_id
	where c.supplier_id is not null;
    
-- 7. Find the names of the parts for which there are at least two suppliers.
select distinct p.name from suppliers s
	inner join catalog c on c.supplier_id = s.id
	inner join parts p on p.id = c.part_id
	group by p.name
	having count(c.supplier_id) > 1;

-- 8. Find the names of the parts for which there is no supplier.
-- (something in the parts table but not in the catalog)
select p.name from parts p
	left join catalog c on p.id = c.part_id
	where c.part_id is null;

-- 9. Find the names of the suppliers who supply every red part.
select s.name from suppliers s
	inner join catalog c on c.supplier_id = s.id
	inner join parts p on p.id = c.part_id
  -- select red parts
	where p.color = 'red'
  -- group red parts by suppliers
	group by s.name
  -- check if amount of red parts from each supplier is equal to amount of total red parts
	having count(p.id) = (select count(p2.id) from parts p2
		where p2.color = 'red');

-- 10. Find the names of the suppliers who supply only red parts.
select distinct s.name from suppliers s  
	inner join catalog c on c.supplier_id = s.id
	inner join parts p on p.id = c.part_id
	-- get all red parts
	where p.color = 'red'
	-- but not suppliers who don't have red parts
	and s.name not in (
	-- exclude suppliers who don't have red parts
	select s2.name from suppliers s2
		inner join catalog c2 on c2.supplier_id = s2.id
		inner join parts p2 on p2.id = c2.part_id
		where p2.color <> 'red');

-- 11. Find the names of the parts that are supplied by Acme Widget Suppliers and no one else.
select p.name from parts p
  inner join catalog c on c.part_id = p.id 
  inner join suppliers s on s.id = c.supplier_id
  -- get part names whose supplier is 'Acme Widget Suppliers'
  where s.name = 'Acme Widget Suppliers'
  -- exclude parts that are not from 'Acme Widget Suppliers'
  and p.id not in (select p2.id from parts p2
	  inner join catalog c2 on c2.part_id = p2.id 
	  inner join suppliers s2 on s2.id = c2.supplier_id 
	  where s2.name <> 'Acme Widget Suppliers');

-- 12. For each part, find the name of the supplier who charges the least for the part.
select distinct s.name from suppliers s
	inner join catalog c on c.supplier_id = s.id
	inner join parts p on p.id = c.part_id 
	-- check that specific price is actually lowest price in catalog (based on id)
	where c.price = (select min(c2.price)
	from catalog c2
	where c2.part_id = p.id);
  
  