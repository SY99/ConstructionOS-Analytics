USE ConstructionOs;

/* Material Inventory, Material_Stock_Summary and Material_Transaction */

SET FOREIGN_KEY_CHECKS = 0;
SET SQL_SAFE_UPDATES = 0;

/* Dropped All Materials Related table due to flawed logic*/
-- DROP TABLE MATERIAL_INVENTORY;
-- DROP TABLE MATERIAL_STOCK_SUMMARY;
-- DROP TABLE MATERIAL_TRANSACTIONS;


SELECT * FROM MATERIAL_INVENTORY;
SELECT * FROM MATERIAL_STOCK_SUMMARY;
SELECT * FROM MATERIAL_TRANSACTIONS;
SELECT DISTINCT material_id, unit_rate, tax_percent 
	FROM MATERIAL_TRANSACTIONS
    ORDER BY MATERIAL_ID ASC;
SELECT * FROM progress_tracking;


/* New Logic 
Material_Inventory = Materital_Definitions
Material_Transactions = All Movement of Materials - Received materials on site, issuance on site, returns, etc. */


/* New Material_Inventory. The Previous_File has been upated too. */
CREATE TABLE material_inventory (
    material_id INT AUTO_INCREMENT PRIMARY KEY,
    material_code VARCHAR(50) UNIQUE NOT NULL,   -- e.g., CEM-OPC-43, STEEL-TMT-12MM
    material_name VARCHAR(150) NOT NULL,         -- Human readable name
    category VARCHAR(100) NOT NULL,              -- Cement, Steel, Plumbing, Electrical
    unit VARCHAR(50) NOT NULL,                   -- bags, kg, tons, sq.ft, litre
    brand VARCHAR(100),                          -- optional e.g., Ultratech, JSW
    grade VARCHAR(100),                          -- M20, 43-Grade, 12mm, etc.
    remarks TEXT,
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Soft delete flag (FALSE = inactive)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


/* Adding Opening_Stock */
ALTER TABLE material_inventory
ADD COLUMN opening_stock DECIMAL(10,2) DEFAULT 0;

ALTER TABLE material_inventory 
MODIFY COLUMN opening_stock DECIMAL(10,2) DEFAULT 0 
AFTER grade;


/* Populating the Material_Inventory table */
INSERT INTO material_inventory (
    material_code,
    material_name,
    category,
    unit,
    brand,
    grade,
    remarks,
    is_active
) VALUES
-- === From your raw material sheet ===
('CEM-GGBS',              'GGBS Bags',                               'Cement & Binders',              'BAGS',  NULL,        'GGBS',             NULL, TRUE),
('CEM-OPC-43',            'OPC Cement Bags 43 Grade',               'Cement & Binders',              'BAGS',  NULL,        '43 Grade',         NULL, TRUE),
('CEM-PPC',               'PPC Cement Bags',                         'Cement & Binders',              'BAGS',  NULL,        'PPC',              NULL, TRUE),
('AGG-SAND-CRUSH',        'Crush Sand',                              'Aggregates',                    'BRASS', NULL,        NULL,              NULL, TRUE),
('AGG-METAL-20MM',        'Metal 20MM',                              'Aggregates',                    'BRASS', NULL,        '20MM',            NULL, TRUE),
('AGG-SAND-M',            'M-Sand',                                  'Aggregates',                    'BRASS', NULL,        NULL,              NULL, TRUE),
('CHEM-ADMIX-GEN',        'Admixture & Chemical',                    'Admixtures & Chemicals',        'NOS',   NULL,        NULL,              NULL, TRUE),
('REINF-FIBER-12MM',      'Fiber 12MM',                              'Reinforcement & Fibers',        'NOS',   NULL,        '12MM',            NULL, TRUE),
('REINF-FIBER-6MM',       'Fiber 6MM',                               'Reinforcement & Fibers',        'NOS',   NULL,        '6MM',             NULL, TRUE),
('REINF-METAL-10MM',      'Metal 10MM',                              'Reinforcement & Steel',         'BRASS', NULL,        '10MM',            'As per supplier sheet', TRUE),
('MORT-JOIN-40KG',        'Magicrete Joining Mortar Bag 40KG',       'Mortar & Masonry Products',     'BAGS',  'Magicrete', '40KG Bag',        NULL, TRUE),
('FUEL-DIESEL-RMC',       'Diesel RMC Plant',                        'Fuel & Consumables',            'LTR',   NULL,        NULL,              'Diesel for RMC plant', TRUE),
('FORM-EXP-SHEET',        'Expansion Sheet',                         'Formwork & Expansion',          'NOS',   NULL,        NULL,              NULL, TRUE),
('REINF-FIBER-MESH',      'Fiber Mesh',                              'Reinforcement & Fibers',        'ROLL',  NULL,        NULL,              NULL, TRUE),
('BRICK-RED-STD',         'Red Bricks',                              'Blocks & Bricks',               'NOS',   NULL,        'Standard',        NULL, TRUE),
('BLOCK-AAC-150',         'AAC Block 150MM',                         'Blocks & Bricks',               'NOS',   NULL,        '150MM',           NULL, TRUE),
('GROUT-GP2',             'GP2 Bag',                                 'Grouts & Repair Mortars',       'BAGS',  NULL,        'GP2',             NULL, TRUE),
('BRICK-FLASH-6IN',       'Flash Bricks 6\"',                        'Blocks & Bricks',               'NOS',   NULL,        '6 Inch',          NULL, TRUE),
('OIL-HYD-68',            'Hydraulic Oil 68',                        'Oils & Lubricants',             'LTR',   NULL,        '68 Grade',        NULL, TRUE),
('LUBE-GREASE-GEN',       'Grease',                                  'Oils & Lubricants',             'KG',    NULL,        NULL,              NULL, TRUE),
('CHEM-DRFIX-LW100',      'Dr Fixit LW+100 Super',                   'Waterproofing & Chemicals',     'KG',    'Dr Fixit',  'LW+100',          NULL, TRUE),

-- === Structural & RCC / Civil ===
('STEEL-TMT-8MM',         'TMT Steel Bar 8MM',                       'Reinforcement & Steel',         'KG',    NULL,        '8MM',             NULL, TRUE),
('STEEL-TMT-10MM',        'TMT Steel Bar 10MM',                      'Reinforcement & Steel',         'KG',    NULL,        '10MM',            NULL, TRUE),
('STEEL-TMT-12MM',        'TMT Steel Bar 12MM',                      'Reinforcement & Steel',         'KG',    NULL,        '12MM',            NULL, TRUE),
('STEEL-TMT-16MM',        'TMT Steel Bar 16MM',                      'Reinforcement & Steel',         'KG',    NULL,        '16MM',            NULL, TRUE),
('PLY-SHUTTER-12MM',      'Shuttering Plywood 12MM',                 'Formwork & Shuttering',         'SQFT',  NULL,        '12MM',            NULL, TRUE),
('PLY-SHUTTER-18MM',      'Shuttering Plywood 18MM',                 'Formwork & Shuttering',         'SQFT',  NULL,        '18MM',            NULL, TRUE),
('SUPPORT-PROP-ADJ',      'Adjustable Steel Props',                  'Formwork & Shuttering',         'NOS',   NULL,        NULL,              NULL, TRUE),
('CENTERING-CHANNEL',     'Centering Channels',                      'Formwork & Shuttering',         'KG',    NULL,        NULL,              NULL, TRUE),

-- === Blockwork & Masonry Support ===
('SAND-PLASTER',          'Plaster Sand',                            'Aggregates',                    'BRASS', NULL,        NULL,              NULL, TRUE),
('MORT-READY-MIX',        'Ready Mix Mortar (Block Jointing)',       'Mortar & Masonry Products',     'BAGS',  NULL,        NULL,              NULL, TRUE),

-- === Waterproofing System ===
('WTP-APP-MEM',           'APP Membrane Roll',                       'Waterproofing & Chemicals',     'ROLL',  NULL,        NULL,              NULL, TRUE),
('WTP-PRIMER',            'Waterproofing Primer',                    'Waterproofing & Chemicals',     'LTR',   NULL,        NULL,              NULL, TRUE),
('WTP-CHEM-SBR',          'SBR Latex',                               'Waterproofing & Chemicals',     'LTR',   NULL,        'SBR',             NULL, TRUE),

-- === Plumbing – Pipes & Fittings ===
('PLUMB-CPVC-25',         'CPVC Pipe 25MM',                          'Plumbing – Pipes & Fittings',   'MTR',   NULL,        '25MM',            NULL, TRUE),
('PLUMB-CPVC-32',         'CPVC Pipe 32MM',                          'Plumbing – Pipes & Fittings',   'MTR',   NULL,        '32MM',            NULL, TRUE),
('PLUMB-UPVC-SWR-110',    'uPVC SWR Pipe 110MM',                     'Plumbing – Pipes & Fittings',   'MTR',   NULL,        '110MM',           NULL, TRUE),
('PLUMB-CPVC-ELBOW-25',   'CPVC Elbow 25MM',                         'Plumbing – Pipes & Fittings',   'NOS',   NULL,        '25MM',            NULL, TRUE),
('PLUMB-CPVC-TEE-25',     'CPVC Tee 25MM',                           'Plumbing – Pipes & Fittings',   'NOS',   NULL,        '25MM',            NULL, TRUE),
('PLUMB-GI-BALLVALVE-25', 'GI Ball Valve 25MM',                      'Plumbing – Valves & Specials',  'NOS',   NULL,        '25MM',            NULL, TRUE),
('PLUMB-TRAP-FLOOR',      'Floor Trap (Nahani Trap)',                'Plumbing – Sanitary Fittings',  'NOS',   NULL,        NULL,              NULL, TRUE),

-- === CP Fittings & Sanitary (Premium) ===
('CP-BASIN-MIXER',        'Basin Mixer (CP Fitting)',                'Sanitary & CP Fittings',        'NOS',   NULL,        'Premium',         NULL, TRUE),
('CP-SHOWER-HEAD',        'Overhead Shower',                         'Sanitary & CP Fittings',        'NOS',   NULL,        NULL,              NULL, TRUE),
('CP-ANGLE-COCK',         'Angle Cock',                              'Sanitary & CP Fittings',        'NOS',   NULL,        NULL,              NULL, TRUE),
('SANIT-WC-WALLHUNG',     'Wall Hung WC',                            'Sanitary Ware',                 'NOS',   NULL,        'Wall Hung',       NULL, TRUE),
('SANIT-WASHBASIN',       'Wash Basin – Counter Top',                'Sanitary Ware',                 'NOS',   NULL,        'Counter Top',     NULL, TRUE),

-- === Electrical – Conduits & Boxes ===
('ELEC-COND-20',          'PVC Conduit Pipe 20MM',                   'Electrical – Conduits & Boxes', 'MTR',   NULL,        '20MM',            NULL, TRUE),
('ELEC-COND-25',          'PVC Conduit Pipe 25MM',                   'Electrical – Conduits & Boxes', 'MTR',   NULL,        '25MM',            NULL, TRUE),
('ELEC-COND-BEND',        'PVC Conduit Bend',                        'Electrical – Conduits & Boxes', 'NOS',   NULL,        NULL,              NULL, TRUE),
('ELEC-GI-BOX-1MOD',      'GI Switch Box 1M',                         'Electrical – Conduits & Boxes', 'NOS',   NULL,        '1 Module',        NULL, TRUE),
('ELEC-GI-BOX-6MOD',      'GI Switch Box 6M',                         'Electrical – Conduits & Boxes', 'NOS',   NULL,        '6 Module',        NULL, TRUE),
('ELEC-DB-12WAY',         'MCB Distribution Board 12 Way',           'Electrical – Panels & DBs',     'NOS',   NULL,        '12 Way',          NULL, TRUE),

-- === Electrical – Wires & Devices ===
('ELEC-WIRE-3C1.5',       'FRLS Wire 3C x 1.5 sqmm',                 'Electrical – Wires & Cables',   'MTR',   NULL,        '3C 1.5 sqmm',     NULL, TRUE),
('ELEC-WIRE-3C2.5',       'FRLS Wire 3C x 2.5 sqmm',                 'Electrical – Wires & Cables',   'MTR',   NULL,        '3C 2.5 sqmm',     NULL, TRUE),
('ELEC-SWITCH-1M',        'Modular Switch 1M',                        'Electrical – Switches & Plates','NOS',   NULL,        '1 Module',        NULL, TRUE),
('ELEC-SOCKET-6A',        'Modular Socket 6A',                        'Electrical – Switches & Plates','NOS',   NULL,        '6A',              NULL, TRUE),
('ELEC-PLATE-6MOD',       'Switch Plate 6M',                          'Electrical – Switches & Plates','NOS',   NULL,        '6 Module',        NULL, TRUE),
('ELEC-CEILING-LIGHT',    'LED Ceiling Light (Downlight)',           'Electrical – Fixtures',         'NOS',   NULL,        'LED',             NULL, TRUE),
('ELEC-FAN-CEILING',      'Ceiling Fan',                             'Electrical – Fixtures',         'NOS',   NULL,        NULL,              NULL, TRUE),

-- === Flooring – Tiles, Stone, Skirting ===
('TILE-FL-600x600-PORC',  'Floor Tile Porcelain 600x600',            'Flooring – Tiles & Stone',      'SQFT',  NULL,        '600x600',         NULL, TRUE),
('TILE-WALL-300x600',     'Wall Tile Ceramic 300x600',               'Flooring – Tiles & Stone',      'SQFT',  NULL,        '300x600',         NULL, TRUE),
('TILE-SKIRT-100',        'Skirting Tile 100MM',                     'Flooring – Tiles & Stone',      'MTR',   NULL,        '100MM',           NULL, TRUE),
('STONE-GRANITE-KITCH',   'Granite Slab – Kitchen Platform',         'Flooring – Tiles & Stone',      'SQFT',  NULL,        'Granite',         NULL, TRUE),
('STONE-MARBLE-LOBBY',    'Marble – Lobby Flooring',                 'Flooring – Tiles & Stone',      'SQFT',  NULL,        'Premium Marble',  NULL, TRUE),

-- === Carpentry & Hardware ===
('WOOD-DOOR-FRAME',       'Door Frame – Hardwood',                   'Carpentry & Joinery',           'NOS',   NULL,        NULL,              NULL, TRUE),
('WOOD-DOOR-SHUTTER',     'Door Shutter Flush',                      'Carpentry & Joinery',           'NOS',   NULL,        NULL,              NULL, TRUE),
('HARD-DOOR-HINGE',       'Door Hinge SS',                           'Carpentry & Hardware',          'NOS',   NULL,        'Stainless Steel', NULL, TRUE),
('HARD-DOOR-LOCK',        'Mortise Lock Set',                        'Carpentry & Hardware',          'NOS',   NULL,        NULL,              NULL, TRUE),
('HARD-DOOR-HANDLE',      'Lever Handle SS',                         'Carpentry & Hardware',          'NOS',   NULL,        'Stainless Steel', NULL, TRUE),

-- === Windows, Glazing & Railings ===
('ALUM-WINDOW-FRAME',     'Aluminium Window Frame',                  'Windows & Glazing',             'SQFT',  NULL,        'Powder Coated',   NULL, TRUE),
('ALUM-SLIDING-SHUTTER',  'Aluminium Sliding Shutter',               'Windows & Glazing',             'SQFT',  NULL,        NULL,              NULL, TRUE),
('GLASS-TOUGH-12MM',      'Toughened Glass 12MM',                    'Windows & Glazing',             'SQFT',  NULL,        '12MM',            NULL, TRUE),
('RAILING-SS-BALCONY',    'SS Balcony Railing',                      'Windows & Glazing',             'RFT',   NULL,        NULL,              NULL, TRUE),

-- === Paints, Putty, POP & Ceilings ===
('PAINT-PRIMER-INT',      'Interior Wall Primer',                    'Paints & Finishes',             'LTR',   NULL,        NULL,              NULL, TRUE),
('PAINT-EMULSION-INT',    'Interior Emulsion Paint',                 'Paints & Finishes',             'LTR',   NULL,        NULL,              NULL, TRUE),
('PAINT-EMULSION-EXT',    'Exterior Emulsion Paint',                 'Paints & Finishes',             'LTR',   NULL,        NULL,              NULL, TRUE),
('PUTTY-WALL',            'Wall Putty',                              'Paints & Finishes',             'KG',    NULL,        NULL,              NULL, TRUE),
('POP-BAG',               'POP Bag',                                 'Ceilings & Drywall',            'KG',    NULL,        NULL,              NULL, TRUE),
('GYPSUM-BOARD-12MM',     'Gypsum Board 12MM',                       'Ceilings & Drywall',            'SQFT',  NULL,        '12MM',            NULL, TRUE),
('CEILING-GRID',          'Ceiling T-Grid System',                   'Ceilings & Drywall',            'RFT',   NULL,        NULL,              NULL, TRUE),

-- === Miscellaneous / Site Consumables ===
('TAPE-MASKING',          'Masking Tape',                            'Miscellaneous Consumables',     'NOS',   NULL,        NULL,              NULL, TRUE),
('COVER-BLOCKS',          'Concrete Cover Blocks',                   'Miscellaneous Consumables',     'NOS',   NULL,        NULL,              NULL, TRUE),
('WIRE-BINDING',          'Binding Wire',                            'Miscellaneous Consumables',     'KG',    NULL,        NULL,              NULL, TRUE),
('NAIL-50MM',             'Nails 50MM',                              'Miscellaneous Consumables',     'KG',    NULL,        '50MM',            NULL, TRUE);


/* Updating Opening_Stock in the Material_Inventory */
UPDATE material_inventory SET opening_stock = 738 WHERE material_id = 1;
UPDATE material_inventory SET opening_stock = 925 WHERE material_id = 2;
UPDATE material_inventory SET opening_stock = 519 WHERE material_id = 3;
UPDATE material_inventory SET opening_stock = 217 WHERE material_id = 4;
UPDATE material_inventory SET opening_stock = 187 WHERE material_id = 5;
UPDATE material_inventory SET opening_stock = 219 WHERE material_id = 6;
UPDATE material_inventory SET opening_stock = 251 WHERE material_id = 7;
UPDATE material_inventory SET opening_stock = 224 WHERE material_id = 8;
UPDATE material_inventory SET opening_stock = 128 WHERE material_id = 9;
UPDATE material_inventory SET opening_stock = 13758 WHERE material_id = 10;
UPDATE material_inventory SET opening_stock = 441 WHERE material_id = 11;
UPDATE material_inventory SET opening_stock = 784 WHERE material_id = 12;
UPDATE material_inventory SET opening_stock = 167 WHERE material_id = 13;
UPDATE material_inventory SET opening_stock = 164 WHERE material_id = 14;
UPDATE material_inventory SET opening_stock = 1244 WHERE material_id = 15;
UPDATE material_inventory SET opening_stock = 1502 WHERE material_id = 16;
UPDATE material_inventory SET opening_stock = 320 WHERE material_id = 17;
UPDATE material_inventory SET opening_stock = 1420 WHERE material_id = 18;
UPDATE material_inventory SET opening_stock = 571 WHERE material_id = 19;
UPDATE material_inventory SET opening_stock = 624 WHERE material_id = 20;
UPDATE material_inventory SET opening_stock = 242 WHERE material_id = 21;
UPDATE material_inventory SET opening_stock = 135 WHERE material_id = 22;
UPDATE material_inventory SET opening_stock = 218 WHERE material_id = 23;
UPDATE material_inventory SET opening_stock = 183 WHERE material_id = 24;
UPDATE material_inventory SET opening_stock = 110 WHERE material_id = 25;
UPDATE material_inventory SET opening_stock = 279 WHERE material_id = 26;
UPDATE material_inventory SET opening_stock = 451 WHERE material_id = 27;
UPDATE material_inventory SET opening_stock = 127 WHERE material_id = 28;
UPDATE material_inventory SET opening_stock = 227 WHERE material_id = 29;
UPDATE material_inventory SET opening_stock = 132 WHERE material_id = 30;
UPDATE material_inventory SET opening_stock = 119 WHERE material_id = 31;
UPDATE material_inventory SET opening_stock = 369 WHERE material_id = 32;
UPDATE material_inventory SET opening_stock = 489 WHERE material_id = 33;
UPDATE material_inventory SET opening_stock = 222 WHERE material_id = 34;
UPDATE material_inventory SET opening_stock = 209 WHERE material_id = 35;
UPDATE material_inventory SET opening_stock = 824 WHERE material_id = 36;
UPDATE material_inventory SET opening_stock = 279 WHERE material_id = 37;
UPDATE material_inventory SET opening_stock = 380 WHERE material_id = 38;
UPDATE material_inventory SET opening_stock = 282 WHERE material_id = 39;
UPDATE material_inventory SET opening_stock = 326 WHERE material_id = 40;
UPDATE material_inventory SET opening_stock = 106 WHERE material_id = 41;
UPDATE material_inventory SET opening_stock = 132 WHERE material_id = 42;
UPDATE material_inventory SET opening_stock = 492 WHERE material_id = 43;
UPDATE material_inventory SET opening_stock = 216 WHERE material_id = 44;
UPDATE material_inventory SET opening_stock = 211 WHERE material_id = 45;
UPDATE material_inventory SET opening_stock = 352 WHERE material_id = 46;
UPDATE material_inventory SET opening_stock = 418 WHERE material_id = 47;
UPDATE material_inventory SET opening_stock = 406 WHERE material_id = 48;
UPDATE material_inventory SET opening_stock = 343 WHERE material_id = 49;
UPDATE material_inventory SET opening_stock = 324 WHERE material_id = 50;
UPDATE material_inventory SET opening_stock = 15422 WHERE material_id = 51;
UPDATE material_inventory SET opening_stock = 13978 WHERE material_id = 52;
UPDATE material_inventory SET opening_stock = 16855 WHERE material_id = 53;
UPDATE material_inventory SET opening_stock = 19340 WHERE material_id = 54;
UPDATE material_inventory SET opening_stock = 18744 WHERE material_id = 55;
UPDATE material_inventory SET opening_stock = 220 WHERE material_id = 56;
UPDATE material_inventory SET opening_stock = 407 WHERE material_id = 57;
UPDATE material_inventory SET opening_stock = 267 WHERE material_id = 58;
UPDATE material_inventory SET opening_stock = 399 WHERE material_id = 59;
UPDATE material_inventory SET opening_stock = 452 WHERE material_id = 60;
UPDATE material_inventory SET opening_stock = 188 WHERE material_id = 61;
UPDATE material_inventory SET opening_stock = 211 WHERE material_id = 62;
UPDATE material_inventory SET opening_stock = 180 WHERE material_id = 63;
UPDATE material_inventory SET opening_stock = 310 WHERE material_id = 64;
UPDATE material_inventory SET opening_stock = 427 WHERE material_id = 65;
UPDATE material_inventory SET opening_stock = 366 WHERE material_id = 66;
UPDATE material_inventory SET opening_stock = 492 WHERE material_id = 67;
UPDATE material_inventory SET opening_stock = 223 WHERE material_id = 68;
UPDATE material_inventory SET opening_stock = 115 WHERE material_id = 69;
UPDATE material_inventory SET opening_stock = 160 WHERE material_id = 70;
UPDATE material_inventory SET opening_stock = 276 WHERE material_id = 71;
UPDATE material_inventory SET opening_stock = 402 WHERE material_id = 72;
UPDATE material_inventory SET opening_stock = 149 WHERE material_id = 73;
UPDATE material_inventory SET opening_stock = 211 WHERE material_id = 74;
UPDATE material_inventory SET opening_stock = 454 WHERE material_id = 75;
UPDATE material_inventory SET opening_stock = 201 WHERE material_id = 76;
UPDATE material_inventory SET opening_stock = 268 WHERE material_id = 77;
UPDATE material_inventory SET opening_stock = 311 WHERE material_id = 78;
UPDATE material_inventory SET opening_stock = 226 WHERE material_id = 79;
UPDATE material_inventory SET opening_stock = 316 WHERE material_id = 80;
UPDATE material_inventory SET opening_stock = 144 WHERE material_id = 81;
UPDATE material_inventory SET opening_stock = 371 WHERE material_id = 82;
UPDATE material_inventory SET opening_stock = 288 WHERE material_id = 83;
UPDATE material_inventory SET opening_stock = 422 WHERE material_id = 84;



/* Creating Material_Transactions table. It stores all the movememtn related to materials on the site*/
CREATE TABLE material_transactions (
    txn_id INT AUTO_INCREMENT PRIMARY KEY,
    material_id INT NOT NULL,
    
    txn_date DATE NOT NULL,
    transaction_type VARCHAR(50) NOT NULL,  -- 'RECEIPT', 'ISSUE', 'RETURN', 'GATE-IN', 'GATE-OUT'
    
    reference_no VARCHAR(50),               -- Can store challan, invoice, or internal issue slip #
    
    unit VARCHAR(50) NOT NULL,
    received_qty DECIMAL(10,2) DEFAULT 0,
    issued_qty DECIMAL(10,2) DEFAULT 0,
    
    -- Cost tracking
    unit_rate DECIMAL(12,2) DEFAULT 0,
    tax_percent DECIMAL(6,2) DEFAULT 0,
    total_cost DECIMAL(12,2) DEFAULT 0,     -- frontend will compute received_qty * unit_rate
    
    -- Site allocation data
    project_id INT NULL,
    wing_id INT NULL,
    floor_id INT NULL,
    contractor_id INT NULL,
    engineer_id INT NULL,
    work_description VARCHAR(150),
    
    remarks TEXT,
    is_active BOOLEAN DEFAULT TRUE,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_material FOREIGN KEY (material_id)
        REFERENCES material_inventory(material_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);



/* Removing */
ALTER TABLE material_transactions
ADD COLUMN project_id INT NULL,
ADD COLUMN wing_id INT NULL,
ADD COLUMN floor_id INT NULL,
ADD COLUMN contractor_id INT NULL,
ADD COLUMN engineer_id INT NULL;

ALTER TABLE material_transactions
DROP COLUMN wing,
DROP COLUMN floor_no;

ALTER TABLE material_transactions
ADD CONSTRAINT fk_mt_project
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
ADD CONSTRAINT fk_mt_wing
    FOREIGN KEY (wing_id) REFERENCES wings(wing_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
ADD CONSTRAINT fk_mt_floor
    FOREIGN KEY (floor_id) REFERENCES floors(floor_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
ADD CONSTRAINT fk_mt_contractor
    FOREIGN KEY (contractor_id) REFERENCES contractors(contractor_id)
    ON DELETE SET NULL ON UPDATE CASCADE,
ADD CONSTRAINT fk_mt_engineer
    FOREIGN KEY (engineer_id) REFERENCES users(user_id)
    ON DELETE SET NULL ON UPDATE CASCADE;


INSERT INTO material_transactions (
    material_id, txn_date, transaction_type, reference_no, unit,
    received_qty, issued_qty, unit_rate, tax_percent, total_cost,
    project_id, wing_id, floor_id, contractor_id, engineer_id,
    work_description, remarks, is_active
)
VALUES
(12, '2024-01-05', 'RECEIPT', 'CH-1045', 'BAGS', 150, 0, 320, 18, 56640, 1, 1, 7, 3, 14, 'Diesel supply for RMC', 'Received from vendor', 1),
(3, '2024-01-07', 'RECEIPT', 'CH-1049', 'BAGS', 200, 0, 345, 18, 81420, 1, 1, 7, 2, 15, 'PPC cement inbound', 'Unloaded near pump room', 1),
(5, '2024-01-09', 'ISSUE', 'IS-0001', 'BRASS', 0, 4, 0, 0, 0, 1, 1, 7, 5, 19, 'Metal issued for leveling', 'Issued to masonry team', 1),
(15, '2024-01-10', 'RECEIPT', 'CH-1051', 'NOS', 3000, 0, 7, 5, 22050, 1, 1, 8, 6, 18, 'Red brick delivery', 'Full truck load', 1),
(15, '2024-01-12', 'ISSUE', 'IS-0003', 'NOS', 0, 1200, 7, 5, 0, 1, 1, 8, 6, 21, 'Brick issued for wall layout', 'Issued to civil team', 1),
(1, '2024-01-14', 'RECEIPT', 'CH-1054', 'BAGS', 180, 0, 345, 18, 73332, 1, 1, 8, 4, 11, 'GGBS received', 'For slab curing mix', 1),
(7, '2024-01-16', 'RECEIPT', 'CH-1055', 'NOS', 40, 0, 1200, 18, 56640, 1, 1, 9, 3, 14, 'Chemical admixture', 'Delivery from Chembur warehouse', 1),
(7, '2024-01-18', 'ISSUE', 'IS-0006', 'NOS', 0, 10, 1200, 18, 0, 1, 1, 9, 3, 14, 'Issued for slab waterproofing', 'Used on site', 1),
(11, '2024-01-20', 'RECEIPT', 'CH-1059', 'BAGS', 400, 0, 240, 18, 113280, 1, 1, 9, 7, 16, 'Magicrete mortar', 'Stacked near hoist', 1),
(11, '2024-01-21', 'ISSUE', 'IS-0011', 'BAGS', 0, 150, 240, 18, 0, 1, 1, 9, 7, 16, 'Mortar issued for brickwork', 'Used by masonry team', 1),

-- continuing…

(4, '2024-01-23', 'RECEIPT', 'CH-1064', 'BRASS', 18, 0, 2100, 18, 44676, 1, 1, 10, 1, 12, 'Crush sand supply', NULL, 1),
(4, '2024-01-24', 'ISSUE', 'IS-0015', 'BRASS', 0, 6, 2100, 18, 0, 1, 1, 10, 1, 12, 'Plaster base layer sand issue', NULL, 1),
(10, '2024-01-27', 'RECEIPT', 'CH-1070', 'BRASS', 7, 0, 2600, 18, 21476, 1, 1, 10, 4, 13, 'Metal 10mm received', NULL, 1),
(14, '2024-01-28', 'ISSUE', 'IS-0019', 'ROLL', 0, 12, 1500, 18, 0, 1, 1, 11, 6, 20, 'Fiber mesh issued', NULL, 1),
(13, '2024-01-29', 'RECEIPT', 'CH-1074', 'NOS', 50, 0, 900, 18, 53100, 1, 1, 11, 5, 22, 'Expansion sheets delivered', NULL, 1),

-- 20th row…

(16, '2024-02-02', 'RECEIPT', 'CH-1081', 'NOS', 2500, 0, 9, 5, 23625, 1, 1, 12, 3, 17, 'AAC blocks 150mm', NULL, 1),
(16, '2024-02-04', 'ISSUE', 'IS-0023', 'NOS', 0, 800, 9, 5, 0, 1, 1, 12, 3, 17, 'Blockwork internal walls', NULL, 1),
(17, '2024-02-06', 'RECEIPT', 'CH-1085', 'BAGS', 120, 0, 425, 18, 60240, 1, 1, 13, 7, 14, 'GP2 Grout received', NULL, 1),
(17, '2024-02-07', 'ISSUE', 'IS-0026', 'BAGS', 0, 40, 425, 18, 0, 1, 1, 13, 7, 14, 'Grout for column repairs', NULL, 1),

-- Continue all the way to 75...

(5, '2024-03-10', 'ISSUE', 'IS-0068', 'BRASS', 0, 3, 2100, 18, 0, 1, 1, 36, 3, 20, 'Metal issued for beam shuttering', NULL, 1),
(12, '2024-03-12', 'RECEIPT', 'CH-1159', 'LTR', 1000, 0, 95, 18, 112100, 1, 1, 36, 4, 23, 'Diesel top-up tank', NULL, 1),
(15, '2024-03-13', 'ISSUE', 'IS-0071', 'NOS', 0, 500, 7, 5, 0, 1, 1, 36, 6, 21, 'Brick issuing top floors', NULL, 1),
(7, '2024-03-14', 'ISSUE', 'IS-0072', 'NOS', 0, 9, 1200, 18, 0, 1, 1, 36, 6, 17, 'Chemical issued for curing', NULL, 1),
(3, '2024-03-15', 'RECEIPT', 'CH-1162', 'BAGS', 150, 0, 345, 18, 81420, 1, 1, 36, 2, 12, 'PPC cement delivered', NULL, 1);


select * from material_transactions;
delete from material_transactions;
truncate table material_transactions;

set sql_safe_updates = 0;

select * from users 
	where role like "%Engineer%";


INSERT INTO material_transactions (material_id, txn_date, 
transaction_type, reference_no, unit, 
received_qty, issued_qty, unit_rate, 
tax_percent, total_cost, project_id, wing_id, 
floor_id, contractor_id, engineer_id, 
work_description, remarks, is_active)
VALUES
( 51, '2025-03-02', 'RECEIPT', 'RC-2503-0001', 'NOS', 115, 0, 230, 0, 26450, 1, 1, 46, 1, 61, 'Auto generated entry', 'OK', TRUE ),
( 7, '2023-04-05', 'RECEIPT', 'RC-2304-0002', 'NOS', 119, 0, 560, 0, 66640, 1, 1, 20, 5, 54, 'Auto generated entry', 'OK', TRUE ),
( 36, '2023-04-29', 'RECEIPT', 'RC-2304-0003', 'MTR', 78, 0, 678, 0, 52884, 1, 1, 6, 6, 78, 'Auto generated entry', 'OK', TRUE ),
( 33, '2024-07-25', 'ISSUE', 'IS-2407-0004', 'LTR', 0, 15, 131, 0, 1965, 1, 1, 22, 1, 3, 'Auto generated entry', 'OK', TRUE ),
( 51, '2024-12-11', 'RECEIPT', 'RC-2412-0005', 'NOS', 194, 0, 546, 0, 105924, 1, 1, 31, 2, 53, 'Auto generated entry', 'OK', TRUE ),
( 52, '2024-11-22', 'ISSUE', 'IS-2411-0006', 'NOS', 0, 95, 137, 0, 13015, 1, 1, 2, 6, 49, 'Auto generated entry', 'OK', TRUE ),
( 28, '2025-01-29', 'ISSUE', 'IS-2501-0007', 'NOS', 0, 96, 155, 0, 14880, 1, 1, 11, 7, 48, 'Auto generated entry', 'OK', TRUE ),
( 33, '2023-12-05', 'ISSUE', 'IS-2312-0008', 'LTR', 0, 26, 779, 0, 20254, 1, 1, 17, 2, 58, 'Auto generated entry', 'OK', TRUE ),
( 73, '2025-02-24', 'RECEIPT', 'RC-2502-0009', 'RFT', 186, 0, 719, 0, 133734, 1, 1, 29, 7, 19, 'Auto generated entry', 'OK', TRUE ),
( 52, '2023-09-18', 'RECEIPT', 'RC-2309-0010', 'NOS', 165, 0, 227, 0, 37455, 1, 1, 33, 7, 50, 'Auto generated entry', 'OK', TRUE ),
( 77, '2023-08-02', 'RECEIPT', 'RC-2308-0011', 'KG', 52, 0, 161, 0, 8372, 1, 1, 7, 11, 23, 'Auto generated entry', 'OK', TRUE ),
( 77, '2024-12-10', 'ISSUE', 'IS-2412-0012', 'KG', 0, 45, 404, 0, 18180, 1, 1, 18, 3, 59, 'Auto generated entry', 'OK', TRUE ),
( 46, '2023-11-04', 'RECEIPT', 'RC-2311-0013', 'NOS', 49, 0, 469, 0, 22981, 1, 1, 12, 9, 53, 'Auto generated entry', 'OK', TRUE ),
( 82, '2025-02-14', 'RECEIPT', 'RC-2502-0014', 'NOS', 135, 0, 264, 0, 35640, 1, 1, 48, 3, 19, 'Auto generated entry', 'OK', TRUE ),
( 68, '2023-09-06', 'ISSUE', 'IS-2309-0015', 'NOS', 0, 45, 577, 0, 25965, 1, 1, 4, 9, 57, 'Auto generated entry', 'OK', TRUE ),
( 1, '2024-10-29', 'ISSUE', 'IS-2410-0016', 'BAGS', 0, 82, 298, 0, 24436, 1, 1, 16, 9, 56, 'Auto generated entry', 'OK', TRUE ),
( 46, '2024-03-07', 'ISSUE', 'IS-2403-0017', 'NOS', 0, 49, 91, 0, 4459, 1, 1, 24, 11, 17, 'Auto generated entry', 'OK', TRUE ),
( 28, '2023-10-09', 'RECEIPT', 'RC-2310-0018', 'NOS', 146, 0, 226, 0, 32996, 1, 1, 47, 11, 23, 'Auto generated entry', 'OK', TRUE ),
( 11, '2024-07-29', 'ISSUE', 'IS-2407-0019', 'BAGS', 0, 57, 491, 0, 27987, 1, 1, 37, 11, 52, 'Auto generated entry', 'OK', TRUE ),
( 41, '2025-04-18', 'ISSUE', 'IS-2504-0020', 'NOS', 0, 97, 295, 0, 28615, 1, 1, 9, 4, 62, 'Auto generated entry', 'OK', TRUE ),
( 39, '2023-01-01', 'RECEIPT', 'RC-2301-0021', 'NOS', 123, 0, 664, 0, 81672, 1, 1, 4, 4, 59, 'Auto generated entry', 'OK', TRUE ),
( 61, '2024-08-31', 'ISSUE', 'IS-2408-0022', 'SQFT', 0, 118, 345, 0, 40710, 1, 1, 11, 8, 57, 'Auto generated entry', 'OK', TRUE ),
( 83, '2024-01-08', 'ISSUE', 'IS-2401-0023', 'KG', 0, 54, 396, 0, 21384, 1, 1, 15, 10, 60, 'Auto generated entry', 'OK', TRUE ),
( 82, '2024-01-31', 'RECEIPT', 'RC-2401-0024', 'NOS', 172, 0, 491, 0, 84452, 1, 1, 36, 5, 17, 'Auto generated entry', 'OK', TRUE ),
( 51, '2023-03-17', 'RECEIPT', 'RC-2303-0025', 'NOS', 22, 0, 328, 0, 7216, 1, 1, 7, 3, 57, 'Auto generated entry', 'OK', TRUE ),
( 72, '2025-06-02', 'ISSUE', 'IS-2506-0026', 'SQFT', 0, 57, 569, 0, 32433, 1, 1, 4, 11, 78, 'Auto generated entry', 'OK', TRUE ),
( 77, '2024-04-03', 'ISSUE', 'IS-2404-0027', 'KG', 0, 60, 126, 0, 7560, 1, 1, 6, 9, 56, 'Auto generated entry', 'OK', TRUE ),
( 44, '2023-12-10', 'RECEIPT', 'RC-2312-0028', 'NOS', 159, 0, 756, 0, 120204, 1, 1, 16, 8, 25, 'Auto generated entry', 'OK', TRUE ),
( 14, '2024-11-05', 'ISSUE', 'IS-2411-0029', 'ROLL', 0, 56, 132, 0, 7392, 1, 1, 21, 8, 50, 'Auto generated entry', 'OK', TRUE ),
( 29, '2024-10-22', 'ISSUE', 'IS-2410-0030', 'KG', 0, 55, 82, 0, 4510, 1, 1, 7, 3, 54, 'Auto generated entry', 'OK', TRUE ),
( 30, '2023-03-23', 'RECEIPT', 'RC-2303-0031', 'BRASS', 97, 0, 252, 0, 24444, 1, 1, 25, 8, 52, 'Auto generated entry', 'OK', TRUE ),
( 55, '2023-01-01', 'RECEIPT', 'RC-2301-0032', 'NOS', 58, 0, 123, 0, 7134, 1, 1, 43, 1, 50, 'Auto generated entry', 'OK', TRUE ),
( 38, '2024-06-23', 'RECEIPT', 'RC-2406-0033', 'NOS', 144, 0, 473, 0, 68112, 1, 1, 22, 5, 78, 'Auto generated entry', 'OK', TRUE ),
( 77, '2023-07-05', 'RECEIPT', 'RC-2307-0034', 'KG', 8, 0, 557, 0, 4456, 1, 1, 51, 7, 61, 'Auto generated entry', 'OK', TRUE ),
( 6, '2024-11-03', 'ISSUE', 'IS-2411-0035', 'BRASS', 0, 105, 314, 0, 32970, 1, 1, 38, 7, 60, 'Auto generated entry', 'OK', TRUE ),
( 53, '2023-05-24', 'ISSUE', 'IS-2305-0036', 'MTR', 0, 18, 484, 0, 8712, 1, 1, 8, 2, 51, 'Auto generated entry', 'OK', TRUE ),
( 14, '2024-07-04', 'ISSUE', 'IS-2407-0037', 'ROLL', 0, 118, 111, 0, 13098, 1, 1, 19, 11, 56, 'Auto generated entry', 'OK', TRUE ),
( 34, '2024-03-27', 'RECEIPT', 'RC-2403-0038', 'LTR', 175, 0, 249, 0, 43575, 1, 1, 34, 6, 60, 'Auto generated entry', 'OK', TRUE ),
( 40, '2023-10-23', 'ISSUE', 'IS-2310-0039', 'NOS', 0, 40, 156, 0, 6240, 1, 1, 22, 9, 19, 'Auto generated entry', 'OK', TRUE ),
( 65, '2024-02-24', 'RECEIPT', 'RC-2402-0040', 'NOS', 30, 0, 345, 0, 10350, 1, 1, 33, 2, 5, 'Auto generated entry', 'OK', TRUE ),
( 65, '2025-06-04', 'RECEIPT', 'RC-2506-0041', 'NOS', 31, 0, 349, 0, 10819, 1, 1, 6, 11, 50, 'Auto generated entry', 'OK', TRUE ),
( 61, '2024-10-30', 'ISSUE', 'IS-2410-0042', 'SQFT', 0, 23, 342, 0, 7866, 1, 1, 1, 1, 49, 'Auto generated entry', 'OK', TRUE ),
( 69, '2024-02-29', 'RECEIPT', 'RC-2402-0043', 'NOS', 169, 0, 752, 0, 127088, 1, 1, 46, 10, 60, 'Auto generated entry', 'OK', TRUE ),
( 51, '2024-07-30', 'RECEIPT', 'RC-2407-0044', 'NOS', 137, 0, 719, 0, 98503, 1, 1, 38, 1, 52, 'Auto generated entry', 'OK', TRUE ),
( 54, '2024-03-16', 'RECEIPT', 'RC-2403-0045', 'MTR', 69, 0, 468, 0, 32292, 1, 1, 44, 10, 3, 'Auto generated entry', 'OK', TRUE ),
( 57, '2024-11-09', 'ISSUE', 'IS-2411-0046', 'NOS', 0, 56, 232, 0, 12992, 1, 1, 12, 6, 61, 'Auto generated entry', 'OK', TRUE ),
( 81, '2024-11-25', 'ISSUE', 'IS-2411-0047', 'NOS', 0, 89, 721, 0, 64169, 1, 1, 4, 6, 53, 'Auto generated entry', 'OK', TRUE ),
( 60, '2024-06-24', 'RECEIPT', 'RC-2406-0048', 'SQFT', 5, 0, 773, 0, 3865, 1, 1, 42, 2, 23, 'Auto generated entry', 'OK', TRUE ),
( 42, '2023-04-10', 'RECEIPT', 'RC-2304-0049', 'NOS', 63, 0, 109, 0, 6867, 1, 1, 48, 3, 25, 'Auto generated entry', 'OK', TRUE ),
( 69, '2023-05-31', 'ISSUE', 'IS-2305-0050', 'NOS', 0, 47, 548, 0, 25756, 1, 1, 44, 11, 48, 'Auto generated entry', 'OK', TRUE ),
( 24, '2024-01-14', 'RECEIPT', 'RC-2401-0051', 'KG', 129, 0, 262, 0, 33798, 1, 1, 1, 7, 56, 'Auto generated entry', 'OK', TRUE ),
( 64, '2024-07-29', 'ISSUE', 'IS-2407-0052', 'SQFT', 0, 19, 458, 0, 8702, 1, 1, 8, 10, 60, 'Auto generated entry', 'OK', TRUE ),
( 61, '2024-08-03', 'ISSUE', 'IS-2408-0053', 'SQFT', 0, 48, 291, 0, 13968, 1, 1, 9, 4, 14, 'Auto generated entry', 'OK', TRUE ),
( 63, '2023-12-20', 'ISSUE', 'IS-2312-0054', 'SQFT', 0, 9, 757, 0, 6813, 1, 1, 35, 8, 3, 'Auto generated entry', 'OK', TRUE ),
( 38, '2023-02-22', 'RECEIPT', 'RC-2302-0055', 'NOS', 109, 0, 520, 0, 56680, 1, 1, 15, 11, 19, 'Auto generated entry', 'OK', TRUE ),
( 42, '2025-02-27', 'RECEIPT', 'RC-2502-0056', 'NOS', 188, 0, 57, 0, 10716, 1, 1, 3, 1, 23, 'Auto generated entry', 'OK', TRUE ),
( 36, '2025-04-24', 'RECEIPT', 'RC-2504-0057', 'MTR', 160, 0, 336, 0, 53760, 1, 1, 35, 4, 59, 'Auto generated entry', 'OK', TRUE ),
( 74, '2024-04-16', 'RECEIPT', 'RC-2404-0058', 'LTR', 170, 0, 130, 0, 22100, 1, 1, 50, 11, 17, 'Auto generated entry', 'OK', TRUE ),
( 42, '2024-08-12', 'RECEIPT', 'RC-2408-0059', 'NOS', 141, 0, 506, 0, 71346, 1, 1, 7, 8, 62, 'Auto generated entry', 'OK', TRUE ),
( 83, '2024-04-18', 'ISSUE', 'IS-2404-0060', 'KG', 0, 75, 405, 0, 30375, 1, 1, 10, 1, 61, 'Auto generated entry', 'OK', TRUE ),
( 35, '2024-12-19', 'RECEIPT', 'RC-2412-0061', 'MTR', 15, 0, 725, 0, 10875, 1, 1, 50, 9, 55, 'Auto generated entry', 'OK', TRUE ),
( 75, '2025-01-30', 'ISSUE', 'IS-2501-0062', 'LTR', 0, 66, 649, 0, 42834, 1, 1, 49, 10, 58, 'Auto generated entry', 'OK', TRUE ),
( 78, '2023-07-04', 'RECEIPT', 'RC-2307-0063', 'KG', 176, 0, 336, 0, 59136, 1, 1, 4, 7, 57, 'Auto generated entry', 'OK', TRUE ),
( 59, '2024-12-28', 'RECEIPT', 'RC-2412-0064', 'NOS', 117, 0, 375, 0, 43875, 1, 1, 9, 6, 62, 'Auto generated entry', 'OK', TRUE ),
( 32, '2024-05-12', 'RECEIPT', 'RC-2405-0065', 'ROLL', 15, 0, 76, 0, 1140, 1, 1, 24, 2, 50, 'Auto generated entry', 'OK', TRUE ),
( 9, '2023-04-14', 'RECEIPT', 'RC-2304-0066', 'NOS', 124, 0, 620, 0, 76880, 1, 1, 46, 8, 21, 'Auto generated entry', 'OK', TRUE ),
( 34, '2024-04-21', 'RECEIPT', 'RC-2404-0067', 'LTR', 54, 0, 382, 0, 20628, 1, 1, 22, 8, 61, 'Auto generated entry', 'OK', TRUE ),
( 46, '2023-08-20', 'ISSUE', 'IS-2308-0068', 'NOS', 0, 73, 153, 0, 11169, 1, 1, 11, 10, 23, 'Auto generated entry', 'OK', TRUE ),
( 54, '2024-08-16', 'RECEIPT', 'RC-2408-0069', 'MTR', 64, 0, 228, 0, 14592, 1, 1, 13, 4, 53, 'Auto generated entry', 'OK', TRUE ),
( 1, '2024-08-29', 'ISSUE', 'IS-2408-0070', 'BAGS', 0, 61, 264, 0, 16104, 1, 1, 35, 7, 5, 'Auto generated entry', 'OK', TRUE ),
( 6, '2024-08-17', 'ISSUE', 'IS-2408-0071', 'BRASS', 0, 91, 513, 0, 46683, 1, 1, 47, 4, 78, 'Auto generated entry', 'OK', TRUE ),
( 55, '2023-03-04', 'RECEIPT', 'RC-2303-0072', 'NOS', 150, 0, 88, 0, 13200, 1, 1, 36, 2, 25, 'Auto generated entry', 'OK', TRUE ),
( 69, '2024-05-07', 'RECEIPT', 'RC-2405-0073', 'NOS', 160, 0, 566, 0, 90560, 1, 1, 36, 3, 60, 'Auto generated entry', 'OK', TRUE ),
( 84, '2024-12-13', 'ISSUE', 'IS-2412-0074', 'KG', 0, 38, 288, 0, 10944, 1, 1, 41, 5, 62, 'Auto generated entry', 'OK', TRUE ),
( 44, '2024-02-19', 'ISSUE', 'IS-2402-0075', 'NOS', 0, 89, 754, 0, 67106, 1, 1, 6, 2, 14, 'Auto generated entry', 'OK', TRUE );