-- Hämta ut alla betyg som blivit satta för kursen 'Databaser'
select e.Grade
from Enrollment e
join Course c on e.CourseId = c.Id
where c.Name = 'Databaser';
-- Hämta ut alla betyg för alla kurser
select c.Name Kurs, e.Grade Betyg
from Enrollment e
join Course c on e.CourseId = c.Id
order by Kurs;
-- Hämta ut medelsnittsbetyg per kurs
select c.Name as Kurs, avg(e.Grade) as Betyg
from Enrollment e
join Course c on e.CourseId = c.Id
group by Kurs;

-- Hämta ut vad varje lärare har satt i snittbetyg
select t.Name as Lärare, avg(e.Grade) as Betyg
from Enrollment e
join Course c on e.CourseId = c.Id
join Teacher t on c.TeacherId = t.Id
group by Lärare;