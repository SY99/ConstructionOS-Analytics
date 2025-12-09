/* The goal of this sql is to populate the contractors, projects, wings, and progress_status*/

USE ConstructionOS;

SHOW CREATE TABLE progress_status;
SHOW CREATE TABLE contractors;
SHOW CREATE TABLE projects;
SHOW CREATE TABLE wings;
SHOW CREATE TABLE departments;
SHOW CREATE TABLE floors;
SHOW CREATE TABLE flats;
SHOW CREATE TABLE users;


SELECT * FROM progress_status;
SELECT * FROM contractors;
SELECT * FROM projects;
SELECT * FROM wings;
SELECT * FROM departments;
SELECT * FROM floors;
SELECT * FROM flats;
Select * from users;

select 
	us.user_id,
	us.first_name, 
    us.last_name, 
    us.role,
	dp.department_id, 
    dp.department_name
		from departments as dp 
			join users as us
				ON dp.department_id = us.DEPARTMENT_ID;


-- =========================================================
-- Insert: progress_status master data
-- Purpose: Predefined progress stages used in all UI dropdowns
-- and in progress_tracking table.
-- =========================================================

INSERT INTO progress_status (status_key, display_label, percentage, is_active)
VALUES
    ('not_started',        'Not Started',         0,    1),
    ('initiated',          'Initiated',           10,   1),
    ('in_progress_low',    'In Progress (Low)',   25,   1),
    ('in_progress_mid',    'In Progress (Mid)',   40,   1),
    ('in_progress_high',   'In Progress (High)',  60,   1),
    ('near_completion',    'Near Completion',     80,   1),
    ('final_review',       'Final Review',        90,   1),
    ('completed',          'Completed',           100,  1);



-- Populating Data for Contractors table
INSERT INTO contractors 
(contractor_name, contact_person, phone, email, address, gst_number, pan_number, contractor_category, status, is_active)
VALUES
-- 1. Masonry / Brickwork Contractor
('Shree Brickwork Solutions', 'Ramesh Gupta', '9876543210', 'ramesh.brickwork@example.com', 'Pune, Maharashtra', '27ABCDE1234F1Z5', 'ABCDE1234F', 'Masonry / Brickwork', 'Active', 1),
-- 2. Plaster Contractor
('Perfect Plaster Works', 'Mahesh Patil', '9087654321', 'mahesh.plaster@example.com', 'Pune, Maharashtra', '27FGHIJ5678K2Z6', 'FGHIJ5678K', 'Plaster', 'Active', 1),
-- 3. POP Contractor
('Interior POP Experts', 'Amit Sharma', '9898989898', 'amit.pop@example.com', 'Mumbai, Maharashtra', '27KLMNO9876P3Z7', 'KLMNO9876P', 'POP / Gypsum', 'Active', 1),
-- 4. Electrical Contractor
('Sai Electricals', 'Suresh Yadav', '9012345678', 'suresh.elec@example.com', 'Pune, Maharashtra', '27PQRS1234T4Z8', 'PQRS1234T', 'Electrical Work', 'Active', 1),
-- 5. Plumbing Contractor
('Omkar Plumbing Services', 'Nikhil Pawar', '9123456780', 'nikhil.plumb@example.com', 'Nashik, Maharashtra', '27UVWX4321Y5Z9', 'UVWX4321Y', 'Plumbing Work', 'Active', 1),
-- 6. Waterproofing Contractor
('AquaSeal Waterproofing', 'Deepak Jadhav', '9345678901', 'deepak.wproof@example.com', 'Thane, Maharashtra', '27MNOPQ1234R6Z1', 'MNOPQ1234R', 'Waterproofing', 'Active', 1),
-- 7. Tiling Contractor
('TileCraft Services', 'Pravin More', '9456789012', 'pravin.tile@example.com', 'Kolhapur, Maharashtra', '27STUVW5678X7Z2', 'STUVW5678X', 'Tiling', 'Active', 1),
-- 8. Granite / Marble Contractor
('Marble & Granite Hub', 'Rohit Verma', '9567890123', 'rohit.granite@example.com', 'Mumbai, Maharashtra', '27YZABC6789D8Z3', 'YZABC6789D', 'Granite / Marble', 'Active', 1),
-- 9. RCC Contractor
('StrongBuild RCC Contractors', 'Vikas Deshmukh', '9678901234', 'vikas.rcc@example.com', 'Pune, Maharashtra', '27EFGHI9876J9Z4', 'EFGHI9876J', 'RCC / Structural Work', 'Active', 1),
-- 10. Doors & Windows (Aluminium / Wood)
('Prime Door & Window Systems', 'Rajesh Shetty', '9789012345', 'rajesh.doors@example.com', 'Pune, Maharashtra', '27JKLMN5432O1Z5', 'JKLMN5432O', 'Doors & Windows', 'Active', 1),
-- 11. Painting Contractor
('ColorWorks Painting Co.', 'Anil Mane', '9890123456', 'anil.paint@example.com', 'Pune, Maharashtra', '27PQRST8765U2Z6', 'PQRST8765U', 'Painting & Touchup', 'Active', 1);

INSERT INTO users 
(first_name, last_name, username, password_hash, email, phone, role, department, status, access_level)
VALUES ('Rahul', 'Deshmukh', 'rahul.deshmukh', 'hash_12345', 'rahul.deshmukh@example.com', '9876543210', 'Project Manager', 'Projects', 'Active', 'Admin');

INSERT INTO projects (
    project_name,
    project_code,
    survey_no,
    rera_number,
    location,
    developer_name,
    total_area_sqm,
    start_date,
    completion_date,
    current_status,
    description,
    created_by
)
VALUES (
    'The Ark: Origin',
    'PRJ-001',
    'CTS No. 4527/7A',
    'P51700099999',
    'Mulund West, Mumbai, Maharashtra',
    'House of Ark',
    12000.00,                 -- approx total carpet + saleable area
    '2023-10-06',
    '2025-11-05',
    'Ongoing',
    'Flagship residential development by House of Ark. Premium lifestyle-focused project.',
    1
);

DELETE FROM PROJECTS WHERE PROJECT_CODE = "PRJ-002";
ALTER TABLE projects AUTO_INCREMENT = 1;
SELECT * FROM projects;


/* POPULATING THE WINGS TABLE */
INSERT INTO wings (
    project_id,
    wing_name,
    total_floors,
    total_flats,
    start_date,
    completion_date,
    construction_status,
    remarks,
    is_active,
    created_at,
    updated_at
) VALUES
(
    1,
    'Tower A',
    45,
    82, 
    '2023-10-06',
    '2025-11-05',
    'Ongoing',
    'Flagship luxury residential tower with 2 flats per floor and 4 penthouses.',
    1,
    '2023-10-06',
    '2025-11-10'
);

UPDATE WINGS
	SET TOTAL_FLATS = 86
	WHERE WING_ID = 1;


-- =========================================================
-- FLOOR INSERTS FOR TOWER A (45 FLOORS)
-- =========================================================

INSERT INTO floors (wing_id, total_flats, construction_stage, progress_status, start_date, completion_date, remarks, is_active, created_at, updated_at)
VALUES
-- Floors 1–41 (2 flats each)
(1, 2, 'Structure Complete', 'In Progress', '2023-10-06', '2024-06-15', 'Standard residential floor', 1, '2023-10-06', '2024-08-10'),
(1, 2, 'Structure Complete', 'In Progress', '2023-10-06', '2024-06-20', 'Standard residential floor', 1, '2023-10-06', '2024-08-10'),
(1, 2, 'Structure Complete', 'In Progress', '2023-10-06', '2024-06-30', 'Standard residential floor', 1, '2023-10-06', '2024-08-15'),
(1, 2, 'Structure Complete', 'In Progress', '2023-10-06', '2024-07-05', 'Standard residential floor', 1, '2023-10-06', '2024-08-15'),
(1, 2, 'Structure Complete', 'In Progress', '2023-10-06', '2024-07-10', 'Standard residential floor', 1, '2023-10-06', '2024-08-20')
-- NOTE: Bro, to keep message size manageable,
-- I will generate floors 6–41 in the next message block,
-- then penthouses 42–45.
;

