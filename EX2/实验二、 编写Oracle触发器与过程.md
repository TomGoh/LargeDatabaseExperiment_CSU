# 实验二、 编写Oracle触发器与过程

## 一、 目的与要求

本实验主要是熟悉ORACLE的后台编程，包括触发器与过程的编制，可比较基于SQL Server的触发器与过程。

## 二、 操作环境

硬件：AMD Ryzen 3750H   16GB RAM

软件：搭载Oracle 12c Enterprise 的  Windows10专业版

## 三、 实验内容

1. 设计与建立上课考勤表Attend_???，能登记每个学生的考勤记录包括正常、迟到、旷课、请假。能统计以专业为单位的出勤类别并进行打分评价排序，如迟到、旷课、请假分别扣2，5，1分。可以考虑给一初始的分值，以免负值。
2. 为major表与stud表增加sum_evaluation 数值字段，以记录根据考勤表Attend_???(Attendance)中出勤类别打分汇总的值。
3. 建立个人考勤汇总表stud_attend与专业考勤表major_attend，表示每个学生或每个专业在某时间周期（起始日期，终止日期）正常、迟到、旷课、请假次数及考勤分值。
4. 根据major表中的值与stud中的值，为考勤表Attend输入足够的样本值，要求每个专业都要有学生，有部分学生至少要有一周的每天5个单元（12，34，56，78，90，没有课的单元可以没有考勤记录）的考勤完整记录，其中**正常、迟到、旷课、请假** 可以用数字或字母符号表示。
5. 建立触发器，当对考勤表Attend表进行相应插入、删除、修改时，对stud表的sum_evaluation 数值进行相应的数据更新。
6. 建立过程，生成某专业某时段（起、止日期）的考勤汇总表major_attend中各字段值，并汇总相应专业，将考勤分值的汇总结果写入到major表中的sum_evaluation中。

## 四、 源程序清单

创建名为T_Attend_J521的出勤记录表，设置学号，记录时间和所记录的课程时间为主键：

``` SQL
CREATE TABLE T_ATTEND_J521(
	SNo char(20) NOT NULL REFERENCES T_STUD_J521(SNO),
	SName varchar(20) NOT NULL,
	MNo char(2) NOT NULL REFERENCES T_MAJOR_J521(MNO),
	RecordDate DATE NOT NULL,
	Class char(2) CHECK (Class IN ('12','34','56','78','90')),
	Records NVARCHAR2(4) CHECK(Records IN('正常','请假','迟到','旷课')),
	CONSTRAINT PK_ATTEND_J521 PRIMARY KEY(SNo, RecordDate ,Class)
);
```

为了实现保证数据的正确性与程序的鲁棒性，对于学号SNo、姓名SName、专业编号MNo以及记录时间Records进行$NOT \quad NULL$ 的约束；同时对于课程时间以及课程出席记录的字段在插入数据时均会进行检查，判断其是否满足约束条件。

修改实验一中创立的学生表与专业表，增加新的$sum \_ evaluation$字段：

```SQL
ALTER TABLE T_MAJOR_J521 ADD(sum_evaluation INT DEFAULT 100);
ALTER TABLE T_STUD_J521 ADD(sum_evaluation INT DEFAULT 100);
```

根据实验指导书的要求，为了避免出现$sum \_ evaluation$出现负值的情况，预先设置一个默认值为100.

创建表格存储不同出席情况对应的分数，以便于其后的对不同出席情况的分数的记录以及对于学生和专业的分数的记录：

```SQL
CREATE TABLE T_ATTENDSCORE_J521(
    Records NVARCHAR2(4) CHECK(Records IN('正常','请假','迟到','旷课')),
    Score INT NOT NULL,
    CONSTRAINT PK_ATTENDSCORE_J521 PRIMARY KEY(Records)
);
```

同样的，为了防止出现不在规定的四种出席情况之外的数值出现，对于Records字段进行约束并检查插入数据；为了防止分数出现不存在的情况对于数值进行$NOT \quad NULL$的约束。
设置 $T\_ATTENDSCORE\_J521$ 表格用意即为存储不同出席情况对应的分数，方便查询并且在出席分数需要修改时修改该表即可。

创建学生出席表，存储了一段时间之内的学生的出席情况，并且统计学生的累计情况与分数：

