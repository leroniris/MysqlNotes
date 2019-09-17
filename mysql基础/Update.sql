#修改语句
/*
1、修改单表的记录
语法：
update 表明
set 列=新值,列=新值,...
where 筛选条件;

2、修改多表的记录
语法：

sql92语法：
	update 表1 别名,表2 别名
	set 列=值
	where 连接条件
	and 筛选条件
	
sql99语法：
	update 表1 别名
	inner|left|right join 表2 别名
	on 连接
	set 列=值,...
	where 筛选条件
*/

#1.修改单表的记录
#案例1：修改beauty表中姓唐的女神的电话为13899888899
SELECT * FROM beauty;
UPDATE beauty
SET phone = '1389999923'
WHERE NAME LIKE '唐%';


#案例2：修改boys表中id号为2的名称为张飞，魅力值10
SELECT * FROM boys;
UPDATE boys
SET boyname='张飞',userCP=10
WHERE id = 2;


#2、修改多表的记录

#案例1：修改张无忌的女朋友的手机号为113
UPDATE boys AS bo,beauty AS b
SET b.`phone`='113'
WHERE b.`boyfriend_id`=bo.`id`
AND bo.`boyName`='张无忌';

UPDATE boys AS bo
INNER JOIN beauty AS b
ON bo.`id` = b.`boyfriend_id`
SET b.`phone` = '115'
WHERE bo.`boyName` = '张无忌';


#案例2：修改没有男朋友的女神的男朋友编号都为2
SELECT * FROM beauty;

UPDATE boys AS bo
RIGHT JOIN beauty AS b
ON bo.`id` = b.`boyfriend_id`
SET b.`boyfriend_id` = 2
WHERE bo.`id` IS NULL;
	