ALTER TABLE FLOORS ADD COLUMN floor_number VARCHAR(150) NOT NULL AFTER WING_ID;


-- INSERT INTO floors (wing_id, floor_number, total_flats, construction_stage, progress_status, start_date, completion_date, remarks, created_at, updated_at, is_active)
-- VALUES
-- -- Basements
-- (1, 'Basement-3', 0, 'Structural Complete', 'Completed', '2023-01-10', '2023-03-10', 'Basement 3 completed.', '2023-01-10 08:30:00', '2023-03-11 10:12:00', TRUE),
-- (1, 'Basement-2', 0, 'Structural Complete', 'Completed', '2023-02-01', '2023-04-01', 'Basement 2 completed.', '2023-02-01 09:00:00', '2023-04-02 11:40:00', TRUE),
-- (1, 'Basement-1', 0, 'Structural Complete', 'Completed', '2023-03-01', '2023-05-01', 'Basement 1 completed.', '2023-03-01 09:15:00', '2023-05-02 12:50:00', TRUE),

-- -- Podiums
-- (1, 'Podium-2', 0, 'Finishing', 'Almost Done', '2023-05-15', '2023-08-10', 'Podium 2 nearing completion.', '2023-05-15 10:00:00', '2023-08-09 15:20:00', TRUE),
-- (1, 'Podium-1', 0, 'Finishing', 'Completed', '2023-06-10', '2023-09-20', 'Podium 1 completed.', '2023-06-10 10:15:00', '2023-09-21 14:10:00', TRUE),

-- -- Ground
-- (1, 'Ground', 0, 'Finishing', 'Completed', '2023-07-01', '2023-10-15', 'Ground floor works completed.', '2023-07-01 11:00:00', '2023-10-16 16:20:00', TRUE),

-- -- Residential Floors 1–10 (Completed)
-- (1, 'Floor-1', 2, 'Completed', 'Completed', '2023-08-01', '2023-11-20', 'Floor completed.', '2023-08-01 09:00:00', '2023-11-21 13:00:00', TRUE),
-- (1, 'Floor-2', 2, 'Completed', 'Completed', '2023-08-20', '2023-12-05', 'Floor completed.', '2023-08-20 09:00:00', '2023-12-06 12:40:00', TRUE),
-- (1, 'Floor-3', 2, 'Completed', 'Completed', '2023-09-05', '2023-12-18', 'Floor completed.', '2023-09-05 09:30:00', '2023-12-19 15:30:00', TRUE),
-- (1, 'Floor-4', 2, 'Completed', 'Completed', '2023-09-25', '2024-01-05', 'Floor completed.', '2023-09-25 10:10:00', '2024-01-06 11:15:00', TRUE),
-- (1, 'Floor-5', 2, 'Completed', 'Completed', '2023-10-10', '2024-01-20', 'Floor completed.', '2023-10-10 10:45:00', '2024-01-21 14:22:00', TRUE),
-- (1, 'Floor-6', 2, 'Completed', 'Completed', '2023-10-25', '2024-02-05', 'Floor completed.', '2023-10-25 11:10:00', '2024-02-06 16:35:00', TRUE),
-- (1, 'Floor-7', 2, 'Completed', 'Completed', '2023-11-10', '2024-02-22', 'Floor completed.', '2023-11-10 08:50:00', '2024-02-23 12:00:00', TRUE),
-- (1, 'Floor-8', 2, 'Completed', 'Completed', '2023-11-25', '2024-03-10', 'Floor completed.', '2023-11-25 09:40:00', '2024-03-11 11:45:00', TRUE),
-- (1, 'Floor-9', 2, 'Completed', 'Completed', '2023-12-10', '2024-03-25', 'Floor completed.', '2023-12-10 10:20:00', '2024-03-26 14:55:00', TRUE),
-- (1, 'Floor-10', 2, 'Completed', 'Completed', '2023-12-28', '2024-04-15', 'Floor completed.', '2023-12-28 10:55:00', '2024-04-16 15:30:00', TRUE),

-- -- Floors 11–20 (Mid Progress)
-- (1, 'Floor-11', 2, 'Finishing', 'Almost Done', '2024-01-10', '2024-05-01', 'Finishing stage.', '2024-01-10 09:20:00', '2024-05-02 12:00:00', TRUE),
-- (1, 'Floor-12', 2, 'Finishing', 'In Progress', '2024-01-20', '2024-05-10', 'Finishing stage.', '2024-01-20 09:30:00', '2024-05-11 13:00:00', TRUE),
-- (1, 'Floor-13', 2, 'Plaster Work', 'In Progress', '2024-02-01', '2024-05-25', 'Plaster running.', '2024-02-01 10:00:00', '2024-05-26 11:00:00', TRUE),
-- (1, 'Floor-14', 2, 'Plaster Work', 'Started', '2024-02-15', '2024-06-10', 'Plaster started.', '2024-02-15 10:30:00', '2024-06-11 12:20:00', TRUE),
-- (1, 'Floor-15', 2, 'Electrical Conduits', 'Started', '2024-03-01', '2024-06-25', 'Electrical conduits stage.', '2024-03-01 11:00:00', '2024-06-26 13:40:00', TRUE),
-- (1, 'Floor-16', 2, 'Electrical Conduits', 'In Progress', '2024-03-12', '2024-07-05', 'Electrical work ongoing.', '2024-03-12 09:10:00', '2024-07-06 14:45:00', TRUE),
-- (1, 'Floor-17', 2, 'Brick Work', 'In Progress', '2024-03-25', '2024-07-20', 'Brick masonry ongoing.', '2024-03-25 09:40:00', '2024-07-21 15:00:00', TRUE),
-- (1, 'Floor-18', 2, 'Brick Work', 'Started', '2024-04-05', '2024-08-01', 'Brick work started.', '2024-04-05 10:15:00', '2024-08-02 16:10:00', TRUE),
-- (1, 'Floor-19', 2, 'Slab Cured', 'Midway', '2024-04-20', '2024-08-15', 'Slab cured.', '2024-04-20 11:25:00', '2024-08-16 12:10:00', TRUE),
-- (1, 'Floor-20', 2, 'Slab Cured', 'Midway', '2024-05-05', '2024-08-28', 'Slab curing done.', '2024-05-05 09:55:00', '2024-08-29 13:45:00', TRUE),

-- -- Floors 21–31 (Early Structural Work)
-- (1, 'Floor-21', 2, 'Slab Cast', 'Started', '2024-05-20', '2024-09-12', 'Slab cast recently.', '2024-05-20 10:10:00', '2024-09-13 12:15:00', TRUE),
-- (1, 'Floor-22', 2, 'Slab Cast', 'Started', '2024-06-01', '2024-09-28', 'Slab cast.', '2024-06-01 09:20:00', '2024-09-29 13:00:00', TRUE),
-- (1, 'Floor-23', 2, 'Formwork', 'In Progress', '2024-06-12', '2024-10-10', 'Formwork ongoing.', '2024-06-12 10:40:00', '2024-10-11 12:30:00', TRUE),
-- (1, 'Floor-24', 2, 'Formwork', 'In Progress', '2024-06-25', '2024-10-25', 'Formwork.', '2024-06-25 10:00:00', '2024-10-26 13:20:00', TRUE),
-- (1, 'Floor-25', 2, 'Column Reinforcement', 'Started', '2024-07-05', '2024-11-10', 'Column bars placing.', '2024-07-05 09:15:00', '2024-11-11 15:00:00', TRUE),
-- (1, 'Floor-26', 2, 'Column Reinforcement', 'In Progress', '2024-07-20', '2024-11-25', 'Reinforcement ongoing.', '2024-07-20 10:50:00', '2024-11-26 14:50:00', TRUE),
-- (1, 'Floor-27', 2, 'Formwork Prep', 'Started', '2024-08-02', '2024-12-10', 'Formwork prep.', '2024-08-02 10:30:00', '2024-12-11 16:15:00', TRUE),
-- (1, 'Floor-28', 2, 'Formwork Prep', 'Started', '2024-08-18', '2024-12-28', 'Formwork prep.', '2024-08-18 11:00:00', '2024-12-29 12:40:00', TRUE),
-- (1, 'Floor-29', 2, 'Material Staging', 'Not Started', '2024-09-01', NULL, 'Materials yet to arrive.', '2024-09-01 09:30:00', '2024-09-01 09:30:00', TRUE),
-- (1, 'Floor-30', 2, 'Material Staging', 'Not Started', '2024-09-10', NULL, 'Pending.', '2024-09-10 10:20:00', '2024-09-10 10:20:00', TRUE),
-- (1, 'Floor-31', 2, 'Layout Marking', 'Not Started', '2024-09-25', NULL, 'Pending.', '2024-09-25 11:00:00', '2024-09-25 11:00:00', TRUE),