```SQL
CREATE TABLE T_STUD_ATTEND_J521(
    SNo CHAR(20) NOT NULL REFERENCES T_STUD_J521(SNo),
    StartDate DATE,
    EndDate DATE,
    LEAVE INT DEFAULT 0,
	ABSENT INT DEFAULT 0,
	NORMAL INT DEFAULT 0,
	LATE  INT DEFAULT 0,
	TotalScore INT DEFAULT 100,
    CONSTRAINT PK_STUD_ATTEND_J521 PRIMARY KEY(SNo,StartDate,EndDate)
);
```

该表格记录从StartDate开始直到EndDate的时期的对应学生的出席数据，对于不同出席情况进行计数并记录累计的分数。其中累计分数为了避免为负值设置一个初始值100。

创建专业出席表，存储了一段时间之内不同专业之中的所有学生的出席情况，并且统计专业内学生的的累计情况与总分数：

```SQL
CREATE TABLE T_MAJOR_ATTEND_J521(
    MNo CHAR(2) REFERENCES T_MAJOR_J521(MNo),
    StartDate DATE,
    EndDate DATE,
    LEAVE INT DEFAULT 0,
	ABSENT INT DEFAULT 0,
	NORMAL INT DEFAULT 0,
	LATE  INT DEFAULT 0,
	TotalScore INT DEFAULT 1000,
    CONSTRAINT PK_T_STUD_ATTEND_J521 PRIMARY KEY(MNo,StartDate,EndDate)
);
```

该表格记录从StartDate开始直到EndDate的时期的对应专业中所有学生的累计的出席数据，对于不同出席情况进行计数并记录累计的分数。其中累计分数为了避免为负值设置一个初始值1000。

向专业出席表中插入数据，设置每个专业的初始数据：

```SQL
INSERT INTO T_MAJOR_ATTEND_J521 VALUES('01','20-Nov-2020','30-Nov-2020',0,0,0,0,1000);
INSERT INTO T_MAJOR_ATTEND_J521 VALUES('02','20-Nov-2020','30-Nov-2020',0,0,0,0,1000);
INSERT INTO T_MAJOR_ATTEND_J521 VALUES('03','20-Nov-2020','30-Nov-2020',0,0,0,0,1000);
```

插入不同的出席情况对应的得分值进入出席分数表 $T\_ATTENDSCORE\_J521$ 中：

```SQL
INSERT INTO T_ATTENDSCORE_J521 VALUES('正常',0);
INSERT INTO T_ATTENDSCORE_J521 VALUES('请假',-1);
INSERT INTO T_ATTENDSCORE_J521 VALUES('迟到',-2);
INSERT INTO T_ATTENDSCORE_J521 VALUES('旷课',-5);
```

插入的分数值参考实验指导书中的要求：

> 能统计以专业为单位的出勤类别并进行打分评价排序，如迟到、旷课、请假分别扣2，5，1分

插入部分学生的信息，其中张二、陈五和吴五分别为代表三个专业的学生，拥有一周完整的记录：

