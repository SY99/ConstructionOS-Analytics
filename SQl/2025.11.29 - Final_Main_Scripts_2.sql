USE ConstructionOS;
SHOW CREATE TABLE contractors;
SHOW CREATE TABLE departments;
SHOW CREATE TABLE flats;
SHOW CREATE TABLE floors;
SHOW CREATE TABLE material_inventory;
SHOW CREATE TABLE material_stock_summary;
SHOW CREATE TABLE material_transactions;
SHOW CREATE TABLE progress_status;
SHOW CREATE TABLE progress_tracking;
SHOW CREATE TABLE projects;
SHOW CREATE TABLE rcc_column_sheet;
SHOW CREATE TABLE rcc_slab_sheet;
SHOW CREATE TABLE subtask_master;
SHOW CREATE TABLE task_master;
SHOW CREATE TABLE users;
SHOW CREATE TABLE wings;

/* ------------------------------------------------------------------
  TABLE: contractors
  PURPOSE:
    - Master list of contractors (previously "suppliers"). Includes
      contact info, tax ids and category. Used across transactions and
      progress tracking as contractor_id.
    - Soft delete by is_active (FALSE = deleted/inactive).
  ------------------------------------------------------------------ */
  
  CREATE TABLE `contractors` (
   `contractor_id` int NOT NULL AUTO_INCREMENT,
   `contractor_name` varchar(150) NOT NULL,
   `contact_person` varchar(100) DEFAULT NULL,
   `phone` varchar(20) DEFAULT NULL,
   `email` varchar(150) DEFAULT NULL,
   `address` varchar(255) DEFAULT NULL,
   `gst_number` varchar(50) DEFAULT NULL,
   `pan_number` varchar(50) DEFAULT NULL,
   `contractor_category` varchar(100) DEFAULT NULL,
   `status` varchar(30) DEFAULT 'Active',
   `is_active` tinyint(1) DEFAULT '1',
   `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
   `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   PRIMARY KEY (`contractor_id`)
 ) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
 
 /* ------------------------------------------------------------------
  RELATIONSHIPS SUMMARY:
    - contractors is a parent/master table referenced by:
        * material_transactions (if used)
        * material_stock_summary (supplier_id -> contractor_id)
        * progress_tracking (contractor_id)
    - Deletions should be soft (set is_active = FALSE); FK should use SET NULL.
  ------------------------------------------------------------------ */
  
  
  -- =========================================================
-- Table: projects
-- Purpose: Stores master project details such as name,
-- location, developer info, registration codes, key dates,
-- and overall status. Supports audit trail of who created it.
-- =========================================================

CREATE TABLE `projects` (
   `project_id` int NOT NULL AUTO_INCREMENT,
   `project_name` varchar(150) NOT NULL,
   `project_code` varchar(50) NOT NULL,
   `survey_no` varchar(50) DEFAULT NULL,
   `rera_number` varchar(100) DEFAULT NULL,
   `location` varchar(255) DEFAULT NULL,
   `developer_name` varchar(150) DEFAULT NULL,
   `total_area_sqm` decimal(10,2) DEFAULT NULL,
   `total_area_sqft` decimal(10,2) GENERATED ALWAYS AS ((`total_area_sqm` * 10.7639)) VIRTUAL,
   `start_date` date DEFAULT NULL,
   `completion_date` date DEFAULT NULL,
   `current_status` varchar(50) DEFAULT 'Planning',
   `description` text,
   `created_by` int DEFAULT NULL,
   `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
   `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   `is_active` tinyint(1) DEFAULT '1' COMMENT 'Soft delete flag (FALSE = deleted/inactive)',
   PRIMARY KEY (`project_id`),
   UNIQUE KEY `project_code` (`project_code`),
   KEY `fk_project_creator` (`created_by`),
   CONSTRAINT `fk_project_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`) ON DELETE RESTRICT ON UPDATE CASCADE
 ) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
 
 -- ==========================================================
-- Relationships:
-- 1. Each project is linked to a creator (users.user_id).
-- 2. Other tables like wings, materials, progress_tracker
--    will reference project_id as a foreign key.
-- ==========================================================



