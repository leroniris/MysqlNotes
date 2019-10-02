#流程控制结构
/*
顺序结构：程序从上往下依次执行
分支结构：程序从两条或多条路径中选择一条执行
循环结构：程序在满足一定条件的基础上，重复执行一段代码

*/
#一、分支结构
#1.if函数
/*
功能：实现简单的双分支
语法：
if(表达式1，表达式2，表达式3)
执行顺序：
如果表达式1成立，则IF函数返回表达式2的值，否则返回表达式3的值
应用：任何地方
*/

#2、case结构
/*
情况一：类似于java中的switch语句，一般用于实现等值判断
语法：
	case 变量|表达式|字段
	when 要判断的值 then 返回值1或语句1
	when 要判断的值 then 返回值2或语句2
	else 要返回的值n或语句n
	end case;

情况二：类似于java中的多重if语句，一般用于实现区间判断
	case
	when 要判断的条件1 then 返回的值1或语句1
	when 要判断的条件2 then 返回的值2或语句2
	when 要判断的条件3 then 返回的值3或语句3
	else 要返回的值n或语句n
	end case;
*/

/*
特点：
①
可以作为表达式，嵌套在其他语句中使用，可以放在任何地方，begin end 中或begin end的外面
可以作为独立的语句去使用，只能放在begin end中
②
如果when中的值满足或条件成立，则执行对应的then后面，并且结束case
如果都不满足，则执行else中的语句或值
③else可以省略，如果else省略了，并且所有when条件都不满足，则返回null

*/

#案例
#创建存储过程，根据传入的成绩，来显示等级，比如
DELIMITER $
CREATE PROCEDURE test_case(IN grade INT)
BEGIN
	CASE 
	WHEN grade>=90 AND grade<=100 THEN SELECT 'A';
	WHEN grade>=80 THEN SELECT 'B';
	WHEN grade>=60 THEN SELECT 'C';
	ELSE SELECT 'D';
	END CASE;
END $

CALL test_case(88);


#3、if结构
/*
功能：实现多重分支
语法：
	if 条件1 then 语句1;
	elseif 条件2 then 语句2;
	...
	【else 语句n;】
	end if;
应用在begin end中
*/
#案例1：根据传入的成绩，来显示等级
DELIMITER $
CREATE FUNCTION test_if(score INT) RETURNS CHAR
BEGIN
	IF score>=90 AND score<=100 THEN RETURN 'A';
	ELSEIF score>=80 THEN RETURN 'B';
	ELSEIF score>=60 THEN RETURN 'C';
	ELSE RETURN 'D';
	END IF;	
END $

SELECT test_if(90);


#案例2：创建存储过程，如果工资<2000,则删除，如果5000>工资>2000,则涨工资1000，否则涨工资500


CREATE PROCEDURE test_if_pro(IN sal DOUBLE)
BEGIN
	IF sal<2000 THEN DELETE FROM employees WHERE employees.salary=sal;
	ELSEIF sal>=2000 AND sal<5000 THEN UPDATE employees SET salary=salary+1000 WHERE employees.`salary`=sal;
	ELSE UPDATE employees SET salary=salary+500 WHERE employees.`salary`=sal;
	END IF;
	
END $

CALL test_if_pro(2100)$


#二、循环结构
 /*
分类：
while、loop、repeat

循环控制：

iterate类似于 continue，继续，结束本次循环，继续下一次
leave 类似于  break，跳出，结束当前所在的循环

*/
#1、while
 /*
语法：
	【标签:】while 循环条件 do
			循环体;
		end while 【标签】;
*/

#2、loop
 /*
语法：
	【标签:】loop
		循环体;
		end loop;
	可以用来模拟简单的死循环
 */
 
 #3、repeat
 /*
语法：
	【标签:】repeat
		循环体;
		until 结束循环条件;
		end repeat 【标签】;
 */
 /*
int i=1;
while(i<=insertcount){
	//插入
	i++;
}
*/
#1.没有添加循环控制语句
#案例：批量插入，根据次数插入到admin表中多条记录
DELIMITER $
CREATE PROCEDURE pro_while1(IN insertCount INT)
BEGIN
	DECLARE i INT DEFAULT 1;
	a:WHILE i<=insertCount DO
		INSERT INTO admin(username, `password`) VALUES(CONCAT('Rose',i),'666');
		SET i=i+1;
	END WHILE a;

END $
CALL pro_while1(100);

#2、添加leave语句
#案例：批量插入，根据次数插入到admin表中多条记录,如果次数大于20，则停止
DELIMITER $
CREATE PROCEDURE test_while1(IN insertCount INT)
BEGIN
	DECLARE i INT DEFAULT 1;
	a:WHILE i<=insertCount DO
		INSERT INTO admin(username, `password`) VALUES(CONCAT('xiaohua',i),'666');
		IF i>=20 THEN LEAVE a;	
		END IF;	
		SET i=i+1;
	END WHILE a;
END $

CALL test_while1(100);
SELECT * FROM admin;

#3、添加iterate语句
#案例：批量插入，根据次数插入到admin表中多条记录,直插入偶数次
DROP PROCEDURE IF EXISTS test_while2;

DELIMITER $
CREATE PROCEDURE test_while2(IN insertCount INT)
BEGIN
	DECLARE i INT DEFAULT 0;
	a:WHILE i<=insertCount DO
		SET i=i+1;
		IF MOD(i,2)!=0 THEN ITERATE a;
		END IF;
		INSERT INTO admin(username, `password`) VALUES(CONCAT('xiaoli',i),'666');
	END WHILE a;
END $

CALL test_while2(100);
SELECT * FROM admin;


/*一、已知表stringcontent
其中字段：
id 自增长
content varchar(20)

向该表插入指定个数的，随机的字符串
*/

DROP TABLE IF EXISTS stringcontent;
CREATE TABLE stringcontent(
	id INT PRIMARY KEY AUTO_INCREMENT,
	content VARCHAR(20)
	
);
DROP PROCEDURE IF EXISTS test_randstr_insert;
DELIMITER $
CREATE PROCEDURE test_randstr_insert(IN insertCount INT)
BEGIN
	DECLARE i INT DEFAULT 1;
	DECLARE str VARCHAR(26) DEFAULT 'abcdefghijklmnopqrstuvwxyz';
	DECLARE startIndex INT;#代表初始索引
	DECLARE len INT;#代表截取的字符长度
	WHILE i<=insertcount DO
		SET startIndex=FLOOR(RAND()*26+1);#代表初始索引，随机范围1-26
		SET len=FLOOR(RAND()*(20-startIndex+1)+1);#代表截取长度，随机范围1-（20-startIndex+1）
		INSERT INTO stringcontent(content) VALUES(SUBSTR(str,startIndex,len));
		SET i=i+1;
	END WHILE;

END $

CALL test_randstr_insert(10);

SELECT * FROM stringcontent;