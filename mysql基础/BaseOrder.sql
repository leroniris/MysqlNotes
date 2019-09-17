# 进阶3：排序查询

/*
特点
1、asc ：升序，如果不写默认升序
   desc：降序
2、排序列表 支持 单个字段、多个字段、函数、表达式、别名
3、order by的位置一般放在查询语句的最后（除limit语句之外）


语法：
	select 查询列表
	from 表
	【where 筛选条件】
	order by 排序列表 【asc|desc】
	不写默认升序
*/
# 案例：查询员工信息，要求工资从高到低排序
SELECT * FROM employees ORDER BY salary DESC;
# 案例：查询员工信息，要求工资从低到高排序
SELECT * FROM employees ORDER BY salary ASC;

# 案例2：查询部门编号>=90的员工信息，按入职时间的先后进行排序
SELECT * FROM employees WHERE department_id >= 90 ORDER BY hiredate ASC;


#案例3：按年薪的高低显示员工的信息【按表达式排序】
SELECT salary * (1 + IFNULL(commission_pct,0)) AS 年薪 
FROM employees 
ORDER BY salary * (1 + IFNULL(commission_pct,0)) DESC;

SELECT salary * 12 *(1 + IFNULL(commission_pct,0)) AS 年薪 
FROM employees 
ORDER BY 年薪 DESC;

# 案例4：按姓名的长度显示员工的姓名和工资【按函数排序】
SELECT LENGTH(last_name) 字节长度,last_name,salary
FROM employees
ORDER BY LENGTH(last_name) DESC;

#案例5：查询员工信息，要求先按工资排序，再按员工编号排序【按多个字段排序】
SELECT *
FROM employees
ORDER BY salary ASC, employee_id DESC;


#1、查询员工的姓名和部门号和年薪，按年薪降序 按姓名升序
SELECT last_name, department_id,salary*12*(1+IFNULL(commission_pct,0)) 年薪
FROM employees
ORDER BY 年薪 DESC,last_name ASC;

#2、选择工资不在8000到17000的员工的姓名和工资，按工资降序
SELECT last_name,salary
FROM employees
WHERE salary <8000 OR salary > 17000
ORDER BY salary DESC;

SELECT last_name,salary
FROM employees
WHERE salary NOT BETWEEN 8000 AND 17000
ORDER BY salary DESC;


#3、查询邮箱中包含e的员工信息，并先按邮箱的字节降序，再按部门号升序
SELECT *
FROM employees
WHERE email LIKE CONCAT('%', 'e', '%')
ORDER BY LENGTH(email) DESC, department_id ASC;