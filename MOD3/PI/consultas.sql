---Function l2
CREATE or replace function l2(elem1 float[], elem2 float[]) returns float as $$
declare
 size integer;
 somat float;
begin
 size := cardinality(elem1);
 somat := 0;
 for i in 1..size loop
    somat := somat + (ABS(elem1[i] - elem2[i])*ABS(elem1[i] - elem2[i]));
 end loop;
 return sqrt(somat);
end $$
language plpgsql; 
------------------------------------------------------------------------------
DROP FUNCTION rangequeryl2
--RangeQuery
CREATE or replace function RangeQueryl2(qc float[], radius float) 
 returns table (id character varying, distance float) as $$
 begin
  return query 
      select track_id, l2(features_array,qc) as distance
      from spotify
      where l2(features_array,qc) <= radius;
 
 end $$
 language plpgsql; 
------------------------------------------------------------------------------

{0.807,0.44799999999999995,0.91,0.604,0,0,6,0.0863,-4.3919999999999995,0,0.08199999999999999}


create extension cube

select * from spotify;
 
SELECT track_id,cube(features_array) <-> cube(array[0.344,0.00267,0.557,0.7190000000000001,0,0,2,0.306,-4.515,0,0.0372]) as distance
FROM spotify
ORDER BY cube(features_array) <-> cube(array[0.344,0.00267,0.557,0.7190000000000001,0,0,2,0.306,-4.515,0,0.0372]) desc LIMIT 5;


SELECT * FROM songs
WHERE track_id = '5tyMJlMqaggzvuX7TtlrTe'


table spotify
SELECT * FROM RangeQueryl2(array[0.344,0.00267,0.557,0.7190000000000001,0,0,2,0.306,-4.515,0,0.0372], 10) ORDER by distance DESC;


SELECT * FROM genre
WHERE track_id = '60ynsPSSKe6O3sfwRnIBRf' OR
track_id = '1whfVLMKWqAX3uk97VXsNN' OR
track_id = '43zdsphuZLzwA9k4DJhU0I'

