#TCL
/*
Transaction Control Language 事务控制语言
事务：
一个或一组sql语句组成一个执行单元，这个执行单元要么全部执行，要么全部不执行。

案例：转账
张三丰 1000
郭襄   1000
 
 
事务的特性：
ACID
原子性：一个事务不可再分割，要么都执行要么都不执行
一致性：一个事务执行会使数据从一个一致状态切换到另外一个一致状态
隔离性：一个事务的执行不受其他事务的干扰
持久性：一个事务一旦提交，则会永久的改变数据库的数据.


事务的创建
隐式事务：事务没有明显的开启和结束的标记
比如insert,update,delete语句

delete from 表 where id = 1;

显示事务：事务具有明显的开启和结束的标记

前提：必须先设置自动提交功能为禁用
set autocommit=0;

步骤1：开启事务
set autocommit=0;
start transaction;可选的
步骤2：编写食物中的sql语句(select insert update delete)
语句1;
语句2;
,,,
#步骤3：结束事务
commit;提交事务
rollback;回滚事务



update 表 set 张三丰的余额=500 where name='张三丰'
意外
update 表 set 郭襄的余额=1500  where name='郭襄'

*/

SHOW VARIABLES LIKE '%autocommit%';


DROP TABLE IF EXISTS account;

CREATE TABLE account(
	id INT PRIMARY KEY AUTO_INCREMENT,
	username VARCHAR(20),
	balance DOUBLE
);

INSERT INTO account(username,balance)
VALUES('张无忌',1000),('赵敏',1000)

#演示事务的实现步骤

#开启事务
SET autocommit=0;
START TRANSACTION;

#编写一组事务的语句
UPDATE account SET balance=1000 WHERE username='张无忌';
UPDATE account SET balance=1500 WHERE username='赵敏';

#结束事务
ROLLBACK;
#commit;

SELECT * FROM account;


/*
脏读：
对于两个事务T1，T2,
T1读取了已经被T2更新但还没有被提交的字段之后，
若T2回滚，T1读取的内容就是临时且无效的

不可重复读：
对于两个事务T1,T2, T1读取了一个字段，然后T2更新了该字段之后
T1再次读取同一字段，值就不同了

幻读：
对于两个事务T1,T2, T1从表中读取了一个字段，然后T2在该表中
插入了一些新的行之后，如果T1再次读取同一个表，就会多出几行

数据库事务的隔离性：数据库系统必须具有隔离并发运行各个事务的能力，
使它们不会相互影响，避免各种并发问题

Mysql支持4中事务隔离级别，默认隔离级别为 REPEATABLE READ
隔离级别：
	READ UNCOMMITTED(读为提交数据)：允许事务未被其他事务提交的变更，
					脏读，不可重复读和幻读的问题会出现
	READ COMMITED(读已提交数据)：只允许事务读取已经被其它事务提交的变更，
				     可以避免脏读，但不可重复读和幻读问题仍然可能出现
	REPEATABLE READ(可重复读)：确保事务可以多次从一个字段中读取相同的值，在这个事务持续期间，
				   禁止其他事务对这个字段进行更新，可以避免脏读和不可重复读，但幻读问题仍然存在
	SERIALIZABLE(串行化)：确保事务可以从一个表中读取相同的行，在这个事务持续期间
			      禁止其他事务对该表执行插入，更新和删除操作，所有并发问题都可以避免，但是性能十分低下
			 
*/

#查询事务的隔离级别
SELECT @@tx_isolation;

#设置事务的隔离级别
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

#设置全局隔离级别
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


#savepoint使用
SET autocommit=0;
START TRANSACTION;
DELETE FROM account WHERE id=25;
SAVEPOINT;
DELETE FROM account WHERE id=28;
ROLLBACK TO a;

SELECT * FROM account;