-- -- Floors 32–41 (Not Started as per instruction)
-- (1, 'Floor-32', 2, 'Not Started', 'Not Started', NULL, NULL, 'No work initiated yet.', NOW(), NOW(), TRUE),
-- (1, 'Floor-33', 2, 'Not Started', 'Not Started', NULL, NULL, 'No work initiated yet.', NOW(), NOW(), TRUE),
-- (1, 'Floor-34', 2, 'Not Started', 'Not Started', NULL, NULL, 'No work initiated yet.', NOW(), NOW(), TRUE),
-- (1, 'Floor-35', 2, 'Not Started', 'Not Started', NULL, NULL, 'No work initiated yet.', NOW(), NOW(), TRUE),
-- (1, 'Floor-36', 2, 'Not Started', 'Not Started', NULL, NULL, 'No work initiated yet.', NOW(), NOW(), TRUE),
-- (1, 'Floor-37', 2, 'Not Started', 'Not Started', NULL, NULL, 'No work yet.', NOW(), NOW(), TRUE),
-- (1, 'Floor-38', 2, 'Not Started', 'Not Started', NULL, NULL, 'Pending start.', NOW(), NOW(), TRUE),
-- (1, 'Floor-39', 2, 'Not Started', 'Not Started', NULL, NULL, 'Pending start.', NOW(), NOW(), TRUE),
-- (1, 'Floor-40', 2, 'Not Started', 'Not Started', NULL, NULL, 'Pending start.', NOW(), NOW(), TRUE),
-- (1, 'Floor-41', 2, 'Not Started', 'Not Started', NULL, NULL, 'Pending start.', NOW(), NOW(), TRUE),

-- -- Penthouses 42–45
-- (1, 'Penthouse-42', 2, 'Design Stage', 'Not Started', NULL, NULL, 'Interior design pending.', NOW(), NOW(), TRUE),
-- (1, 'Penthouse-43', 2, 'Design Stage', 'Not Started', NULL, NULL, 'High-end customization.', NOW(), NOW(), TRUE),
-- (1, 'Penthouse-44', 2, 'Design Stage', 'Not Started', NULL, NULL, 'Awaiting premium materials.', NOW(), NOW(), TRUE),
-- (1, 'Penthouse-45', 2, 'Design Stage', 'Not Started', NULL, NULL, 'Top floor penthouse.', NOW(), NOW(), TRUE);




-- INSERT INTO flats (floor_id, flat_number, flat_type, unit_type, carpet_area, builtup_area, status, owner_name, sale_date, remarks, is_active)
-- VALUES
-- -- ===========================
-- -- FLOORS 1–10 (Completed)
-- -- ===========================

-- -- Floor 1 (floor_id=7)
-- (7, 'A101', '5BHK', 'Luxury', 4750, 5937.50, 'Sold', 'Aarav Malhotra', '2024-02-14', 'Completed / Sea Facing Unit', 1),
-- (7, 'A102', '5BHK', 'Luxury', 4750, 5937.50, 'Sold', 'Riya Fernandes', '2024-05-10', 'Completed', 1),

-- -- Floor 2 (id=8)
-- (8, 'A201', '5BHK', 'Luxury', 4750, 5937.50, 'Sold', 'Vikram Patel', '2024-01-22', 'Completed / Sea Facing Unit', 1),
-- (8, 'A202', '5BHK', 'Luxury', 4750, 5937.50, 'Sold', 'Sneha Arora', '2024-03-08', 'Completed', 1),

-- -- Floor 3 (id=9)
-- (9, 'A301', '5BHK', 'Luxury', 4750, 5937.50, 'Sold', 'Farhan Daruwala', '2024-07-18', 'Completed / Sea Facing Unit', 1),
-- (9, 'A302', '5BHK', 'Luxury', 4750, 5937.50, 'Sold', 'Elina Varghese', '2024-08-02', 'Completed', 1),

-- -- Floor 4 (10)
-- (10, 'A401', '5BHK', 'Luxury', 4750, 5937.50, 'Sold', 'Daniel D’Souza', '2023-11-22', 'Completed / Sea Facing Unit', 1),
-- (10, 'A402', '5BHK', 'Luxury', 4750, 5937.50, 'Available', NULL, NULL, 'Completed', 1),

-- -- Floor 5 (11)
-- (11, 'A501', '5BHK', 'Luxury', 4750, 5937.50, 'Sold', 'Kunal Shah', '2024-09-17', 'Completed / Sea Facing Unit', 1),
-- (11, 'A502', '5BHK', 'Luxury', 4750, 5937.50, 'Available', NULL, NULL, 'Completed', 1),

-- -- Floor 6 (12)
-- (12, 'A601', '5BHK', 'Luxury', 4750, 5937.50, 'Sold', 'Sarah Joseph', '2023-12-11', 'Completed / Sea Facing Unit', 1),
-- (12, 'A602', '5BHK', 'Luxury', 4750, 5937.50, 'Sold', 'Manoj Reddy', '2024-04-02', 'Completed', 1),

-- -- Floor 7 (13)
-- (13, 'A701', '5BHK', 'Luxury', 4750, 5937.50, 'Sold', 'Anisha Kapoor', '2025-01-19', 'Completed / Sea Facing Unit', 1),
-- (13, 'A702', '5BHK', 'Luxury', 4750, 5937.50, 'Available', NULL, NULL, 'Completed', 1),

-- -- Floor 8 (14)
-- (14, 'A801', '5BHK', 'Luxury', 4750, 5937.50, 'Sold', 'Rohan Mehta', '2024-06-20', 'Completed / Sea Facing Unit', 1),
-- (14, 'A802', '5BHK', 'Luxury', 4750, 5937.50, 'Sold', 'Zoya Siddiqui', '2024-10-11', 'Completed', 1),

-- -- Floor 9 (15)
-- (15, 'A901', '5BHK', 'Luxury', 4750, 5937.50, 'Sold', 'Kabir Khanna', '2024-12-09', 'Completed / Sea Facing Unit', 1),
-- (15, 'A902', '5BHK', 'Luxury', 4750, 5937.50, 'Available', NULL, NULL, 'Completed', 1),

-- -- Floor 10 (16)
-- (16, 'A1001', '5BHK', 'Luxury', 4750, 5937.50, 'Sold', 'Devanshi Merchant', '2023-10-14', 'Completed / Sea Facing Unit', 1),
-- (16, 'A1002', '5BHK', 'Luxury', 4750, 5937.50, 'Sold', 'Aman Chopra', '2024-01-04', 'Completed', 1),


-- -- ===========================
-- -- FLOORS 11–25 (Finishing)
-- -- ===========================

-- -- I will now compress formatting to save space while maintaining correctness.

-- -- Floors 11–25 auto pattern:
-- -- For each floor:
-- -- 01 → Sea Facing, higher chance SOLD
-- -- 02 → Mixed
-- -- status → "Finishing Stage"

-- -- Floor 11 (17)
-- (17,'A1101','5BHK','Luxury',4750,5937.50,'Sold','Arman Parikh','2024-06-02','Finishing Stage / Sea Facing',1),
-- (17,'A1102','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Finishing Stage',1),

