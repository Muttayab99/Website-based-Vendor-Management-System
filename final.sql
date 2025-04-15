CREATE DATABASE VendorManagement;
USE VendorManagement;

-- Create table for Vendors
CREATE TABLE Vendors (
    VendorID INT PRIMARY KEY,
    VendorName VARCHAR(255) NOT NULL,
    ServiceCategories VARCHAR(255),
    Email VARCHAR(255) NOT NULL,
    Phone VARCHAR(20),
    ComplianceCertifications TEXT,
    PerformanceMetrics TEXT
);

-- Create table for Contracts
CREATE TABLE Contracts (
    ContractID INT PRIMARY KEY,
    VendorID INT NOT NULL,
    Terms TEXT,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    Status VARCHAR(50) NOT NULL,
    FOREIGN KEY (VendorID) REFERENCES Vendors(VendorID) ON DELETE CASCADE
);


-- Create table for Roles
CREATE TABLE Roles (
    RoleID INT PRIMARY KEY,
    RoleName VARCHAR(50) NOT NULL UNIQUE
);

-- Create table for Departments
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(255) NOT NULL,
    RoleID INT,
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID) ON DELETE CASCADE
    
);

-- Create table for Purchase Orders
CREATE TABLE PurchaseOrders (
    PurchaseOrderID INT PRIMARY KEY,
    DepartmentID INT NOT NULL,
    VendorID INT NOT NULL,
    ItemDetails TEXT NOT NULL,
    Quantity INT NOT NULL,
    TotalCost DECIMAL(15, 2) NOT NULL,
    Status VARCHAR(50) NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID) ON DELETE CASCADE,
    FOREIGN KEY (VendorID) REFERENCES Vendors(VendorID) ON DELETE CASCADE
);

-- Create table for Budgets
CREATE TABLE Budgets (
    BudgetID INT PRIMARY KEY,
    DepartmentID INT NOT NULL,
    AllocatedBudget DECIMAL(15, 2) NOT NULL,
    UsedBudget DECIMAL(15, 2) NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID) ON DELETE CASCADE
);

-- Create table for Users
CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    Username VARCHAR(255) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    Role VARCHAR(50) NOT NULL,
    DepartmentID INT NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID) ON DELETE CASCADE
);


-- Create table for Vendor Performance
CREATE TABLE VendorPerformance (
    PerformanceID INT PRIMARY KEY,
    VendorID INT NOT NULL,
    Rating DECIMAL(3, 2) NOT NULL CHECK (Rating >= 0 AND Rating <= 5),
    Feedback TEXT,
    EvaluationDate DATE NOT NULL,
    FOREIGN KEY (VendorID) REFERENCES Vendors(VendorID) ON DELETE CASCADE
);

-- Create table for Notifications
CREATE TABLE Notifications (
    NotificationID INT PRIMARY KEY,
    UserID INT NOT NULL,
    ContractID INT NOT NULL,
    Message TEXT NOT NULL,
    Date DATE NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (ContractID) REFERENCES Contracts(ContractID) ON DELETE CASCADE
);

-- Create table for Budget Messages
CREATE TABLE BudgetMessages (
    MessageID INT PRIMARY KEY,
    MessageText VARCHAR(255) NOT NULL,
    ContractID INT Default NULL,
    TotalCost DECIMAL(15, 2) NOT NULL,
    BudgetRemaining DECIMAL(15, 2) DEFAULT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ContractID) REFERENCES Contracts(ContractID)
);

-- Triggers

-- Trigger to Notify Users of Contract Renewal
DELIMITER $$
CREATE TRIGGER ContractRenewalNotification
AFTER INSERT ON Contracts
FOR EACH ROW
BEGIN
    IF NEW.EndDate <= CURDATE() + INTERVAL 30 DAY THEN
        INSERT INTO Notifications (UserID, ContractID, Message, Date)
        VALUES (1, NEW.ContractID, 'Contract is nearing renewal.', CURDATE());
    END IF;
END$$
DELIMITER ;

-- Trigger to Notify Users if allocated budget<used budget
DELIMITER $$
CREATE TRIGGER BudgetCheck
AFTER INSERT ON Budgets
FOR EACH ROW
BEGIN
    IF NEW.UsedBudget > NEW.AllocatedBudget THEN
        INSERT INTO BudgetMessages (MessageText, ContractID, TotalCost, BudgetRemaining)
        VALUES (
            CONCAT('Warning: Department ', NEW.DepartmentID, ' has exceeded the allocated budget.'),
            NULL, -- No ContractID associated
            0.00,
            NEW.AllocatedBudget - NEW.UsedBudget
        );
    END IF;
END$$
DELIMITER ;



-- Stored Procedures

-- Procedure to Register a Vendor
DELIMITER $$
CREATE PROCEDURE RegisterVendor(
    IN vName VARCHAR(255),
    IN serviceCategories VARCHAR(255),
    IN email VARCHAR(255),
    IN phone VARCHAR(20),
    IN complianceCertifications TEXT
)
BEGIN
    INSERT INTO Vendors (VendorID, VendorName, ServiceCategories, Email, Phone, ComplianceCertifications)
    VALUES (UUID(), vName, serviceCategories, email, phone, complianceCertifications);
END$$
DELIMITER ;

-- Procedure to Update Contract Status
DELIMITER $$
CREATE PROCEDURE UpdateContractStatus(
    IN contractID INT,
    IN newStatus VARCHAR(50)
)
BEGIN
    UPDATE Contracts
    SET Status = newStatus
    WHERE ContractID = contractID;
