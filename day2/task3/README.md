# Problem Statement

### Given below are the three schemas of different accounts belonging to users, another where imformation about differnet items are managed and lastly which defines which item is held by which account_id and whats its quality. We need to design a item adviser mechanism that suggests the HIGHEST quality item of a given type for a given user and the data should be arranged in ascending order by username and then ascending order by type.

## Database and Schema SQL code:

```sql

Create Database Task_3;
use Task_3;
 
-- Schema design
CREATE TABLE accounts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    type ENUM('sword', 'shield', 'armor') NOT NULL,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE accounts_items (
    account_id INT,
    item_id INT,
    quality ENUM('common', 'rare', 'epic') NOT NULL,
    FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES items(id) ON DELETE CASCADE
);
```

## Dummy Data inserted:
note that some additional data was added for testing.

```sql
INSERT INTO accounts (id, username) VALUES
(1, 'cmunns1'),
(2, 'yworcs0');

INSERT INTO items (id, type, name) VALUES
(1, 'sword', 'Sword of Solanaceae'),
(2, 'shield', 'Shield of Rosaceae'),
(3, 'shield', 'Shield of Fagaceae'),
(5, 'shield', 'Shield of Lauraceae'),
(6, 'sword', 'Sword of Loasaceae'),
(7, 'armor', 'Armor of Myrtaceae'),
(8, 'shield ', 'Shield of Rosaceae'),
(10, 'shield', 'Shield of Rosaceae');

-- Additional data 
insert into accounts_items(account_id, item_id, quality) values
(1,6, 'common'),
(2,3, 'epic'),
(1,3, 'epic');



INSERT INTO accounts_items (account_id, item_id, quality) VALUES
(1, 10, 'epic'),
(1, 2, 'rare'),
(1, 2, 'rare'),
(1, 7, 'rare'),
(1, 1, 'common'),
(1, 2, 'common'),
(1, 3, 'common'),
(1, 5, 'common'),
(1, 8, 'common'),
(2, 8, 'epic'),
(2, 5, 'rare'),
(2, 3, 'common'),
(2, 6, 'common');
```


## Solution SQL code:
```sql 
WITH QualityRanked AS (
   -- quality into a numerical value so we can compare them
    SELECT 
        ai.account_id,
        ai.item_id,
        i.type,
        i.name,
        ai.quality,
        CASE 
            WHEN ai.quality = 'common' THEN 1
            WHEN ai.quality = 'rare' THEN 2
            WHEN ai.quality = 'epic' THEN 3
        END AS quality_rank
    FROM accounts_items ai
    JOIN items i ON ai.item_id = i.id
),
MaxQualityPerType AS (
   -- only the highest quality rank for each user and item type
    SELECT 
        account_id,
        type,
        MAX(quality_rank) AS max_quality_rank
    FROM QualityRanked
    GROUP BY account_id, type
),
FilteredItems AS (
    -- only the items that match the highest quality rank per user and type
    SELECT 
        qr.account_id,
        qr.item_id,
        qr.type,
        qr.name,
        qr.quality
    FROM QualityRanked qr
    JOIN MaxQualityPerType mq 
        ON qr.account_id = mq.account_id 
        AND qr.type = mq.type 
        AND qr.quality_rank = mq.max_quality_rank
),
FinalResult AS (
    -- Group multiple same-quality items of the same type for a user
    SELECT 
        a.username,
        fi.type,
        GROUP_CONCAT(DISTINCT fi.name ORDER BY fi.name ASC SEPARATOR ', ') AS advised_items,
        fi.quality as advised_quality
    FROM FilteredItems fi
    JOIN accounts a ON fi.account_id = a.id
    GROUP BY a.username, fi.type, fi.quality
)
-- Sort the results by given constraints
SELECT * FROM FinalResult
ORDER BY 
```

## Approach:

### step 1:
First of all we need to convert the given item quality enum values into the rank, as enums dont have any default ranks or integer values, thats why we gave "common" as rank 1, "rare " as rank 2 and "epic" ad rank 3. and created a new table using with operator as Quality ranked.

### step 2:
then we took the table we created earlier and chose only the highest ranked items using MAX() operator and grouped them by account_id and item_type, and we named this new table as MaxQualityPerType.

### step 3:
now we need to join the previously created tables and their results based on account_id, item type and max_item_quality and then name this newly created table as filtered items.

### step 4:
then we need to group_concat the results if there are two items of same type and same quality for a given user we can merge the records by using group_concat() on item name, then to fetch usernames from the account table we need to join this current filtered_items table with the given accounts table based on account_id.

### step 5: 
At last we need to just sort the given table based on given criterias as non-decreasing order by username and non-decreasing order by item type.

## Final Output:

[View CSV on GitHub](task_3_final_output.csv)





