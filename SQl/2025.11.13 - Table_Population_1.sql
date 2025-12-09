/* The goal of this sql is to populate the task_maste table, the subtask master table and the floors table.*/

USE constructionOS;

SHOW CREATE TABLE TASK_MASTER;
SHOW CREATE TABLE SUBTASK_MASTER;

SELECT * FROM TASK_MASTER;
SELECT * FROM SUBTASK_MASTER;

/* Gives Ambigous column result */
SELECT TASK_CODE, SUBTASK_CODE, TASK_NAME, SUBTASK_NAME FROM TASK_MASTER
	JOIN SUBTASK_MASTER
		WHERE SUBTASK_MASTER.TASK_CODE = TASK_MASTER.TASK_CODE;

/* Corrected syntax */
SELECT
	tm.task_id,
    sm.subtask_id,
    tm.TASK_CODE,
    sm.SUBTASK_CODE,
    tm.TASK_NAME,
    sm.SUBTASK_NAME
FROM
    TASK_MASTER AS tm
JOIN
    SUBTASK_MASTER AS sm ON tm.TASK_CODE = sm.TASK_CODE;


/* POPULATING PREDEFINED DATA FOR TASK_MASTER TABL */
/* DELETING TASK CODE, TASK TYPE, UNIT OF MEASURE AND DEFAULT_PERCENT BECAUSE THEY SERVE NO PURPOSE. 
THIS TABLE - TASKMASTER IS PURELY A REFERENCCE TABLE AND NOTHING MORE. */
ALTER TABLE TASK_MASTER DROP COLUMN TASK_TYPE;
ALTER TABLE TASK_MASTER DROP COLUMN TASK_code;
ALTER TABLE TASK_MASTER DROP COLUMN DEFAULT_PERCENT;
ALTER TABLE TASK_MASTER DROP COLUMN UNIT_OF_MEASURE;
 
 DESC TASK_MASTER;
 
 
 INSERT INTO task_master (task_name, task_description, is_active) VALUES
('Slab Cleaning', 'Cleaning slab before starting the next construction stage', TRUE),
('Brick Work', 'Brick masonry, layout, and alignment work', TRUE),
('Cement Plaster', 'Internal and external wall plastering with cement mortar', TRUE),
('POP Plaster', 'Plaster of Paris finishing work on walls and ceilings', TRUE),
('Electrical Conduits', 'Installation of electrical conduits and boxes prior to wiring', TRUE),
('Waterproofing', 'Waterproofing of wet areas including toilets, balconies, and terraces', TRUE),
('Plumbing', 'Plumbing pipe installation, outlets, and fittings setup', TRUE),
('Tiling', 'Floor, wall, skirting, and granite tiling works', TRUE),
('Doors & Windows', 'Installation of doors, door frames, and window systems', TRUE),
('CP Fittings', 'Installation of sanitary and CP fittings across bathrooms and kitchens', TRUE),
('Wiring and Electrical Fixtures', 'Electrical wiring, switchboard setup, and fitting of fixtures', TRUE),
('Painting & Touchup', 'Surface preparation, primer, and painting with final touchups', TRUE),
('Cleaning', 'Final cleaning and handover preparation of the flat/unit', TRUE);

 SELECT * FROM TASK_MASTER;
 SELECT * from subtask_master;
 
/* Deleting the task_code column was a mistake. I have to get back that table. */
ALTER TABLE task_master
ADD COLUMN task_code VARCHAR(5);


ALTER TABLE task_master DROP INDEX task_code;

SHOW index from task_master;
SHOW CREATE TABLE task_master;
SHOW CREATE TABLE subtask_master;
/* Deleting duplicates from the task_master */
DELETE t1
FROM task_master t1
JOIN task_master t2
  ON t1.task_name = t2.task_name
  AND t1.task_id > t2.task_id;

SET SQL_SAFE_UPDATES = 0;
SET SQL_SAFE_UPDATES = 1;


/* Updating task_code for task-names*/
-- 🔹 Assign business codes to unique tasks in task_master

