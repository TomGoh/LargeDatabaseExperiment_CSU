create user U_J521 identified by Dashui506;
grant resource, connect to U_J521;

--连接用户
conn U_J521/Dashui506;

--创建专业表
create table T_major_J521(
    MNo char(2) primary key,
    MName varchar(30),
    MLoc varchar(40) check(MLoc in ('主校区','南校区','新校区','铁道校区','湘雅小区')),
    MDean varchar(20)
);

--创建学生表
create table T_stud_J521
(
    SNo char(20) primary key,
    SName varchar(20),
    Sex varchar(10) check(sex in('男','女','其它','其他')),
    Tel varchar(15),
    Email varchar(24) check(email like '%@%.%'),
    Birthday date check((TO_CHAR('yyyymmdd'))>='19990731'),
    BNo char(20) references T_stud_J521(SNo),
    Mno char(2) references T_major_J521(MNo)
);

--插入专业数据
insert into T_major_J521 values ('01','计算机科学与技术','主校区','负责人一');
insert into T_major_J521 values ('02','大数据','南校区','负责人二');
insert into T_major_J521 values ('03','物联网','新校区','负责人三');

select * from T_MAJOR_J521

--插入学生数据
insert into T_stud_J521 values ('8202180502','张二','女','17877781802','123456789c@qq.com','21-May-2000','8202180502','02');
insert into T_stud_J521 values ('8202180521','吴昊泽','男','17877781898','tom-goh@outlook.com','06-May-2000','8202180502','02');
insert into T_stud_J521 values ('8202180501','张一','男','17877781801','123456789b@qq.com','12-May-2000','8202180502','02');
insert into T_stud_J521 values ('8202180503','张三','男','17877781803','123456789d@qq.com','14-May-2000','8202180502','02');
insert into T_stud_J521 values ('8202180504','张四','女','17877781804','123456789e@qq.com','15-May-2000','8202180502','02');
insert into T_stud_J521 values ('8202180608','张八','男','17877781808','123456789i@qq.com','01-May-2000','8202180608','02');
insert into T_stud_J521 values ('8202180605','张五','女','17877781805','123456789f@qq.com','16-May-2000','8202180608','02');
insert into T_stud_J521 values ('8202180606','张六','男','17877781806','123456789g@qq.com','17-May-2000','8202180608','02');
insert into T_stud_J521 values ('8202180607','张七','女','17877781807','123456789h@qq.com','18-May-2000','8202180608','02');
insert into T_stud_J521 values ('8202180610','张九','女','17877781809','123456789j@qq.com','20-May-2000','8202180608','02');

insert into T_stud_J521 values ('8201180100','陈一','女','15906027689','987654321a@qq.com','21-Oct-2000','8201180100','01');
insert into T_stud_J521 values ('8201180102','陈二','男','15906027688','987654321b@qq.com','22-Oct-2000','8201180100','01');
insert into T_stud_J521 values ('8201180103','陈三','女','15906027687','987654321c@qq.com','23-Oct-2000','8201180100','01');
insert into T_stud_J521 values ('8201180104','陈四','男','15906027686','987654321d@qq.com','24-Oct-2000','8201180100','01');
insert into T_stud_J521 values ('8201180105','陈五','男','15906027685','987654321e@qq.com','25-Oct-2000','8201180100','01');
insert into T_stud_J521 values ('8201180106','陈六','女','15906027684','987654321z@qq.com','26-Oct-2000','8201180100','01');
insert into T_stud_J521 values ('8201180300','陈七','男','15906027682','987654321f@qq.com','20-Oct-2000','8201180300','01');
insert into T_stud_J521 values ('8201180301','陈八','女','15906027682','987654321g@qq.com','27-Oct-2000','8201180300','01');
insert into T_stud_J521 values ('8201180302','陈九','男','15906027681','987654321h@qq.com','28-Oct-2000','8201180300','01');
insert into T_stud_J521 values ('8201180303','陈十','男','15906027680','987654321i@qq.com','29-Oct-2000','8201180300','01');

