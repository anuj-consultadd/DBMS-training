show databases;
create database test1;
use test1;
CREATE TABLE IF NOT EXISTS unlabeled_image_predictions (
image_id int,
score float
);
INSERT INTO unlabeled_image_predictions (image_id, score) VALUES
('828','0.3149'), ('705','0.9892'), ('46', '0.5616'), ('594','0.7670'), ('232','0.1598'), ('524','0.9876'), ('306','0.6487'), ('132','0.8823'), ('906', '0.8394'), ('272', '0.9778'), ('616', '0.1003'), ('161','0.7113'), ('715', '0.8921'), ('109', '0.1151'), ('424','0.7790'), ('609', '0.5241'), ('63', '0.2552'), ('276','0.2672'), ('701', '0.0758'), ('554','0.4418'), ('998', '0.0379'), ('809','0.1058'), ('219', '0.7143'), ('402', '0.7655'), ('363', '0.2661'), ('624', '0.8270'), ('640', '0.8790'), ('913', '0.2421'), ('439','0.3387'), ('464', '0.3674'), ('405', '0.6929'), ('986', '0.8931'), ('344', '0.3761'), ('847', '0.4889'), ('482', '0.5023'), ('823','0.3361'), ('617', '0.0218'), ('47', '0.0072'), ('867','0.4050'), ('96', '0.4498'), ('126', '0.3564'), ('943','0.0452'), ('115', '0.5309'), ('417', '0.7168'), ('706', '0.9649'), ('166', '0.2507'), ('991','0.4191'), ('465', '0.0895'), ('53','0.8169'), ('971','0.9871');

RENAME TABLE unlabeled_image_predictions TO uip;

-- select * from uip;

-- select image_id, score, row_number() over (order by score desc) as ronum from uip ;
-- select image_id, score, row_number() over (order by score) as ronum from uip;

-- select image_id, score from 
-- (select image_id, score, row_number() over (order by score desc) as ronum from uip) as descRes
-- where mod(descres.ronum, 3) = 1;

-- select image_id, score from 
-- (select image_id, score, row_number() over (order by score ) as ronum from uip) as ascRes
-- where mod(ascres.ronum, 3) = 1 


-- method 1 using subqueries
select image_id, round(score) as weak_label from
(select image_id, score, 
row_number() over (order by score desc) as descRonum,
row_number() over (order by score)  as ascRonum
from uip) as rankedRoNum
where
descRonum < 30000 AND mod(descRonum, 3) = 1 or ascRonum < 30000 AND mod(ascRonum,3) = 1 order by image_id;



-- method 2 using CTEs
with topEntries as (
select image_id, score,
row_number() over(order by score desc) as descRonum
from uip
limit 10000),

bottomEntries as (
select image_id, score,
row_number() over(order by score ) as ascRonum
from uip
limit 100000)

select image_id, round(score) as weak_label
from( select image_id, score, descRonum, NULL as ascRonum from topEntries
UNION ALL
select image_id, score, NULL as descRonum, ascRonum from bottomEntries
) as combinedRanked
where mod(descRonum, 3 ) = 1 OR mod(ascRonum, 3) = 1
order by image_id;










