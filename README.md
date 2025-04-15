# Vendor Management System

## Overview

The **Vendor Management System** is a web-based solution designed to streamline vendor operations by integrating a robust database with a dynamic web interface. This project follows a structured workflow that includes database design, backend and frontend development, and system integration/deployment.

---

## Flow

1. **Database Design:**  
   - **Entity-Relationship Diagram (ERD):**  
     Visualizes all entities, attributes, and relationships to ensure a normalized database that avoids redundancy while maintaining referential integrity.
   - **Relational Schema:**  
     The finalized ERD is translated into a relational schema outlining tables, columns, primary keys, and foreign key constraints.
  
2. **Database Implementation:**  
   - Implemented using **MySQL**.
   - A DDL script creates tables with all necessary constraints (primary keys, foreign keys with cascade actions).
   - **Stored Procedures** handle frequently executed operations (e.g., inserting/updating records).
   - **Triggers** are implemented to automate behaviors like logging changes or enforcing business rules.

3. **Backend Development:**  
   - Developed using **Node.js** with the **Express** framework.
   - Connects to the MySQL database via a library such as `mysql2`.
   - Routes and controllers are defined to handle API endpoints for CRUD operations, with robust error handling.

4. **Frontend Development:**  
   - Pages are built using **HTML**, **JavaScript**, and **Bootstrap** for responsive design.
   - Enhanced interactivity with **SVG** and **D3.js** visualizations.
   - Inline CSS is used for minor customization, ensuring a balance between style and performance.
   - User-friendly forms allow seamless data input.

5. **Integration and Deployment:**  
   - Ensures smooth communication between the Node.js server and the MySQL database.
   - The frontend interfaces provide an intuitive user experience.
   - The application is thoroughly tested for bugs and performance issues to deliver a robust, efficient, and user-friendly solution.

---

## ERD: Summary of Key Relationships

- **Vendors ↔ Contracts:** 1:N (Mandatory)
- **Vendors ↔ Purchase Orders:** 1:N (Mandatory)
- **Roles ↔ Departments:** 1:N (Optional)
- **Departments ↔ Users:** 1:N (Mandatory)
- **Departments ↔ Budgets:** 1:1 (Mandatory)
- **Contracts ↔ Notifications:** 1:N (Optional)
- **Users ↔ Notifications:** 1:N (Mandatory)
- **Vendors ↔ VendorPerformance:** 1:N (Mandatory)
- **Contracts ↔ BudgetMessages:** 1:1 (Optional)

---

## Table Descriptions and Constraints

### Vendors Table

- **Primary Key:** `VendorID` (Unique identifier for each vendor)
- **Constraints:**
  - **NotNull:** `VendorName` and `Email` must not be blank.
  - **DataType Lengths:**  
    - `VendorName`: Maximum 255 characters  
    - `Email`: Maximum 255 characters  
    - `Phone`: Maximum 20 characters

### Contracts Table

- **Primary Key:** `ContractID` (Unique identifier for each contract)
- **Foreign Key:** `VendorID` references `Vendors(VendorID)`  
  - **On Delete Cascade:** Automatically deletes related contracts when a vendor is removed.
- **Constraints:**  
  - **NotNull:** `StartDate`, `EndDate`, and `Status` are required.

### PurchaseOrders Table

- **Primary Key:** `PurchaseOrderID` (Unique identifier for each order)
- **Foreign Keys:**  
  - `DepartmentID` references `Departments(DepartmentID)` (On Delete Cascade)  
  - `VendorID` references `Vendors(VendorID)` (On Delete Cascade)
- **Constraints:**  
  - **NotNull:** `ItemDetails`, `Quantity`, `TotalCost`, and `Status` must be provided.
  - **Data Range Check:** `TotalCost` must be a positive value (≥ 0).

### Roles Table

- **Primary Key:** `RoleID`
- **Unique Constraint:** `RoleName` (prevents duplicate role names)
- **NotNull:** `RoleName` is required.

### Departments Table

