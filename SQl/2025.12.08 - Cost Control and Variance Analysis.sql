USE constructionOs;
select * from progress_tracking where flat_id = 1 AND Progress_percent = 100.00
ORDER BY task_id ASC;
Select * from users where user_id = 57;
-- ALTER TABLE SUBTASK_MASTER
-- 	DROP COLUMN order;-- 

set foreign_key_checks = 0;
set sql_safe_updates = 0;

select * from rcc_slab_sheet;
select * from rcc_column_sheet;

select AVG(progress_percent) from progress_tracking
	WHERE flat_id = 1;


select contractor_id, contractor_name, contractor_category from contractors;    
-- Cost Control & Variance Analysis

select task_name from task_master;
select * from projects;


