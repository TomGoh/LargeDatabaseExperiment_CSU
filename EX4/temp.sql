create or replace function formatfield(v_tname varchar,v_cname varchar,v_colno number) return varchar  
as  
v_name varchar(3999);  
v_type varchar(99);  
begin  
    select coltype into v_type from col where tname = upper(v_tname) and colno = v_colno;  
    if v_type = 'DATE' then  
        v_name := 'to_date('||''''||v_cname||''''||','||''''||'yyyy-mm-dd hh24:mi:ss'||''''||')';  
    elsif v_type = 'varchar' then  
        v_name := ''''||v_cname||'''';  
    else  
    v_name := v_cname;  
    end if;  
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


create or replace procedure print_insert(v_tname varchar,v_cbatch number default 0)  
as  
/* 声明动态游标变量 */  
type cur_alldata is ref cursor;  
l_alldata cur_alldata;  
/* 将单行数据写入v_row*/  
v_sql varchar(3999);  
v_row varchar(3999);  
begin  
execute immediate 'alter session set nls_date_format='||''''||'yyyy-mm-dd hh24:mi:ss'||'''';  
v_sql := getfields(v_tname);  
dbms_output.put_line(v_sql);  
open l_alldata for v_sql;  
loop  
fetch l_alldata into v_row;  
exit when l_alldata%notfound;  
dbms_output.put_line(v_row);  
  
dbms_output.put_line(formatdata(v_tname,v_row));  
end loop;  
dbms_output.put_line(formatdata(v_tname,v_row));  
close l_alldata;  
end;  
