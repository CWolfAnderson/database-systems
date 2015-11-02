-- Write triggers to enforce the following data constraints in the University Database:
-- Only math majors can take the course titled Topology.
-- Students cannot take the course Calculus 2 without having received a passing grade (i.e. C or better) in Calculus 1.
create or replace function math_students_only() returns trigger as $$
declare
	course_title courses.title%type;
	student_major departments.name%type;

begin
	select title into course_title from courses c, sections s
	where s.id = new.section_id and s.course_id = c.id;

	select d.name into student_major from departments d, students s 
  where	s.id = new.student_id and s.major_id = d.id;

	if course_title = 'Topology' then
		if student_major != 'Math' then
			raise exception 'Only math students can take the topology class';
		end if;
	end if;

	return new;
end;
$$ language plpgsql;

create trigger math_students_only
    before insert or update
    on enrollment
    for each row -- for each statement (statement is the update enrollment...)
    execute procedure math_students_only();
		
		
		