/* ==========================================================
   Table: wings
   Purpose:
   Defines all building wings or blocks within a project.
   Each wing is linked to a parent project and includes
   construction timeline, total floors, total flats,
   and soft deletion for safe archival.

   ========================================================== */
   
   CREATE TABLE `wings` (
   `wing_id` int NOT NULL AUTO_INCREMENT,
   `project_id` int NOT NULL,
   `wing_name` varchar(50) NOT NULL,
   `total_floors` int DEFAULT NULL,
   `total_flats` int DEFAULT NULL,
   `start_date` date DEFAULT NULL,
   `completion_date` date DEFAULT NULL,
   `construction_status` varchar(50) DEFAULT 'Planning',
   `remarks` text,
   `is_active` tinyint(1) DEFAULT '1',
   `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
   `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   PRIMARY KEY (`wing_id`),
   KEY `fk_project_wing` (`project_id`),
   CONSTRAINT `fk_project_wing` FOREIGN KEY (`project_id`) REFERENCES `projects` (`project_id`) ON DELETE RESTRICT ON UPDATE CASCADE
 ) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
   
   /* ==========================================================
   Relationships:
   - Each wing belongs to one project → linked via 'project_id'.
   - Each wing can have multiple floors → referenced in 'floors.wing_id'.
   - Certificates (RERA, Bank, Structural, etc.) can be associated 
     with wings for compliance and tracking.
   ========================================================== */
   
   
   
   /* ==========================================================
   Table: floors
   Purpose:
   Defines the vertical hierarchy of a project’s wing.
   Each floor belongs to exactly one wing and forms the basis
   for flat-level, progress-level, and task-level tracking.

   Key Design Notes:
   - 'floor_number' defines the numeric order (e.g., 1, 2, 3...).
   - 'floor_name' allows friendly labels (e.g., “Ground Floor”).
   - 'construction_stage' enables tracking of current phase 
     (e.g., Slab Casting, Brickwork, Plastering).
   - 'progress_status' uses dropdowns in GUI for consistent data.
   - Each floor connects upward to one wing and downward to many flats.
   - InnoDB ensures referential integrity between floors and wings.

   Example Record:
   | floor_id | wing_id | floor_number | floor_name | construction_stage | progress_status | remarks |
   |-----------|----------|--------------|-------------|--------------------|----------------|----------|
   | 1 | 1 | 1 | Ground Floor | Slab Casting | Mid | RCC in progress |
   ========================================================== */
   
   CREATE TABLE `floors` (
   `floor_id` int NOT NULL AUTO_INCREMENT,
   `wing_id` int NOT NULL,
   `floor_number` varchar(150) NOT NULL,
   `total_flats` int DEFAULT NULL,
   `construction_stage` varchar(150) DEFAULT NULL,
   `progress_status` varchar(50) DEFAULT 'Not Started',
   `start_date` date DEFAULT NULL,
   `completion_date` date DEFAULT NULL,
   `remarks` text,
   `is_active` tinyint(1) DEFAULT '1' COMMENT 'Soft delete flag (FALSE = deleted/inactive)',
   `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
   `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   PRIMARY KEY (`floor_id`),
   KEY `wing_id` (`wing_id`),
   CONSTRAINT `floors_ibfk_1` FOREIGN KEY (`wing_id`) REFERENCES `wings` (`wing_id`) ON DELETE RESTRICT ON UPDATE CASCADE
 ) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
   
   /* ==========================================================
   Relationships:
   - Each floor belongs to one wing → linked via 'floors.wing_id'
   - Each floor can have multiple flats → linked via 'flats.floor_id'
   - Each floor can be referenced in progress, RERA, and bank tracking.
   ========================================================== */
   
   
   
-- =========================================================
-- Table: flats
-- Purpose:
--   Stores information for each flat/apartment within a floor.
--   Includes flat numbering, type, area details, status, and sales info.
--   Supports soft delete, audit timestamps, and restricts cascading deletions.
--
-- Relationships:
--   - floor_id references floors(floor_id)
--     ON DELETE RESTRICT (prevents deleting floors with flats)
--     ON UPDATE CASCADE
-- =========================================================

CREATE TABLE `flats` (
   `flat_id` int NOT NULL AUTO_INCREMENT,
   `floor_id` int NOT NULL,
   `flat_number` varchar(20) NOT NULL,
   `flat_type` varchar(50) DEFAULT NULL,
   `unit_type` varchar(50) DEFAULT NULL,
   `carpet_area` decimal(8,2) DEFAULT NULL,
   `builtup_area` decimal(8,2) DEFAULT NULL,
   `status` varchar(50) DEFAULT 'Available',
   `owner_name` varchar(100) DEFAULT NULL,
   `sale_date` date DEFAULT NULL,
   `remarks` text,
   `is_active` tinyint(1) DEFAULT '1' COMMENT 'Soft delete flag (FALSE = deleted/inactive)',
   `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
   `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   PRIMARY KEY (`flat_id`)
 ) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

