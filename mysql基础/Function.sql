#函数
/*
含义：一组预先编译好的SQL语句的集合，理解成批处理语句
1、提高代码的重用性
2、简化操作
3、减少了编译次数并且减少了和数据库服务器的连接次数，提高了效率

区别：

存储过程：可以有0个返回，也可以有多个返回，适合做批量插入、批量更新
函数：有且仅有1 个返回，适合做处理数据后返回一个结果

*/
一、创建语法
CREATE FUNCTION 函数名(参数列表) RETURNS 返回类型
BEGIN
	函数体
END

/*
注意：
参数列表 包含两部分
参数名 参数类型

函数体：肯定会有return语句，如果没有会报错
如果return语句没有放在函数体的最后也不报错，但不建议

return 值;

3.函数体中仅有一句话，则可以省略begin end
4.使用delimiter语句设置结束标记
delimiter $;
*/

#二、调用语法
SELECT 函数名(参数列表)


#案例演示
#1、无参有返回
#案例：返回公司的员工个数
DELIMITER $
CREATE FUNCTION myf1() RETURNS INT
BEGIN
	DECLARE c INT DEFAULT 0;
	SELECT COUNT(*) INTO c
	FROM employees;
	RETURN c;
END $

SELECT myf1();


#2、有参有返回
#案例：根据员工名返回它的工资
DELIMITER $
CREATE FUNCTION myf2(employName VARCHAR(20)) RETURNS DOUBLE
BEGIN 
	SET @sal=0;#定义用户变量
	SELECT salary INTO @sal
	FROM employees
	WHERE last_name=employName;
	RETURN @sal;
END $

SELECT myf2('kochhar');

#案例2：根据部门名，返回该部门的平均工资
DELIMITER $
CREATE FUNCTION myf3(deptName VARCHAR(20)) RETURNS DOUBLE
BEGIN
	DECLARE sal DOUBLE;
	SELECT AVG(salary) INTO sal
	FROM employees AS e
	INNER JOIN departments AS d
	ON e.department_id = d.department_id
	WHERE d.department_name=deptName;
	RETURN sal;
END $

SELECT myf3('IT');


#三、查看函数
SHOW CREATE FUNCTION myf3;

#四、删除函数
DROP FUNCTION myf3;


#案例
#一、创建函数，实现传入两个float,返回二者之和
DROP FUNCTION IF EXISTS myf4;
DELIMITER $
CREATE FUNCTION myf4(x1 FLOAT,x2 FLOAT) RETURNS FLOAT
BEGIN
	DECLARE `sum` FLOAT DEFAULT 0;
	SELECT (x1+x2) INTO `sum`;
	RETURN ROUND(`sum`,2);
END$
SELECT myf4(1.2,2.2);