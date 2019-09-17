# DML语言
/*
数据操作语言 ：
插入：insert
修改：update
删除：delete
*/

#一、插入语句
/*
语法：
insert into 表明(列明,...) values(新值,...);
*/
SELECT * FROM beauty;
#1.插入的值的类型要与列的类型一致或兼容
INSERT INTO beauty(id,NAME,sex,borndate,phone,photo,boyfriend_id) 
VALUES(13,'唐艺昕','女','1990-4-23','1898888888',NULL,2);

#2.不可以为null的列必须插入值。可以为null的列如何插入值？
#方式一：
INSERT INTO beauty(id,NAME,sex,borndate,phone,photo,boyfriend_id)
VALUES(13,'唐艺昕','女','1990-4-23','1898888888',NULL,2);

#方式二：

INSERT INTO beauty(id,NAME,sex,phone)
VALUES(15,'娜扎','女','1388888888');


#3.列的顺序是否可以调换
INSERT INTO beauty(NAME,sex,id,phone)
VALUES('蒋欣','女',16,'110');


#4.列数和值的个数必须一致

INSERT INTO beauty(NAME,sex,id,phone)
VALUES('关晓彤','女',17,'110');


#5.可以省略列名，默认所有列，而且列的顺序和表中列的顺序一致

INSERT INTO beauty
VALUES(18,'张飞','男',NULL,'119',NULL,NULL);



#方式二：
/*
语法：
insert into 表明
set 列名=值,列名=值...
*/

INSERT INTO beauty
SET id=19,NAME='刘涛',phone='1999825343';


#两种方式大pk
#1、方式一支持插入多行，方式二不支持
SELECT * FROM beauty;
INSERT INTO beauty
VALUES(23,'唐艺昕1','女','1990-4-23','1898888888',NULL,2)
,(24,'唐艺昕2','女','1990-4-23','1898888888',NULL,2)
,(25,'唐艺昕3','女','1990-4-23','1898888888',NULL,2);

#2、方式一支持子查询，方式二不支持
INSERT INTO beauty(id,NAME,phone)
SELECT 26,'宋茜','11188';


INSERT INTO beauty(id,NAME,phone)
SELECT id,boyname,'19848'
FROM boys 
WHERE id < 3;


