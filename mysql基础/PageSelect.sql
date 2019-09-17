# 进阶8：分页查询
/*
应用场景：当要显示的数据，一页显示不全，需要分页提交sql请求
语法：
	select 查询列表
	from 表
	【join type】 join 表2
	on 连接
	where 筛选条件
	group by 分组字段
	having 分组后的筛选
	order by 排序的字段
	limit 【offset,】size;
	
	offset要显示条目的起始索引（起始索引从0开始）
	size要显示的条目个数

特点：
	①limit语句放在查询语句最后
	②公式
		要显示的页数page,每页的条目size
		
		select 查询列表
		from 表
		limit (page - 1) * size,size;
*/

# 案例1：查询前五条员工信息
SELECT * FROM employees LIMIT 0,5;
SELECT * FROM employees LIMIT 5;

# 案例2：查询第11条——第25条
SELECT * FROM employees LIMIT 10,15;

# 案例3：有奖金的员工信息，并且工资较高的前10名显示出来
SELECT * 
FROM employees 
WHERE commission_pct IS NOT NULL
ORDER BY salary DESC
LIMIT 10;



# 1. 查询工资最低的员工信息: last_name, salary
SELECT last_name,salary
FROM employees
WHERE salary = (
	SELECT MIN(salary)
	FROM employees
);

# 2. 查询平均工资最低的部门信息
# ①查询每个部门的平均工资
SELECT department_id,AVG(salary) AS ag
FROM employees
GROUP BY department_id;

# ②查询平均工资最低是多少
SELECT MIN(ag)
FROM (
	SELECT department_id,AVG(salary) AS ag
	FROM employees
	GROUP BY department_id
) AS ag_dep;

# ③查询平均工资最低的部门id
SELECT AVG(salary),department_id
FROM employees
GROUP BY department_id
HAVING AVG(salary) = (
	SELECT MIN(ag)
	FROM (
		SELECT department_id,AVG(salary) AS ag
		FROM employees
		GROUP BY department_id
	) AS ag_dep
);

# ④查询平均工资最低的部门信息
SELECT d.*
FROM departments AS d
WHERE d.department_id = (
SELECT department_id
FROM employees
GROUP BY department_id
HAVING AVG(salary) = (
	SELECT MIN(ag)
	FROM (
		SELECT department_id,AVG(salary) AS ag
		FROM employees
		GROUP BY department_id
	) AS ag_dep
)
) ;


# 3. 查询平均工资最低的部门信息和该部门的平均工资
SELECT d.*
FROM departments AS d
WHERE d.department_id = (
SELECT department_id,AVG(salary) AS Average
FROM employees
GROUP BY department_id
HAVING AVG(salary) = (
	SELECT MIN(ag)
	FROM (
		SELECT department_id,AVG(salary) AS ag
		FROM employees
		GROUP BY department_id
	) AS ag_dep
)
) ;
# 4. 查询平均工资最高的 job 信息
#①查询每个job_id平均工资
SELECT AVG(salary),job_id
FROM employees
GROUP BY job_id;

# ②查询平均工资最大的job_id
SELECT MAX(ag)
FROM (
	SELECT AVG(salary) AS ag,job_id
	FROM employees
	GROUP BY job_id;
) AS avg_de;


SELECT job_id
FROM employees
GROUP BY job_id
HAVING AVG(salary) = (
	SELECT MAX(ag)
	FROM (
		SELECT AVG(salary) AS ag
		FROM employees
		GROUP BY job_id
	) AS avg_de
);

SELECT j.*
FROM jobs AS j
INNER JOIN (
	SELECT job_id
	FROM employees
	GROUP BY job_id
	HAVING AVG(salary) = (
		SELECT MAX(ag)
		FROM (
			SELECT AVG(salary) AS ag
			FROM employees
			GROUP BY job_id
		) AS avg_de
	)
) AS max_avg
ON j.`job_id` = max_avg.job_id;


# 5. 查询平均工资高于公司平均工资的部门有哪些?
SELECT department_id
FROM departments
WHERE department_id IN (
	SELECT department_id FROM (
		SELECT AVG(salary) AS avg_sa,department_id
		FROM employees
		GROUP BY department_id
		HAVING avg_sa > (
			SELECT AVG(salary)
			FROM employees
		)
	) AS avg_de
);

# 6. 查询出公司中所有 manager 的详细信息.
SELECT manager_id
FROM employees

SELECT *
FROM employees
WHERE employee_id =ANY(
	SELECT DISTINCT manager_id
	FROM employees

);

# 7. 各个部门中 最高工资中最低的那个部门的 最低工资是多少
SELECT department_id, MAX(salary)
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id
ORDER BY MAX(salary)
LIMIT 1;

SELECT MIN(salary),department_id
FROM employees
WHERE department_id = (
	SELECT department_id
	FROM employees
	WHERE department_id IS NOT NULL
	GROUP BY department_id
	ORDER BY MAX(salary)
	LIMIT 1
);

# 8. 查询平均工资最高的部门的 manager 的详细信息: last_name, department_id, email, salary
SELECT department_id,AVG(salary) AS avg_em
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id
ORDER BY AVG(salary) DESC
LIMIT 1;

SELECT last_name,department_id,email,salary
FROM employees AS e
WHERE e.`employee_id` = (
	SELECT manager_id
	FROM departments AS d
	INNER JOIN (
		SELECT department_id,AVG(salary) AS avg_em
		FROM employees
		WHERE department_id IS NOT NULL
		GROUP BY department_id
		ORDER BY AVG(salary) DESC
		LIMIT 1
	) AS ag
	ON d.department_id = ag.department_id
);




