#存储过程和函数
/*
存储过程和函数：类似于java中的方法
好处：
1、提高代码的重用性
2、简化操作



*/
#存储过程
/*
含义：一组预先编译好的SQL语句的集合，理解成批处理语句
1、提高代码的重用性
2、简化操作
3、减少了编译次数并且减少了和数据库服务器的连接次数，提高了效率
*/

#一、创建语法
CREATE PROCEDURE 存储过程(参数列表)
BEGIN
	存储过程体（一组合法的SQL语句）
END

注意：
1、参数列表包含三部分
参数模式 参数名 参数类型
举例：
IN stuname VARCHAR(20)

参数模式：
in：该参数可以作为输入，也就是说该参数需要调用方传入值
out：该参数可以作为输出，也就是该参数可以作为返回值
inout：该参数既可以作为输入又可以作为输出，也就是该参数既需要传入值，又可以返回值


2、如果存储过程体仅仅只有一句话，BEGIN END 可以省略
存储过程体中的每条SQL结尾要求必须加分号，
存储过程的结尾可以使用`delimiter`重新设置
语法：
DELIMITER 结束标记

案例：
DELIMITER $


#二、调用方法
CALL 存储过程名(实参列表);


#1、空参列表
#案例：插入到admin表中五条记录
DELIMITER $
CREATE PROCEDURE myp1()
BEGIN
	INSERT INTO admin(username, `password`) 
	VALUES('john1','0000'),('lily','0000'),('lily2','0000'),('lily3','0000'),('lily4','0000');
	
END $


#调用
CALL myp1()$

SELECT * FROM admin;


#2、创建带in模式参数的存储过程
#案例1：创建存储过程实现 根据女神名，查询对应的男神信息
DELIMITER $
CREATE PROCEDURE myl2(IN beautyName VARCHAR(20))
BEGIN
	SELECT bo.*
	FROM boys bo
	RIGHT JOIN beauty b
	ON bo.id = b.boyfriend_id
	WHERE b.name = beautyName;
END $

#调用
CALL myl2('小昭') $


#案例2：创建存储过程实现，用户是否登录成功
DELIMITER $
CREATE PROCEDURE myp3(IN username VARCHAR(20),IN PASSWORD VARCHAR(20))
BEGIN
	DECLARE result INT DEFAULT 0;#声明并初始化
	SELECT COUNT(*) INTO result
	FROM admin
	WHERE admin.username = username
	AND admin.`password` = PASSWORD;
	
	SELECT IF(result>0,'成功','失败');
END $ 

#调用
CALL myp3('张飞','8888') $

CALL myp3('john', '8888') $

#3、创建带out模式的存储过程
#案例1：根据女神名，返回对应的男神名
DELIMITER $
CREATE PROCEDURE myp4(IN beautyName VARCHAR(20),OUT boyName VARCHAR(20))
BEGIN
	SELECT bo.boyName INTO boyName
	FROM boys bo
	INNER JOIN beauty b
	ON bo.id = b.boyfriend_id
	WHERE b.name=beautyName;
END $

SET @boyName$
CALL myp4('小昭', @boyName) $
SELECT @boyName$

#案例2：根据女神名，返回对应的男神名和男神魅力值
DELIMITER $
CREATE PROCEDURE myp5(IN beautyName VARCHAR(20),OUT boyName VARCHAR(20),OUT userCP INT)
BEGIN 
	SELECT bo.boyName,bo.userCP INTO boyName,userCP
	FROM boys AS bo
	INNER JOIN beauty AS b
	ON b.boyfriend_id = bo.id
	WHERE b.name=beautyName;
END $

CALL myp5('小昭',@boyName,@userCP) $
SELECT @boyName,@userCP $


#4、创建带inout模式参数的存储过程
#案例1：传入a和b两个值，最终a和b都翻倍并返回
DELIMITER $
CREATE PROCEDURE myp6(INOUT a INT,INOUT b INT)
BEGIN
	SET a=a*2;
	SET b=b*2;
END $

SET @m=10;
SET @n=20;

CALL myp6(@m,@n);

SELECT @m,@n;




#二、删除存储过程
语法：DROP PROCEDURE 存储过程名
DROP PROCEDURE p1;

#三、查看存储过程的信息
DESC myp1;#错误的
SHOW CREATE PROCEDURE myp1;

#不支持修改





#一、创建存储过程实现传入用户名和密码，插入到admin表中
DELIMITER $
CREATE PROCEDURE myp7(IN username VARCHAR(20), IN PASSWORD VARCHAR(20))
BEGIN
	INSERT INTO admin(admin.`username`,admin.`password`)
	VALUES(username, PASSWORD);
END $

CALL myp7('admin','123456');

SELECT  * FROM admin;

#二、创建存储过程实现传入女神编号，返回女神名称和女神电话
DELIMITER $
CREATE PROCEDURE myp8(IN id INT,OUT NAME VARCHAR(20),OUT phone VARCHAR(20))
BEGIN
	SELECT b.name,b.phone INTO NAME,phone
	FROM beauty AS b
	WHERE b.id = id;
END$

CALL myp8(8,@name,@phone);

SELECT @name,@phone;
#三、创建存储存储过程或函数实现传入两个女神生日，返回大小
DELIMITER $
CREATE PROCEDURE myp9(IN birth1 DATETIME,IN birth2 DATETIME,OUT result INT)
BEGIN
	SELECT DATEDIFF(birth1,birth2) INTO result;
END $

CALL myp9('1998-1-1','1999-1-1',@result);
SELECT @result;

#四、创建存储过程或函数实现传入一个日期，格式化成xx年xx月xx日并返回
DELIMITER $
CREATE PROCEDURE test_pro4(IN mydate DATETIME,OUT strDate VARCHAR(50))
BEGIN
	SELECT DATE_FORMAT(mydate,'%y年%m月%d日') INTO strDate;
END $

DELIMITER $
CALL test_pro4(NOW(),@str)$

DELIMITER $
SELECT @str $

#五、创建存储过程或函数实现传入女神名称，返回：女神 and 男神  格式的字符串
如 传入 ：小昭
返回： 小昭 AND 张无忌
DROP PROCEDURE test_pro5 $
DELIMITER $
CREATE PROCEDURE test_pro5(IN beautyName VARCHAR(20),OUT str VARCHAR(50))
BEGIN
	SELECT CONCAT(beautyName,' and ',IFNULL(boyName,'null')) INTO str
	FROM boys bo
	RIGHT JOIN beauty b ON b.boyfriend_id = bo.id
	WHERE b.name=beautyName;
	
END $

DELIMITER $
CALL test_pro5('小昭',@str)$

DELIMITER $
SELECT @str $



#六、创建存储过程或函数，根据传入的条目数和起始索引，查询beauty表的记录
DROP PROCEDURE test_pro6$
DELIMITER $
CREATE PROCEDURE test_pro6(IN startIndex INT,IN size INT)
BEGIN
	SELECT * FROM beauty LIMIT startIndex,size;
END $

DELIMITER $
CALL test_pro6(3,5)$


