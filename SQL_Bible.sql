-- create a table
/*
create table `tableName`(
`columnName`  `dataType`,
`columnName`  `dataType`,
...
);

`dataType`:
char(n): fixed-length, max length = n (always takes up n data)
varchar(n): variable-length, max length = n
text: articles & essays

integer: can use `auto_increment` & `serial`
boolean, bool

*/

-- date & time
/*
date – YYYY-MM-DD
time – HH:MM:SS
datetime – YYYY-MM-DD HH:MM:SS
timestamp – YYYY-MM-DD HH:MM:SS

** these are all entered as strings, i.e. ‘2015-10-15’
*/


-- to get current date:
current_date

-- to just get the year, day, month from date
-- extract(`selector` from `table`);
extract(year from graduation_date);

-- constraints:
/*
  not null
  default: lets you set default value if not given
  unique
  primary key: unique + not null, one per table
  foreign key
  check
*/

/* aggregate functions */
-- use 'having' with aggregate functions

-- auto_increment:
id  integer auto_increment primary key,
insert into employees (first_name, last_name) values ('Jane', 'Doe');

-- interval: (in the last year, days, etc) (returns exact day, not span)
select * from students where graduation_date is not null and current_date – interval '6 months' < graduaton_date;
  
select id from orders where date_ordered = current_date - interval '2 weeks';
  
-- functions:
-- to drop: drop function functionName(parameterType);

-- 1. (10pt) Create a stored function digits_sum() which takes an integer argument and returns the sum of the digits of the integer. For example, digits_sum(323)=8, i.e. 3+2+3. To receive full credit, your implementation must handle 0 and negative integers as well, e.g. digits_sum(0)=0 and digits_sum(-626)=14.

drop function digits_sum(integer);
create or replace function digits_sum( a integer ) returns integer as $$
declare
    sum integer;
begin

  -- check for negative
  if a < 0 then
    a := -a;
  end if;
  
  sum := 0;
  
  while a > 0 loop
    sum := sum + a % 10;
    a := a / 10;
  end loop;
  return sum;
  
end;
$$ language plpgsql;

-- select * from digits_sum(323);
-- select * from digits_sum(0);
-- select * from digits_sum(-626);
  
  
-- sample:
    
-- always drop tables in reverse order in which they were created
drop table if exists project_members;
drop table if exists projects;
drop table if exists employees;

-- employees(id, first_name, last_name, address, supervisor_id)
create table employees (
  id              integer auto_increment primary key,
  first_name      varchar(255),
  last_name       varchar(255),
  address         varchar(255),
  supervisor_id   integer references employees(id)
);

insert into employees values (1, 'John', 'Doe', 'Street #215', null);
insert into employees (first_name, last_name, address, supervisor_id)
  values ('Jane', 'Doe', 'Street #711', 1);

select * from employees;

-- projects(id, name,leader_id )
create table projects (
  id          integer auto_increment primary key,
  name        varchar(255),
  leader_id   integer references employees(id)
);

insert into projects values (1, 'Firestone', 1);
insert into projects values (2, 'Blue', 2);

select * from projects;

-- project_members( project_id, member_id ) 
create table project_members (
  project_id  integer references projects(id),
  member_id   integer references employees(id)
);

insert into project_members values (1, 1);
insert into project_members values (2, 1);
insert into project_members values (2, 2);

select * from project_members;

show databases;

-- Find the name and address of employee with id=1
select first_name, last_name, address from employees where id = 1;
-- -OR-
select concat( first_name, ' ', last_name) as name, address
    from employees where id = 1;

-- Find the name of employee who leads the project Firestone
select e.first_name, e.last_name from employees e, projects p
    where p.name = 'Firestone' and p.leader_id = e.id;
-- -OR-
select e.first_name, e.last_name from employees e inner join projects p
    on e.id = p.leader_id
    where p.name = 'Firestone';

-- Find the name of Jane Doe's supervisor
select e2.first_name, e2.last_name from employees e1, employees e2
    where e1.first_name = 'Jane' and e1.last_name = 'Doe'
    and e1.supervisor_id = e2.id;

-- Find the number of projects led by John Doe
select count(p.id) from projects p, employees e
    where p.leader_id = e.id and e.first_name = 'John'
    and e.last_name = 'Doe';

-- List the number of members of each project
select p.name, count(m.member_id) from projects p, project_members m
    where p.id = m.project_id
    group by p.name;

-- Change John Doe's address to 123 Main St.
update employees set address = '123 Main St.'
    where first_name = 'John' and last_name = 'Doe';

-- Change John Doe's name to Tom Smith 
update employees set first_name = 'Tom', last_name = 'Smith'
    where first_name = 'John' and last_name = 'Doe';

select * from employees;

-- Delete all the projects led by John Doe
delete from project_members where project_id in
    (select p.id from projects p, employees e
        where p.leader_id = e.id
        and e.first_name = 'John' and e.last_name = 'Doe');

delete from projects where leader_id = (select id from employees
        where first_name = 'John' and last_name = 'Doe');

-- Delete all the projects
delete from project_members;
delete from projects;

  
  
  
  
  