-- =========================================================
-- Relationships Summary:
-- ---------------------------------------------------------
-- flats.floor_id → floors.floor_id
--   - Each flat belongs to one specific floor.
--   - ON DELETE RESTRICT → prevents deleting a floor if flats exist.
--   - ON UPDATE CASCADE → ensures foreign key updates propagate automatically.
--
-- Hierarchical Chain:
--   users → projects → wings → floors → flats
--   This maintains full structural integrity across the project hierarchy.
--
-- Frontend Role Mapping:
--   - Developers / Sales Team → Full access (add/edit/update sale info)
--   - Engineers / Site Team → Read-only view access
--   - Admin → Override privileges
--
-- Data Integrity:
--   - Soft delete via `is_deleted` instead of hard delete.
--   - Auto-generated flat numbers governed by master settings (future feature).
-- =========================================================

/* ==========================================================
   Relationships:
   - Each flat belongs to one floor → linked via 'flats.floor_id'
   - Each floor can have multiple flats (1:N relationship)
   - Each flat can later link to:
       → material usage per unit
       → task progress (unit-level tracking)
       → sales and finance data (future phases)
   ========================================================== */
   
   
   
   -- =========================================================
-- Table: users
-- Purpose:
-- Stores all user account details, roles, and access levels for
-- the ConstructionOS platform. This table holds personal info,
-- authentication credentials, job titles, access rights, and 
-- audit timestamps for user lifecycle management.
-- =========================================================

CREATE TABLE `users` (
   `user_id` int NOT NULL AUTO_INCREMENT,
   `first_name` varchar(100) NOT NULL,
   `last_name` varchar(100) NOT NULL,
   `username` varchar(100) NOT NULL,
   `password_hash` varchar(255) NOT NULL,
   `email` varchar(150) DEFAULT NULL,
   `phone` varchar(15) DEFAULT NULL,
   `role` varchar(50) DEFAULT NULL COMMENT 'Functional job title, e.g. Engineer, Architect, etc.',
   `DEPARTMENT_ID` int DEFAULT NULL,
   `status` varchar(20) DEFAULT 'Active',
   `access_level` varchar(50) DEFAULT 'Engineer' COMMENT 'System access permission level',
   `joined_date` date DEFAULT NULL,
   `last_login` datetime DEFAULT NULL,
   `assignment` text COMMENT 'Stores user work assignments; frontend displays as chips/tags',
   `is_active` tinyint(1) DEFAULT '1' COMMENT 'Soft delete flag (FALSE = deleted/inactive)',
   `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
   `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   PRIMARY KEY (`user_id`),
   UNIQUE KEY `username` (`username`),
   KEY `FK_USERS_DEPARTMENT` (`DEPARTMENT_ID`),
   CONSTRAINT `FK_USERS_DEPARTMENT` FOREIGN KEY (`DEPARTMENT_ID`) REFERENCES `departments` (`department_id`) ON DELETE RESTRICT ON UPDATE CASCADE
 ) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

-- ==========================================================
-- Relationships:
-- 1. No direct foreign keys; acts as a parent table for:
--    - tasks (assigned_by, assigned_to)
--    - materials (issued_by, received_by)
--    - approvals (approved_by)
-- 2. user_id will be used as FK across multiple tables
-- ==========================================================



/* ------------------------------------------------------------------
  TABLE: task_master
  PURPOSE:
    - Canonical reference list of tasks (interior work focus for phase 1).
    - Acts purely as a lookup/reference table for progress_tracking.
    - No status/writer timestamps (kept minimal per your request).
    - Soft delete via is_active.
  ------------------------------------------------------------------ */
SHOW CREATE TABLE subtask_master;
CREATE TABLE `task_master` (
   `task_id` int NOT NULL AUTO_INCREMENT,
   `task_name` varchar(150) NOT NULL,
   `task_description` text,
   `is_active` tinyint(1) DEFAULT '1',
   `task_code` varchar(5) NOT NULL,
   PRIMARY KEY (`task_id`),
   UNIQUE KEY `task_code_UNIQUE` (`task_code`)
 ) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