- **Primary Key:** `DepartmentID`
- **Foreign Key:** `RoleID` references `Roles(RoleID)` (On Delete Cascade)
- **NotNull:** `DepartmentName` is mandatory.

### Budgets Table

- **Primary Key:** `BudgetID`
- **Foreign Key:** `DepartmentID` references `Departments(DepartmentID)` (On Delete Cascade)
- **Constraints:**  
  - **NotNull:** `AllocatedBudget` and `UsedBudget` must be provided.
  - **Data Range Check:** Both budgets must be positive values (≥ 0).

### Users Table

- **Primary Key:** `UserID`
- **Unique Constraint:** `Username` prevents duplicate entries.
- **Constraints:**  
  - **NotNull:** `Username`, `Password`, `Role`, and `DepartmentID` are required.
  - **Foreign Key:** `DepartmentID` references `Departments(DepartmentID)` (On Delete Cascade)

### VendorPerformance Table

- **Primary Key:** `PerformanceID`
- **Foreign Key:** `VendorID` references `Vendors(VendorID)` (On Delete Cascade)
- **Constraints:**  
  - **NotNull:** `Rating` and `EvaluationDate` are required.
  - **Data Range Check:** `Rating` must be between 0 and 5 (inclusive).

### Notifications Table

- **Primary Key:** `NotificationID`
- **Foreign Keys:**  
  - `UserID` references `Users(UserID)` (On Delete Cascade)  
  - `ContractID` references `Contracts(ContractID)` (On Delete Cascade)
- **Constraints:**  
  - **NotNull:** `Message` and `Date` are required.

### BudgetMessages Table

- **Primary Key:** `MessageID`
- **Foreign Key:** `ContractID` references `Contracts(ContractID)` with **No Action** on delete.
- **Default Values:**  
  - `CreatedAt` defaults to the current timestamp if not provided.
- **Data Range Check:**  
  - `TotalCost` and `BudgetRemaining` must be positive values (≥ 0).

---

## Assumptions and Design Philosophy

### Administrator Role and Authority

- **Single Administrator Oversight:**  
  - The system is managed by a single administrator with unrestricted access to all functionalities.
  - Responsibilities include managing vendor details, overseeing contract renewals, managing department budgets, and tracking purchase orders.
  
- **Comprehensive Access and Analytics:**  
  - The administrator has access to detailed performance analytics for vendor evaluation, contract monitoring, and resource allocation.
  
- **Centralized Management:**  
  - The centralized role ensures integrity and allows rapid adaptation to changes such as updating terms or resolving conflicts.

### Database Assumptions and Structure

- **Key Entities:**  
  - **Vendors:** Vendor details, services, certifications, and performance metrics.
  - **Contracts:** Contract terms, vendor associations, and status.
  - **Departments:** Organizational departments with budgets and roles.
  - **Purchase Orders:** Transactions between departments and vendors.
  - **Budgets:** Departmental allocated and used budgets.
  - **Users:** Login credentials and roles.
  - **VendorPerformance:** Performance ratings and feedback.
  - **Notifications:** Automated alerts (e.g., contract renewals).
  - **BudgetMessages:** Budget overage alerts.

- **Foreign Key Dependencies:**  
  - Vendors, Departments, and Contracts are interlinked to maintain data integrity and support targeted insights.
  
- **Automation:**  
  - **Triggers** alert users when contracts near expiration or budgets are exceeded.
  - **Stored Procedures:**  
    - `RegisterVendor`: Adds new vendors.
    - `UpdateContractStatus`: Modifies contract statuses.
    - `EvaluateVendorPerformance`: Records performance ratings and feedback.

- **Data Validation:**  
  - Constraints ensure that data (e.g., vendor ratings) adheres to defined ranges and integrity rules.

### Overall Design Goal

The design aims to centralize and streamline vendor management while offering flexibility for updates. With the administrator’s comprehensive control and rigorous data validation, the system is robust, scalable, and adaptable to dynamic business needs.