```SQL
INSERT INTO T_ATTEND_J521 VALUES ('8202180502','张二','02','27-Nov-2020','12','正常');
INSERT INTO T_ATTEND_J521 VALUES ('8202180502','张二','02','27-Nov-2020','34','正常');
INSERT INTO T_ATTEND_J521 VALUES ('8202180502','张二','02','27-Nov-2020','56','正常');
INSERT INTO T_ATTEND_J521 VALUES ('8202180502','张二','02','26-Nov-2020','12','迟到');
INSERT INTO T_ATTEND_J521 VALUES ('8202180502','张二','02','26-Nov-2020','90','请假');
INSERT INTO T_ATTEND_J521 VALUES ('8202180502','张二','02','24-Nov-2020','12','请假');
INSERT INTO T_ATTEND_J521 VALUES ('8202180502','张二','02','24-Nov-2020','90','正常');
INSERT INTO T_ATTEND_J521 VALUES ('8202180502','张二','02','23-Nov-2020','90','正常');
INSERT INTO T_ATTEND_J521 VALUES ('8202180502','张二','02','25-Nov-2020','12','旷课');
INSERT INTO T_ATTEND_J521 VALUES ('8202180502','张二','02','24-Nov-2020','34','正常');
INSERT INTO T_ATTEND_J521 VALUES ('8202180502','张二','02','26-Nov-2020','56','请假');
INSERT INTO T_ATTEND_J521 VALUES ('8202180502','张二','02','25-Nov-2020','78','迟到');
INSERT INTO T_ATTEND_J521 VALUES ('8202180502','张二','02','25-Nov-2020','90','旷课');

INSERT INTO T_ATTEND_J521 VALUES ('8202180501','张一','02','25-Nov-2020','12','旷课');
INSERT INTO T_ATTEND_J521 VALUES ('8202180501','张一','02','25-Nov-2020','56','正常');
INSERT INTO T_ATTEND_J521 VALUES ('8202180501','张一','02','25-Nov-2020','90','旷课');

INSERT INTO T_ATTEND_J521 VALUES ('8201180100','陈一','01','25-Nov-2020','12','正常');
INSERT INTO T_ATTEND_J521 VALUES ('8201180100','陈一','01','26-Nov-2020','78','正常');
INSERT INTO T_ATTEND_J521 VALUES ('8201180100','陈一','01','25-Nov-2020','90','正常');

INSERT INTO T_ATTEND_J521 VALUES ('8201180105','陈五','01','25-Nov-2020','12','正常');
INSERT INTO T_ATTEND_J521 VALUES ('8201180105','陈五','01','26-Nov-2020','78','正常');
INSERT INTO T_ATTEND_J521 VALUES ('8201180105','陈五','01','25-Nov-2020','34','迟到');
INSERT INTO T_ATTEND_J521 VALUES ('8201180105','陈五','01','24-Nov-2020','78','正常');
INSERT INTO T_ATTEND_J521 VALUES ('8201180105','陈五','01','24-Nov-2020','12','正常');
INSERT INTO T_ATTEND_J521 VALUES ('8201180105','陈五','01','23-Nov-2020','34','正常');
INSERT INTO T_ATTEND_J521 VALUES ('8201180105','陈五','01','23-Nov-2020','56','正常');
INSERT INTO T_ATTEND_J521 VALUES ('8201180105','陈五','01','23-Nov-2020','90','正常');
INSERT INTO T_ATTEND_J521 VALUES ('8201180105','陈五','01','27-Nov-2020','12','旷课');
INSERT INTO T_ATTEND_J521 VALUES ('8201180105','陈五','01','27-Nov-2020','56','正常');
INSERT INTO T_ATTEND_J521 VALUES ('8201180105','陈五','01','27-Nov-2020','90','正常');

INSERT INTO T_ATTEND_J521 VALUES ('8203181104','吴四','03','25-Nov-2020','12','正常');
INSERT INTO T_ATTEND_J521 VALUES ('8203181104','吴四','03','24-Nov-2020','78','正常');
INSERT INTO T_ATTEND_J521 VALUES ('8203181104','吴四','03','25-Nov-2020','34','迟到');

INSERT INTO T_ATTEND_J521 VALUES ('8203181105','吴五','03','25-Nov-2020','12','正常');
INSERT INTO T_ATTEND_J521 VALUES ('8203181105','吴五','03','25-Nov-2020','78','正常');
INSERT INTO T_ATTEND_J521 VALUES ('8203181105','吴五','03','24-Nov-2020','12','迟到');
INSERT INTO T_ATTEND_J521 VALUES ('8203181105','吴五','03','23-Nov-2020','78','正常');
INSERT INTO T_ATTEND_J521 VALUES ('8203181105','吴五','03','23-Nov-2020','12','正常');
INSERT INTO T_ATTEND_J521 VALUES ('8203181105','吴五','03','26-Nov-2020','12','正常');
INSERT INTO T_ATTEND_J521 VALUES ('8203181105','吴五','03','26-Nov-2020','78','正常');
INSERT INTO T_ATTEND_J521 VALUES ('8203181105','吴五','03','26-Nov-2020','34','正常');
INSERT INTO T_ATTEND_J521 VALUES ('8203181105','吴五','03','26-Nov-2020','90','正常');
INSERT INTO T_ATTEND_J521 VALUES ('8203181105','吴五','03','27-Nov-2020','56','正常');
INSERT INTO T_ATTEND_J521 VALUES ('8203181105','吴五','03','27-Nov-2020','12','正常');
```

编写触发器，，针对对于$T\_ATTEND\_J521$该出席表的插入、删除、更新三个操作进行相应的操作，自发更新在$T\_STUD\_J521$学生表中的$sum\_evaluation$项目更新：

