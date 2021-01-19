create tablespace tabspace_J521
datafile 'D:\Database\Tablespace\tabspace_J521.dbf' size 3072M;

create table T_major1_J521(
    MNo char(2) primary key,
    MName varchar(30),
    MLoc varchar(40) check(MLoc in ('主校区','南校区','新校区','铁道校区','湘雅校区')),
    MDean varchar(20)
)tablespace tabspace_J521;

create table T_stud1_J521
(
    SNo char(20) primary key,
    SName varchar(20),
    Sex varchar(10) check(sex in('男','女','其它','其他')),
    Tel varchar(15),
    Email varchar(24) check(email like '%@%.%'),
    Birthday date check((TO_CHAR('yyyymmdd'))>='19990731'),
    BNo char(20) references T_stud_J521(SNo),
    Mno char(2) references T_major_J521(MNo)
)tablespace tabspace_J521;

EXEC RECORDTIME('重新插入专业前');
insert into T_major1_J521 values ('01','计算机科学与技术','主校区','负责人一');
insert into T_major1_J521 values ('02','大数据','南校区','负责人二');
insert into T_major1_J521 values ('03','物联网','新校区','负责人三');
EXEC RECORDTIME('重新插入专业后');

EXEC RECORDTIME('重新插入学生前');
insert into T_stud1_J521 values ('8202180502','张二','女','17877781802','123456789c@qq.com','21-5月-2000','8202180502','02');
insert into T_stud1_J521 values ('8202180521','吴昊泽','男','17877781898','tom-goh@outlook.com','06-5月-2000','8202180502','02');
insert into T_stud1_J521 values ('8202180501','张一','男','17877781801','123456789b@qq.com','12-5月-2000','8202180502','02');
insert into T_stud1_J521 values ('8202180503','张三','男','17877781803','123456789d@qq.com','14-5月-2000','8202180502','02');
insert into T_stud1_J521 values ('8202180504','张四','女','17877781804','123456789e@qq.com','15-5月-2000','8202180502','02');
insert into T_stud1_J521 values ('8202180608','张八','男','17877781808','123456789i@qq.com','01-5月-2000','8202180608','02');
insert into T_stud1_J521 values ('8202180605','张五','女','17877781805','123456789f@qq.com','16-5月-2000','8202180608','02');
insert into T_stud1_J521 values ('8202180606','张六','男','17877781806','123456789g@qq.com','17-5月-2000','8202180608','02');
insert into T_stud1_J521 values ('8202180607','张七','女','17877781807','123456789h@qq.com','18-5月-2000','8202180608','02');
insert into T_stud1_J521 values ('8202180610','张九','女','17877781809','123456789j@qq.com','20-5月-2000','8202180608','02');

insert into T_stud1_J521 values ('8201180100','陈一','女','15906027689','987654321a@qq.com','21-10月-2000','8201180100','01');
insert into T_stud1_J521 values ('8201180102','陈二','男','15906027688','987654321b@qq.com','22-10月-2000','8201180100','01');
insert into T_stud1_J521 values ('8201180103','陈三','女','15906027687','987654321c@qq.com','23-10月-2000','8201180100','01');
insert into T_stud1_J521 values ('8201180104','陈四','男','15906027686','987654321d@qq.com','24-10月-2000','8201180100','01');
insert into T_stud1_J521 values ('8201180105','陈五','男','15906027685','987654321e@qq.com','25-10月-2000','8201180100','01');
insert into T_stud1_J521 values ('8201180106','陈六','女','15906027684','987654321z@qq.com','26-10月-2000','8201180100','01');
insert into T_stud1_J521 values ('8201180300','陈七','男','15906027682','987654321f@qq.com','20-10月-2000','8201180300','01');
insert into T_stud1_J521 values ('8201180301','陈八','女','15906027682','987654321g@qq.com','27-10月-2000','8201180300','01');
insert into T_stud1_J521 values ('8201180302','陈九','男','15906027681','987654321h@qq.com','28-10月-2000','8201180300','01');
insert into T_stud1_J521 values ('8201180303','陈十','男','15906027680','987654321i@qq.com','29-10月-2000','8201180300','01');

