const express = require('express');
const mysql = require('mysql2');
const bodyParser = require('body-parser');
const path = require('path');
const app = express();
const port = 8080;

// Middleware to parse URL-encoded bodies
app.use(bodyParser.urlencoded({ extended: true }));
// Middleware to serve static files from 'public' directory
app.use(express.static(path.join(__dirname, 'public')));

// Start the server
app.listen(port, () => {
    console.log(`Listening on port ${port}...`);

});

// Database connection setup
const connection = mysql.createConnection({
    host: "localhost",
    user: "root", // replace with your database username
    password: "121315", // replace with your database password
    database: "proj2" // replace with your database name
});

// Connect to the database
connection.connect(err => {
    if (err) {
        console.error("Error connecting to the database:", err.stack);
        return;
    }
    console.log("Connected to the database");
});

// Handle form submission for adding a vendor
app.post('/add-vendor', (req, res) => {
    const { VendorID, VendorName, ServiceCategories, Email, Phone, ComplianceCertifications, PerformanceMetrics } = req.body;

    const insertQuery = `
        INSERT INTO Vendors (VendorID, VendorName, ServiceCategories, Email, Phone, ComplianceCertifications, PerformanceMetrics)
        VALUES (?,?, ?, ?, ?, ?, ?);
    `;

    connection.query(insertQuery, [ VendorID, VendorName, ServiceCategories, Email, Phone, ComplianceCertifications, PerformanceMetrics], (err, results) => {
        if (err) {
            console.error("Error inserting vendor:", err.stack);
            res.status(500).send('Error adding vendor: ' + err.message);
            return;
        }
        res.redirect('/success.html');
    });
});

// Handle form submission for adding a contract
app.post('/add-contract', (req, res) => {
    const { ContractID, VendorID, Terms, StartDate, EndDate, Status } = req.body;

    const insertQuery = `
        INSERT INTO Contracts (ContractID,VendorID, Terms, StartDate, EndDate, Status)
        VALUES (?,?, ?, ?, ?, ?);
    `;

    connection.query(insertQuery, [ContractID,VendorID, Terms, StartDate, EndDate, Status], (err, results) => {
        if (err) {
            console.error("Error inserting contract:", err.stack);
            res.status(500).send('Error adding contract: ' + err.message);
            return;
        }
        res.redirect('/success.html');
    });
});

// Handle form submission for adding a purchase order
app.post('/add-purchase-order', (req, res) => {
    console.log("Received request to add a purchase order.");

    // Destructure request body
    const { PurchaseOrderID, DepartmentID, VendorID, ItemDetails, Quantity, TotalCost, Status } = req.body;
    console.log("Request body:", req.body);

    // Prepare the SQL query
    const insertQuery = `
        INSERT INTO PurchaseOrders (PurchaseOrderID, DepartmentID, VendorID, ItemDetails, Quantity, TotalCost, Status)
        VALUES (?, ?, ?, ?, ?, ?, ?);
    `;
    console.log("SQL query prepared:", insertQuery);

    // Execute the query
    connection.query(insertQuery, [PurchaseOrderID, DepartmentID, VendorID, ItemDetails, Quantity, TotalCost, Status], (err, results) => {
        if (err) {
            console.error("Error inserting purchase order:", err.stack); // Logs the error stack trace
            console.error("Error details:", {
                PurchaseOrderID,
                DepartmentID,
                VendorID,
                ItemDetails,
                Quantity,
                TotalCost,
                Status
            }); // Logs the input data to verify
            res.status(500).send('Error adding purchase order: ' + err.message);
            return;
        }
        console.log("Insert successful:", results); // Logs the success results
        res.redirect('/success.html');
    });
});