```SQL
CREATE OR REPLACE TRIGGER TR_ATTEND_J521 AFTER INSERT OR DELETE OR UPDATE ON T_ATTEND_J521 FOR EACH ROW
DECLARE 
    OLDSUM INT :=0;
    OLDSCORE INT :=0;
    TEMPSCORE INT :=0;
    NEWSUM INT :=0;
    
BEGIN
    IF INSERTING THEN
        SELECT SUM_EVALUATION INTO OLDSUM FROM T_STUD_J521 WHERE T_STUD_J521.SNo = :NEW.SNo;
        SELECT Score INTO TEMPSCORE FROM T_ATTENDSCORE_J521 WHERE T_ATTENDSCORE_J521.Records=:NEW.Records;
        NEWSUM:=OLDSUM + TEMPSCORE;
        UPDATE T_STUD_J521 SET SUM_EVALUATION = NEWSUM WHERE T_STUD_J521.SNo=:NEW.SNo;
    ELSIF UPDATING THEN
        SELECT SUM_EVALUATION INTO OLDSUM FROM T_STUD_J521 WHERE T_STUD_J521.SNo = :NEW.SNo;
        SELECT Score INTO TEMPSCORE FROM T_ATTENDSCORE_J521 WHERE T_ATTENDSCORE_J521.Records=:NEW.Records;
        SELECT Score INTO OLDSCORE FROM T_ATTENDSCORE_J521 WHERE T_ATTENDSCORE_J521.Records=:OLD.Records;
        NEWSUM:=OLDSUM+TEMPSCORE-OLDSCORE;
        UPDATE T_STUD_J521 SET SUM_EVALUATION = NEWSUM WHERE T_STUD_J521.SNo=:NEW.SNo;
    ELSIF DELETING THEN
        SELECT SUM_EVALUATION INTO OLDSUM FROM T_STUD_J521 WHERE T_STUD_J521.SNo = :OLD.SNo;
        SELECT Score INTO TEMPSCORE FROM T_ATTENDSCORE_J521 WHERE T_ATTENDSCORE_J521.Records=:OLD.Records;
        NEWSUM:=NEWSUM-TEMPSCORE;
        UPDATE T_STUD_J521 SET SUM_EVALUATION = NEWSUM WHERE T_STUD_J521.SNo=:OLD.SNo;
    END IF;
END;
```

在该触发器中，对于插入的数值进行增加$sum\_evaluation$的操作；对于删除操作则从对应的$sum\_evaluation$减去相应的数值；而对于更改操作，则读取原先记录对应的操作分数，减去该分数并加上新更改后的数值。

建立过程，将已经记录的学生的出席记录信息统计进入专业出席统计表中：

```SQL
CREATE OR REPLACE PROCEDURE PC_ATTEND_J521 AS
CURSOR ATTEND_CURSOR IS SELECT * FROM T_ATTEND_J521;
CURSOR MAJOR_CURSOR IS SELECT * FROM T_MAJOR_ATTEND_J521;

AttendRecord T_ATTEND_J521%ROWTYPE;
MajorRecord T_MAJOR_ATTEND_J521%ROWTYPE;
Majorr T_MAJOR_ATTEND_J521%ROWTYPE;
SCORES INT :=0;
INITIALSCORE INT :=1000;

BEGIN
    OPEN ATTEND_CURSOR;
    LOOP
        FETCH ATTEND_CURSOR INTO AttendRecord;
        SELECT * INTO MajorRecord FROM T_MAJOR_ATTEND_J521 WHERE T_MAJOR_ATTEND_J521.MNo=AttendRecord.MNo;
        SELECT T_ATTENDSCORE_J521.Score INTO SCORES FROM T_ATTENDSCORE_J521 WHERE T_ATTENDSCORE_J521.Records=AttendRecord.Records;
            CASE AttendRecord.Records
                WHEN '迟到' THEN
                    UPDATE T_MAJOR_ATTEND_J521
                    SET LATE=LATE+1 WHERE T_MAJOR_ATTEND_J521.MNo=AttendRecord.MNo;
                WHEN '旷课' THEN
                    UPDATE T_MAJOR_ATTEND_J521
                    SET ABSENT=ABSENT+1 WHERE T_MAJOR_ATTEND_J521.MNo=AttendRecord.MNo;
                WHEN '正常' THEN
                    UPDATE T_MAJOR_ATTEND_J521
                    SET NORMAL=NORMAL+1 WHERE T_MAJOR_ATTEND_J521.MNo=AttendRecord.MNo;
                WHEN '请假' THEN
                    UPDATE T_MAJOR_ATTEND_J521
                    SET LEAVE=LEAVE+1 WHERE T_MAJOR_ATTEND_J521.MNo=AttendRecord.MNo;
            END CASE;
            UPDATE T_MAJOR_ATTEND_J521 
                        SET TotalScore=TotalScore+SCORES WHERE T_MAJOR_ATTEND_J521.MNo=AttendRecord.MNo;
        EXIT WHEN ATTEND_CURSOR%NOTFOUND;
    END LOOP;
    CLOSE ATTEND_CURSOR;
    
    OPEN MAJOR_CURSOR;
    LOOP 
        FETCH MAJOR_CURSOR INTO Majorr;
        UPDATE T_MAJOR_J521
        SET SUM_EVALUATION=Majorr.TotalScore WHERE T_MAJOR_J521.MNo=Majorr.MNo;
        EXIT WHEN MAJOR_CURSOR%NOTFOUND;
    END LOOP;
    CLOSE MAJOR_CURSOR;
END;
```