insert into T_stud1_J521 values ('8203181101','吴一','男','15985911469','456789123a@qq.com','22-1月-2000','8203181101','03');
insert into T_stud1_J521 values ('8203181102','吴二','女','15985911468','456789123b@qq.com','23-10月-2000','8203181101','03');
insert into T_stud1_J521 values ('8203181103','吴三','男','15985911467','456789123c@qq.com','24-10月-2000','8203181101','03');
insert into T_stud1_J521 values ('8203181104','吴四','男','15985911466','456789123d@qq.com','25-10月-2000','8203181101','03');
insert into T_stud1_J521 values ('8203181105','吴五','女','15985911465','456789123e@qq.com','26-1月-2000','8203181101','03');
insert into T_stud1_J521 values ('8203181301','吴六','男','15985911464','456789123f@qq.com','27-1月-2000','8203181301','03');
insert into T_stud1_J521 values ('8203181302','吴七','女','15985911463','456789123g@qq.com','28-1月-2000','8203181301','03');
insert into T_stud1_J521 values ('8203181303','吴八','男','15985911462','456789123h@qq.com','29-1月-2000','8203181301','03');
insert into T_stud1_J521 values ('8203181304','吴九','男','15985911461','456789123i@qq.com','30-1月-2000','8203181301','03');
insert into T_stud1_J521 values ('8203181305','吴十','女','15985911460','456789123j@qq.com','21-1月-2000','8203181301','03');
EXEC RECORDTIME('重新插入学生后');

--重做实验三至新的表空间
CREATE TABLE Name11(
    OName1 NVARCHAR2(1)
)tablespace tabspace_J521;

CREATE TABLE Name21(
    OName2 NVARCHAR2(1)
)tablespace tabspace_J521;

CREATE TABLE Name31(
    OName3 NVARCHAR2(1)
)tablespace tabspace_J521;

EXEC RECORDTIME('取姓名前');
INSERT INTO NAME11 (SELECT DISTINCT SUBSTR(OX,1,1) FROM ORIGINALX);
INSERT INTO NAME11 (SELECT DISTINCT SUBSTR(ONAME,1,1) FROM OriginalName);
INSERT INTO NAME21 (SELECT DISTINCT SUBSTR(ONAME,2,1) FROM OriginalName);
INSERT INTO NAME31 (SELECT DISTINCT SUBSTR(ONAME,3,1) FROM OriginalName);
EXEC RECORDTIME('取姓名后');

CREATE TABLE "#temp" AS (SELECT DISTINCT * FROM NAME11);   --创建临时表，并把DISTINCT 去重后的数据插入到临时表中
truncate TABLE NAME11;   --清空原表数据
INSERT INTO NAME11 (SELECT * FROM "#temp");   --将临时表数据插入到原表中
DROP TABLE "#temp";  

CREATE TABLE "#temp" AS (SELECT DISTINCT * FROM NAME21);
truncate TABLE NAME21;
INSERT INTO NAME21 (SELECT * FROM "#temp");
DROP TABLE "#temp";  

CREATE TABLE "#temp" AS (SELECT DISTINCT * FROM NAME31);
truncate TABLE NAME31;
INSERT INTO NAME31 (SELECT * FROM "#temp");
DROP TABLE "#temp"; 

CREATE TABLE T_STUD_NAMES1_J521(
    STUDNAME NVARCHAR2(10)
)tablespace tabspace_J521;

EXEC RECORDTIME('插入姓名前');
INSERT INTO T_STUD_NAMES1_J521 (SELECT ONAME1||ONAME2||ONAME3 NAMES31 FROM NAME11,NAME21,NAME31 WHERE ROWNUM<=9000000);
INSERT INTO T_STUD_NAMES1_J521 (SELECT ONAME1||ONAME3 NAMES21 FROM NAME11,NAME31 WHERE ROWNUM<=1500000);
INSERT INTO T_STUD_NAMES1_J521 (SELECT ONAME1||ONAME2 NAMES22 FROM NAME11,NAME21 WHERE ROWNUM<=1500000);
EXEC RECORDTIME('插入姓名后');

CREATE TABLE "#temp" AS (SELECT DISTINCT * FROM T_STUD_NAMES1_J521);
truncate TABLE T_STUD_NAMES1_J521;
INSERT INTO T_STUD_NAMES1_J521 (SELECT * FROM "#temp");
DROP TABLE "#temp";  

--创建表格生成学号，按照要求诸位生成并保存
CREATE TABLE T_STUD_SNOGH1_J521(SNOGH number(10)) tablespace tabspace_J521;
CREATE TABLE T_STUD_SNOEF1_J521(SNOEF number(10))tablespace tabspace_J521;
CREATE TABLE T_STUD_SNOCD1_J521(SNOCD number(10))tablespace tabspace_J521;
CREATE TABLE T_STUD_SNOAB1_J521(SNOAB varchar2(10))tablespace tabspace_J521;

