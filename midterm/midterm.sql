-- 2. (15pt) Complete the following queries:

-- (a) List the movies that have been rented less than 3 times. The results should include movie title and the number of times the movie was rented. Movies that have never been rented should be included in the results as being rented 0 times.
select m.title, count(r.id) count from movies m
	inner join discs d on d.movie_id = m.id
	inner join rentals r on r.disc_id = d.id
	group by m.title
	having count(r.id) < 3;

-- (b) Find the most popular genre based on the number of rentals. The result should include the name of the genre and the number of times the movies in that genre were rented. If there is a tie, showing one of the top genres is enough.
select g.name from genres g
	inner join movie_genres mg on mg.genre_id = g.id
	inner join movies m on m.id = mg.movie_id
	inner join discs d on d.movie_id = m.id
	inner join rentals r on r.disc_id = d.id
	group by g.name
	having count(r.id) >= 2; -- how do you say greater than all the rest?

-- (c) Find the most popular genre based on the average movie ratings. The result should include the name of the genre and the average movie rating for that genre. If there is a tie, showing one of the top genres is enough.
select g.name, avg(r.rating) from genres g
	inner join a bunch of stuff

-- 3. (30pt) Write a stored function return_disc() that takes a disc id as argument and returns the amount to be charged for the rental. 
-- The function should first check the rentals table and see if the disc was rented out but not yet returned. 
-- If so, the function sets date_returned to be the current date and sets the available field of the disc to true in the discs table, then returns the amount to be charged based on date_rented, date_returned, and the per-day rental price of the disc. 
-- If the rentals table shows that the disc was not rented out or had already been returned, the function outputs a warning message and returns -1.

drop function return_disc(integer);

create or replace function return_disc(d_id integer) returns float as $$
declare
	l_rented 	date;
	l_returned 	date;
	l_charge	float;
	l_days_rented	integer;
begin
	select r.date_rented into l_rented from rentals r
		where r.disc_id = d_id;
	select r.date_returned into l_returned from rentals r
		where r.disc_id = d_id;

	-- check the rentals table and see if the disc was rented out but not yet returned
	if l_returned is null then
		raise exception 'Movies has not been returned';
	end if;

	-- set date_returned to current_date

	-- set discs.available to true

	-- get days rented
	

	-- get the price (include date_rented & date_returned)
	select d.price into l_charge from discs d
		where d.id = d_id;
	

	return l_charge;
  
end;
$$ language plpgsql;

-- 2 is null, 5 is ok
-- select return_disc(5);


-- 4. (20pt) Create a trigger rate_only_rented which enforces the constraint that a customer can only rate a movie he or she rented before.

create or replace function rate_only_rented_fun() returns trigger as $$
declare
	l_rented	date;
begin

	-- check if movie was previously rented
	select re.date_rented into l_rented from rentals re
		inner join ratings ra on ra.customer_id = re.customer_id;

	if l_rented is null then
		raise exception 'Ratings cannot be given for movies not rented';
	end if;

	return new;
end;
$$ language plpgsql;

create trigger rate_only_rented
    before insert or update
    on ratings
    for each row
    execute procedure rate_only_rented_fun();

-- insert into ratings values (2, 2, 1);