/* ------------------------------------------------------------------
  RELATIONSHIPS SUMMARY:
    - task_master is a reference table used by subtask_master and progress_tracking.
    - Keep this table static / pre-populated with your master list of tasks.
  ------------------------------------------------------------------ */
  
  
  /* ------------------------------------------------------------------
  TABLE: subtask_master
  PURPOSE:
    - Master list of subtasks (one-to-many to task_master).
    - Minimal columns: IDs, codes, names, weightage and is_active.
    - No created_at / updated_at (per instruction) to keep it simple.
  ------------------------------------------------------------------ */


CREATE TABLE `subtask_master` (
   `subtask_id` int NOT NULL AUTO_INCREMENT,
   `task_code` varchar(5) NOT NULL,
   `subtask_code` varchar(50) NOT NULL,
   `subtask_name` varchar(150) NOT NULL,
   `is_active` tinyint(1) DEFAULT '1',
   `order` int NOT NULL,
   `task_id` int DEFAULT NULL,
   PRIMARY KEY (`subtask_id`),
   KEY `idx_task_code` (`task_code`),
   KEY `fk_subtask_task_id` (`task_id`),
   CONSTRAINT `fk_subtask_task` FOREIGN KEY (`task_code`) REFERENCES `task_master` (`task_code`) ON DELETE RESTRICT ON UPDATE CASCADE,
   CONSTRAINT `fk_subtask_task_id` FOREIGN KEY (`task_id`) REFERENCES `task_master` (`task_id`)
 ) ENGINE=InnoDB AUTO_INCREMENT=460 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

/* ------------------------------------------------------------------
  RELATIONSHIPS SUMMARY:
    - subtask_master.task_id -> task_master.task_id (RESTRICT)
    - Use this table as the authoritative subtask list for progress entries.
  ------------------------------------------------------------------ */
  
  
  
  /* ------------------------------------------------------------------
  TABLE: progress_status
  PURPOSE:
    - Lookup table for allowed progress states and their numerical weights.
    - Use this to map status_id → display_label and weight_percent.
    - Weight_percent can be 0..100. Using steps of 10 is fine and recommended
      (0,10,20...100) but not required — frontend may use these values.
    - is_active for soft-disable of a status option.
  ------------------------------------------------------------------ */

CREATE TABLE `progress_status` (
   `status_id` int NOT NULL AUTO_INCREMENT,
   `status_key` varchar(50) NOT NULL,
   `display_label` varchar(100) NOT NULL,
   `percentage` tinyint NOT NULL DEFAULT '0',
   `is_active` tinyint(1) DEFAULT '1',
   PRIMARY KEY (`status_id`),
   UNIQUE KEY `status_key` (`status_key`)
 ) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

-- example seed rows (optional):
-- INSERT INTO progress_status (status_key, display_label, weight_percent) VALUES
-- ('not_started','Not Started',0),
-- ('started','Started',10),
-- ('in_progress','In Progress',40),
-- ('midway','Midway',60),
-- ('almost_done','Almost Done',90),
-- ('completed','Completed',100);

/* ------------------------------------------------------------------
  RELATIONSHIPS SUMMARY:
    - progress_status.status_id referenced by progress_tracking.progress_status_id
    - Manage statuses centrally here; frontend reads these for dropdowns.
  ------------------------------------------------------------------ */
  
  
  
  /* ------------------------------------------------------------------
  TABLE: progress_tracking
  PURPOSE:
    - Stores per-unit progress entries reported from frontend.
    - All dynamic logic (percent calculation, status transitions,
      completion dates, notifications) is handled by frontend/app.
    - Backend stores IDs (FKs) and supplied dates/remarks as submitted.
    - Soft delete via is_active; keep created/updated timestamps for audit.
  ------------------------------------------------------------------ */