// Handle form submission for adding a department
app.post('/add-department', (req, res) => {
    const {DepartmentID, DepartmentName, RoleID } = req.body;

    const insertQuery = `
        INSERT INTO Departments (DepartmentID,DepartmentName, RoleID)
        VALUES (?,?, ?);
    `;

    connection.query(insertQuery, [DepartmentID,DepartmentName, RoleID], (err, results) => {
        if (err) {
            console.error("Error inserting department:", err.stack);
            res.status(500).send('Error adding department: ' + err.message);
            return;
        }
        res.redirect('/success.html');
    });
});

// Handle form submission for adding a budget
app.post('/add-budget', (req, res) => {
    const {BudgetID, DepartmentID, AllocatedBudget, UsedBudget } = req.body;

    const insertQuery = `
        INSERT INTO Budgets (BudgetID,DepartmentID, AllocatedBudget, UsedBudget)
        VALUES (?,?, ?, ?);
    `;

    connection.query(insertQuery, [BudgetID,DepartmentID, AllocatedBudget, UsedBudget], (err, results) => {
        if (err) {
            console.error("Error inserting budget:", err.stack);
            res.status(500).send('Error adding budget: ' + err.message);
            return;
        }
        res.redirect('/success.html');
    });
});

// Handle form submission for adding a user
app.post('/add-user', (req, res) => {
    const {UserID, Username, Password, Role, DepartmentID } = req.body;

    const insertQuery = `
        INSERT INTO Users (UserID,Username, Password, Role, DepartmentID)
        VALUES (?,?, ?, ?, ?);
    `;

    connection.query(insertQuery, [UserID,Username, Password, Role, DepartmentID], (err, results) => {
        if (err) {
            console.error("Error inserting user:", err.stack);
            res.status(500).send('Error adding user: ' + err.message);
            return;
        }
        res.redirect('/success.html');
    });
});

// Handle form submission for adding vendor performance
app.post('/add-vendor-performance', (req, res) => {
    const {PerformanceID, VendorID, Rating, Feedback, EvaluationDate } = req.body;

    const insertQuery = `
        INSERT INTO VendorPerformance (PerformanceID,VendorID, Rating, Feedback, EvaluationDate)
        VALUES (?,?, ?, ?, ?);
    `;

    connection.query(insertQuery, [PerformanceID,VendorID, Rating, Feedback, EvaluationDate], (err, results) => {
        if (err) {
            console.error("Error inserting vendor performance:", err.stack);
            res.status(500).send('Error adding vendor performance: ' + err.message);
            return;
        }
        res.redirect('/success.html');
    });
});

// Handle form submission for adding a role
app.post('/add-role', (req, res) => {
    const {RoleID, RoleName } = req.body;

    const insertQuery = `
        INSERT INTO Roles (RoleID,RoleName)
        VALUES (?,?);
    `;

    connection.query(insertQuery, [RoleID,RoleName], (err, results) => {
        if (err) {
            console.error("Error inserting role:", err.stack);
            res.status(500).send('Error adding role: ' + err.message);
            return;
        }
        res.redirect('/success.html');
    });
});

// Handle form submission for adding a notification
app.post('/add-notification', (req, res) => {
    const {NotificationID, UserID, ContractID, Message, Date } = req.body;

    const insertQuery = `
        INSERT INTO Notifications (NotificationID,UserID, ContractID, Message, Date)
        VALUES (?,?, ?, ?, ?);
    `;

    connection.query(insertQuery, [NotificationID,UserID, ContractID, Message, Date], (err, results) => {
        if (err) {
            console.error("Error inserting notification:", err.stack);
            res.status(500).send('Error adding notification: ' + err.message);
            return;
        }
        res.redirect('/success.html');
    });
});

// Fetch purchase orders
app.get('/getPurchaseOrders', (req, res) => {
    connection.query('SELECT * FROM PurchaseOrders', (err, results) => {
        if (err) {
            console.error("Error fetching purchase orders:", err.stack);
            return res.status(500).send('Error fetching purchase orders');
        }
        res.json(results);
    });
});

