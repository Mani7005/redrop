-- ============================================================
-- REDROP - Smart Blood Donation Management System
-- 06_sample_data.sql : Sample data for all 6 tables
-- ============================================================

USE blood_donation;

-- ------------------------------------------------------------
-- Blood_Group (all 8 types)
-- ------------------------------------------------------------
INSERT INTO Blood_Group (blood_type) VALUES
('A+'), ('A-'), ('B+'), ('B-'),
('O+'), ('O-'), ('AB+'), ('AB-');

-- ------------------------------------------------------------
-- Blood_Availability (initial stock)
-- ------------------------------------------------------------
INSERT INTO Blood_Availability (blood_group_id, available_units) VALUES
(1, 15),  -- A+
(2,  4),  -- A-
(3, 20),  -- B+
(4,  3),  -- B-
(5, 25),  -- O+
(6,  6),  -- O-
(7,  8),  -- AB+
(8,  2);  -- AB-

-- ------------------------------------------------------------
-- Donors (15 sample donors across multiple cities)
-- ------------------------------------------------------------
INSERT INTO Donor (name, age, gender, contact, blood_group_id, last_donation, is_available, city) VALUES
('Arjun Sharma',    24, 'Male',   '9876543210', 1, '2024-12-01', TRUE,  'Patiala'),
('Priya Singh',     28, 'Female', '9876543211', 3, '2025-01-15', TRUE,  'Patiala'),
('Rahul Verma',     32, 'Male',   '9876543212', 5, '2024-11-20', TRUE,  'Amritsar'),
('Sneha Kapoor',    22, 'Female', '9876543213', 2, '2025-03-10', FALSE, 'Delhi'),
('Vikram Rao',      35, 'Male',   '9876543214', 7, '2024-10-05', TRUE,  'Delhi'),
('Ananya Gupta',    26, 'Female', '9876543215', 1, '2024-09-25', TRUE,  'Patiala'),
('Karan Mehta',     29, 'Male',   '9876543216', 4, '2025-02-18', FALSE, 'Chandigarh'),
('Divya Nair',      31, 'Female', '9876543217', 6, '2024-08-12', TRUE,  'Chandigarh'),
('Rohan Joshi',     23, 'Male',   '9876543218', 3, '2025-04-01', FALSE, 'Patiala'),
('Meera Pillai',    27, 'Female', '9876543219', 8, '2024-07-30', TRUE,  'Amritsar'),
('Aditya Kumar',    33, 'Male',   '9876543220', 5, '2024-12-15', TRUE,  'Delhi'),
('Pooja Sharma',    25, 'Female', '9876543221', 1, '2025-01-28', TRUE,  'Patiala'),
('Suresh Reddy',    38, 'Male',   '9876543222', 2, '2024-11-05', TRUE,  'Chandigarh'),
('Kavita Patel',    30, 'Female', '9876543223', 3, '2025-03-20', FALSE, 'Amritsar'),
('Nikhil Bose',     21, 'Male',   '9876543224', 7, '2024-06-14', TRUE,  'Delhi');

-- ------------------------------------------------------------
-- Donation_Record (past donation history)
-- ------------------------------------------------------------
INSERT INTO Donation_Record (donor_id, donation_date, quantity_ml) VALUES
(1,  '2024-12-01', 450),
(2,  '2025-01-15', 450),
(3,  '2024-11-20', 350),
(4,  '2025-03-10', 450),
(5,  '2024-10-05', 450),
(6,  '2024-09-25', 450),
(7,  '2025-02-18', 450),
(8,  '2024-08-12', 350),
(9,  '2025-04-01', 450),
(10, '2024-07-30', 450),
(11, '2024-12-15', 450),
(12, '2025-01-28', 450),
(1,  '2024-06-10', 450),
(3,  '2024-05-22', 350),
(5,  '2024-03-18', 450);

-- ------------------------------------------------------------
-- Emergency_Request
-- ------------------------------------------------------------
INSERT INTO Emergency_Request (hospital_name, blood_group_id, required_units, contact_phone, urgency, status, city) VALUES
('PGIMER Chandigarh',     3, 2, '9811111111', 'Critical', 'Pending',   'Chandigarh'),
('Rajindra Hospital',     1, 1, '9811111112', 'Urgent',   'Pending',   'Patiala'),
('Apollo Delhi',          5, 3, '9811111113', 'Normal',   'Fulfilled', 'Delhi'),
('Fortis Amritsar',       7, 1, '9811111114', 'Urgent',   'Pending',   'Amritsar'),
('Max Hospital Delhi',    2, 2, '9811111115', 'Critical', 'Pending',   'Delhi');

-- ------------------------------------------------------------
-- Donor_Notification (linking donors to emergency requests)
-- ------------------------------------------------------------
INSERT INTO Donor_Notification (donor_id, request_id, notification_status) VALUES
(2,  1, 'Sent'),
(9,  1, 'Acknowledged'),
(1,  2, 'Sent'),
(6,  2, 'Sent'),
(12, 2, 'Declined'),
(3,  3, 'Acknowledged'),
(11, 3, 'Sent'),
(5,  4, 'Sent'),
(15, 4, 'Acknowledged');