-- (18,'A1201','5BHK','Luxury',4750,5937.50,'Sold','Neha Chatterjee','2024-09-22','Finishing Stage / Sea Facing',1),
-- (18,'A1202','5BHK','Luxury',4750,5937.50,'Sold','Rahul Bhatia','2024-08-12','Finishing Stage',1),

-- (19,'A1301','5BHK','Luxury',4750,5937.50,'Sold','Imran Qureshi','2024-03-14','Finishing Stage / Sea Facing',1),
-- (19,'A1302','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Finishing Stage',1),

-- (20,'A1401','5BHK','Luxury',4750,5937.50,'Sold','Sana Lobo','2024-06-30','Finishing Stage / Sea Facing',1),
-- (20,'A1402','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Finishing Stage',1),

-- (21,'A1501','5BHK','Luxury',4750,5937.50,'Sold','Nikhil Suri','2024-11-04','Finishing Stage / Sea Facing',1),
-- (21,'A1502','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Finishing Stage',1),

-- (22,'A1601','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Finishing Stage / Sea Facing',1),
-- (22,'A1602','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Finishing Stage',1),

-- (23,'A1701','5BHK','Luxury',4750,5937.50,'Sold','Vishal Shetty','2024-04-25','Finishing Stage / Sea Facing',1),
-- (23,'A1702','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Finishing Stage',1),

-- (24,'A1801','5BHK','Luxury',4750,5937.50,'Sold','Harleen Gill','2025-02-11','Finishing Stage / Sea Facing',1),
-- (24,'A1802','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Finishing Stage',1),

-- (25,'A1901','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Finishing Stage / Sea Facing',1),
-- (25,'A1902','5BHK','Luxury',4750,5937.50,'Sold','Samuel Dsouza','2024-07-14','Finishing Stage',1),

-- -- ===========================
-- -- FLOORS 26–41 (Ongoing Work)
-- -- ===========================

-- -- Only a few sold here, most available

-- (26,'A2001','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Ongoing Work / Sea Facing',1),
-- (26,'A2002','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Ongoing Work',1),

-- (27,'A2101','5BHK','Luxury',4750,5937.50,'Sold','Rehan Contractor','2025-01-11','Ongoing Work / Sea Facing',1),
-- (27,'A2102','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Ongoing Work',1),

-- (28,'A2201','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Ongoing Work / Sea Facing',1),
-- (28,'A2202','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Ongoing Work',1),

-- (29,'A2301','5BHK','Luxury',4750,5937.50,'Sold','Ananya Singh','2024-09-04','Ongoing Work / Sea Facing',1),
-- (29,'A2302','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Ongoing Work',1),

-- (30,'A2401','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Ongoing Work / Sea Facing',1),
-- (30,'A2402','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Ongoing Work',1),

-- (31,'A2501','5BHK','Luxury',4750,5937.50,'Sold','Yusuf Bharucha','2025-03-02','Ongoing Work / Sea Facing',1),
-- (31,'A2502','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Ongoing Work',1),

-- (32,'A2601','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Ongoing Work / Sea Facing',1),
-- (32,'A2602','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Ongoing Work',1),

-- (33,'A2701','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Ongoing Work / Sea Facing',1),
-- (33,'A2702','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Ongoing Work',1),

-- (34,'A2801','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Ongoing Work / Sea Facing',1),
-- (34,'A2802','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Ongoing Work',1),

-- (35,'A2901','5BHK','Luxury',4750,5937.50,'Sold','Zara Malkani','2025-02-23','Ongoing Work / Sea Facing',1),
-- (35,'A2902','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Ongoing Work',1),

-- (36,'A3001','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Ongoing Work / Sea Facing',1),
-- (36,'A3002','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Ongoing Work',1),

-- (37,'A3101','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Ongoing Work / Sea Facing',1),
-- (37,'A3102','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Ongoing Work',1),

-- (38,'A3201','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Ongoing Work / Sea Facing',1),
-- (38,'A3202','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Ongoing Work',1),

-- (39,'A3301','5BHK','Luxury',4750,5937.50,'Sold','Krish Oberoi','2024-11-18','Ongoing Work / Sea Facing',1),
-- (39,'A3302','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Ongoing Work',1),

-- (40,'A3401','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Ongoing Work / Sea Facing',1),
-- (40,'A3402','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Ongoing Work',1),

-- (41,'A3501','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Ongoing Work / Sea Facing',1),
-- (41,'A3502','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Ongoing Work',1),

-- (42,'A3601','5BHK','Luxury',4750,5937.50,'Sold','Nikita Bansal','2025-01-27','Ongoing Work / Sea Facing',1),
-- (42,'A3602','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Ongoing Work',1),

-- (43,'A3701','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Ongoing Work / Sea Facing',1),
-- (43,'A3702','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Ongoing Work',1),

-- (44,'A3801','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Ongoing Work / Sea Facing',1),
-- (44,'A3802','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Ongoing Work',1),

-- (45,'A3901','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Ongoing Work / Sea Facing',1),
-- (45,'A3902','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Ongoing Work',1),

-- (46,'A4001','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Ongoing Work / Sea Facing',1),
-- (46,'A4002','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Ongoing Work',1),

-- (47,'A4101','5BHK','Luxury',4750,5937.50,'Sold','Rayhaan Dastur','2024-12-01','Ongoing Work / Sea Facing',1),
-- (47,'A4102','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Ongoing Work',1),


-- -- ===========================
-- -- PENTHOUSES 42–45
-- -- ===========================

-- (48,'APH42','5BHK','Luxury',4750,5937.50,'Sold','Kabir Advani','2025-01-12','Penthouse / Sea Facing / Ultra Luxury',1),
-- (49,'APH43','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Penthouse / Ongoing Work',1),
-- (50,'APH44','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Penthouse / Ongoing Work',1),
-- (51,'APH45','5BHK','Luxury',4750,5937.50,'Available',NULL,NULL,'Penthouse / Ongoing Work',1);


ALTER TABLE flats
DROP COLUMN builtup_area_sqft;

SET SQL_SAFE_UPDATES = 0;
SET SQL_SAFE_UPDATES = 1;

DELETE FROM FLATS;
set foreign_key_checks = 0;
set foreign_key_checks = 1;

SELECT * FROM FLATS;
ALTER TABLE FLATS AUTO_INCREMENT = 1;
truncate table flats;


-- New Populating of Flats Table
INSERT INTO flats (floor_id, flat_number, flat_type, unit_type, carpet_area, builtup_area, status, owner_name, sale_date, remarks, is_active)
VALUES
-- ===========================
-- FLOORS 1–10 (Completed)
-- ===========================

-- Floor 1 (floor_id=7)
(7, 'A101', '5BHK', 'Luxury', 441.29, 529.55, 'Sold', 'Aarav Malhotra', '2024-02-14', 'Completed / Sea Facing Unit', 1),
(7, 'A102', '5BHK', 'Luxury', 441.29, 529.55, 'Sold', 'Riya Fernandes', '2024-05-10', 'Completed', 1),

-- Floor 2 (id=8)
(8, 'A201', '5BHK', 'Luxury', 441.29, 529.55, 'Sold', 'Vikram Patel', '2024-01-22', 'Completed / Sea Facing Unit', 1),
(8, 'A202', '5BHK', 'Luxury', 441.29, 529.55, 'Sold', 'Sneha Arora', '2024-03-08', 'Completed', 1),

-- Floor 3 (id=9)
(9, 'A301', '5BHK', 'Luxury', 441.29, 529.55, 'Sold', 'Farhan Daruwala', '2024-07-18', 'Completed / Sea Facing Unit', 1),
(9, 'A302', '5BHK', 'Luxury', 441.29, 529.55, 'Sold', 'Elina Varghese', '2024-08-02', 'Completed', 1),

