-- 1 判断记录是否存在
-- right
select isnull((select top(1) from SALGRADE where grade < 1), 0)
if exists(select * from SALGRADE where grade < 1) select '1' else select '0';
