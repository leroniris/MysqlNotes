/*
二、分组函数
功能：用作统计使用，又称为聚合函数或统计函数或组函数

分类：
sum求和，avg平均值，max最大值，min最小值，count计算个数

特点：
1、sum、avg一般用于处理数值型
   max、min，count处理任何类型
2、以上分组函数都会忽略NULL值
3、可以和distinct搭配使用
4、和分组函数一同查询的字段要求是group by后的字段
*/

# 1、简单的使用
SELECT SUM(salary) FROM employees;
SELECT AVG(salary) FROM employees;
SELECT MIN(salary) FROM employees;
SELECT MAX(salary) FROM employees;
SELECT COUNT(salary) FROM employees;

SELECT SUM(salary) 和, ROUND(AVG(salary),2) 平均,MAX(salary) 最高, MIN(salary) 最低, COUNT(salary) 个数
FROM employees;


# 2、参数类型支持哪些类型

# 3、和distinct搭配
SELECT SUM(DISTINCT salary), SUM(salary) FROM employees;

SELECT COUNT(DISTINCT salary),COUNT(salary) FROM employees;


# 4、count函数的详细介绍
SELECT COUNT(salary) FROM employees;

SELECT COUNT(*) FROM employees;

SELECT COUNT(1) FROM employees;

/*
效率：
MYISAM存储引擎下  ，COUNT(*)的效率高
INNODB存储引擎下，COUNT(*)和COUNT(1)的效率差不多，比COUNT(字段)要高一些
*/


#1、查询公司员工工资的最大值，最小值，平均值，总和
SELECT MAX(salary),MIN(salary),ROUND(AVG(salary),2),SUM(salary)
FROM employees;
#2、查询员工表中的最大入职时间和最小入职时间的相差天数（DIFFRENCE）
SELECT DATEDIFF(NOW(),'1998-06-26');
SELECT DATEDIFF(MAX(hiredate), MIN(hiredate)) DIFFRENCE
FROM employees;
#3、查询部门编号未90的员工个数
SELECT COUNT(*) 个数
FROM employees
WHERE department_id = 90; 