// Update status of a purchase order
app.post('/updatePurchaseOrderStatus/:poID', (req, res) => {
    const poID = req.params.poID;
    const { status } = req.body;

    const updateQuery = `
        UPDATE PurchaseOrders
        SET Status = ?
        WHERE poID = ?
    `;

    connection.query(updateQuery, [status, poID], (err, results) => {
        if (err) {
            console.error("Error updating purchase order status:", err.stack);
            return res.status(500).send('Error updating purchase order status');
        }
        res.json({ message: 'Purchase order status updated successfully' });
    });
});

// Fetch vendor performance
app.get('/getVendorPerformance', (req, res) => {
    const query = 'SELECT VendorID, Rating FROM VendorPerformance';
    connection.query(query, (err, results) => {
        if (err) {
            console.error('Database query error:', err);
            return res.status(500).send('Error fetching vendor performance');
        }
        res.json(results);
    });
});


//
// Handle fetching contract details by Vendor ID
app.get('/getContractDetails/:vendorID', (req, res) => {
    const vendorID = req.params.vendorID;
    console.log(`[DEBUG] Received request to fetch contract details for VendorID: ${vendorID}`);

    const query = `
        SELECT ContractID, StartDate, EndDate, Terms
        FROM Contracts
        WHERE VendorID = ?;
    `;

    connection.query(query, [vendorID], (err, results) => {
        if (err) {
            console.error(`[ERROR] Database error while fetching contract details for VendorID ${vendorID}:`, err.stack);
            res.status(500).send('Error fetching contract details: ' + err.message);
            return;
        }

        console.log(`[DEBUG] Query executed successfully. Rows returned: ${results.length}`);
        if (results.length > 0) {
            console.log(`[DEBUG] Contract details for VendorID ${vendorID}:`, results[0]);
            res.json(results[0]); // Return first matching contract
        } else {
            console.warn(`[WARN] No contract found for VendorID ${vendorID}`);
            res.status(404).json({ message: 'Contract not found for this Vendor ID' });
        }
    });
});

app.use(express.json());

// Handle contract renewal
app.post('/renewContract', (req, res) => {
    const { vendorID, newEndDate } = req.body;

    console.log('Received renewal data:', req.body); // Log the received data for debugging

    // Check if vendorID and newEndDate are provided
    if (!vendorID || !newEndDate) {
        console.error('Missing required fields:', { vendorID, newEndDate });
        return res.status(400).json({ error: 'Missing required fields' });
    }

    // Update contract query without the "Status = Active" condition
    const query = `
        UPDATE Contracts
        SET EndDate = ?, Status = "Renewed"
        WHERE VendorID = ?;
    `;

    // Execute the query to update the contract
    connection.query(query, [newEndDate, vendorID], (err, result) => {
        if (err) {
            console.error("Error updating contract:", err.stack);
            return res.status(500).json({ error: err.message });
        }

        // Check if any rows were affected (contract found and updated)
        if (result.affectedRows > 0) {
            res.json({ success: true });
        } else {
            // No contract found or the contract was already renewed
            res.status(404).json({ success: false, message: 'Contract not found' });
        }
    });
});




// Error handling middleware for unhandled routes
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({ error: 'Internal Server Error' });
});

// Fetch notifications
app.get('/notifications', (req, res) => {
    const query = 'SELECT NotificationID, Message AS MessageText, Date AS CreatedAt FROM Notifications';
    connection.query(query, (err, results) => {
        if (err) {
            console.error('Error fetching notifications:', err);
            return res.status(500).json({ success: false, message: 'Error fetching notifications.' });
        }
        res.json({ success: true, notifications: results });
    });
});

// Fetch budget check messages
app.get('/budget-check', (req, res) => {
    const query = 'SELECT MessageText AS MessageText, CreatedAt FROM budgetmessages';
    connection.query(query, (err, results) => {
        if (err) {
            console.error('Error fetching budget messages:', err);
            return res.status(500).json({ success: false, message: 'Error fetching budget messages.' });
        }
        res.json({ success: true, budgetMessages: results });
    });
});