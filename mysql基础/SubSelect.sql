#进阶7：子查询
/*
含义：出现在其他语句中的select语句，称为子查询或内查询
外部的查询语句，称为主查询或外查询

分类：
按子查询出现的位置：
	select后面
		仅仅支持标量子查询
	from后面
		支持表子查询
	where或having后面
		标量子查询
		列子查询
		行子查询
	exists后面（相关子查询）
		表子查询
按结果集的行列数不同：
	标量子查询（结果集只有一行一列）
	列子查询（结果集只有一列多行）
	行子查询（结果集有一行多列）
	表子查询（结果集一般为多行多列）
*/

#一、where或having后面
-- 1、标量子查询（单行子查询）
-- 
-- 2、列子查询（多行子查询）
-- 
-- 3、行子查询（）
-- 
-- 特点：
-- 子查询都会放在小括号内
-- 子查询一般放在条件的右侧
-- 标量子查询，一般搭配着单行操作符的使用
-- > < >= <= = <>
-- 列子查询，一般搭配多行操作符使用
-- in, any/some,all
-- 
-- 4、子查询的执行优先于主查询的执行，主查询的条件用到了子查询

#1、标量子查询

#案例1：谁的工资比Abel高？
#①查询Abel的工资
SELECT salary FROM employees
WHERE last_name = 'Abel';

#查询员工的信息，满足salary>①的结果
SELECT
  *
FROM
  employees
WHERE salary >
  (SELECT
    salary
  FROM
    employees
  WHERE last_name = 'Abel'

);

#案例2：返回job_id与141号员工相同，salary比143号员工多的员工 姓名，job_id和工资
#①查询141号员工的job_id
SELECT job_id
FROM employees
WHERE employee_id = 141;

#②查询143号员工的salary
SELECT salary
FROM employees
WHERE employee_id = 143;

#③查询员工的姓名，job_id工资，要求job_id=①并且salary>②
SELECT last_name,job_id,salary
FROM employees
WHERE job_id =
(SELECT
  job_id
FROM
  employees
WHERE employee_id = 141

) AND salary > 
(SELECT
  salary
FROM
  employees
WHERE employee_id = 143);

#案例3：返回公司工资最少的员工的last_name,job_id,salary
SELECT MIN(salary)
FROM employees;

SELECT last_name,job_id,salary
FROM employees
WHERE salary = 
(SELECT
  MIN(salary)
FROM
  employees);

#案例4：查询最低工资大于50号部门最低工资的部门id和其最低工资
SELECT MIN(salary)
FROM employees
WHERE department_id = 50;

SELECT
  department_id,
  MIN(salary)
FROM
  employees
GROUP BY department_id
HAVING MIN(salary) >
  (SELECT
    MIN(salary)
  FROM
    employees
  WHERE department_id = 50);


#非法使用标量子查询


#二、select后面
# 案例：查询每个部门的员工个数
SELECT d.*,(
SELECT COUNT(*)
FROM employees AS e
WHERE e.department_id = d.`department_id`
) 个数
FROM departments AS d;

# 案例：查询员工号=102的部门名
SELECT (
SELECT department_name
FROM departments AS d
INNER JOIN employees AS e
ON d.department_id = e.department_id
WHERE e.employee_id = 102
) 部门名;


#三、from后面
/*
将子查询结果充当一张表，要求起别名
*/
# 案例：查询每个部门的平均工资的工资等级
SELECT AVG(salary),department_id
FROM employees
GROUP BY department_id; 

SELECT * FROM job_grades;

SELECT ag_dep.*, grade_level
FROM (
SELECT AVG(salary) AS ag, department_id
FROM employees
GROUP BY department_id
) AS ag_dep
INNER JOIN job_grades AS j
ON  ag_dep.ag BETWEEN j.`lowest_sal` AND j.`highest_sal`;


# 四、exists后面（相关子查询）
/*
语法：
exists(完整的查询语句)
结果：
1或0
*/
SELECT EXISTS(SELECT employee_id FROM employees);

#案例1：查询有员工名的部门名

SELECT department_name
FROM departments AS d
WHERE EXISTS(
  SELECT * 
  FROM employees AS e
  WHERE d.department_id = e.`department_id`
);


SELECT department_name 
FROM departments
WHERE department_id IN (
	SELECT department_id
	FROM employees
);


# 案例2：查询没有女朋友的男神信息
SELECT bo.*
FROM boys AS bo
WHERE NOT EXISTS(
	SELECT boyfriend_id
	FROM beauty
	WHERE bo.id = boyfriend_id
);

SELECT bo.*
FROM boys AS bo
WHERE bo.id NOT IN (
	SELECT boyfriend_id
	FROM beauty
);

# 1、查询和Zlotkey相同部门的员工姓名和工资
SELECT last_name,salary,department_id
FROM employees
WHERE department_id = (
	SELECT department_id
	FROM employees
	WHERE last_name = 'Zlotkey'
);

# 2、查询工资比公司平均工资高的员工的员工号，姓名和工资
SELECT last_name,salary
FROM employees
WHERE salary > (
	SELECT AVG(salary)
	FROM employees
)
ORDER BY salary DESC;

# 3、查询各部门中工资比本部门平均工资高的员工号，姓名和工资
1、查询每个部门的平均工资和部门名
SELECT AVG(salary),department_id
FROM employees
GROUP BY department_id;

SELECT last_name,salary,e.department_id
FROM employees AS e
INNER JOIN (
	SELECT AVG(salary) AS ag,department_id
	FROM employees
	GROUP BY department_id
) AS avg_de
ON e.department_id = avg_de.department_id
WHERE salary > avg_de.ag;

# 4、查询和姓名中包含字母u的员工在相同部门的员工的员工号和姓名
SELECT employee_id,last_name,department_id
FROM employees
WHERE department_id IN (
	SELECT DISTINCT department_id
	FROM employees
	WHERE last_name LIKE '%u%'
);
# 5、查询在部门的location_id为1700的部门工作的员工的员工号
SELECT employee_id,d.`location_id`
FROM employees AS e
INNER JOIN departments AS d
ON e.`department_id` = d.`department_id`
WHERE d.`location_id` = 1700;
# 6、查询管理者是King的员工姓名和工资
SELECT last_name,salary
FROM employees
WHERE manager_id IN (
	SELECT employee_id
	FROM employees
	WHERE last_name = 'K_ing'
);
# 7、查询工资最高的员工的姓名，要求first_name和last_name显示为一列，列名为 姓.名
SELECT CONCAT(first_name,last_name) AS '姓.名'
FROM employees
WHERE salary = (
	SELECT MAX(salary)
	FROM employees
);