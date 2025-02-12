## Problem statement 
### A Data is given about the different images and their scores given by a classifier.Our task is to sort the given data according to the scores then starting from first value take every third value and also starting from the bottom most take every third value making sure those values does not exeed the given limit of 10000 and combine those two results in a single table having coloumns as image_id and rounded of scores named "weak_label".


## Database Schema and Given data

```sql
CREATE TABLE IF NOT EXISTS unlabeled_image_predictions (
    image_id INT,
    score FLOAT
);


INSERT INTO unlabeled_image_predictions (image_id, score) VALUES
(828, 0.3149), (705, 0.9892), (46, 0.5616), (594, 0.7670), (232, 0.1598), 
(524, 0.9876), (306, 0.6487), (132, 0.8823), (906, 0.8394), (272, 0.9778), 
(616, 0.1003), (161, 0.7113), (715, 0.8921), (109, 0.1151), (1424, 0.7790), 
(609, 0.5241), (63, 0.2552), (276, 0.2672), (701, 0.0758), (554, 0.4418), 
(998, 0.0379), (1809, 0.1058), (219, 0.7143), (402, 0.7655), (363, 0.2661), 
(624, 0.8270), (640, 0.8790), (913, 0.2421), (439, 0.3387), (464, 0.3674), 
(405, 0.6929), (986, 0.8931), (344, 0.3761), (847, 0.4889), (482, 0.5023), 
(823, 0.3361), (617, 0.0218), (47, 0.0072), (867, 0.4050), (96, 0.4498), 
(126, 0.3564), (943, 0.0452), (115, 0.5309), (417, 0.7168), (706, 0.9649), 
(166, 0.2507), (991, 0.4191), (465, 0.0895), (53, 0.8169), (1971, 0.9871);
```

## Approach 1: using subqueries
```sql
select image_id, round(score) as weak_label from
(select image_id, score, 
row_number() over (order by score desc) as descRonum,
row_number() over (order by score)  as ascRonum
from uip) as rankedRoNum
where
descRonum < 30000 AND mod(descRonum, 3) = 1 or ascRonum < 30000 AND mod(ascRonum,3) = 1 order by image_id;
```

Here firsty we tried to add a additional colomn to our table after its sorted in descending order according to scores.

To take the first value and then every third afterwards it, this was accomplised uning the "Row_Rumber()" window function over descending score and also gave the coloumn name as "descRonum".

Now to take the first value from bottom and then every third value above it we first added another coloumn named "ascRonum" using the same row_number window operator but this time over non-decreasing(ascending) order sorted scores (so our bottom most value gets the lowest row number)

After the creation of these two coloumns we need to display the final table output so to do that and keep every third value.

FOR every third from TOP: we took mod of the descRonum value and took the modulus of it by 3 and it should be equal to 1 that way it will always start from 1 and take every third value.

FOR every third from BOTTOM: we took mod of the ascRonum value and took the modulus of it by 3 and it should be equal to 1 that way it will always start from 1 and take every third value.

also another checks were added so the total row entries from top and bottom does not exeed 10000 this was done using descRonum < 30000 and ascRonum < 30000
as we are taking every third value that meanins only one third of these values will we considered 

Lastly in the output table we took the rounded off score values and renamed that coloumn as weak_label.


## drawbacks:

using subqueries can make our query complex and difficult to understand.

Additionally the limit check using descRonum value below 30000 and same for ascRonum will work but will cause a large overhead as we are using the limit when we are creating the final output not when we are giving the row number so the cpu have to firstly consider all the rows and give them a row_number.

## Approach 2: using Common Table Expressions:

```sql
with topEntries as (
select image_id, score,
row_number() over(order by image_id desc) as descRonum
from uip
limit 10000),

bottomEntries as (
select image_id, score,
row_number() over(order by image_Id ) as ascRonum
from uip
limit 100000)

select image_id, round(score) as weak_label
from( select image_id, score, descRonum, NULL as ascRonum from topEntries
UNION ALL
select image_id, score, NULL as descRonum, ascRonum from bottomEntries
) as combinedRanked
where mod(descRonum, 3 ) = 1 OR mod(ascRonum, 3) = 1
order by image_id;
```

Here we firstly created two new temporary tables using the "with" clause names topEntries and bottomEntries
so that we can keep track of every third row from the top and also from the bottom respectively.

The "with" clause was used beacuse so to increase the scope of out derieved tables and use them later anywhere in the same query.

although here also both these new tables were given a new coloumn names descRonum to the TopEntries and ascRonum to the bottomEntries using the same row number logic as we previously used in approach 1.

But the main reason for using this approach was to use the given limit of 10000 the moment we are creating these two tables. This way even if there are a large number of entries only first 10000 entries will be considered.

Then both of these two created tables were combined using UNION ALL (duplicates included) into a new table named "combinedRanked" and the output was given using the same previously used modulus operaator logic to consider every third values.
lastly here the score values were rounded off with given alias as weak_score.

## FINAL OUTPUT.
[View CSV on GitHub](task_1_final_output.csv)