-- Floor 4 (10)
(10, 'A401', '5BHK', 'Luxury', 441.29, 529.55, 'Sold', 'Daniel D’Souza', '2023-11-22', 'Completed / Sea Facing Unit', 1),
(10, 'A402', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Completed', 1),

-- Floor 5 (11)
(11, 'A501', '5BHK', 'Luxury', 441.29, 529.55, 'Sold', 'Kunal Shah', '2024-09-17', 'Completed / Sea Facing Unit', 1),
(11, 'A502', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Completed', 1),

-- Floor 6 (12)
(12, 'A601', '5BHK', 'Luxury', 441.29, 529.55, 'Sold', 'Sarah Joseph', '2023-12-11', 'Completed / Sea Facing Unit', 1),
(12, 'A602', '5BHK', 'Luxury', 441.29, 529.55, 'Sold', 'Manoj Reddy', '2024-04-02', 'Completed', 1),

-- Floor 7 (13)
(13, 'A701', '5BHK', 'Luxury', 441.29, 529.55, 'Sold', 'Anisha Kapoor', '2025-01-19', 'Completed / Sea Facing Unit', 1),
(13, 'A702', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Completed', 1),

-- Floor 8 (14)
(14, 'A801', '5BHK', 'Luxury', 441.29, 529.55, 'Sold', 'Rohan Mehta', '2024-06-20', 'Completed / Sea Facing Unit', 1),
(14, 'A802', '5BHK', 'Luxury', 441.29, 529.55, 'Sold', 'Zoya Siddiqui', '2024-10-11', 'Completed', 1),

-- Floor 9 (15)
(15, 'A901', '5BHK', 'Luxury', 441.29, 529.55, 'Sold', 'Kabir Khanna', '2024-12-09', 'Completed / Sea Facing Unit', 1),
(15, 'A902', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Completed', 1),

-- Floor 10 (16)
(16, 'A1001', '5BHK', 'Luxury', 441.29, 529.55, 'Sold', 'Devanshi Merchant', '2023-10-14', 'Completed / Sea Facing Unit', 1),
(16, 'A1002', '5BHK', 'Luxury', 441.29, 529.55, 'Sold', 'Aman Chopra', '2024-01-04', 'Completed', 1),


-- ===========================
-- FLOORS 11–25 (Finishing)
-- ===========================

-- Floor 11 (17)
(17, 'A1101', '5BHK', 'Luxury', 441.29, 529.55, 'Sold', 'Arman Parikh', '2024-06-02', 'Finishing Stage / Sea Facing', 1),
(17, 'A1102', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Finishing Stage', 1),

(18, 'A1201', '5BHK', 'Luxury', 441.29, 529.55, 'Sold', 'Neha Chatterjee', '2024-09-22', 'Finishing Stage / Sea Facing', 1),
(18, 'A1202', '5BHK', 'Luxury', 441.29, 529.55, 'Sold', 'Rahul Bhatia', '2024-08-12', 'Finishing Stage', 1),

(19, 'A1301', '5BHK', 'Luxury', 441.29, 529.55, 'Sold', 'Imran Qureshi', '2024-03-14', 'Finishing Stage / Sea Facing', 1),
(19, 'A1302', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Finishing Stage', 1),

(20, 'A1401', '5BHK', 'Luxury', 441.29, 529.55, 'Sold', 'Sana Lobo', '2024-06-30', 'Finishing Stage / Sea Facing', 1),
(20, 'A1402', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Finishing Stage', 1),

(21, 'A1501', '5BHK', 'Luxury', 441.29, 529.55, 'Sold', 'Nikhil Suri', '2024-11-04', 'Finishing Stage / Sea Facing', 1),
(21, 'A1502', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Finishing Stage', 1),

(22, 'A1601', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Finishing Stage / Sea Facing', 1),
(22, 'A1602', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Finishing Stage', 1),

(23, 'A1701', '5BHK', 'Luxury', 441.29, 529.55, 'Sold', 'Vishal Shetty', '2024-04-25', 'Finishing Stage / Sea Facing', 1),
(23, 'A1702', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Finishing Stage', 1),

(24, 'A1801', '5BHK', 'Luxury', 441.29, 529.55, 'Sold', 'Harleen Gill', '2025-02-11', 'Finishing Stage / Sea Facing', 1),
(24, 'A1802', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Finishing Stage', 1),

(25, 'A1901', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Finishing Stage / Sea Facing', 1),
(25, 'A1902', '5BHK', 'Luxury', 441.29, 529.55, 'Sold', 'Samuel Dsouza', '2024-07-14', 'Finishing Stage', 1),

-- ===========================
-- FLOORS 26–41 (Ongoing Work)
-- ===========================

(26, 'A2001', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Ongoing Work / Sea Facing', 1),
(26, 'A2002', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Ongoing Work', 1),

(27, 'A2101', '5BHK', 'Luxury', 441.29, 529.55, 'Sold', 'Rehan Contractor', '2025-01-11', 'Ongoing Work / Sea Facing', 1),
(27, 'A2102', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Ongoing Work', 1),

(28, 'A2201', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Ongoing Work / Sea Facing', 1),
(28, 'A2202', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Ongoing Work', 1),

(29, 'A2301', '5BHK', 'Luxury', 441.29, 529.55, 'Sold', 'Ananya Singh', '2024-09-04', 'Ongoing Work / Sea Facing', 1),
(29, 'A2302', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Ongoing Work', 1),

(30, 'A2401', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Ongoing Work / Sea Facing', 1),
(30, 'A2402', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Ongoing Work', 1),

(31, 'A2501', '5BHK', 'Luxury', 441.29, 529.55, 'Sold', 'Yusuf Bharucha', '2025-03-02', 'Ongoing Work / Sea Facing', 1),
(31, 'A2502', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Ongoing Work', 1),

(32, 'A2601', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Ongoing Work / Sea Facing', 1),
(32, 'A2602', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Ongoing Work', 1),

(33, 'A2701', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Ongoing Work / Sea Facing', 1),
(33, 'A2702', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Ongoing Work', 1),

(34, 'A2801', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Ongoing Work / Sea Facing', 1),
(34, 'A2802', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Ongoing Work', 1),

(35, 'A2901', '5BHK', 'Luxury', 441.29, 529.55, 'Sold', 'Zara Malkani', '2025-02-23', 'Ongoing Work / Sea Facing', 1),
(35, 'A2902', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Ongoing Work', 1),

(36, 'A3001', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Ongoing Work / Sea Facing', 1),
(36, 'A3002', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Ongoing Work', 1),

(37, 'A3101', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Ongoing Work / Sea Facing', 1),
(37, 'A3102', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Ongoing Work', 1),

(38, 'A3201', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Ongoing Work / Sea Facing', 1),
(38, 'A3202', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Ongoing Work', 1),

(39, 'A3301', '5BHK', 'Luxury', 441.29, 529.55, 'Sold', 'Krish Oberoi', '2024-11-18', 'Ongoing Work / Sea Facing', 1),
(39, 'A3302', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Ongoing Work', 1),

(40, 'A3401', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Ongoing Work / Sea Facing', 1),
(40, 'A3402', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Ongoing Work', 1),

(41, 'A3501', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Ongoing Work', 1),
(41, 'A3502', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Ongoing Work', 1),

(42, 'A3601', '5BHK', 'Luxury', 441.29, 529.55, 'Sold', 'Nikita Bansal', '2025-01-27', 'Ongoing Work / Sea Facing', 1),
(42, 'A3602', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Ongoing Work', 1),

(43, 'A3701', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Ongoing Work / Sea Facing', 1),
(43, 'A3702', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Ongoing Work', 1),

(44, 'A3801', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Ongoing Work / Sea Facing', 1),
(44, 'A3802', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Ongoing Work', 1),

(45, 'A3901', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Ongoing Work / Sea Facing', 1),
(45, 'A3902', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Ongoing Work', 1),

(46, 'A4001', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Ongoing Work / Sea Facing', 1),
(46, 'A4002', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Ongoing Work', 1),

(47, 'A4101', '5BHK', 'Luxury', 441.29, 529.55, 'Sold', 'Rayhaan Dastur', '2024-12-01', 'Ongoing Work / Sea Facing', 1),
(47, 'A4102', '5BHK', 'Luxury', 441.29, 529.55, 'Available', NULL, NULL, 'Ongoing Work', 1),


-- ===========================
-- PENTHOUSES (combined areas)
-- ===========================

(48, 'APH42', 'Penthouse', 'Sky Villa', 882.58, 1059.09, 'Sold', 'Kabir Advani', '2025-01-12', 'Penthouse / Sea Facing / Ultra Luxury', 1),
(49, 'APH43', 'Penthouse', 'Sky Villa', 882.58, 1059.09, 'Available', NULL, NULL, 'Penthouse / Ongoing Work', 1),
(50, 'APH44', 'Penthouse', 'Sky Villa', 882.58, 1059.09, 'Available', NULL, NULL, 'Penthouse / Ongoing Work', 1),
(51, 'APH45', 'Penthouse', 'Sky Villa', 882.58, 1059.09, 'Available', NULL, NULL, 'Penthouse / Ongoing Work', 1);



SELECT FLAT_ID, flat_number,floor_number, FLOORS.FLOOR_ID AS FD1,
	   FLATS.FLOOR_ID AS FD2
       FROM FLOORS
       INNER JOIN FLATS ON floors.FLOOR_ID = FLATS.FLOOR_ID;
       
       
       
       
       
/* Populating Departments */
INSERT INTO departments 
(department_name, department_head, phone, email, location, status, is_active)
VALUES
('Project Management', 'Rahul Khanna', '9820111122', 'rahul.khanna@arkprojects.com', 'Site Office - Level 1', 'Active', 1),
('Architecture', 'Neha S. Mehta', '9819934455', 'neha.mehta@arkprojects.com', 'Design Studio - Worli', 'Active', 1),
('Structural Engineering', 'S. Prakash', '9892556677', 'prakash.struct@arkprojects.com', 'Consultant Office - Andheri', 'Active', 1),
('MEP Engineering', 'Arun V. Iyer', '9922445566', 'arun.iyer@arkprojects.com', 'MEP Cabin - Site Block B', 'Active', 1),
('Contracts & Procurement', 'Vikas Sharma', '9819234567', 'vikas.sharma@arkprojects.com', 'Corporate Office - Lower Parel', 'Active', 1),
('Finance & Accounts', 'Priya R. Desai', '9819256789', 'priya.desai@arkprojects.com', 'Corporate Office - Lower Parel', 'Active', 1),
('Human Resources', 'Anita Rodrigues', '8899776655', 'anita.hr@arkprojects.com', 'Corporate Office - Lower Parel', 'Active', 1),
('Quality Control', 'Rohit Tamhane', '9820345678', 'rohit.qc@arkprojects.com', 'QC Cabin - Site Block C', 'Active', 1),
('Safety & Compliance', 'Mahesh Patil', '9988776655', 'mahesh.safety@arkprojects.com', 'Site Safety Cabin', 'Active', 1),
('Store & Inventory', 'Devendra Pawar', '9892012345', 'devendra.store@arkprojects.com', 'Main Store - Basement 1', 'Active', 1),
('IT & Technical Support', 'Harshit Singh', '9833445566', 'harshit.it@arkprojects.com', 'IT Cabin - Ground Floor', 'Active', 1),
('Sales & Marketing', 'Ritu Mishra', '9820012345', 'ritu.sales@arkprojects.com', 'Marketing Office - Bandra', 'Active', 1);


ALTER TABLE USERS 
	DROP COLUMN	DEPARTMENT;
    
select * FROM USERS;
select * from departments;
SHOW CREATE TABLE DEPARTMENTS;

ALTER TABLE USERS ADD COLUMN DEPARTMENT_ID INT AFTER ROLE;
ALTER TABLE USERS ADD CONSTRAINT
	FK_USERS_DEPARTMENT FOREIGN KEY (DEPARTMENT_ID) 
    REFERENCES Departments(department_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;
	
INSERT INTO departments
(department_name, department_head, phone, email, location, status, is_active)
VALUES
('Operations & Support', 'Ramesh Singh', '9820001122', 'ops.support@houseofark.com', 'On Site Admin Block', 'Active', 1);


UPDATE USERS 
	SET PASSWORD_HASH = "Ark@123" 
		WHERE user_id = 1;

UPDATE USERS 
	SET DEPARTMENT_ID = 1 
		WHERE user_id = 1;

UPDATE USERS 
	SET email = "rahul.deshmukh@houseofark.com", 
    joined_date = '2023-05-01', 
    last_login = '2025-11-10 09:12:00', 
    Assignment = 'Oversee all site operations'
		WHERE user_id = 1;

-- INSERT: 78 users for ConstructionOS (The Ark: Origin)
-- Note: department_id values must match your departments table (1..13)
INSERT INTO users
(first_name, last_name, username, password_hash, email, phone, role, department_id, status, access_level, joined_date, last_login, assignment, is_active)
VALUES
-- 1 Project Management (1 PM)
-- ('Rahul','Deshmukh','rahul.deshmuk','Ark@123','rahul.deshmukh@houseofark.com','9876543210','Project Manager',1,'Active','Admin','2023-05-01','2025-11-10 09:12:00','Oversee all site operations',1),

-- 2 Architecture (dept 2)
('Neha','Mehta','neha.mehta','Ark@123','neha.mehta@houseofark.com','9819934455','Lead Architect',2,'Active','Manager','2023-04-12','2025-11-14 08:45:00','Design approvals, RERA certs',1),

-- 3 Structural Engineering (dept 3)
('Sanjeev','Prakash','s.prakash','Ark@123','sanjeev.prakash@houseofark.com','9892556677','Structural Engineer',3,'Active','Engineer','2023-06-10','2025-11-13 10:05:00','Structural checks & reports',1),

-- 4-6 MEP Engineering (dept 4)
('Arun','Iyer','arun.iyer','Ark@123','arun.iyer@houseofark.com','9922445566','MEP Lead',4,'Active','Manager','2023-07-01','2025-11-12 11:12:00','MEP coordination',1),
('Kavita','Rao','kavita.rao','Ark@123','kavita.rao@houseofark.com','9876543210','MEP Engineer',4,'Active','Engineer','2024-01-15','2025-11-11 09:00:00','HVAC & plumbing',1),
('Rohit','Bedi','rohit.bedi','Ark@123','rohit.bedi@houseofark.com','9900112233','MEP Technician',4,'Active','Engineer','2024-05-20','2025-11-10 07:40:00','Site MEP support',1),

-- 7-8 Contracts & Procurement (dept 5)
('Vikas','Sharma','vikas.sharma','Ark@123','vikas.sharma@houseofark.com','9819234567','Head - Contracts',5,'Active','Manager','2023-03-20','2025-11-09 16:00:00','Vendor negotiations',1),
('Priyanka','Roy','priyanka.roy','Ark@123','priyanka.roy@houseofark.com','9819012345','Procurement Executive',5,'Active','Staff','2024-02-01','2025-11-12 12:30:00','Purchase orders, challans',1),

-- 9-11 Finance & Accounts (dept 6)
('Priya','Desai','priya.desai','Ark@123','priya.desai@houseofark.com','9819256789','Head - Finance',6,'Active','Manager','2023-02-10','2025-11-13 14:22:00','Accounts & payroll',1),
('Anand','Kapoor','anand.kapoor','Ark@123','anand.kapoor@houseofark.com','9811122334','Accountant',6,'Active','Staff','2024-04-01','2025-11-12 10:31:00','Vendor payments',1),
('Meera','Bose','meera.bose','Ark@123','meera.bose@houseofark.com','9833445566','Finance Assistant',6,'Active','Staff','2024-07-20','2025-11-10 08:50:00','Invoicing, receipts',1),

-- 12 Human Resources (dept 7)
('Anita','Rodrigues','anita.rodrigues','Ark@123','anita.rodrigues@houseofark.com','8899776655','HR Head',7,'Active','Manager','2023-01-05','2025-11-15 09:05:00','Recruitment & HR',1),

-- 13-26 Quality Control (dept 8)  (14 people)
('Rohit','Tamhane','rohit.tamhane','Ark@123','rohit.tamhane@houseofark.com','9820345678','QC Head',8,'Active','Manager','2023-03-01','2025-11-14 07:30:00','Quality standards & checks',1),
('Sahil','Gupta','sahil.gupta','Ark@123','sahil.gupta@houseofark.com','9900223344','QC Engineer',8,'Active','Engineer','2023-06-15','2025-11-12 09:15:00','Site QC - materials',1),
('Maya','Iyer','maya.iyer','Ark@123','maya.iyer@houseofark.com','9887766554','QC Engineer',8,'Active','Engineer','2023-07-11','2025-11-11 08:22:00','Workmanship checks',1),
('Dev','Menon','dev.menon','Ark@123','dev.menon@houseofark.com','9877001122','QC Inspector',8,'Active','Staff','2024-02-20','2025-11-10 17:01:00','Daily QC logs',1),
('Rhea','Nair','rhea.nair','Ark@123','rhea.nair@houseofark.com','9966554433','QC Engineer',8,'Active','Engineer','2024-03-30','2025-11-12 13:40:00','Sampling & testing',1),
('Amit','Vora','amit.vora','Ark@123','amit.vora@houseofark.com','9813344455','QC Inspector',8,'Active','Staff','2024-06-18','2025-11-09 09:11:00','Material compaction tests',1),
('Shilpa','Reddy','shilpa.reddy','Ark@123','shilpa.reddy@houseofark.com','9890099887','QC Engineer',8,'Active','Engineer','2024-08-10','2025-11-10 11:25:00','Concrete tests & records',1),
('Karan','Malhotra','karan.malhotra','Ark@123','karan.malhotra@houseofark.com','9821122333','QC Assistant',8,'Active','Staff','2024-09-12','2025-11-08 08:45:00','QC support',1),
('Leena','Pillai','leena.pillai','Ark@123','leena.pillai@houseofark.com','9876549900','QC Engineer',8,'Active','Engineer','2024-10-05','2025-11-07 10:20:00','Plaster & finishing checks',1),
('Manish','Bhatt','manish.bhatt','Ark@123','manish.bhatt@houseofark.com','9815566778','QC Inspector',8,'Active','Staff','2025-01-12','2025-11-06 07:50:00','Site QC logs',1),
('Isha','Chopra','isha.chopra','Ark@123','isha.chopra@houseofark.com','9900776655','QC Engineer',8,'Active','Engineer','2025-02-21','2025-11-05 12:00:00','Sample testing',1),
('Tarun','Deshmukh','tarun.deshmukh','Ark@123','tarun.deshmukh@houseofark.com','9898877665','QC Technician',8,'Active','Staff','2025-03-10','2025-11-04 09:00:00','On-site QC',1),
('Sana','Khatri','sana.khatri','Ark@123','sana.khatri@houseofark.com','9812233445','QC Engineer',8,'Active','Engineer','2025-04-08','2025-11-03 08:10:00','Finishing QC',1),
('Vivek','Desai','vivek.desai','Ark@123','vivek.desai@houseofark.com','9813344112','QC Assistant',8,'Active','Staff','2025-05-01','2025-11-02 15:30:00','QC admin',1),

-- 27-31 Safety & Compliance (dept 9) (6 people)
('Mahesh','Patil','mahesh.patil','Ark@123','mahesh.patil@houseofark.com','9988776655','Head - Safety',9,'Active','Manager','2023-05-12','2025-11-12 08:00:00','Safety policies & audits',1),
('Deepak','Kumar','deepak.kumar','Ark@123','deepak.kumar@houseofark.com','9899090909','Safety Officer',9,'Active','Staff','2023-09-22','2025-11-11 07:45:00','PPE checks & toolbox talks',1),
('Ritu','Sharma','ritu.sharma','Ark@123','ritu.sharma@houseofark.com','9870011223','Safety Officer',9,'Active','Staff','2024-01-16','2025-11-10 09:05:00','Incident reporting',1),
('Samir','Khan','samir.khan','Ark@123','samir.khan@houseofark.com','9900114455','Safety Supervisor',9,'Active','Staff','2024-04-05','2025-11-09 10:12:00','Site safety rounds',1),
('Anil','Bhat','anil.bhat','Ark@123','anil.bhat@houseofark.com','9884433221','Safety Inspector',9,'Active','Staff','2024-07-12','2025-11-08 08:40:00','Compliance checks',1),
('Richa','Gandhi','richa.gandhi','Ark@123','richa.gandhi@houseofark.com','9899988776','Safety Officer',9,'Active','Staff','2024-08-25','2025-11-07 07:20:00','Safety audits',1),

-- 32-35 Store & Inventory (dept 10) (4 people)
('Devendra','Pawar','devendra.pawar','Ark@123','devendra.pawar@houseofark.com','9892012345','Store In-charge',10,'Active','Manager','2023-03-18','2025-11-13 09:30:00','Inventory & challans',1),
('Suresh','Nair','suresh.nair','Ark@123','suresh.nair@houseofark.com','9870091122','Store Assistant',10,'Active','Staff','2024-02-02','2025-11-12 08:55:00','Material issue',1),
('Mohit','Agarwal','mohit.agarwal','Ark@123','mohit.agarwal@houseofark.com','9817766554','Store Assistant',10,'Active','Staff','2024-06-15','2025-11-11 10:45:00','Goods receipt',1),
('Ritika','Sen','ritika.sen','Ark@123','ritika.sen@houseofark.com','9900991122','Store Clerk',10,'Active','Staff','2024-09-20','2025-11-10 09:10:00','Inventory logs',1),

-- 36 IT & Technical Support (dept 11)
('Harshit','Singh','harshit.singh','Ark@123','harshit.singh@houseofark.com','9833445566','IT Head',11,'Active','Manager','2023-01-12','2025-11-14 06:50:00','IT & systems support',1),

-- 37-46 Sales & Marketing (dept 12) (10 people)
('Ritu','Mishra','ritu.mishra','Ark@123','ritu.mishra@houseofark.com','9820012345','Head - Sales',12,'Active','Manager','2023-02-20','2025-11-12 11:20:00','Sales strategy & showflat',1),
('Aarav','Shah','aarav.shah','Ark@123','aarav.shah@houseofark.com','9821122334','Sales Executive',12,'Active','Staff','2023-07-05','2025-11-11 10:02:00','Lead follow-ups',1),
('Riya','Mehta','riya.mehta','Ark@123','riya.mehta@houseofark.com','9812233377','Sales Executive',12,'Active','Staff','2023-08-15','2025-11-10 09:42:00','Site visits & clients',1),
('Kunal','Shah','kunal.shah','Ark@123','kunal.shah@houseofark.com','9813344499','Sales Executive',12,'Active','Staff','2024-01-10','2025-11-09 08:58:00','Client demos',1),
('Elina','Varghese','elina.varghese','Ark@123','elina.varghese@houseofark.com','9900221133','Marketing Exec',12,'Active','Staff','2024-02-28','2025-11-08 12:22:00','Digital marketing',1),
('Vikram','Poonawalla','vikram.poonawalla','Ark@123','vikram.poonawalla@houseofark.com','9890093344','Sales Executive',12,'Active','Staff','2024-04-18','2025-11-07 14:30:00','High-networth outreach',1),
('Sarah','Joseph','sarah.joseph','Ark@123','sarah.joseph@houseofark.com','9900332211','Sales Exec',12,'Active','Staff','2024-06-01','2025-11-06 09:05:00','Showflat coordination',1),
('Daniel','Dsouza','daniel.dsouza','Ark@123','daniel.dsouza@houseofark.com','9890095566','Sales Exec',12,'Active','Staff','2024-07-20','2025-11-05 11:11:00','Client relations',1),
('Natasha','Merchant','natasha.merchant','Ark@123','natasha.merchant@houseofark.com','9814455667','Marketing Manager',12,'Active','Manager','2024-08-30','2025-11-04 10:00:00','Brand & PR',1),
('Farhan','Daruwala','farhan.daruwala','Ark@123','farhan.daruwala@houseofark.com','9815566001','Sales Exec',12,'Active','Staff','2024-10-10','2025-11-03 07:50:00','Client follow-ups',1),

-- 47-61 Civil Site Engineering (dept 3)  (15 engineers; mix of senior/junior/interns)
('Amit','Singh','amit.singh','Ark@123','amit.singh@houseofark.com','9817001122','Senior Site Engineer',3,'Active','Engineer','2022-11-05','2025-11-12 08:14:00','Structural & slab coordination',1),
('Pooja','Sharma','pooja.sharma','Ark@123','pooja.sharma@houseofark.com','9817003344','Site Engineer',3,'Active','Engineer','2023-01-20','2025-11-11 08:00:00','Site supervision',1),
('Raghav','Malik','raghav.malik','Ark@123','raghav.malik@houseofark.com','9822334455','Site Engineer',3,'Active','Engineer','2023-02-10','2025-11-10 07:30:00','Structural works',1),
('Suman','Verma','suman.verma','Ark@123','suman.verma@houseofark.com','9900445566','Junior Engineer',3,'Active','Engineer','2023-05-18','2025-11-09 09:33:00','Assists senior engineers',1),
('Vivek','Sharma','vivek.sharma','Ark@123','vivek.sharma@houseofark.com','9890776655','Junior Engineer',3,'Active','Engineer','2023-06-25','2025-11-08 10:14:00','Site QA support',1),
('Neel','Patel','neel.patel','Ark@123','neel.patel@houseofark.com','9877766554','Junior Engineer',3,'Active','Engineer','2023-08-01','2025-11-07 11:20:00','Masonry & BBM support',1),
('Tanya','Kohli','tanya.kohli','Ark@123','tanya.kohli@houseofark.com','9880011223','Site Engineer',3,'Active','Engineer','2023-09-18','2025-11-06 12:12:00','Floor finishing coordination',1),
('Harsh','Mehta','harsh.mehta','Ark@123','harsh.mehta@houseofark.com','9813388999','Senior Engineer',3,'Active','Engineer','2023-10-01','2025-11-05 08:05:00','Technical supervision',1),
('Irfan','Khan','irfan.khan','Ark@123','irfan.khan@houseofark.com','9900113344','Site Engineer',3,'Active','Engineer','2024-01-12','2025-11-04 07:44:00','Concrete & reinforcement',1),
('Mira','Roy','mira.roy','Ark@123','mira.roy@houseofark.com','9899001122','Junior Engineer',3,'Active','Engineer','2024-02-20','2025-11-03 10:33:00','Plaster & finishes',1),
('Rohan','Deshmukh','rohan.deshmukh','Ark@123','rohan.deshmukh@houseofark.com','9810092233','Intern Engineer',3,'Active','Intern','2024-03-30','2025-11-02 16:12:00','Site intern',1),
('Kiran','Bajaj','kiran.bajaj','Ark@123','kiran.bajaj@houseofark.com','9870013344','Site Engineer',3,'Active','Engineer','2024-05-09','2025-11-01 09:55:00','BBM & finishing',1),
('Sahil','Khanna','sahil.khanna','Ark@123','sahil.khanna@houseofark.com','9811127799','Junior Engineer',3,'Active','Engineer','2024-06-18','2025-10-31 07:12:00','Site works',1),
('Diya','Narang','diya.narang','Ark@123','diya.narang@houseofark.com','9901223344','Site Engineer',3,'Active','Engineer','2024-08-02','2025-10-30 08:22:00','Floor progress updates',1),
('Mukul','Ahuja','mukul.ahuja','Ark@123','mukul.ahuja@houseofark.com','9890097788','Senior Engineer',3,'Active','Engineer','2022-12-12','2025-10-29 09:00:00','Lead technical tasks',1),

-- 62-72 Operations & Support (dept 13) (11 people: 5 security, 3 housekeeping, 3 admin support)
('Ramesh','Singh','ramesh.singh','Ark@123','ramesh.singh@houseofark.com','9820001122','Ops Head',13,'Active','Manager','2022-10-01','2025-11-15 08:10:00','Overall ops & support',1),
('Suresh','Kumar','suresh.kumar','Ark@123','suresh.kumar@houseofark.com','9890090011','Security Guard','13','Active','Staff','2023-03-05','2025-11-14 06:45:00','Perimeter security',1),
('Manoj','Patel','manoj.patel','Ark@123','manoj.patel@houseofark.com','9890090022','Security Guard',13,'Active','Staff','2023-04-11','2025-11-13 06:50:00','Gate & patrols',1),
('Ajay','Kumar','ajay.kumar','Ark@123','ajay.kumar@houseofark.com','9890090033','Security Guard',13,'Active','Staff','2023-05-08','2025-11-12 06:55:00','Night patrols',1),
('Rajat','Verma','rajat.verma','Ark@123','rajat.verma@houseofark.com','9890090044','Security Guard',13,'Active','Staff','2023-06-20','2025-11-11 07:00:00','Lobby security',1),
('Vikash','Yadav','vikash.yadav','Ark@123','vikash.yadav@houseofark.com','9890090055','Security Guard',13,'Active','Staff','2023-07-15','2025-11-10 07:05:00','Patrol & CCTV',1),
('Sunita','Kaur','sunita.kaur','Ark@123','sunita.kaur@houseofark.com','9890090066','Housekeeping','13','Active','Staff','2023-08-01','2025-11-09 08:20:00','Cleaning & common areas',1),
('Preeti','Shah','preeti.shah','Ark@123','preeti.shah@houseofark.com','9890090077','Housekeeping','13','Active','Staff','2023-09-10','2025-11-08 08:25:00','Housekeeping',1),
('Kamal','Nair','kamal.nair','Ark@123','kamal.nair@houseofark.com','9890090088','Housekeeping','13','Active','Staff','2023-10-05','2025-11-07 08:30:00','Cleaning',1),
('Sonia','Dutta','sonia.dutta','Ark@123','sonia.dutta@houseofark.com','9890090099','Admin Assistant',13,'Active','Staff','2023-11-20','2025-11-06 09:00:00','Admin support',1),
('Ravi','Joshi','ravi.joshi','Ark@123','ravi.joshi@houseofark.com','9890090100','Admin Assistant',13,'Active','Staff','2024-02-14','2025-11-05 09:15:00','Site admin support',1),

-- 73-78 Extra (3 more Sales/Marketing juniors + 3 support) to reach 78
('Tanvi','Gupta','tanvi.gupta','Ark@123','tanvi.gupta@houseofark.com','9812347788','Sales Executive',12,'Active','Staff','2024-03-01','2025-11-04 10:12:00','Lead gen',1),
('Karan','Agarwal','karan.agarwal','Ark@123','karan.agarwal@houseofark.com','9813347788','Sales Executive',12,'Active','Staff','2024-05-12','2025-11-03 11:11:00','Client follow-up',1),
('Nidhi','Bhandari','nidhi.bhandari','Ark@123','nidhi.bhandari@houseofark.com','9814457788','Marketing Exec',12,'Active','Staff','2024-06-20','2025-11-02 12:10:00','Digital campaigns',1),
('Vivek','Jain','vivek.jain','Ark@123','vivek.jain@houseofark.com','9815567788','Site Electrician','4','Active','Staff','2024-07-30','2025-11-01 07:40:00','Electrical maintenance',1),
('Sonia','Kohli','sonia.kohli','Ark@123','sonia.kohli@houseofark.com','9816677788','Junior Engineer',3,'Active','Engineer','2024-08-15','2025-10-30 09:20:00','Assists site work',1),
('Aman','Sethi','aman.sethi','Ark@123','aman.sethi@houseofark.com','9817788899','Logistics Coordinator',5,'Active','Staff','2024-09-20','2025-10-29 08:55:00','Material logistics',1);

-- End of INSERT block

