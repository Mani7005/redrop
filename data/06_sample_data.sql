-- ============================================================
--  Blood Donation System  |  DBMS Project
--  Step 6: Sample Data
-- ============================================================
USE blood_donation;

DELETE FROM requests;
DELETE FROM donors;

INSERT INTO donors (name, blood_group, city, phone, last_donation) VALUES
('Rahul Sharma',    'A+',  'Delhi',     '9876543210', '2023-10-01'),
('Priya Singh',     'B+',  'Mumbai',    '9123456780', '2023-08-15'),
('Amit Kumar',      'O+',  'Delhi',     '9988776655', '2023-09-20'),
('Shreya Singhal',  'O+',  'Siliguri',  '9832145011', '2023-07-14'),
('Meena Rao',       'AB+', 'Chennai',   '9765432100', '2023-11-05'),
('Vikram Das',      'B-',  'Kolkata',   '9654321098', '2023-06-28'),
('Anjali Mehta',    'A-',  'Delhi',     '9543210987', '2023-12-10'),
('Rohit Verma',     'O-',  'Mumbai',    '9432109876', '2023-05-15'),
('Sunita Patel',    'A+',  'Ahmedabad', '9321098765', '2024-01-02'),
('Karan Malhotra',  'B+',  'Delhi',     '9210987654', '2023-04-11');

INSERT INTO requests (patient_name, blood_group, city, phone, urgency) VALUES
('Neeraj Joshi', 'O+',  'Delhi',  '9000011111', 'Critical'),
('Deepa Nair',   'A-',  'Mumbai', '9000022222', 'Urgent');
