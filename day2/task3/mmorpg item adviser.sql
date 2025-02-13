Create Database Task_3;
use Task_3;

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



-- select * from accounts;
-- select* from items;
-- select * from accounts_items;





-- with item_des as
-- (select i.*, ac.account_id, ac.quality
-- from items as i join accounts_items as ac
-- on i.id = ac.item_id)
-- select a.username, itd.* from accounts as a join item_des as itd on a.id = itd.account_id order by username, type asc;
 






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
ORDER BY username ASC, type ASC;







