#DDL
/*
数据定义语言：

库和表的管理

一、库的管理
创建、修改、删除
二、表的管理
创建、修改、删除

创建：create
修改：alter
删除：drop
*/


#一、库的管理
#1、库的创建
/*
语法:
create database 库名;
*/
CREATE DATABASE IF NOT EXISTS books;

#2、库的修改
#目前不修改
RENAME DATABASE books TO 新库名;

#更改库的字符集
ALTER DATABASE books CHARACTER SET gbk;


#3、库的删除
DROP DATABASE IF EXISTS books;


#二、表的管理
#1、表的创建
/*
create table 表明(
	列明 列的类型【(长度) 约束】,
	列明 列的类型【(长度) 约束】,
	列明 列的类型【(长度) 约束】,
	...
	列明 列的类型【(长度) 约束】
)
*/

#案例：创建book表
CREATE TABLE book(
	id INT,
	bname VARCHAR(20),
	price DOUBLE,
	authorId INT,
	publishDate DATETIME
);

#案例：创建表author
CREATE TABLE author(
	id INT,
	au_name VARCHAR(20),
	nation VARCHAR(10)
);


#2、表的修改
/*
alter table 表名 add|drop|modify|change column 列名 【列类型 约束】
*/
DESC book;
DESC book_author;
#①修改列名
ALTER TABLE book CHANGE COLUMN publishdate pubDate DATETIME;

#②修改列的类型或约束
ALTER TABLE book MODIFY COLUMN pubdate TIMESTAMP;

#③添加新列
ALTER TABLE author ADD COLUMN annual DOUBLE;

#④删除列
ALTER TABLE author DROP COLUMN annual;
#⑤修改表名
ALTER TABLE author RENAME TO book_author;
ALTER TABLE book_author RENAME TO author;

#3、表的删除
DROP TABLE IF EXISTS author;
SHOW TABLE;


#4、表的复制
INSERT INTO author VALUES
(1,'村上春树','日本'),
(2,'莫言','中国'),
(3,'冯唐','中国'),
(4,'金庸','中国');


#1.仅仅复制表的结构
CREATE TABLE copy LIKE author;


#2.复制表的结构+数据
CREATE TABLE copy2
SELECT * FROM author;


#3.只复制部门表的数据
CREATE TABLE copy3
SELECT id,au_name 
FROM author
WHERE  nation='中国';

#仅仅复制某些字段
CREATE TABLE copy4
SELECT id,au_name
FROM author
WHERE 1=2;



#1.	创建表dept1
/*
NAME	NULL?	TYPE
id		INT(7)
NAME		VARCHAR(25)
*/
CREATE DATABASE IF NOT EXISTS test;
USE test;

CREATE TABLE dept1(
	id INT(7),
	NAME VARCHAR(25)
	

);
#2.	将表departments中的数据插入新表dept2中
CREATE TABLE dept2
SELECT department_id,department_name
FROM myemployees.departments;


#3.	创建表emp5
/*
NAME	NULL?	TYPE
id		INT(7)
First_name	VARCHAR (25)
Last_name	VARCHAR(25)
Dept_id		INT(7)
*/

CREATE TABLE emp5(
	id INT(7),
	first_name VARCHAR(25),
	last_name VARCHAR(25),
	dept_id INT(7)
);


#4.	将列Last_name的长度增加到50
ALTER TABLE emp5 MODIFY COLUMN last_name VARCHAR(50);
#5.	根据表employees创建employees2
CREATE TABLE employee2 LIKE myemployees.`employees`;

#6.	删除表emp5
DROP TABLE IF EXISTS emp5;

#7.	将表employees2重命名为emp5
ALTER TABLE employee2 RENAME TO emp5;

#8.在表dept和emp5中添加新列test_column，并检查所作的操作

ALTER TABLE emp5 ADD COLUMN test_column INT;
#9.直接删除表emp5中的列 dept_id
DESC emp5;
ALTER TABLE emp5 DROP COLUMN test_column;