使用游标针对记录时段内的出席情况并记录进入专业和学生的表格，同时使用游标对专业出席表进行更新。

## 五、 运行测试

在建立好上述表格、触发器与过程后，向$T\_ATTEND\_J521$出席表中插入数据，而后查看$T\_STUD\_J521$中的数据：

![image-20201203104026683](C:\Users\dicte\AppData\Roaming\Typora\typora-user-images\image-20201203104026683.png)

可以看出插入的陈五对应的$sum\_evaluation$的数值根据插入的数据发生了改变，其他的几个插入对象的学生亦是如此：

![image-20201203104212049](C:\Users\dicte\AppData\Roaming\Typora\typora-user-images\image-20201203104212049.png)

说明触发器确实在运行且成功达到了同步记录的目的。

而后执行统计专业出席数据的过程并查询专业出席表$T\_MAJOR\_J521$：

![image-20201203105029867](C:\Users\dicte\AppData\Roaming\Typora\typora-user-images\image-20201203105029867.png)

专业的出席总数据都根据插入的学生的出席记录发生了变动，证明过程也是正常运作的。

## 六、 实验中遇到的问题及结解决方案

在本次实验的过程中，遇到的问题有：

1. 在实验的初始版本中，对于出勤的记录为按照每天记录的形式：

   ```SQL
   CREATE TABLE T_ATTEND_J521(
   	SNo char(20) NOT NULL REFERENCES T_STUD_J521(SNO),
   	SName varchar(20) NOT NULL,
   	MNo char(2) NOT NULL REFERENCES T_MAJOR_J521(MNO),
   	RecordDate DATE NOT NULL,
   	Records12 NVARCHAR2(4) CHECK(Records IN('正常','请假','迟到','旷课')),
       Records34 NVARCHAR2(4) CHECK(Records IN('正常','请假','迟到','旷课')),
       Records56 NVARCHAR2(4) CHECK(Records IN('正常','请假','迟到','旷课')),
       Records78 NVARCHAR2(4) CHECK(Records IN('正常','请假','迟到','旷课')),
       Records90 NVARCHAR2(4) CHECK(Records IN('正常','请假','迟到','旷课')),
   	CONSTRAINT PK_ATTEND_J521 PRIMARY KEY(SNo, RecordDate ,Class)
   );
   ```

   在这种形式的数据存储之下，存在极大的数据冗余：学生每天未必有5节课但每一条出席记录中都包含了每天的五节课的数据信息即使未上课。后期在针对学生的出席信息进行统计并计算$sum\_evaluation$的过程中及时发现这一冗余并修改数据表的数据结构。

2. 在处理专业出席表时，初期未对专业出席数据表进行初始化，即未设置专业的初始缺席等出席情况的数值以及未设置专业的初试分数，最终导致执行过程时数据的插入失败。而后在每次重新运行程序代码时都会重新初始化每个专业的数值以便后期插入：

   ```SQL
   xxxxxxxxxx INSERT INTO T_MAJOR_ATTEND_J521 VALUES('01','20-Nov-2020','30-Nov-2020',0,0,0,0,1000);
   INSERT INTO T_MAJOR_ATTEND_J521 VALUES('02','20-Nov-2020','30-Nov-2020',0,0,0,0,1000);
   INSERT INTO T_MAJOR_ATTEND_J521 VALUES('03','20-Nov-2020','30-Nov-2020',0,0,0,0,1000);
   ```

   