UPDATE task_master SET task_code = 'O'  WHERE task_name = 'Slab Cleaning';
UPDATE task_master SET task_code = 'A'  WHERE task_name = 'Brick Work';
UPDATE task_master SET task_code = 'B'  WHERE task_name = 'Cement Plaster';
UPDATE task_master SET task_code = 'C'  WHERE task_name = 'POP Plaster';
UPDATE task_master SET task_code = 'D'  WHERE task_name = 'Electrical Conduits';
UPDATE task_master SET task_code = 'E'  WHERE task_name = 'Waterproofing';
UPDATE task_master SET task_code = 'F'  WHERE task_name = 'Plumbing';
UPDATE task_master SET task_code = 'G1' WHERE task_name = 'Tiling - Floors';
UPDATE task_master SET task_code = 'G2' WHERE task_name = 'Tiling - Wall';
UPDATE task_master SET task_code = 'G3' WHERE task_name = 'Tiling - Skirting';
UPDATE task_master SET task_code = 'G4' WHERE task_name = 'Tiling - Granite';
UPDATE task_master SET task_code = 'H1' WHERE task_name = '(D&W) - Door Frames';
UPDATE task_master SET task_code = 'H2' WHERE task_name = '(D&W) - Door Shutter + Hardware';
UPDATE task_master SET task_code = 'H3' WHERE task_name = '(D&W) - Windows and Sliding Doors Frame';
UPDATE task_master SET task_code = 'H4' WHERE task_name = '(D&W) - Windows and Sliding Doors Shutter';
UPDATE task_master SET task_code = 'I'  WHERE task_name = 'CP Fittings';
UPDATE task_master SET task_code = 'J'  WHERE task_name = 'Wiring and Electrical Fixtures';
UPDATE task_master SET task_code = 'K'  WHERE task_name = 'Painting & Touchup';
UPDATE task_master SET task_code = 'L'  WHERE task_name = 'Cleaning';


DELETE FROM TASK_MASTER WHERE is_active = 1;

/* Redid the table - messed up data entry before */
INSERT INTO task_master (task_id, task_code, task_name, task_description, is_active) VALUES
(1,  'O',  'Slab Cleaning', 'Cleaning slab before starting the next construction stage', TRUE),
(2,  'A',  'Brick Work', 'Brick masonry, layout, and alignment work', TRUE),
(3,  'B',  'Cement Plaster', 'Internal and external wall plastering with cement mortar', TRUE),
(4,  'C',  'POP Plaster', 'Plaster of Paris finishing work on walls and ceilings', TRUE),
(5,  'D',  'Electrical Conduits', 'Installation of electrical conduits and boxes prior to wiring', TRUE),
(6,  'E',  'Waterproofing', 'Waterproofing of wet areas including toilets, balconies, and terraces', TRUE),
(7,  'F',  'Plumbing', 'Plumbing pipe installation, outlets, and fittings setup', TRUE),
(8,  'G1', 'Tiling - Floors', 'Floor tiling works including surface leveling and joint finishing', TRUE),
(9,  'G2', 'Tiling - Wall', 'Wall tiling works for bathrooms, kitchens, and utility areas', TRUE),
(10, 'G3', 'Tiling - Skirting', 'Skirting tile fixing along the floor edges', TRUE),
(11, 'G4', 'Tiling - Granite', 'Granite countertop and sill fixing works', TRUE),
(12, 'H1', '(D&W) - Door Frames', 'Installation of door frames including alignment and fixing', TRUE),
(13, 'H2', '(D&W) - Door Shutter + Hardware', 'Installation of door shutters, handles, and locks', TRUE),
(14, 'H3', '(D&W) - Windows and Sliding Doors Frame', 'Fixing window and sliding door frames', TRUE),
(15, 'H4', '(D&W) - Windows and Sliding Doors Shutter', 'Installation of window shutters and sliding panels', TRUE),
(16, 'I',  'CP Fittings', 'Installation of sanitary and CP fittings across bathrooms and kitchens', TRUE),
(17, 'J',  'Wiring and Electrical Fixtures', 'Electrical wiring, switchboard setup, and fixture fitting', TRUE),
(18, 'K',  'Painting & Touchup', 'Surface preparation, primer, and painting with final touchups', TRUE),
(19, 'L',  'Cleaning', 'Final cleaning and handover preparation of the flat/unit', TRUE);

