# 进阶5：分组查询


/*
语法：

select 查询列表
from 表
【where 筛选条件】
group by 分组的字段
【order by 排序的字段】;

特点：
1、和分组函数一同查询的字段必须是group by后出现的字段
2、筛选分为两类：分组前筛选和分组后筛选
		针对的表			位置		连接的关键字
分组前筛选	原始表				group by前	where
	
分组后筛选	group by后的结果集    		group by后	having

问题1：分组函数做筛选能不能放在where后面
答：不能

问题2：where——group by——having

一般来讲，能用分组前筛选的，尽量使用分组前筛选，提高效率

3、分组可以按单个字段也可以按多个字段
4、可以搭配着排序使用


*/

#引入：查询每个部门的平均工资
SELECT department_id,AVG(salary) AS '每个部门平均工资'
FROM employees
GROUP BY department_id;

# 案例1、查询每隔工种的最高工资
SELECT MAX(salary) '最高工资', job_id
FROM employees
GROUP BY job_id;

# 案例2、查询每个位置上的部门个数
SELECT COUNT(*),location_id
FROM departments
GROUP BY location_id;

#添加筛选条件
#案例1、查询邮箱中包含a字符的，每个部门的平均工资
SELECT AVG(salary),department_id
FROM employees
WHERE email LIKE '%a%'
GROUP BY department_id;

# 案例2、查询有奖金的每个领导手下的最高工资
SELECT MAX(salary),manager_id
FROM employees
WHERE commission_pct IS NOT NULL
GROUP BY manager_id;

# 添加复杂的筛选条件
# 案例1：查询哪个部门的员工个数>2
SELECT COUNT(*), department_id
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 2;


# 案例2：查询每个工种有奖金的员工的最高工资>12000的工种编号和最高工资
SELECT MAX(salary), job_id
FROM employees
WHERE commission_pct IS NOT NULL
GROUP BY job_id
HAVING MAX(salary) > 12000

# 案例3：查询领导编号>102的每个领导手下的最低工资>5000的领导编号是哪个，以及其最低工资
SELECT MIN(salary), manager_id
FROM employees
WHERE manager_id>102
GROUP BY manager_id
HAVING MIN(salary) > 5000;


# 按表达式或函数分组
# 案例：按员工的姓名长度分组，查询每一个组的员工个数，筛选员工个数>5的有哪些
SELECT COUNT(*), LENGTH(last_name) len_name
FROM employees
GROUP BY LENGTH(last_name)
HAVING COUNT(*) > 5;


# 按多个字段分组 
# 案例：查询每个部门每个工种的员工的平均工资
SELECT AVG(salary), department_id, job_id
FROM employees
GROUP BY department_id, job_id;

# 添加排序
# 案例：查询每个部门每个工种的员工的平均工资,并且按平均工资的高低显示

SELECT AVG(salary), department_id, job_id
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id, job_id
HAVING AVG(salary) > 10000
ORDER BY department_id ASC,AVG(salary) DESC;


#1、查询各job_id的员工工资的最大值，最小值，平均值，总和，并按job_id升序
SELECT MAX(salary),MIN(salary),AVG(salary),SUM(salary),job_id
FROM employees
GROUP BY job_id
ORDER BY job_id ASC;

#2、查询员工最高工资和最低工资的差距（DIFFERENCE)
SELECT (MAX(salary) - MIN(salary)) AS DIFFERENCE
FROM employees;

#3、查询各个管理者手下员工的最低工资，其中最低工资不能低于6000，没有管理者的员工不计算在内
SELECT MIN(salary),manager_id
FROM employees
WHERE manager_id IS NOT NULL
GROUP BY manager_id
HAVING MIN(salary) >= 6000;

#4、查询所有部门的编号，员工数量和工资平均值，并按平均工资降序
SELECT department_id, COUNT(*) 员工数量, AVG(salary)
FROM employees
GROUP BY department_id
ORDER BY AVG(salary) DESC;

#5、每个job_id的员工人数
SELECT COUNT(*)  个数, job_id
FROM employees
GROUP BY job_id;