insert into T_stud_J521 values ('8203181101','吴一','男','15985911469','456789123a@qq.com','22-Jan-2000','8203181101','03');
insert into T_stud_J521 values ('8203181102','吴二','女','15985911468','456789123b@qq.com','23-Oct-2000','8203181101','03');
insert into T_stud_J521 values ('8203181103','吴三','男','15985911467','456789123c@qq.com','24-Oct-2000','8203181101','03');
insert into T_stud_J521 values ('8203181104','吴四','男','15985911466','456789123d@qq.com','25-Oct-2000','8203181101','03');
insert into T_stud_J521 values ('8203181105','吴五','女','15985911465','456789123e@qq.com','26-Jan-2000','8203181101','03');
insert into T_stud_J521 values ('8203181301','吴六','男','15985911464','456789123f@qq.com','27-Jan-2000','8203181301','03');
insert into T_stud_J521 values ('8203181302','吴七','女','15985911463','456789123g@qq.com','28-Jan-2000','8203181301','03');
insert into T_stud_J521 values ('8203181303','吴八','男','15985911462','456789123h@qq.com','29-Jan-2000','8203181301','03');
insert into T_stud_J521 values ('8203181304','吴九','男','15985911461','456789123i@qq.com','30-Jan-2000','8203181301','03');
insert into T_stud_J521 values ('8203181305','吴十','女','15985911460','456789123j@qq.com','21-Jan-2000','8203181301','03');

select * from T_STUD_J521;
--筛选学生表中的用户并创建用户名
select 'create user U' ||SNo|| ' identified by P'||Sno|| ';'from T_stud_J521

create user U8201180100 identified by P8201180100 ;
create user U8201180102 identified by P8201180102 ;
create user U8201180103 identified by P8201180103 ;
create user U8201180104 identified by P8201180104 ;
create user U8201180105 identified by P8201180105 ;
create user U8201180106 identified by P8201180106 ;
create user U8201180300 identified by P8201180300 ;
create user U8201180301 identified by P8201180301 ;
create user U8201180302 identified by P8201180302 ;
create user U8201180303 identified by P8201180303 ;
create user U8202180501 identified by P8202180501 ;
create user U8202180502 identified by P8202180502 ;
create user U8202180503 identified by P8202180503 ;
create user U8202180504 identified by P8202180504 ;
create user U8202180521 identified by P8202180521 ;
create user U8202180605 identified by P8202180605 ;
create user U8202180606 identified by P8202180606 ;
create user U8202180607 identified by P8202180607 ;
create user U8202180608 identified by P8202180608 ;
create user U8202180610 identified by P8202180610 ;
create user U8203181101 identified by P8203181101 ;
create user U8203181102 identified by P8203181102 ;
create user U8203181103 identified by P8203181103 ;
create user U8203181104 identified by P8203181104 ;
create user U8203181105 identified by P8203181105 ;
create user U8203181301 identified by P8203181301 ;
create user U8203181302 identified by P8203181302 ;	
create user U8203181303 identified by P8203181303 ;
create user U8203181304 identified by P8203181304 ;
create user U8203181305 identified by P8203181305 ;
--给予学生用户查询权限
select 'grant connect to U'||SNo|| ';' from T_stud_J521;
grant connect to  U8201180100 ;
grant connect to  U8201180102 ;
grant connect to  U8201180103 ;
grant connect to  U8201180104 ;
grant connect to  U8201180105 ;
grant connect to  U8201180106 ;
grant connect to  U8201180300 ;
grant connect to  U8201180301 ;
grant connect to  U8201180302 ;
grant connect to  U8201180303 ;
grant connect to  U8202180501 ;
grant connect to  U8202180502 ;
grant connect to  U8202180503 ;
grant connect to  U8202180504 ;
grant connect to U8202180521 ;
grant connect to U8202180605 ;
grant connect to U8202180606 ;
grant connect to U8202180607 ;
grant connect to U8202180608 ;
grant connect to U8202180610 ;
grant connect to U8203181101 ;
grant connect to U8203181102 ;
grant connect to U8203181103 ;
grant connect to U8203181104 ;
grant connect to U8203181105 ;
grant connect to U8203181301 ;
grant connect to U8203181302 ;
grant connect to U8203181303 ;
grant connect to U8203181304 ;
grant connect to U8203181305 ;


--创建系主任的用户
select 'create user U'||MNo|| ' identified by P'||MNo|| ';' from T_major_J521;

create user U01 identified by P01;
create user U02 identified by P02;
create user U03 identified by P03;
--基于系主任用户查询权限
select 'grant  connect to U'||MNo||';' from T_major_J521;
grant connect to U01;
grant connect to U02;
grant connect to U03;

--创建视图，可根据用户层级不同显示相应信息
create View V_View1_J521 AS
select * from T_stud_J521 
where user='U'||Sno or user='U'||Bno or user='U'||MNo


--查询视图示例
conn U02/P02;
select * from U_J521.V_View1_J521;

conn U8202180521/P8202180521;
select * from U_J521.V_View1_J521;

conn U8202180502/P8202180502;
select * from U_J521.V_View1_J521;

