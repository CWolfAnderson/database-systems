-- 1. (10pt) Create a stored function digits_sum() which takes an integer argument and returns the sum of the digits of the integer. For example, digits_sum(323)=8, i.e. 3+2+3. To receive full credit, your implementation must handle 0 and negative integers as well, e.g. digits_sum(0)=0 and digits_sum(-626)=14.

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