CREATE OR REPLACE PROCEDURE SNOCREATE1
AS
TEMP INT;
BEGIN
    FOR TEMP IN 1..32 
        LOOP
            INSERT INTO T_STUD_SNOGH1_J521 values(TEMP);
            COMMIT;
        END LOOP;
    FOR TEMP IN 1..50 
        LOOP
            INSERT INTO T_STUD_SNOEF1_J521 SELECT 170000+TEMP*100+T_STUD_SNOGH1_J521.SNOGH FROM T_STUD_SNOGH1_J521;
            COMMIT;
        END LOOP;
    FOR TEMP IN 1..90
        LOOP
            INSERT INTO T_STUD_SNOCD1_J521 SELECT TEMP*1000000+T_STUD_SNOEF1_J521.SNOEF FROM T_STUD_SNOEF1_J521;
            COMMIT;
        END LOOP;
    FOR TEMP IN 1..80
        LOOP
            INSERT INTO T_STUD_SNOAB1_J521 SELECT substr(10000000000+TEMP*100000000+T_STUD_SNOCD1_J521.SNOCD,2,10) FROM T_STUD_SNOCD1_J521;
            COMMIT;
        END LOOP;
END;

EXEC RECORDTIME('生成学号前');
EXEC SNOCREATE1;
EXEC RECORDTIME('生成学号后');

CREATE TABLE T_STUD_INFOR1_J521(
    SEX NVARCHAR2(2),
    TEL VARCHAR2(11),
    MAIL VARCHAR2(40),
    BIRTHDAY DATE
)tablespace tabspace_J521;

CREATE OR REPLACE PROCEDURE INPUTINFOR1 
AS
BEGIN
    FOR I IN 0..9999999 LOOP
    INSERT INTO T_STUD_INFOR1_J521(SEX,TEL,MAIL,BIRTHDAY) VALUES(GENDERCREATE,GENERATEPHONE,GENERATEMAIL,GENERATEBIRTH);
    END LOOP;
END;

select count(*) from T_STUD_INFOR1_J521;

EXEC RECORDTIME('生成学生信息前');
EXEC INPUTINFOR1;
EXEC RECORDTIME('生成学生信息后');

CREATE TABLE T_STUDENT_EX31_J521(
    SNo VARCHAR2(10),
    SName NVARCHAR2(3),
    SEX NVARCHAR2(2),
    TEL VARCHAR2(11),
    MAIL VARCHAR2(30),
    BIRTHDAY DATE
)tablespace tabspace_J521;

EXEC RECORDTIME('无主键插入前时间戳');
INSERT INTO T_STUDENT_EX31_J521(SNO,SNAME,SEX,TEL,MAIL,BIRTHDAY)
SELECT X.SNOAB,A.STUDNAME,B.SEX,B.TEL,B.MAIL,B.BIRTHDAY
FROM
(SELECT ROWNUM ROWNUMX, SNOAB FROM T_STUD_SNOAB1_J521) X,
(SELECT ROWNUM ROWNUMA,STUDNAME FROM T_STUD_NAMES1_J521) A,
(SELECT ROWNUM ROWNUMB, SEX,TEL,MAIL,BIRTHDAY FROM T_STUD_INFOR1_J521) B
WHERE ROWNUMA=ROWNUMB AND ROWNUMB = ROWNUMX;
EXEC RECORDTIME('无主键插入后时间戳');

DROP TABLE T_STUDENT_EX31_J521;

--创建适用于该实验的学生表格，该表格使用学生序号作为主键
CREATE TABLE T_STUDENT_EX31_J521(
    SNo VARCHAR2(10) PRIMARY KEY,
    SName NVARCHAR2(3),
    SEX NVARCHAR2(2),
    TEL VARCHAR2(11),
    MAIL VARCHAR2(30),
    BIRTHDAY DATE
)tablespace tabspace_J521;

EXEC RECORDTIME('有主键插入前时间戳');
INSERT INTO T_STUDENT_EX31_J521(SNO,SNAME,SEX,TEL,MAIL,BIRTHDAY)
SELECT X.SNOAB,A.STUDNAME,B.SEX,B.TEL,B.MAIL,B.BIRTHDAY
FROM
(SELECT ROWNUM ROWNUMX, SNOAB FROM T_STUD_SNOAB1_J521) X,
(SELECT ROWNUM ROWNUMA,STUDNAME FROM T_STUD_NAMES1_J521) A,
(SELECT ROWNUM ROWNUMB, SEX,TEL,MAIL,BIRTHDAY FROM T_STUD_INFOR1_J521) B
WHERE ROWNUMA=ROWNUMB AND ROWNUMB = ROWNUMX;
EXEC RECORDTIME('有主键插入后时间戳');


select * from timeRecord;