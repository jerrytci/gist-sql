-- 1 查看版本
SELECT t.* FROM SYS.V_$VERSION t;
select * from V$VERSION;

-- 2 判断是否有中文
select lengthb('可以查看汉子占用多少字节 UTF8==3') from dual;
select lengthb('单位是字节') from dual;
select length('单位是字符') from dual;

select length('判断是否有中文') from dual union select lengthb('判断是否有中文') from dual;

-- 系统常用
select sys_guid() from dual;
select sysdate from dual;
select userenv('language') from dual;
select * from SALGRADE;
select * from DEPT;
select * from EMP;

-- 查询表是否被锁
select a.object_name,
       b.SESSION_ID,
       c.SERIAL#,
       c.PROGRAM,
       c.USERNAME,
       c.COMMAND,
       c.MACHINE,
       c.LOCKWAIT
from SYS.ALL_OBJECTS a,
     V$LOCKED_OBJECT b,
     V$SESSION c
where a.OBJECT_ID = b.OBJECT_ID
  and c.SID = b.SESSION_ID;

-- 查看锁表原因
select l.session_id sid,
       l.OS_USER_NAME,
       l.LOCKED_MODE,
       l.ORACLE_USERNAME,
       s.USER#,
       s.SERIAL#,
       s.MACHINE,
       s.TERMINAL,
       sa.SQL_TEXT,
       sa.ACTION
from V$SQLAREA sa,
     V$SESSION s,
     V$LOCKED_OBJECT l
where l.SESSION_ID = s.SID
  and s.PREV_SQL_ADDR = sa.ADDRESS
order by sid, s.SERIAL#;

-- 解锁方法
alter system kill session '锁住的进程号，即spid';

-- 查看被锁的表
select p.spid,
       ao.OBJECT_NAME,
       lo.SESSION_ID,
       lo.ORACLE_USERNAME,
       lo.OS_USER_NAME
from V$PROCESS p,
     V$SESSION s,
     V$LOCKED_OBJECT lo,
     ALL_OBJECTS ao
where p.ADDR = s.PADDR
  and s.PROCESS = lo.PROCESS
  and ao.OBJECT_ID = lo.OBJECT_ID;


-- 将多个查询结果合并
-- 场景：字段合并
select * from EMP;
select t.DEPTNO, WMSYS.wm_concat(t.EMPNO || '-' || JOB) from EMP t group by t.DEPTNO;

-- oracle客户端函数
select sysdate from dual;
declare
    dt date:=null;
    begin
    dt:=sysdate;
end;
/

-- 链接，
-- inner join
-- outer join(join)
-- full join
-- cross join

-- 没有参数的函数
create or replace function get_user return varchar2 is
    v_user varchar2(50);
begin
    select username into v_user from user_users;
    return v_user;
end get_user;

select get_user() from dual;

-- var v_name varchar2(50);
-- exec :v_name:=get_user;
-- print v_name;

-- exec dbms_output.put_line('当前数据库用户是：'||get_user);

-- 带参函数
create or replace function get_empname(v_id in number) return varchar2 is
    v_name varchar2(100);
begin
    select ENAME into v_name from EMP where DEPTNO = v_id;
    return v_name;
--     EXCEPTION
--     WHEN no_data_found then raise_application_error(-20001, '你输入的ID无效');
end get_empname;

select get_empname(20) from dual; -- select ENAME from EMP where DEPTNO = 20;
select text from user_source where name = 'GET_EMPNAME';
drop function get_empname;

--
select to_char(sysdate, 'YY/MM/DD HH24:MI:SS') from dual;

select add_months(sysdate, 3) from dual;
select sysdate-1 from dual;