CREATE TABLE `progress_tracking` (
   `progress_id` int NOT NULL AUTO_INCREMENT,
   `project_id` int NOT NULL,
   `wing_id` int DEFAULT NULL,
   `floor_id` int DEFAULT NULL,
   `flat_id` int DEFAULT NULL,
   `task_id` int DEFAULT NULL,
   `subtask_id` int DEFAULT NULL,
   `engineer_id` int DEFAULT NULL,
   `contractor_id` int DEFAULT NULL,
   `progress_status_id` int DEFAULT NULL,
   `progress_percent` decimal(6,2) DEFAULT NULL,
   `start_date` date DEFAULT NULL,
   `reported_at` datetime DEFAULT CURRENT_TIMESTAMP,
   `last_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   `completion_date` date DEFAULT NULL,
   `remarks` text,
   `is_active` tinyint(1) DEFAULT '1',
   PRIMARY KEY (`progress_id`),
   KEY `fk_pt_project` (`project_id`),
   KEY `fk_pt_wing` (`wing_id`),
   KEY `fk_pt_floor` (`floor_id`),
   KEY `fk_pt_flat` (`flat_id`),
   KEY `fk_pt_task` (`task_id`),
   KEY `fk_pt_subtask` (`subtask_id`),
   KEY `fk_pt_engineer` (`engineer_id`),
   KEY `fk_pt_contractor` (`contractor_id`),
   KEY `fk_pt_status` (`progress_status_id`),
   CONSTRAINT `fk_pt_contractor` FOREIGN KEY (`contractor_id`) REFERENCES `contractors` (`contractor_id`) ON DELETE SET NULL ON UPDATE CASCADE,
   CONSTRAINT `fk_pt_engineer` FOREIGN KEY (`engineer_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
   CONSTRAINT `fk_pt_flat` FOREIGN KEY (`flat_id`) REFERENCES `flats` (`flat_id`) ON DELETE SET NULL ON UPDATE CASCADE,
   CONSTRAINT `fk_pt_floor` FOREIGN KEY (`floor_id`) REFERENCES `floors` (`floor_id`) ON DELETE SET NULL ON UPDATE CASCADE,
   CONSTRAINT `fk_pt_project` FOREIGN KEY (`project_id`) REFERENCES `projects` (`project_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
   CONSTRAINT `fk_pt_status` FOREIGN KEY (`progress_status_id`) REFERENCES `progress_status` (`status_id`) ON DELETE SET NULL ON UPDATE CASCADE,
   CONSTRAINT `fk_pt_subtask` FOREIGN KEY (`subtask_id`) REFERENCES `subtask_master` (`subtask_id`) ON DELETE SET NULL ON UPDATE CASCADE,
   CONSTRAINT `fk_pt_task` FOREIGN KEY (`task_id`) REFERENCES `task_master` (`task_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
   CONSTRAINT `fk_pt_wing` FOREIGN KEY (`wing_id`) REFERENCES `wings` (`wing_id`) ON DELETE SET NULL ON UPDATE CASCADE
 ) ENGINE=InnoDB AUTO_INCREMENT=8085 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

/* ------------------------------------------------------------------
  RELATIONSHIPS SUMMARY:
    - project_id -> projects.project_id (RESTRICT)
    - wing_id    -> wings.wing_id (SET NULL)
    - floor_id   -> floors.floor_id (SET NULL)
    - flat_id    -> flats.flat_id (SET NULL)
    - task_id    -> task_master.task_id (RESTRICT)
    - subtask_id -> subtask_master.subtask_id (SET NULL)
    - engineer_id -> users.user_id (SET NULL)
    - contractor_id -> contractors.contractor_id (SET NULL)
    - progress_status_id -> progress_status.status_id (SET NULL)
  ------------------------------------------------------------------ */
/* ==========================================================
   Relationships:
   - Each flat belongs to one floor → linked via 'flats.floor_id'
   - Each floor can have multiple flats (1:N relationship)
   - Each flat can later link to:
       → material usage per unit
       → task progress (unit-level tracking)
       → sales and finance data (future phases)
   ========================================================== */
   
   
   
   -- =========================================================
-- Table: material_inventory
-- Purpose: Maintains master list of materials and current stock levels.
-- Tracks opening stock, received and issued quantities, balance, and reorder alerts.
-- Includes soft delete protection and audit timestamps.
-- =========================================================

CREATE TABLE `material_inventory` (
   `material_id` int NOT NULL AUTO_INCREMENT,
   `material_code` varchar(50) NOT NULL,
   `material_name` varchar(150) NOT NULL,
   `category` varchar(100) NOT NULL,
   `unit` varchar(50) NOT NULL,
   `brand` varchar(100) DEFAULT NULL,
   `grade` varchar(100) DEFAULT NULL,
   `opening_stock` decimal(10,2) DEFAULT '0.00',
   `remarks` text,
   `is_active` tinyint(1) DEFAULT '1' COMMENT 'Soft delete flag (FALSE = inactive)',
   `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
   `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   PRIMARY KEY (`material_id`),
   UNIQUE KEY `material_code` (`material_code`)
 ) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

-- =========================================================
-- Relationships: Referenced by material_transactions(material_id)
-- =========================================================



/* ------------------------------------------------------------------
   TABLE: material_stock_summary
   PURPOSE:
     - Tracks material-wise stock details, quantities, and movements 
       for each project department and supplier.
     - Links materials to departments, suppliers, and the approving 
       engineer (user).
     - Computes total value automatically from current stock * unit rate.
     - Percentage-based stock indicators (e.g., low stock, reorder) 
       will be handled on the frontend dynamically.
     - Includes soft delete mechanism using is_deleted flag.
   ------------------------------------------------------------------ */

CREATE TABLE `material_stock_summary` (
   `stock_id` int NOT NULL AUTO_INCREMENT,
   `material_id` int NOT NULL,
   `opening_quantity` decimal(10,2) DEFAULT '0.00',
   `received_quantity` decimal(10,2) DEFAULT '0.00',
   `issued_quantity` decimal(10,2) DEFAULT '0.00',
   `current_stock` decimal(10,2) GENERATED ALWAYS AS (((ifnull(`opening_quantity`,0) + ifnull(`received_quantity`,0)) - ifnull(`issued_quantity`,0))) STORED,
   `unit` varchar(50) DEFAULT NULL,
   `unit_rate` decimal(12,2) DEFAULT '0.00',
   `total_value` decimal(12,2) GENERATED ALWAYS AS ((((`opening_quantity` + `received_quantity`) - `issued_quantity`) * `unit_rate`)) STORED,
   `remarks` text,
   `is_active` tinyint(1) DEFAULT '1',
   `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
   `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   PRIMARY KEY (`stock_id`),
   KEY `fk_ms_material` (`material_id`),
   CONSTRAINT `fk_ms_material` FOREIGN KEY (`material_id`) REFERENCES `material_inventory` (`material_id`) ON DELETE RESTRICT ON UPDATE CASCADE
 ) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


/* ------------------------------------------------------------------
   RELATIONSHIPS SUMMARY:
   ------------------------------------------------------------------
   - material_id  →  materials(material_id)
       Purpose : Identifies which material record this stock belongs to
       Action  : RESTRICT on DELETE | CASCADE on UPDATE

   - department_id  →  departments(department_id)
       Purpose : Links stock usage or allocation to specific department
       Action  : SET NULL on DELETE | CASCADE on UPDATE

   - supplier_id  →  suppliers(supplier_id)
       Purpose : Tracks supplier for received materials
       Action  : SET NULL on DELETE | CASCADE on UPDATE

   - engineer_id  →  users(user_id)
       Purpose : References the engineer or user who approved/issued stock
       Action  : SET NULL on DELETE | CASCADE on UPDATE
   ------------------------------------------------------------------ */
   
/* Triggers */
/* Auto-create summary row when a material is added */
DELIMITER $$

CREATE TRIGGER trg_autocreate_stock_on_inventory
AFTER INSERT ON material_inventory
FOR EACH ROW
BEGIN
    INSERT INTO material_stock_summary (
        material_id,
        opening_quantity,
        unit,
        unit_rate
    )
    VALUES (
        NEW.material_id,
        NEW.opening_stock,
        NEW.unit,
        0
    );
END$$

DELIMITER ;

/* Auto-update stock after transactions */
DELIMITER $$

CREATE TRIGGER trg_update_stock_after_transaction
AFTER INSERT ON material_transactions
FOR EACH ROW
BEGIN
    UPDATE material_stock_summary
    SET 
        received_quantity = received_quantity + NEW.received_qty,
        issued_quantity   = issued_quantity   + NEW.issued_qty,
        updated_at = CURRENT_TIMESTAMP
    WHERE material_id = NEW.material_id;
END$$

DELIMITER ;

/* One-Time Initialization for Existing Materials */
INSERT INTO material_stock_summary (material_id, opening_quantity, unit, unit_rate)
SELECT 
    material_id,
    opening_stock,
    unit,
    0
FROM material_inventory
WHERE material_id NOT IN (SELECT material_id FROM material_stock_summary);




   -- =========================================================
-- Table: material_transactions
-- Purpose: Records all incoming (receipts), outgoing (issues),
-- and returned materials linked to materials_inventory.
-- Includes challan, supplier, quantity, and work info.
-- Data is restricted from deletion and maintains referential
-- integrity with materials_inventory.
-- =========================================================

CREATE TABLE `material_transactions` (
   `txn_id` int NOT NULL AUTO_INCREMENT,
   `material_id` int NOT NULL,
   `txn_date` date NOT NULL,
   `transaction_type` varchar(50) NOT NULL,
   `reference_no` varchar(50) DEFAULT NULL,
   `unit` varchar(50) NOT NULL,
   `received_qty` decimal(10,2) DEFAULT '0.00',
   `issued_qty` decimal(10,2) DEFAULT '0.00',
   `unit_rate` decimal(12,2) DEFAULT '0.00',
   `tax_percent` decimal(6,2) DEFAULT '0.00',
   `total_cost` decimal(12,2) DEFAULT '0.00',
   `work_description` varchar(150) DEFAULT NULL,
   `remarks` text,
   `is_active` tinyint(1) DEFAULT '1',
   `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
   `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   `project_id` int DEFAULT NULL,
   `wing_id` int DEFAULT NULL,
   `floor_id` int DEFAULT NULL,
   `contractor_id` int DEFAULT NULL,
   `engineer_id` int DEFAULT NULL,
   PRIMARY KEY (`txn_id`),
   KEY `fk_material` (`material_id`),
   KEY `fk_mt_project` (`project_id`),
   KEY `fk_mt_wing` (`wing_id`),
   KEY `fk_mt_floor` (`floor_id`),
   KEY `fk_mt_contractor` (`contractor_id`),
   KEY `fk_mt_engineer` (`engineer_id`),
   CONSTRAINT `fk_material` FOREIGN KEY (`material_id`) REFERENCES `material_inventory` (`material_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
   CONSTRAINT `fk_mt_contractor` FOREIGN KEY (`contractor_id`) REFERENCES `contractors` (`contractor_id`) ON DELETE SET NULL ON UPDATE CASCADE,
   CONSTRAINT `fk_mt_engineer` FOREIGN KEY (`engineer_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
   CONSTRAINT `fk_mt_floor` FOREIGN KEY (`floor_id`) REFERENCES `floors` (`floor_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
   CONSTRAINT `fk_mt_project` FOREIGN KEY (`project_id`) REFERENCES `projects` (`project_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
   CONSTRAINT `fk_mt_wing` FOREIGN KEY (`wing_id`) REFERENCES `wings` (`wing_id`) ON DELETE RESTRICT ON UPDATE CASCADE
 ) ENGINE=InnoDB AUTO_INCREMENT=751 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

-- ==========================================================
-- Relationships:
-- - material_id → materials_inventory(material_id)
--   Restricts deletion of materials that have transactions.
-- - Updates cascade automatically to keep relationships intact.
-- ==========================================================



-- =========================================================
-- Table: departments
-- Purpose: Stores department details for organizational
-- structure and assigns users to their respective departments.
-- Includes soft delete flag and timestamps for auditability.
-- =========================================================

CREATE TABLE `departments` (
   `department_id` int NOT NULL AUTO_INCREMENT,
   `department_name` varchar(100) NOT NULL,
   `department_head` varchar(100) DEFAULT NULL,
   `phone` varchar(15) DEFAULT NULL,
   `email` varchar(150) DEFAULT NULL,
   `location` varchar(150) DEFAULT NULL,
   `status` varchar(20) DEFAULT 'Active',
   `is_active` tinyint(1) DEFAULT '1' COMMENT 'Soft delete flag (FALSE = deleted/inactive)',
   `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
   `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   PRIMARY KEY (`department_id`),
   UNIQUE KEY `department_name` (`department_name`)
 ) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

-- ==========================================================
-- Relationships:
-- - Referenced by users(department_id)
-- - Each user must belong to an existing, active department
-- - Deletion restricted via soft delete (is_active flag)
-- ==========================================================



/* ------------------------------------------------------------------
   TABLE: rcc_slab_sheet
   PURPOSE:
     - Tracks slab casting activity for each floor, wing, and project.
     - Logs who checked the slab (junior/senior/architect/structural) 
       and when it was approved before casting.
     - Curing status and QC handled on frontend (15-day countdown rule).
     - Simplified check tracking: checked_by, check_status, check_date.
     - ENUMs avoided for simplicity — handled via dropdowns in UI.
     - Uses soft delete flag (is_deleted) for safe archival.
   ------------------------------------------------------------------ */

CREATE TABLE `rcc_slab_sheet` (
   `slab_id` int NOT NULL AUTO_INCREMENT,
   `project_id` int NOT NULL,
   `wing_id` int NOT NULL,
   `floor_id` int NOT NULL,
   `slab_no` varchar(50) NOT NULL,
   `casting_date` date DEFAULT NULL,
   `concrete_grade` varchar(20) DEFAULT NULL,
   `thickness` decimal(5,2) DEFAULT NULL,
   `curing_status` varchar(50) DEFAULT 'Pending',
   `remarks` text,
   `is_active` tinyint(1) DEFAULT '1' COMMENT 'Soft delete flag (FALSE = deleted/inactive)',
   `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
   `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   `str_eng_chk` date DEFAULT NULL,
   `site_eng_chk` date DEFAULT NULL,
   `sn_eng_chk` date DEFAULT NULL,
   `arc_chk` date DEFAULT NULL,
   PRIMARY KEY (`slab_id`),
   KEY `fk_project_slab` (`project_id`),
   KEY `fk_wing_slab` (`wing_id`),
   KEY `fk_floor_slab` (`floor_id`),
   CONSTRAINT `fk_floor_slab` FOREIGN KEY (`floor_id`) REFERENCES `floors` (`floor_id`) ON DELETE CASCADE ON UPDATE CASCADE,
   CONSTRAINT `fk_project_slab` FOREIGN KEY (`project_id`) REFERENCES `projects` (`project_id`) ON DELETE CASCADE ON UPDATE CASCADE,
   CONSTRAINT `fk_wing_slab` FOREIGN KEY (`wing_id`) REFERENCES `wings` (`wing_id`) ON DELETE CASCADE ON UPDATE CASCADE
 ) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

/* ------------------------------------------------------------------
   RELATIONSHIPS SUMMARY:
   - project_id  → projects(project_id)
   - wing_id     → wings(wing_id)
   - floor_id    → floors(floor_id)
   - checked_by  → users(user_id)
   Notes:
     * Frontend handles curing updates (15-day timer).
     * Dropdown UI will supply check_status and curing_status values.
   ------------------------------------------------------------------ */
   
   
   
   /* ------------------------------------------------------------------
   TABLE: rcc_column_sheet
   PURPOSE:
     - Records casting details for each RCC column.
     - Linked with project, wing, floor, and responsible engineer.
     - Reinforcement details optional — field kept for reference notes.
     - Status and checks handled via frontend forms.
     - Soft delete flag used for safe data removal.
   ------------------------------------------------------------------ */

CREATE TABLE `rcc_column_sheet` (
   `column_id` int NOT NULL AUTO_INCREMENT,
   `project_id` int NOT NULL,
   `wing_id` int NOT NULL,
   `floor_id` int NOT NULL,
   `column_no` varchar(50) NOT NULL,
   `concrete_grade` varchar(20) DEFAULT NULL,
   `size` varchar(50) DEFAULT NULL,
   `reinforcement_details` text,
   `casting_date` date DEFAULT NULL,
   `checked_by` int DEFAULT NULL,
   `check_status` varchar(50) DEFAULT NULL,
   `check_date` date DEFAULT NULL,
   `remarks` text,
   `is_active` tinyint(1) DEFAULT '1' COMMENT 'Soft delete flag (FALSE = deleted/inactive)',
   `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
   `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   PRIMARY KEY (`column_id`),
   KEY `fk_project_column` (`project_id`),
   KEY `fk_wing_column` (`wing_id`),
   KEY `fk_floor_column` (`floor_id`),
   KEY `fk_checked_by_column` (`checked_by`),
   CONSTRAINT `fk_checked_by_column` FOREIGN KEY (`checked_by`) REFERENCES `users` (`user_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
   CONSTRAINT `fk_floor_column` FOREIGN KEY (`floor_id`) REFERENCES `floors` (`floor_id`) ON DELETE CASCADE ON UPDATE CASCADE,
   CONSTRAINT `fk_project_column` FOREIGN KEY (`project_id`) REFERENCES `projects` (`project_id`) ON DELETE CASCADE ON UPDATE CASCADE,
   CONSTRAINT `fk_wing_column` FOREIGN KEY (`wing_id`) REFERENCES `wings` (`wing_id`) ON DELETE CASCADE ON UPDATE CASCADE
 ) ENGINE=InnoDB AUTO_INCREMENT=919 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

/* ------------------------------------------------------------------
   RELATIONSHIPS SUMMARY:
   - project_id   → projects(project_id)
   - wing_id      → wings(wing_id)
   - floor_id     → floors(floor_id)
   - checked_by   → users(user_id)
   Notes:
     * All checking roles (junior/senior/architect/structural) 
       are stored in users table for flexible referencing.
     * Status values come from frontend dropdowns.
   ------------------------------------------------------------------ */