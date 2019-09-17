# 二、sql99语法
/*
语法：
	select 查询列表
	from 表1 别名 【连接类型】
	join 表2 别名
	on 连接条件
	【where 筛选条件】
	【group by 分组】
	【having 筛选条件】
	【order by 排序列表】
连接类型填：

内连接: inner
	
外连接
	左外:left [outer]
	右外:right [outer]
	全外:full [outer]
交叉连接 cross
*/


#1)内连接
/*
语法：
select 查询列表
from 表1 别名
inner join 表2 别名
on 连接条件

分类：
等值
非等值
自连接

特点：
①添加排序、分组、筛选
②inner可以省略
③ 筛选条件放在where后面，连接条件放在on后面，提高分离性，便于阅读
④inner join连接和sql92语法中的等值连接效果是一样的，都是查询多表的交集

*/


#1、等值连接
#案例1.查询员工名、部门名
SELECT last_name,department_name
FROM employees AS e
INNER JOIN departments AS d
ON e.`department_id` = d.`department_id`;

#案例2.查询名字中包含e的员工名和工种名（添加筛选）
SELECT last_name, job_title
FROM employees AS e
INNER JOIN jobs AS j
ON e.`job_id` = j.`job_id`
WHERE last_name LIKE '%e%';

#3. 查询部门个数>3的城市名和部门个数，（添加分组+筛选）
SELECT city, COUNT(*) 部门个数
FROM departments AS d
INNER JOIN locations AS l
ON d.`location_id` = l.`location_id`
GROUP BY city
HAVING COUNT(*) > 3;

#案例4.查询哪个部门的员工个数>3的部门名和员工个数，并按个数降序（添加排序）
SELECT department_name, COUNT(*) AS 员工个数
FROM employees AS e
INNER JOIN departments AS d
ON e.`department_id` = d.`department_id`
GROUP BY department_name
HAVING COUNT(*) > 3
ORDER BY COUNT(*) DESC;

#5.查询员工名、部门名、工种名，并按部门名降序（添加三表连接）
SELECT last_name, department_name, job_title
FROM employees AS e
INNER JOIN departments AS d ON e.`department_id` = d.`department_id`
INNER JOIN jobs AS j ON j.`job_id` = e.`job_id`
ORDER BY department_name DESC;

#2）非等值连接

#查询员工的工资级别
SELECT salary, grade_level
FROM employees AS e
INNER JOIN job_grades g
ON e.`salary` BETWEEN g.`lowest_sal` AND g.`highest_sal`;


# 查询每个工资级别个数 > 20，并且按工资级别降序
SELECT grade_level,COUNT(*) 个数
FROM employees AS e
INNER JOIN job_grades AS g
ON e.`salary` BETWEEN g.`lowest_sal` AND g.`highest_sal`
GROUP BY grade_level
HAVING COUNT(*) > 20 
ORDER BY grade_level DESC;


#三）自连接
#查询姓名中包含字符k的员工的名字，上级名字
SELECT e.last_name, e.employee_id, m.last_name, m.employee_id
FROM employees AS e
INNER JOIN employees AS m
ON e.`manager_id` = m.`employee_id`
WHERE e.last_name LIKE '%k%';



#二、外连接
/*
应用场景：用于查询一个表中有，另一个表没有的记录


特点：
 1、外连接的查询结果为主表中的所有记录
	如果从表中有和它匹配的，则显示匹配的值
	如果从表中没有和它匹配的，则显示null
	外连接查询结果=内连接结果+主表中有而从表没有的记录
 2、左外连接，left join左边的是主表
    右外连接，right join右边的是主表
 3、左外和右外交换两个表的顺序，可以实现同样的效果 
 4、全外连接=内连接的结果+表1中有但表2没有的+表2中有但表1没有的
*/

#引入：查询男朋友不在男神表的女神名

#左外连接
SELECT b.name,bo.*
FROM beauty AS b
LEFT OUTER JOIN boys bo
ON b.`boyfriend_id` = bo.`id`;

#右外连接
SELECT b.name,bo.*
FROM boys AS bo
RIGHT OUTER JOIN beauty b
ON b.`boyfriend_id` = bo.`id`;

# 案例1：查询哪个部门没有员工
# 左外
SELECT d.*, e.employee_id
FROM departments AS d
LEFT OUTER JOIN employees AS e
ON e.`department_id` = d.`department_id`
WHERE e.employee_id IS NULL;
# 右外
SELECT d.*, e.employee_id
FROM employees AS e
RIGHT OUTER JOIN departments AS d
ON e.`department_id` = d.`department_id`
WHERE e.employee_id IS NULL;


#全外连接
USE girls;
SELECT b.*,bo.*
FROM beauty AS b
FULL OUTER JOIN boys AS bo
ON b.`boyfriend_id` = bo.id;


#交叉连接
SELECT b.*,bo.*
FROM beauty AS b
CROSS JOIN boys bo;

#一、查询编号>3的女神的男朋友信息，如果有则列出详细，如果没有，用null填充
SELECT b.*
FROM beauty AS b
LEFT OUTER JOIN boys AS bo
ON b.`boyfriend_id` = bo.`id`
WHERE  b.id > 3;

#二、查询哪个城市没有部门
SELECT city,d.*
FROM locations AS l
LEFT OUTER JOIN departments AS d
ON l.`location_id` = d.`location_id`
WHERE d.`department_id` IS NULL;

#三、查询部门名为SAL或IT的员工信息
SELECT department_name,e.*
FROM departments AS d
LEFT OUTER JOIN employees AS e
ON d.`department_id` = e.`department_id`
WHERE d.department_name = 'SAL' OR d.`department_name` = 'IT';