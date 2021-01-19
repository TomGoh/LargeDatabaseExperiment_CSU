alter session set "_oracle_script"=true;

create profile pTester limit FAILED_LOGIN_ATTEMPTS 3 CONNECT_TIME 60 PASSWORD_LOCK_TIME 30;

create user Tester identified by Tester123 default tablespace tabspace_J521
quota 50M on tabspace_J521
profile pTester;

grant RESOURCE to Tester;

grant create session to Tester;

grant dba to Tester;

create table detailsTable(
    tableName varchar(256),
    columnName varchar(256),
    columnType varchar(20),
    colomnLenth number
);

create or replace NONEDITIONABLE PROCEDURE auto_generate (tableName in VARCHAR , filePath in VARCHAR ) AS

cursor detailsCursor is select columnName,columnType,columnLenth from detailsTable;
outFile UTL_FILE.FILE_TYPE;
fileBuffer varchar(10000);
columnName1 varchar(20);
columnType1 varchar(20);
bufferlenth number;
columnLenth1 number;

BEGIN 
    outFile:=UTL_FILE.FOPEN('D_OUTPUT',filePath,'w');

    insert into detailsTable(tableName,columnName,columnType,columnLenth) select table_name, column_name,data_type,data_length from user_tab_cols where table_name=tableName;

    select distinct 'create table '||tablename||' (' into fileBuffer from detailsTable where rownum>0;
    DBMS_OUTPUT.PUT_LINE(fileBuffer);
    open detailsCursor;
    loop 
        fetch detailsCursor into columnName1,columnType1,columnLenth1;
        fileBuffer:=fileBuffer || columnName1 ||' '|| columnType1 ||'('||columnLenth1||'),';
        DBMS_OUTPUT.PUT_LINE(fileBuffer);
        exit when detailsCursor%NOTFOUND;
    end loop;
    close detailsCursor;
    select length(fileBuffer)-1 into bufferLenth from DUAL;
    select substr(fileBuffer,0,bufferLenth ) into fileBuffer from dual;
    fileBuffer:= fileBuffer ||');';
    DBMS_OUTPUT.PUT_LINE(fileBuffer);

    UTL_FILE.PUT_LINE(outFile,fileBuffer);
    

    
    UTL_FILE.FCLOSE(outFile);
END ;