-- 🔹 Step 1: Drop the old foreign key and index
ALTER TABLE `subtask_master`
  DROP FOREIGN KEY `task_code`,
  DROP INDEX `task_code_idx`;

-- 🔹 Step 2: Recreate index and foreign key with better names and ON UPDATE CASCADE
ALTER TABLE `subtask_master`
  ADD KEY `idx_task_code` (`task_code`),
  ADD CONSTRAINT `fk_subtask_task`
    FOREIGN KEY (`task_code`)
    REFERENCES `task_master` (`task_code`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;


-- Check structure and foreign keys
SHOW CREATE TABLE subtask_master;

-- Optional: confirm that the FK constraint and index exist
SELECT 
    TABLE_NAME, 
    CONSTRAINT_NAME, 
    REFERENCED_TABLE_NAME, 
    UPDATE_RULE, 
    DELETE_RULE
FROM information_schema.REFERENTIAL_CONSTRAINTS
WHERE CONSTRAINT_SCHEMA = 'constructionos' 
  AND TABLE_NAME = 'subtask_master';

ALTER TABLE subtask_master
ADD COLUMN `order` INT NOT NULL;


/* Populating the subtask table */
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('O', 'O1', 'Slab Cleaning', 1, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('A', 'A1', 'Line Out', 1, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('A', 'A2', 'AAC Block', 2, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('A', 'A3', 'Cleaning', 3, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('B', 'B1', 'Guest Bedroom', 1, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('B', 'B2', 'Guest Toilet', 2, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('B', 'B3', 'Guest Balcony', 3, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('B', 'B4', 'Hall', 4, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('B', 'B5', 'Hall Balcony', 5, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('B', 'B6', 'Kitchen', 6, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('B', 'B7', 'Child''s Bedroom', 7, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('B', 'B8', 'Common Toilet', 8, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('B', 'B9', 'Passage', 9, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('B', 'B10', 'Master Bedroom - 1', 10, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('B', 'B11', 'Master Toilet - 1', 11, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('B', 'B12', 'Master Balcony. - 1', 12, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('B', 'B13', 'Master Bedroom - 2', 13, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('B', 'B14', 'Master Toilet - 2', 14, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('B', 'B15', 'Master Balcony. - 2', 15, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('B', 'B16', 'Cleaning', 16, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('C', 'C1', 'Guest Bedroom', 1, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('C', 'C2', 'Guest Toilet', 2, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('C', 'C3', 'Hall', 3, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('C', 'C4', 'Kitchen', 4, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('C', 'C5', 'Child''s Bedroom', 5, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('C', 'C6', 'Common Toilet', 6, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('C', 'C7', 'Passage', 7, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('C', 'C8', 'Master Bedroom - 1', 8, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('C', 'C9', 'Master Toilet - 1', 9, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('C', 'C10', 'Master Bedroom - 2', 10, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('C', 'C11', 'Master Toilet - 2', 11, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('C', 'C12', 'Cleaning', 12, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('D', 'D1', 'Hall', 1, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('D', 'D2', 'Guest Bedroom', 2, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('D', 'D3', 'Kitchen', 3, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('D', 'D4', 'Common Toilet', 4, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('D', 'D5', 'MCB', 5, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('D', 'D6', 'Child''s Bedroom', 6, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('D', 'D7', 'Master Bed - 1', 7, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('D', 'D8', 'Master Toil - 1', 8, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('D', 'D9', 'Master Bed - 2', 9, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('D', 'D10', 'Master Toil - 2', 10, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('D', 'D11', 'Cleaning', 11, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E1', 'Common Toilet', 1, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E2', 'Cleaning & Chemical Coat', 2, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E3', 'Water Retention', 3, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E4', 'Core Cut', 4, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E5', 'Plumbing Outlet', 5, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E6', 'Brick Bat Coba', 6, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E7', 'Water Retention', 7, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E8', 'Final Cement Layer', 8, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E9', 'Cleaning', 9, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E10', 'Guest Toilet', 10, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E11', 'Cleaning & Chemical Coat', 11, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E12', 'Water Retention', 12, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E13', 'Core Cut', 13, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E14', 'Plumbing Outlet', 14, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E15', 'Brick Bat Coba', 15, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E16', 'Water Retention', 16, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E17', 'Final Cement Layer', 17, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E18', 'Cleaning', 18, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E19', 'Guest Balcony', 19, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E20', 'Cleaning & Chemical Coat', 20, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E21', 'Water Retention', 21, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E22', 'Core Cut', 22, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E23', 'Plumbing Outlet', 23, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E24', 'Brick Bat Coba', 24, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E25', 'Water Retention', 25, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E26', 'Final Cement Layer', 26, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E27', 'Cleaning', 27, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E28', 'Hall Balcony', 28, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E29', 'Cleaning & Chemical Coat', 29, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E30', 'Water Retention', 30, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E31', 'Core Cut', 31, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E32', 'Plumbing Outlet', 32, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E33', 'Brick Bat Coba', 33, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E34', 'Water Retention', 34, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E35', 'Final Cement Layer', 35, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E36', 'Cleaning', 36, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E37', 'Kitchen', 37, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E38', 'Cleaning & Chemical Coat', 38, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E39', 'Water Retention', 39, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E40', 'Core Cut', 40, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E41', 'Plumbing Outlet', 41, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E42', 'Brick Bat Coba', 42, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E43', 'Water Retention', 43, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E44', 'Final Cement Layer', 44, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E45', 'Cleaning', 45, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E46', 'Master Toilet - 1', 46, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E47', 'Cleaning & Chemical Coat', 47, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E48', 'Water Retention', 48, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E49', 'Core Cut', 49, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E50', 'Plumbing Outlet', 50, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E51', 'Brick Bat Coba', 51, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E52', 'Water Retention', 52, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E53', 'Final Cement Layer', 53, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E54', 'Cleaning', 54, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E55', 'Master Toilet - 2', 55, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E56', 'Cleaning & Chemical Coat', 56, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E57', 'Water Retention', 57, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E58', 'Core Cut', 58, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E59', 'Plumbing Outlet', 59, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E60', 'Brick Bat Coba', 60, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E61', 'Water Retention', 61, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E62', 'Final Cement Layer', 62, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E63', 'Cleaning', 63, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E64', 'Master Balcony', 64, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E65', 'Cleaning & Chemical Coat', 65, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E66', 'Water Retention', 66, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E67', 'Core Cut', 67, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E68', 'Plumbing Outlet', 68, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E69', 'Brick Bat Coba', 69, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E70', 'Water Retention', 70, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E71', 'Final Cement Layer', 71, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E72', 'Cleaning', 72, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E73', 'Master Terrace', 73, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E74', 'Cleaning & Chemical Coat', 74, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E75', 'Water Retention', 75, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E76', 'Core Cut', 76, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E77', 'Plumbing Outlet', 77, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E78', 'Brick Bat Coba', 78, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E79', 'Water Retention', 79, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E80', 'Final Cement Layer', 80, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('E', 'E81', 'Cleaning', 81, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F1', 'Hall Balcony', 1, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F2', 'Core Cut', 2, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F3', 'Inlet Pipe', 3, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F4', 'Outlet Pipe', 4, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F5', 'Cleaning', 5, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F6', 'Kitchen', 6, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F7', 'Core Cut', 7, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F8', 'Inlet Pipe', 8, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F9', 'Outlet Pipe', 9, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F10', 'Cleaning', 10, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F11', 'Common Toilet', 11, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F12', 'Core Cut', 12, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F13', 'Inlet Pipe', 13, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F14', 'Outlet Pipe', 14, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F15', 'Cleaning', 15, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F16', 'Guest Toilet', 16, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F17', 'Core Cut', 17, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F18', 'Inlet Pipe', 18, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F19', 'Outlet Pipe', 19, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F20', 'Cleaning', 20, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F21', 'Guest Balcony', 21, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F22', 'Core Cut', 22, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F23', 'Inlet Pipe', 23, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F24', 'Outlet Pipe', 24, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F25', 'Cleaning', 25, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F26', 'Master Toilet', 26, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F27', 'Core Cut', 27, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F28', 'Inlet Pipe', 28, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F29', 'Outlet Pipe', 29, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F30', 'Cleaning', 30, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F31', 'Master Terrace', 31, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F32', 'Core Cut', 32, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F33', 'Inlet Pipe', 33, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F34', 'Outlet Pipe', 34, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F35', 'Cleaning', 35, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F36', 'Master Balcony', 36, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F37', 'Core Cut', 37, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F38', 'Inlet Pipe', 38, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F39', 'Outlet Pipe', 39, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('F', 'F40', 'Cleaning', 40, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G1', 'Guest Bedroom', 1, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G2', 'Pre - Cleaning', 2, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G3', 'Aggregate Fill', 3, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G4', 'Aggregate Level', 4, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G5', 'Tile Cutting', 5, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G6', 'Tile Install', 6, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G7', 'Curing', 7, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G8', 'Grouting', 8, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G9', 'Post - Cleaning', 9, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G10', 'Guest Toilet', 10, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G11', 'Pre - Cleaning', 11, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G12', 'Aggregate Fill', 12, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G13', 'Aggregate Level', 13, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G14', 'Tile Cutting', 14, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G15', 'Tile Install', 15, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G16', 'Curing', 16, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G17', 'Grouting', 17, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G18', 'Post - Cleaning', 18, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G19', 'Guest Balcony', 19, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G20', 'Pre - Cleaning', 20, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G21', 'Aggregate Fill', 21, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G22', 'Aggregate Level', 22, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G23', 'Tile Cutting', 23, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G24', 'Tile Install', 24, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G25', 'Curing', 25, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G26', 'Grouting', 26, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G27', 'Post - Cleaning', 27, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G28', 'Hall', 28, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G29', 'Pre - Cleaning', 29, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G30', 'Aggregate Fill', 30, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G31', 'Aggregate Level', 31, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G32', 'Tile Cutting', 32, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G33', 'Tile Install', 33, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G34', 'Curing', 34, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G35', 'Grouting', 35, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G36', 'Post - Cleaning', 36, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G37', 'Hall Balcony', 37, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G38', 'Pre - Cleaning', 38, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G39', 'Aggregate Fill', 39, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G40', 'Aggregate Level', 40, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G41', 'Tile Cutting', 41, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G42', 'Tile Install', 42, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G43', 'Curing', 43, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G44', 'Grouting', 44, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G45', 'Post - Cleaning', 45, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G46', 'Kitchen', 46, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G47', 'Pre - Cleaning', 47, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G48', 'Aggregate Fill', 48, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G49', 'Aggregate Level', 49, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G50', 'Kitchen Counter Framing', 50, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G51', 'Kitchen Counter Sink Fitting', 51, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G52', 'Tile Cutting', 52, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G53', 'Tile Install', 53, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G54', 'Curing', 54, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G55', 'Grouting', 55, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G56', 'Post-Cleaning', 56, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G57', 'Common Toilet', 57, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G58', 'Pre - Cleaning', 58, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G59', 'Aggregate Fill', 59, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G60', 'Aggregate Level', 60, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G61', 'Tile Cutting', 61, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G62', 'Tile Install', 62, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G63', 'Curing', 63, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G64', 'Grouting', 64, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G65', 'Post-Cleaning', 65, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G66', 'Passage', 66, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G67', 'Pre - Cleaning', 67, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G68', 'Aggregate Fill', 68, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G69', 'Aggregate Level', 69, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G70', 'Tile Cutting', 70, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G71', 'Tile Install', 71, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G72', 'Curing', 72, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G73', 'Grouting', 73, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G74', 'Post - Cleaning', 74, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G75', 'Child''s Bedroom', 75, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G76', 'Pre - Cleaning', 76, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G77', 'Aggregate Fill', 77, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G78', 'Aggregate Level', 78, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G79', 'Tile Cutting', 79, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G80', 'Tile Install', 80, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G81', 'Curing', 81, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G82', 'Grouting', 82, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G83', 'Post-Cleaning', 83, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G84', 'Master Bedroom  - 1', 84, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G85', 'Pre - Cleaning', 85, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G86', 'Aggregate Fill', 86, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G87', 'Aggregate Level', 87, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G88', 'Tile Cutting', 88, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G89', 'Tile Install', 89, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G90', 'Curing', 90, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G91', 'Grouting', 91, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G92', 'Post-Cleaning', 92, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G93', 'Master Toilet - 1', 93, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G94', 'Pre - Cleaning', 94, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G95', 'Aggregate Fill', 95, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G96', 'Aggregate Level', 96, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G97', 'Tile Cutting', 97, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G98', 'Tile Install', 98, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G99', 'Curing', 99, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G100', 'Grouting', 100, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G101', 'Post-Cleaning', 101, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G102', 'Master Bedroom - 2', 102, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G103', 'Pre - Cleaning', 103, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G104', 'Aggregate Fill', 104, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G105', 'Aggregate Level', 105, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G106', 'Tile Cutting', 106, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G107', 'Tile Install', 107, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G108', 'Curing', 108, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G109', 'Grouting', 109, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G110', 'Post-Cleaning', 110, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G111', 'Master Toilet - 2', 111, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G112', 'Pre - Cleaning', 112, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G113', 'Aggregate Fill', 113, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G114', 'Aggregate Level', 114, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G115', 'Tile Cutting', 115, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G116', 'Tile Install', 116, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G117', 'Curing', 117, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G118', 'Grouting', 118, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G119', 'Post - Cleaning', 119, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G120', 'Master Terrace', 120, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G121', 'Pre - Cleaning', 121, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G122', 'Aggregate Fill', 122, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G123', 'Aggregate Level', 123, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G124', 'Tile Cutting', 124, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G125', 'Tile Install', 125, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G126', 'Curing', 126, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G127', 'Grouting', 127, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G128', 'Post - Cleaning', 128, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G129', 'Master Balcony', 129, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G130', 'Pre - Cleaning', 130, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G131', 'Aggregate Fill', 131, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G132', 'Aggregate Level', 132, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G133', 'Tile Cutting', 133, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G134', 'Tile Install', 134, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G135', 'Curing', 135, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G136', 'Grouting', 136, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G1', 'G137', 'Post - Cleaning', 137, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G2', 'G21', 'Guest Toilet', 21, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G2', 'G22', 'Kitchen', 22, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G2', 'G23', 'Common Toilet', 23, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G2', 'G24', 'Passage', 24, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G2', 'G25', 'Master Toilet - 1', 25, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G2', 'G26', 'Master Toilet - 2', 26, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G2', 'G27', 'Grouting', 27, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G2', 'G31', 'Guest Bedroom', 31, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G3', 'G32', 'Guest Toilet', 32, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G3', 'G33', 'Guest Balcony', 33, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G3', 'G34', 'Hall', 34, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G3', 'G35', 'Hall Balcony', 35, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G3', 'G36', 'Kitchen', 36, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G3', 'G37', 'Common Toilet', 37, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G3', 'G38', 'Passage', 38, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G3', 'G39', 'Child''s Bedroom', 39, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G3', 'G40', 'Master Bedroom - 1', 40, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G3', 'G41', 'Master Toilet - 1', 41, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G3', 'G42', 'Master Bedroom - 2', 42, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G3', 'G43', 'Master Toilet - 2', 43, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G3', 'G44', 'Master Terrace', 44, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G4', 'G41', 'Main Door', 41, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G4', 'G42', 'Guest Bedroom', 42, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G4', 'G43', 'Guest Toilet', 43, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G4', 'G44', 'Guest Balcony', 44, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G4', 'G45', 'Hall Balcony', 45, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G4', 'G46', 'Kitchen Window', 46, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G4', 'G47', 'Kitchen Exhaust', 47, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G4', 'G48', 'Kitchen Counter', 48, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G4', 'G49', 'Common Toilet Door', 49, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G4', 'G50', 'Common Toilet Window', 50, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G4', 'G51', 'Common Toilet Basin Counter', 51, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G4', 'G52', 'Child''s Bedroom', 52, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G4', 'G53', 'Child''s Bedroom Window', 53, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G4', 'G54', 'Master Bedroom - 1 Door', 54, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G4', 'G55', 'Master Bedroom - 1 Window', 55, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G4', 'G56', 'Master Toilet - 1 Door', 56, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G4', 'G57', 'Master Toilet - 1 Window', 57, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G4', 'G58', 'Master Toilet  - 1 Basin Counter', 58, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G4', 'G59', 'Master Bedroom - 2 Door', 59, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G4', 'G60', 'Master Bedroom - 2 Window', 60, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G4', 'G61', 'Master Toilet - 2 Door', 61, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G4', 'G62', 'Master Toilet - 2 Window', 62, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G4', 'G63', 'Master Toilet  - 2 Basin Counter', 63, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G4', 'G64', 'Master Bedroom Terrace Window', 64, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('G4', 'G65', 'Grouting', 65, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H1', 'H1', 'Pre - Cleaning', 1, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H1', 'H2', 'Main Door', 2, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H1', 'H3', 'Guest Bedroom', 3, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H1', 'H4', 'Guest Toilet', 4, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H1', 'H5', 'Common Toilet', 5, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H1', 'H6', 'Child''s Bedroom ', 6, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H1', 'H7', 'Master Bedroom - 1', 7, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H1', 'H8', 'Master Toilet - 1', 8, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H1', 'H9', 'Master Bedroom - 2', 9, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H1', 'H10', 'Master Toilet - 2', 10, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H1', 'H11', 'Post-Cleaning', 11, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H2', 'H21', 'Pre - Cleaning', 21, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H2', 'H22', 'Main Door', 22, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H2', 'H23', 'Guest Bedroom', 23, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H2', 'H24', 'Guest Toilet', 24, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H2', 'H25', 'Common Toilet', 25, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H2', 'H26', 'Child''s Bedroom ', 26, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H2', 'H27', 'Master Bedroom - 1', 27, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H2', 'H28', 'Master Toilet - 1', 28, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H2', 'H29', 'Master Bedroom - 2', 29, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H2', 'H30', 'Master Toilet - 2', 30, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H2', 'H31', 'Post-Cleaning', 31, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H3', 'H32', 'Pre - Cleaning', 32, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H3', 'H33', 'Guest Bedroom', 33, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H3', 'H34', 'Hall Balcony', 34, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H3', 'H35', 'Kitchen Window', 35, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H3', 'H36', 'Common Toilet', 36, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H3', 'H37', 'Child''s Bedroom', 37, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H3', 'H38', 'Master Bedroom - 1', 38, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H3', 'H39', 'Master Toilet - 1', 39, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H3', 'H40', 'Master Bedroom - 2', 40, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H3', 'H41', 'Master Toilet - 2', 41, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H3', 'H42', 'Post-Cleaning', 42, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H4', 'H43', 'Pre - Cleaning', 43, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H4', 'H44', 'Guest Bedroom', 44, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H4', 'H45', 'Hall Balcony', 45, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H4', 'H46', 'Kitchen Window', 46, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H4', 'H47', 'Common Toilet', 47, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H4', 'H48', 'Child''s Bedroom', 48, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H4', 'H49', 'Master Bedroom - 1', 49, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H4', 'H50', 'Master Toilet - 1', 50, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H4', 'H51', 'Master Bedroom - 2', 51, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H4', 'H52', 'Master Toilet - 2', 52, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('H4', 'H53', 'Post - Cleaning', 53, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I1', 'Kitchen', 1, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I2', 'Pre - Cleaning', 2, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I3', 'Kitchen Basin', 3, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I4', 'Kitchen Water Fitting', 4, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I5', 'Washing Machine Fitting', 5, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I6', 'Post - Cleaning', 6, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I7', 'Guest Toilet', 7, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I8', 'Pre - Cleaning', 8, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I9', 'Wash Basin', 9, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I10', 'Wash Basin Tap', 10, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I11', 'Shower Handles Cold/Hot', 11, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I12', 'Shower Head', 12, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I13', 'Diverter', 13, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I14', 'WC Flush Tank', 14, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I15', 'WC Installation', 15, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I16', 'WC Ledge Wall', 16, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I17', 'Post-Cleaning', 17, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I18', 'Common Toilet', 18, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I19', 'Pre - Cleaning', 19, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I20', 'Wash Basin', 20, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I21', 'Wash Basin Tap', 21, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I22', 'Shower Handles Cold/Hot', 22, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I23', 'Shower Head', 23, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I24', 'Diverter', 24, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I25', 'WC Flush Tank', 25, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I26', 'WC / Pan Installation', 26, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I27', 'WC Ledge Wall', 27, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I28', 'Post - Cleaning', 28, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I29', 'Master Toilet - 1', 29, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I30', 'Pre - Cleaning', 30, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I31', 'Wash Basin', 31, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I32', 'Wash Basin Tap', 32, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I33', 'Shower Handles Cold/Hot', 33, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I34', 'Shower Head', 34, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I35', 'Diverter', 35, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I36', 'WC Flush Tank', 36, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I37', 'WC / Pan Installation', 37, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I38', 'WC Ledge Wall', 38, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I39', 'Post-Cleaning', 39, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I40', 'Master Toilet - 2', 40, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I41', 'Pre - Cleaning', 41, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I42', 'Wash Basin', 42, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I43', 'Wash Basin Tap', 43, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I44', 'Shower Handles Cold/Hot', 44, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I45', 'Shower Head', 45, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I46', 'Diverter', 46, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I47', 'WC Flush Tank', 47, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I48', 'WC / Pan Installation', 48, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I49', 'WC Ledge Wall', 49, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('I', 'I50', 'Post-Cleaning', 50, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('J', 'J1', 'Hall', 1, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('J', 'J2', 'Guest Bedroom', 2, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('J', 'J3', 'Guest Toilet', 3, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('J', 'J4', 'Kitchen ', 4, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('J', 'J5', 'MCB', 5, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('J', 'J6', 'Common Toilet', 6, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('J', 'J7', 'Child''s Bedroom', 7, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('J', 'J8', 'Master Bedroom - 1', 8, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('J', 'J9', 'Master Toilet - 1', 9, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('J', 'J10', 'Master Bedroom - 2', 10, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('J', 'J11', 'Master Toilet - 2', 11, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('K', 'K1', 'Plaster Touchup & Putty', 1, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('K', 'K2', 'Sanding', 2, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('K', 'K3', 'Putty Touchup', 3, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('K', 'K4', 'Sanding', 4, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('K', 'K5', 'First Coat Paint', 5, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('K', 'K6', 'Final Coat Paint', 6, TRUE);
INSERT INTO subtask_master (task_code, subtask_code, subtask_name, `order`, is_active) VALUES ('L', 'L1', 'Final Cleaning', 1, TRUE);




DELETE FROM subtask_master;
set foreign_key_checks = 0;
set foreign_key_checks = 1;

truncate table subtask_master;
SELECT * FROM subtask_master;