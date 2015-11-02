-- Write triggers to enforce the following data constraints in the University Database:
-- Only math majors can take the course titled Topology.
-- Students cannot take the course Calculus 2 without having received a passing grade (i.e. C or better) in Calculus 1.

create or replace function class_check() returns trigger as $$
declare
	l_class_title	courses.title%type;
	l_major				departments.name%type;
	l_calc1_grade	grades.id%type;
begin
	-- to get the class title they want to add
	
	-- 	select title into course_title from courses c, sections s
	--	where s.id = new.section_id and s.course_id = c.id;
	select c.title into l_class_title 
		from courses c, sections s
		where s.id = new.section_id 
		and s.course_id = c.id;
		

			select d.name into student_major from departments d, students s 
		  where	s.id = new.student_id and s.major_id = d.id;
		
		
	-- check if they when to add Topology
	if l_course_title = 'Topology' then
	
		-- get their major
		select d.name into l_major from departments d, students s
			where s.id = new.student_id and s.major_id = d.id;

		-- check if major is math
		if l_major <> 'Math' then
			raise exception 'You are not a math major therefore you cannot take Topology.';
		end if;
	end if;

	-- check if they want to add calculus 2
	if l_course_title = 'Calculus 2' then
	
		-- get their calculus 1 grade
		select e.grade_id into l_calc1_grade from enrollment e, students s
			inner join s.id = e.student_id
			where section_id = 32; -- Calculus 1 has a course id of 32
			
		-- check if their calculus 1 grade id is >= 7
		if l_calc1_grade >= 7 then
			raise exception 'You must receive a grade of C or better in Calculus 1 to take this class.';
		end if;
	end if;
	
    return new;
end;
$$ language plpgsql;

create trigger allowed_class
	before insert or update
	on enrollment
	for each statement
	execute procedure class_check();