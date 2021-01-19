alter session set "_oracle_script"=true;

create profile pTester limit FAILED_LOGIN_ATTEMPTS 3 CONNECT_TIME 60 PASSWORD_LOCK_TIME 30;

create user Tester identified by Tester123 default tablespace tabspace_J521
quota 50M on tabspace_J521
profile pTester;

grant RESOURCE to Tester;

grant create session to Tester;

create   or   replace  directory D_OUTPUT  as   'D:/' ;
grant   read ,write  on  directory D_OUTPUT  to U_J521;
grant dba to Tester;

select * from user_tab_cols where table_name='T_STUDENT_EX3_J521';

create table detailsTable(
    tableName varchar(256),
    columnName varchar(256),
    columnType varchar(20),
    columnLenth number
);

insert into detailsTable(tableName,columnName,columnType,columnLenth) select table_name, column_name,data_type,data_length from user_tab_cols where table_name='T_STUDENT_EX3_J521';

select count(*) from user_tab_cols  where table_name='T_STUDENT_EX3_J521';

create or replace directory D_OUTPUT as 'D:/';

SET SERVEROUTPUT ON


EXEC auto_generate('T_MAJOR_J521','output.txt');


create or replace PROCEDURE auto_generate (tableName in VARCHAR , filePath in VARCHAR ) AS

type curType is ref cursor;  
tableCursor curType;  
 
v_sql varchar(3999);  
v_row varchar(3999);

cursor detailsCursor is select columnName,columnType,columnLenth from detailsTable;
outFile UTL_FILE.FILE_TYPE;
fileBuffer varchar(10000);
columnName1 varchar(20);
columnType1 varchar(20);
bufferlenth number;
columnLenth1 number;

BEGIN 
    outFile:=UTL_FILE.FOPEN('D_OUTPUT',filePath,'w',32767);
    execute immediate 'truncate table detailsTable';
    insert into detailsTable(tableName,columnName,columnType,columnLenth) select table_name, column_name,data_type,data_length from user_tab_cols where table_name=tableName;
    select distinct 'create table '||tablename||' (' into fileBuffer from detailsTable where rownum>0;
    DBMS_OUTPUT.PUT_LINE(fileBuffer);
    open detailsCursor;
    loop 
        fetch detailsCursor into columnName1,columnType1,columnLenth1;
        exit when detailsCursor%NOTFOUND;
        if instr(columnName1,'$')<=0 then
            fileBuffer:=fileBuffer || columnName1 ||' '|| columnType1 ||'('||columnLenth1||'),';
            DBMS_OUTPUT.PUT_LINE(fileBuffer);
        end if;
        
    end loop;
    close detailsCursor;
    select length(fileBuffer)-1 into bufferLenth from DUAL;
    select substr(fileBuffer,0,bufferLenth ) into fileBuffer from dual;
    fileBuffer:= fileBuffer ||');';
    DBMS_OUTPUT.PUT_LINE(fileBuffer);

    UTL_FILE.PUT_LINE(outFile,fileBuffer);
    
    v_sql := getfields(tableName);  
    dbms_output.put_line(v_sql);  
    open tableCursor for v_sql;  
        loop  
            fetch tableCursor into v_row;  
            dbms_output.put_line(v_row); 
            exit when tableCursor%notfound;  
            dbms_output.put_line(formatdata(tableName,v_row));  
            UTL_FILE.PUT_LINE(outFile,formatdata(tableName,v_row));
        end loop;      
    close tableCursor;

    UTL_FILE.FCLOSE(outFile);
END auto_generate;

create or replace function formatfield(v_tname varchar,v_cname varchar,v_colno number) return varchar  
as  
v_name varchar(3999);  
v_type varchar(99);  
begin  
    select coltype into v_type from col where tname = upper(v_tname) and colno = v_colno;  
    dbms_output.put_line(v_type);
    if v_type = 'DATE' then  
        v_name := 'to_date('||''''||v_cname||''''||','||''''||'yyyy-mm-dd hh:mi:ss'||''''||')';  
    elsif v_type = 'VARCHAR' then  
        v_name := ''''||v_cname||'''';  
    elsif v_type = 'VARCHAR2' then
        v_name := ''''||v_cname||'''';  
    else  
    v_name := v_cname;  
    end if; 
    dbms_output.put_line('after format:'||v_name);
    return v_name;    
end;  


create or replace function formatdata(v_tname varchar,v_row varchar) return varchar  
as  
v_ldata varchar(32765);  
v_rdata varchar(32765);  
v_cname varchar(3999);  
v_instr number(10);  
v_count number(6);  
begin  
    v_instr := instr(v_row,'(');  
    v_ldata := substr(v_row,1,v_instr);  
    v_rdata := substr(v_row,v_instr+1);  
    v_instr := instr(v_rdata,')');  
    v_rdata := substr(v_rdata,1,v_instr-1);  
  
    v_count := 0;  
    loop  
        v_instr := instr(v_rdata,',');  
        exit when v_instr = 0;  
        v_cname := substr(v_rdata,1,v_instr-1);  
        v_rdata := substr(v_rdata,v_instr+1);  
        v_count := v_count + 1;  
/* 格式化不同的数据类型 */  
        v_cname := formatfield(v_tname,v_cname,v_count);  
        dbms_output.put_line('get from format:'||v_cname);  
/* 将处理后的字段值加入v_ldata */  
        if v_count = 1 then  
            v_ldata := v_ldata||v_cname;  
        else  
            v_ldata := v_ldata||','||v_cname;  
        end if;  
    end loop;  
  
/* 添加最后一个字段的值 */  
    if v_count = 1 then  
        v_ldata := v_ldata||formatfield(v_tname,v_rdata,v_count+1)||');';  
    else  
        v_ldata := v_ldata||','||formatfield(v_tname,v_rdata,v_count+1)||');';  
    end if;  
    
    dbms_output.put_line(v_ldata);  
    return v_ldata;  
end;  

/* 求输入表的字段列表 */  
create or replace function getfields(v_tname varchar) return varchar  
as  
v_fields varchar(3999);  
begin  
    for cur_fname in (select cname,coltype from col where tname = upper(v_tname) order by colno) 
    loop  
        if v_fields is null then  
            v_fields := 'nvl('||cur_fname.cname||','||''''||'0'||''''||')';  
            
        else  
            v_fields := v_fields||'||'',''||'||'nvl('||cur_fname.cname||','||''''||'0'||''''||')';  
        end if;  
    end loop;  
    v_fields := 'select '||''''||'insert into '||v_tname||' values('||''''||'||'||v_fields||'||'||''''||')'||''''||' from '||v_tname;  
    return v_fields;  
end; 

EXEC auto_generate('T_MAJOR_J521','outputFile.txt');
