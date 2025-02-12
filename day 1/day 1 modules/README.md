# Summary of modules from 1 to 4.

## Introduction to Databases
    Database is a collection of organised data for efficient retrieval, management and storage of data.

● History and evolution of databases.
    
    Databases evolved from IBM's IMS (hierarchial) then relational(mysql) then to the non-relational (mongodb) databases.
    

● Types of databases: Relational vs. Non-relational. 

    There are two types of databases Relational which used relations or a table format like mysql and the non-relational which does not use a particular structure like mongodb.

● Database Management Systems (DBMS) overview.

    Along with storage, retrieval, manipulate, a dbms also helps in data security, backups and recovery and etc.
    

● SQL vs. NoSQL databases.

    SQL database is a structured database with a fixed schema that uses a table or a row-coloumn structure for data representaion.
    on the other hand 
    NoSql database uses a non-structured database with a dyanamic schema that uses object or a key value pairs for data representaions.

---
## 2. Relational Database Fundamentals

● Database design concepts
 
    Database design mainly depends on the purpose of our database, what data is going to be stored, what different attributes are going to be used and what are the relations between them.

● Entity-Relationship (ER) model
    
    It is a way to design a database by mapping entities, attributes and their relationships in a visual manner.

● Tables, rows, and columns

    Table is a structures format to hold rows and coloumns.

● Primary keys and foreign keys
    
    A primary key is a used to uniquely identify each record in a table.
    A particular table can only have one primary key.

    while Foriegn keys are used to define relationships between diferent tables belonging to the same database.
    a FK in one table refers to a feild in another table.

● Normalization (1NF, 2NF, 3NF, BCNF)

    Normalization is a way to remove redundencies  and also to make sure the there are no updation, deletion, and insertion anomalies in our database.

    1NF - each coloumn must contain a atomic value.
    2NF - there are no partial dependencies.
    3NF - no Transitive dependency. (NP cant
    depend on other non prime).
    BCNF - all functional dependencies originate
    from super-keys.

● Denormalization and when to use it
    
    Addiing redundencies to make data retrieval faster. Mainly used in very large databases.
---

## 3. Basic SQL Commands
● Data Definition Language (DDL): CREATE, ALTER, DROP
    
    Defines the structure or schema of a table.
    used to create table, delete tables, or manipulate a existing table structure.


● Data Manipulation Language (DML): SELECT, INSERT, UPDATE, DELETE
    
    used to manage the date inside the table.
    to insert, retrieve, update the given data and delete certain data from our table or database.

● Data Control Language (DCL): GRANT, REVOKE

    used to givespecific permissions over a specific database to a specific user.
    can be used to influence the control of a user over a database.

● Transaction Control Language (TCL): BEGIN, COMMIT, ROLLBACK

        used to manage transactions or group of sql operations.
        Begin starts the transaction
        Commit save the changes 
        and rollback 
        undo or restore the most recent change.

---


## 4. Advanced SQL Queries
● Joins: Inner, Outer (Left, Right, Full), Cross joins
    
    used to comibe rows or data from multiple tables based on a ommon feild.
    inner join - finds only matching(common) feilds from both tables.

    left join - all entries from left table plus common entries from the right table.

    right join - all entries from right table plus common entries from the left table.

    full joins - combines all entries from both tables.

    cross join- provides a cartesian product.
    
● Subqueries and correlated subqueries

    subquery is a query inside another query

    corrlated query is a query that is depended on the outer query.


● Set operations: UNION, INTERSECT, EXCEPT

    union is also used to combine the entries from both the tables not including duplicates.

    union all also does the same but it includes duplicates.

    intersect provides common data from both tables.

    exept Finds records in first query but not in second one.

● Window functions: ROW_NUMBER(), RANK(), DENSE_RANK(), NTILE(), LAG(),
LEAD()

    perform calculation across a set of rows or windows. Used to capture row wise aggregation data. 

    ROW_NUMBER() - provides a index number to every row.
    RANK() - provides a unique rank to every rank skipping a rank after the duplicate.

    DENSE RANK() - provides a unique rank to every rank but not skipping a rank after the duplicate.'

    NTILE()- used to divide the data into equal sized groups.

    LAG and LEAD are used to compare data values.



● Common Table Expressions (CTEs) and recursive queries

    It is a temporary table that can be used anywhere in the same query afterwards also improves readability.

    It is achieved using a "with" clause.

● Pivoting and unpivoting data.

    It is used to convert rows to coloumns and vice versa.