END$$
DELIMITER ;

-- Procedure to Evaluate Vendor Performance
DELIMITER $$
CREATE PROCEDURE EvaluateVendorPerformance(
    IN vendorID INT,
    IN rating DECIMAL(3, 2),
    IN feedback TEXT
)
BEGIN
    INSERT INTO VendorPerformance (PerformanceID, VendorID, Rating, Feedback, EvaluationDate)
    VALUES (UUID(), vendorID, rating, feedback, CURDATE());
END$$
DELIMITER ;


-- Insert Data for Vendors
INSERT INTO Vendors (VendorID, VendorName, ServiceCategories, Email, Phone, ComplianceCertifications, PerformanceMetrics)
VALUES
    (1, 'TechSupplies Inc.', 'IT Hardware, Maintenance', 'contact@techsupplies.com', '+1234567890', 'ISO 9001', '95% delivery accuracy'),
    (2, 'OfficeFurnishings Co.', 'Office Supplies', 'sales@officefurnishings.com', '+1987654321', 'ISO 14001', 'High customer satisfaction'),
    (3, 'SmartLogistics Ltd.', 'Transportation Services', 'info@smartlogistics.com', '+1122334455', 'ISO 45001', 'On-time delivery 98%'),
    (4, 'GreenEnergy Solutions', 'Renewable Energy', 'support@greenenergy.com', '+5544332211', 'LEED Gold Certified', '85% efficiency'),
    (5, 'CleanSpace Services', 'Facility Management', 'help@cleanspace.com', '+9988776655', 'OSHA Compliant', '99% cleanliness rating');

-- Insert Data for Roles
INSERT INTO Roles (RoleID, RoleName)
VALUES
    (1, 'Admin'),
    (2, 'Manager'),
    (3, 'Employee'),
    (4, 'Supervisor'),
    (5, 'Staff');

-- Insert Data for Departments
INSERT INTO Departments (DepartmentID, DepartmentName, RoleID)
VALUES
    (1, 'IT Department', 1),
    (2, 'Logistics', 2),
    (3, 'HR', 3),
    (4, 'Finance', 4),
    (5, 'Operations', 5);

-- Insert Data for Users
INSERT INTO Users (UserID, Username, Password, Role, DepartmentID)
VALUES
    (1, 'admin1', 'password123', 'Admin', 1),
    (2, 'manager1', 'password123', 'Manager', 2),
    (3, 'employee1', 'password123', 'Employee', 3),
    (4, 'supervisor1', 'password123', 'Supervisor', 4),
    (5, 'staff1', 'password123', 'Staff', 5);

-- Insert Data for Contracts
INSERT INTO Contracts (ContractID, VendorID, Terms, StartDate, EndDate, Status)
VALUES
    (1, 1, 'TechSupplies IT Hardware Supply Agreement', '2024-01-01', '2025-01-01', 'active'),
    (2, 2, 'OfficeFurnishings Office Supplies Agreement', '2024-02-01', '2025-02-01','active'),
    (3, 3, 'SmartLogistics Transportation Service Agreement', '2024-03-01', '2025-03-01','active'),
    (4, 4, 'GreenEnergy Renewable Energy Supply Agreement', '2024-04-01', '2025-04-01','active'),
    (5, 5, 'CleanSpace Facility Management Agreement', '2024-05-01', '2025-05-01','active');


-- Insert Data for Contracts
INSERT INTO Notifications (NotificationID, UserID, ContractID, Message, Date)
VALUES
    (1, 1, 1, 'System update scheduled for tonight.', '2024-11-30'),
    (2, 2, 2, 'New project assigned.', '2024-11-30'),
    (3, 3, 3, 'Meeting reminder: HR team sync.', '2024-11-30'),
    (4, 4, 4, 'Supervisor approval needed for budget adjustment.', '2024-11-30'),
    (5, 5, 5, 'Facility maintenance request completed.', '2024-11-30');


-- Insert Data for Budgets
INSERT INTO Budgets (BudgetID, DepartmentID, AllocatedBudget, UsedBudget)
VALUES
    (1, 1, 100000, 50000),
    (2, 2, 200000, 150000),
    (3, 3, 50000, 20000),
    (4, 4, 150000, 100000),
    (5, 5, 300000, 250000);

-- Insert Data for Purchase Orders
-- Insert Data for Purchase Orders
INSERT INTO PurchaseOrders (PurchaseOrderID, VendorID, DepartmentID, ItemDetails, Quantity, TotalCost, Status)
VALUES
    (1, 1, 1, 'IT Hardware Supplies', 150, 15000, 'Completed'),
    (2, 2, 2, 'Office Furniture', 50, 25000, 'Pending'),
    (3, 3, 3, 'Transportation Services', 10, 8000, 'Completed'),
    (4, 4, 4, 'Renewable Energy Systems', 30, 12000, 'Pending'),
    (5, 5, 5, 'Facility Maintenance Supplies', 100, 5000, 'Completed');


-- Insert Data for Vendor Performance
INSERT INTO VendorPerformance (PerformanceID, VendorID, Rating, Feedback, EvaluationDate)
VALUES
    (1, 1, 4, 'Excellent delivery accuracy', '2024-11-30'),
    (2, 2, 2, 'High customer satisfaction rate', '2024-11-30'),
    (3, 3, 4.5, 'Very reliable on-time deliveries', '2024-11-30'),
    (4, 4, 3.8, 'Good overall efficiency', '2024-11-30'),
    (5, 5, 5, 'Exceptional cleanliness rating', '2024-11-30');


