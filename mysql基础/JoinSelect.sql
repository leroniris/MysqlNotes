#进阶6：连接查询
/*
含义：又称多表查询，当查询的字段来自于多个表时，就会用到连接查询

笛卡尔乘积现象：表1 有m行，表2有n行，结果=m*n行

发生原因：没有有效的连接条件
如何避免：添加有效的连接条件

分类：
	按年代分类：
	sql92标准：仅仅支持内连接
	sql99标准：支持内连接+外连接（左外+右外）+交叉连接
	
	按功能分类：
		内连接：
			等值连接
			非等值连接
			自连接
		外连接：
			左外连接
			右外连接
			全外连接
		交叉连接：
			
*/

SELECT * FROM beauty;
SELECT * FROM boys;

SELECT `name`, boyName FROM boys,beauty
WHERE boys.id = beauty.`boyfriend_id`;

# sql92标准

#1、等值连接
/*
① 多表等值连接的结果为多表的交集部分
② n表连接，至少需要n-1个连接条件
③ 多表的顺序没有要求
④ 一般需要为表起别名
⑤ 可以搭配前面介绍的所有子句使用，比如排序、分组、筛选
*/
#案例1、查询女神名和对应的男神名
SELECT `name`, boyName FROM boys,beauty
WHERE boys.id = beauty.`boyfriend_id`;


#案例2：查询员工名和对应的部门名
SELECT last_name, department_name
FROM employees, departments
WHERE employees.department_id = departments.department_id;


#2、为表起别名
/*
①提高语句的简洁度
②区分多个重名的字段

注意：如果为表起了别名，则查询的字段就不能使用原来的表名去限定

*/
#查询员工名、工种号、工种名
SELECT last_name,e.job_id,job_title
FROM employees AS e, jobs AS j
WHERE e.job_id = j.`job_id`;


#3、两个表的顺序是否可以调换

#查询员工名、工种号、工种名

SELECT e.last_name,e.job_id,j.job_title
FROM jobs j,employees e
WHERE e.`job_id`=j.`job_id`;


# 4、可以加筛选？

# 案例1：查询有奖金的员工名、部门名
SELECT last_name, department_name,commission_pct
FROM employees, departments
WHERE `commission_pct` IS NOT NULL AND employees.`department_id` = departments.`department_id`;


# 案例2：查询城市名中第二个字符为o的部门名和城市名
SELECT department_name,city
FROM departments AS d, locations AS l
WHERE city LIKE '_o%' AND d.`location_id` = l.`location_id`;

# 5、可以分组？

# 案例1：查询每个城市的部门个数
SELECT COUNT(*) 个数,city
FROM departments d, locations l
WHERE d.`location_id` = l.`location_id`
GROUP BY city;
	
# 案例2：查询有奖金的每个部门名和部门的领导编号和该部门的最低工资
SELECT department_name, d.manager_id, MIN(salary)
FROM employees AS e, departments d
WHERE e.`department_id` = d.`department_id`
AND e.`manager_id` = d.`manager_id`
AND commission_pct IS NOT NULL
GROUP BY department_name;

# 6、可以加排序

# 案例：查询每个工种的工种名和员工的个数，并且按员工个数降序
SELECT job_title,COUNT(*)
FROM employees AS e, jobs AS j
WHERE e.`job_id` = j.`job_id`
GROUP BY job_title
ORDER BY COUNT(*) DESC;

# 7、可以实现三表连接

# 案例：查询员工名，部门名和所在的城市
SELECT last_name,department_name,city
FROM employees AS e, departments AS d, locations AS l
WHERE e.`department_id` = d.`department_id`
AND l.`location_id` = d.`location_id`;







# 2、非等值连接

# 案例：查询员工的工资工资级别
SELECT salary,grade_level
FROM employees AS e, job_grades AS j
WHERE salary BETWEEN j.`lowest_sal` AND j.`highest_sal`;





# 3、自连接

# 案例：查询员工名和他上级的名称
SELECT e.employee_id, e.last_name,m.employee_id,m.last_name
FROM employees e, employees m 
WHERE e.manager_id = m.employee_id;


#测试：
#1、显示员工表的最大工资，工资平均值
SELECT MAX(salary),AVG(salary)
FROM employees;

#2、查询员工共表的employee_id,job_id,last_name,按department_id降序，salary升序
SELECT employee_id,job_id,last_name
FROM employees
ORDER BY department_id DESC,salary ASC;

#3、查询员工表的job_id中包含 a和 e的，并且a在e的前面
SELECT job_id
FROM employees
WHERE job_id LIKE '%a%e%'

#4、已知表student里面有id(学号)，name,gradeId(年级编号)
#   已知表grade里面有id(年级编号), name(年级名)
#   已知表result，里面有id，score,studentNo(学号)
# 要求查询姓名、年级名、成绩



#5、显示当前日期，以及去前后空格，截取子字符串的函数
SELECT NOW();
SELECT TRIM('a' FROM 'aaaabbbaaabbbbaaaa');
SELECT SUBSTR(str,startIndex);
SELECT SUBSTR(str,startIndex, LENGTH);



# 6、显示所有员工的姓名，部门号和部门名称
SELECT last_name,e.department_id,department_name
FROM employees AS e, departments AS d
WHERE e.`department_id` = d.`department_id`;
# 7、查询90号部门员工的job_id和90号部门的location_id
SELECT job_id, location_id
FROM employees AS e, departments AS d
WHERE e.`department_id` = d.`department_id`
AND e.department_id = 90;
# 8、选择所有有奖金的员工的last_name,department_name,location_id,city
SELECT last_name,department_name,d.location_id,city
FROM employees AS e,departments AS d, locations AS l
WHERE e.`department_id` = d.`department_id`
AND l.`location_id` = d.`location_id`
AND commission_pct IS NOT NULL;
# 9、选择city在Toronto工作的员工的last_name,job_id,department_id,department_name
SELECT last_name,job_id,e.department_id,department_name
FROM employees AS e, departments AS d, locations AS l
WHERE e.`department_id` = d.`department_id`
AND l.`location_id` = d.`location_id`
AND l.`city` = 'Toronto';
# 10、查询每个工种，每个部门的部门名，工种名和最低工资
SELECT e.job_id,job_title,department_name,MIN(salary)
FROM employees AS e, departments AS d, jobs AS j
WHERE e.`department_id` = d.`department_id`
AND e.`job_id` = j.`job_id`
GROUP BY department_name,job_title;
# 11、查询每个国家下的部门个数大于2的国家编号
SELECT country_id,COUNT(*)
FROM departments AS d, locations AS l
WHERE d.`location_id` = l.`location_id`
GROUP BY country_id
HAVING COUNT(*) > 2;
# 12、选择指定员工的姓名，员工号，以及他的管理者的姓名和员工号，结果类似于下面的格式
# employees Emp manager
SELECT e.last_name, e.employee_id, m.`last_name`, m.`employee_id`
FROM employees AS e, employees AS m
WHERE e.`manager_id` = m.`employee_id`;
