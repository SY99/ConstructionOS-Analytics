/* Use this table to create and populate the Material_Stock_Summary table*/
Use ConstructionOS;
SELECT * from material_stock_summary;

/* Creating a New Material_Stock_Summary table*/
CREATE TABLE material_stock_summary (
    stock_id INT AUTO_INCREMENT PRIMARY KEY,
    material_id INT NOT NULL,

    -- Quantities tracked from inventory + transactions
    opening_quantity DECIMAL(10,2) DEFAULT 0,
    received_quantity DECIMAL(10,2) DEFAULT 0,
    issued_quantity DECIMAL(10,2) DEFAULT 0,

    -- Auto-computed balance
    current_stock DECIMAL(10,2) GENERATED ALWAYS AS 
        (opening_quantity + received_quantity - issued_quantity) STORED,

    unit VARCHAR(50),
    unit_rate DECIMAL(12,2) DEFAULT 0,

    -- Total stock value (calculated)
    total_value DECIMAL(12,2) GENERATED ALWAYS AS 
        ((opening_quantity + received_quantity - issued_quantity) * unit_rate) STORED,

    -- Notes
    remarks TEXT,
    is_active BOOLEAN DEFAULT TRUE,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_ms_material FOREIGN KEY (material_id)
        REFERENCES material_inventory(material_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


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

ALTER TABLE material_stock_summary
MODIFY COLUMN current_stock DECIMAL(10,2)
    GENERATED ALWAYS AS (
        IFNULL(opening_quantity,0) 
        + IFNULL(received_quantity,0) 
        - IFNULL(issued_quantity,0)
    ) STORED;

/* Populating Material_Stock_Summary */
INSERT INTO material_stock_summary 
(material_id, opening_quantity, received_quantity, issued_quantity, unit, unit_rate, remarks, is_active)
VALUES
(1, 738.00, 65.00, 89.10, 'BAGS', 23.00, NULL, 1),
(2, 925.00, 50.46, 100.42, 'BAGS', 26.00, NULL, 1),
(3, 519.00, 20.52, 36.64, 'BAGS', 29.00, NULL, 1),
(4, 217.00, 0.00, 52.00, 'BRASS', 64.00, NULL, 1),
(5, 187.00, 0.00, 0.00, 'BRASS', 0.00, NULL, 1),
(6, 219.00, 153.88, 21.82, 'BRASS', 76.00, NULL, 1),
(7, 251.00, 30.75, 0.00, 'NOS', 82.00, NULL, 1),
(8, 224.00, 35.31, 80.75, 'NOS', 88.00, NULL, 1),
(9, 128.00, 51.31, 46.58, 'NOS', 94.00, NULL, 1),
(10, 13758.00, 1331.36, 1473.72, 'BRASS', 100.00, NULL, 1),
(11, 441.00, 0.00, 0.00, 'BAGS', 0.00, NULL, 1),
(12, 784.00, 64.20, 172.24, 'LTR', 56.00, NULL, 1),
(13, 167.00, 0.00, 49.42, 'NOS', 118.00, NULL, 1),
(14, 164.00, 26.27, 0.00, 'ROLL', 124.00, NULL, 1),
(15, 1244.00, 177.39, 142.30, 'NOS', 130.00, NULL, 1),
(16, 1502.00, 250.63, 146.56, 'NOS', 136.00, NULL, 1),
(17, 320.00, 0.00, 49.91, 'BAGS', 71.00, NULL, 1),
(18, NULL, 0.00, 0.00, NULL, 0.00, NULL, 1),
(19, 571.00, 0.00, 27.86, 'LTR', 77.00, NULL, 1),
(20, 624.00, 88.21, 0.00, 'KG', 80.00, NULL, 1),
(21, 242.00, 0.00, 0.00, 'KG', 0.00, NULL, 1),
(22, 135.00, 16.18, 0.00, 'KG', 86.00, NULL, 1),
(23, 218.00, 0.00, 117.07, 'KG', 89.00, NULL, 1),
(24, 183.00, 0.00, 0.00, 'KG', 0.00, NULL, 1),
(25, 110.00, 0.00, 91.45, 'KG', 95.00, NULL, 1),
(26, 279.00, 0.00, 18.93, 'SQFT', 147.00, NULL, 1),
(27, 451.00, 0.00, 52.59, 'SQFT', 151.50, NULL, 1),
(28, 127.00, 0.00, 44.12, 'NOS', 208.00, NULL, 1),
(29, 227.00, 53.99, 25.66, 'KG', 107.00, NULL, 1),
(30, 132.00, 9.61, 0.00, 'BRASS', 220.00, NULL, 1),
(31, 119.00, 80.54, 0.00, 'BAGS', 113.00, NULL, 1),
(32, 369.00, 0.00, 177.06, 'ROLL', 232.00, NULL, 1),
(33, 489.00, 16.39, 66.10, 'LTR', 119.00, NULL, 1),
(34, 222.00, 91.33, 0.00, 'LTR', 122.00, NULL, 1),
(35, 209.00, 85.32, 0.00, 'MTR', 125.00, NULL, 1),
(36, 824.00, 135.02, 171.54, 'MTR', 128.00, NULL, 1),
(37, 279.00, 33.60, 25.51, 'MTR', 131.00, NULL, 1),
(38, 380.00, 0.00, 0.00, 'NOS', 0.00, NULL, 1),
(39, 282.00, 0.00, 55.32, 'NOS', 274.00, NULL, 1),
(40, 326.00, 5.76, 26.52, 'NOS', 280.00, NULL, 1),
(41, 106.00, 0.00, 0.00, 'NOS', 0.00, NULL, 1),
(42, 132.00, 0.00, 50.95, 'NOS', 292.00, NULL, 1),
(43, 492.00, 33.76, 35.05, 'NOS', 298.00, NULL, 1),
(44, 216.00, 56.47, 0.00, 'NOS', 304.00, NULL, 1),
(45, 211.00, 0.00, 0.00, 'NOS', 0.00, NULL, 1),
(46, 352.00, 96.31, 0.00, 'NOS', 316.00, NULL, 1),
(47, 418.00, 184.03, 114.43, 'MTR', 161.00, NULL, 1),
(48, 406.00, 0.00, 29.43, 'MTR', 164.00, NULL, 1),
(49, 343.00, 67.17, 81.51, 'NOS', 334.00, NULL, 1),
(50, 324.00, 46.24, 56.36, 'NOS', 340.00, NULL, 1),
(51, 15422.00, 1418.36, 1704.57, 'NOS', 346.00, NULL, 1),
(52, 13978.00, 1464.81, 1819.07, 'NOS', 352.00, NULL, 1),
(53, 16855.00, 1430.79, 2186.69, 'MTR', 179.00, NULL, 1),
(54, 19340.00, 2686.45, 2350.33, 'MTR', 182.00, NULL, 1),
(55, 18744.00, 1910.09, 1990.31, 'NOS', 370.00, NULL, 1),
(56, 220.00, 0.00, 59.32, 'NOS', 376.00, NULL, 1),
(57, 407.00, 25.85, 120.64, 'NOS', 382.00, NULL, 1),
(58, 267.00, 0.00, 0.00, 'NOS', 0.00, NULL, 1),
(59, 399.00, 0.00, 41.42, 'NOS', 394.00, NULL, 1),
(60, 452.00, 116.73, 26.25, 'SQFT', 300.00, NULL, 1),
(61, 188.00, 84.34, 40.63, 'SQFT', 304.50, NULL, 1),
(62, 211.00, 36.69, 9.79, 'MTR', 206.00, NULL, 1),
(63, 180.00, 0.00, 0.00, 'SQFT', 0.00, NULL, 1),
(64, 310.00, 0.00, 0.00, 'SQFT', 0.00, NULL, 1),
(65, 427.00, 0.00, 160.00, 'NOS', 430.00, NULL, 1),
(66, 366.00, 58.72, 53.58, 'NOS', 436.00, NULL, 1),
(67, 492.00, 5.65, 0.00, 'NOS', 442.00, NULL, 1),
(68, 223.00, 0.00, 0.00, 'NOS', 0.00, NULL, 1),
(69, 115.00, 67.23, 6.73, 'NOS', 454.00, NULL, 1),
(70, 160.00, 90.00, 0.00, 'SQFT', 345.00, NULL, 1),
(71, 276.00, 0.00, 0.00, 'SQFT', 0.00, NULL, 1),
(72, 402.00, 33.44, 89.15, 'SQFT', 354.00, NULL, 1),
(73, 149.00, 0.00, 0.00, 'RFT', 0.00, NULL, 1),
(74, 211.00, 0.00, 16.43, 'LTR', 242.00, NULL, 1),
(75, 454.00, 0.00, 0.00, 'LTR', 0.00, NULL, 1),
(76, 201.00, 0.00, 59.80, 'LTR', 248.00, NULL, 1),
(77, 268.00, 0.00, 0.00, 'KG', 0.00, NULL, 1),
(78, 311.00, 0.00, 59.44, 'KG', 254.00, NULL, 1),
(79, 226.00, 0.00, 0.00, 'SQFT', 0.00, NULL, 1),
(80, 316.00, 0.00, 114.51, 'RFT', 390.00, NULL, 1),
(81, 144.00, 41.47, 0.00, 'NOS', 526.00, NULL, 1),
(82, 371.00, 76.71, 12.69, 'NOS', 532.00, NULL, 1),
(83, 288.00, 0.00, 39.88, 'KG', 269.00, NULL, 1),
(84, 422.00, 35.37, 26.66, 'KG', 272.00, NULL, 1);


