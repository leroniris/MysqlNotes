#进阶1：基础查询
/*
语法：
select 查询列表 from 表名;
*/

USE myemployees;

# 1、查询表中的单个字段
SELECT last_name FROM employees;

# 2、查询表中的多个字段
SELECT last_name,salary,email FROM employees;

# 3、查询表中的所有数据
SELECT * FROM employees;


# 4、查询常量值
SELECT 100;
SELECT 'john';

# 5、查询表达式
SELECT 100%98;

# 6、查询函数
SELECT VERSION();

# 7、起别名
# 方式一：使用AS

SELECT 100%98 AS 结果;
SELECT last_name AS 姓,first_name AS 名 FROM employees;

# 方式二：使用空格
SELECT last_name 姓,first_name 名 FROM employees;

# 案例：查询salary,显示结果为out put
SELECT salary AS 'out put' FROM employees;

# 8、去重
# 案例：查询员工表中涉及道的所有的员工编号
SELECT DISTINCT department_id FROM employees;

# 9、+号的作用
/*
select 100+90; 两个操作数都为数值型，则做加法运算
select '123'+90; 只要其中一方为字符型，视图将字符型数值转化为数值型
		 如果转化成功，则继续做加法运算
		 如果转化失败，则将字符型数值转化为0
select null+10;只要其中一方为null,则结果肯定为null
*/
# 案例：查询员工名和姓连接成一个字段，并显示为姓名
SELECT last_name+first_name AS 姓名 FROM employees;
SELECT CONCAT(last_name,first_name) AS 姓名 FROM employees;


# 测试
#1.下面的语句是否可以执行成功  
SELECT last_name , job_id , salary AS sal
FROM employees; 

#2.下面的语句是否可以执行成功  
SELECT  *  FROM employees; 


#3.找出下面语句中的错误 
SELECT employee_id , last_name,
salary * 12 AS "ANNUAL  SALARY"
FROM employees;



#4.显示表departments的结构，并查询其中的全部数据

DESC departments;
SELECT * FROM `departments`;

#5.显示出表employees中的全部job_id（不能重复）
SELECT DISTINCT job_id FROM employees;

#6.显示出表employees的全部列，各个列之间用逗号连接，列头显示成OUT_PUT

SELECT
  IFNULL(commission_pct, 0) AS 奖金率,
  commission_pct
FROM
  employees;

	
	
#-------------------------------------------

SELECT
  CONCAT(
    `first_name`,
    ',',
    `last_name`,
    ',',
    `job_id`,
    ',',
    IFNULL(commission_pct, 0)
  ) AS out_put
FROM
  employees;

	
	