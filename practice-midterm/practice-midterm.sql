-- 2. (15pt) Complete the following queries:

-- (a) List the average section size in each year. The results should be ordered by average section size in descending order.
select a.year, avg(a.count)
  from (select s.year, s.id, count(e.student_id) as count
  from enrollment e, sections s
  where e.section_id = s.id
  group by s.id, s.year)
  as something group by a.year
  order by avg(a.myCount);

-- (b) List the names of the professors who have taught Computer Science courses for at least two consecutive years. The results should not contain duplicates.


-- (c) Find the GPA of the student Joe. Note that GPA is calculated as sum(grade_point_value*units)/sum(units). For example, if a student got an A in a 4-unit class and a B in a 2-unit class, the GPA of the student should be (4.0*4+3.0*2)/(4+2)=3.67.


-- 3 (30pt)

-- (a) Write a stored function round_to_grade() that takes a number between 0 and 4, and returns the letter grade whose grade point value is closest to the number. For example, round_to_grade(3.75) should return 'A-', while round_to_grade(3.9) should return 'A'. If a number is at the exact middle of two grades, we round it up to the higher grade, e.g. round_to_grade(3.85) should return 'A'. For any number outside the range of 0 to 4, the function should raise an exception.
create or replace function round_to_grade(num_grade numeric) returns varchar(255) as $$
declare
    l_letter varchar(255);
begin

  -- round by decimal
  num_grade := round(num_grade, 1);

	if num_grade > 4.0 or num_grade < 0 then
		raise exception 'You must enter a valide grade.';
	end if;
  
  
	select g.letter into l_letter from grades g
		order by abs(g.value - num_grade)
		limit 1;
	
	return l_letter;
  
end;
$$ language plpgsql;

-- (b) Use the function round_to_grade() to write a query that lists the names of the professors and the average grade they gave in their classes.
select f.name, round_to_grade(sum(g.value) / count(g.value))
	from faculty f, sections s, enrollment e, grades g
	where f.id = s.instructor_id
	and s.id = e.section_id
	and e.grade_id = g.id
	group by f.name;

-- 4. (20pt)  Write a trigger enrollment_check to enforce the constraint that only students who major in Computer Science can take the class Compilers.
create or replace function enrollment_check_fun() returns trigger as $$
declare
	l_course_title	 courses.title%type;
	l_student_major departments.name%type;

begin
	select c.title into l_course_title from courses c, sections s
	where s.id = new.section_id 
	and s.course_id = c.id;

	if l_course_title = 'Compilers' then
		select d.name into l_student_major from departments d, students s 
		where s.id = new.student_id and s.major_id = d.id;
		
		if student_major <> 'Computer Science' then
			raise exception 'Only CS students can take the Compilers.';
		end if;
	end if;

	return new;
end;
$$ language plpgsql;

create trigger enrollment_check
    before insert or update
    on enrollment
    for each row
    execute procedure enrollment_check_fun();
