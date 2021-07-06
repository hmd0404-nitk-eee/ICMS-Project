const express = require("express");
const cors = require("cors");
const path = require("path");
const mysql = require("mysql");

const app = express();

//View Engine Setup
app.set("views", path.join(__dirname, "views"));
app.set("view engine", "ejs");

//Middleware
app.use(express.urlencoded({ extended: true }));
app.use(cors());
app.use(express.static("public"));

//MySQL DB Connection
const connection = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "password123",
  database: "icms_scheme",
  multipleStatements: true,
});

connection.connect((err) => {
  if (err) {
    console.log(err.message);
    return err;
  }
});

//Login Creds
var usrName = "";
var priv = "";

//-------> QUERIES <----------
const loginQuery =
  "SET @usrname = ?; SET @pswd = ?; CALL Verify_User(@usrname, @pswd);";
const signUpQuery =
  "SET @usrname = ?; SET @pswd = ?; SET @ueid = ?; SET @priv = ?;CALL Add_DB_User(@usrname, @pswd, @ueid, @priv);";

//----> View Queries
const viewEmpQuery =
  "SELECT ueid,`f-name` AS fname,`m-name` AS mname, `l-name` AS lname,post, aan, pan FROM EmployeeList;";
const viewProductsQuery =
  "SELECT ueid,`f-name` AS fname,`m-name` AS mname, `l-name` AS lname,post, aan, pan FROM EmployeeList;";
const viewClientsQuery =
  "SELECT ueid,`f-name` AS fname,`m-name` AS mname, `l-name` AS lname,post, aan, pan FROM EmployeeList;";
const viewPurchaseRecordsQuery =
  "SELECT ueid,`f-name` AS fname,`m-name` AS mname, `l-name` AS lname,post, aan, pan FROM EmployeeList;";
const viewSalesRecordsQuery =
  "SELECT ueid,`f-name` AS fname,`m-name` AS mname, `l-name` AS lname,post, aan, pan FROM EmployeeList;";
const viewPurchaseBillsQuery =
  "SELECT ueid,`f-name` AS fname,`m-name` AS mname, `l-name` AS lname,post, aan, pan FROM EmployeeList;";
const viewSalesBillsQuery =
  "SELECT ueid,`f-name` AS fname,`m-name` AS mname, `l-name` AS lname,post, aan, pan FROM EmployeeList;";
const viewEmpBankQuery =
  "SELECT ueid,`f-name` AS fname,`m-name` AS mname, `l-name` AS lname,post, aan, pan FROM EmployeeList;";
const viewDBUserQuery =
  "SELECT ueid,`f-name` AS fname,`m-name` AS mname, `l-name` AS lname,post, aan, pan FROM EmployeeList;";
const addEmpQuery =
  "SET @ueid = ?; SET @fname = ?; SET @mname = ?;SET @lname = ?;SET @post = ?;SET @aan = ?;\
                     SET @pan = ?;SET @bname = ?;SET @baccnum = ?;SET @bIfsc = ?;\
                     CALL Add_Employee(@ueid,@fname,@mname,@lname,@post,@aan,@pan,@bname,@baccnum,@bIfsc);";
const removeEmpQuery = "SET @ueid = ?; CALL Remove_Employee(@ueid);";

//All the routes
app.get("/api", (req, res) => {
  res.end("<h1> Welcome to ICMS Server</h1>");
});

app.get("/", (req, res) => {
  if (usrName !== "") {
    res.render("homePage", {
      title: "Home",
    });
  } else {
    res.render("errorPage", {
      title: "Error!",
      error: "Authentication Failure.",
      message: "Please Login with correct credentials",
    });
  }
});

app.get("/login", (req, res) => {
  res.render("loginPage", {
    title: "Login",
  });
});

app.get("/signup", (req, res) => {
  if (priv === "Admin") {
    res.render("signUpPage", {
      title: "Sign Up",
    });
  } else {
    res.render("errorPage", {
      title: "Error!",
      error: "Authentication Failure.",
      message: "Please Login with correct credentials",
    });
  }
});

app.get("/about", (req, res) => {
  res.render("aboutPage", {
    title: "About",
  });
});

app.get("/view", (req, res) => {
  if (usrName !== "") {
    console.log(priv);
    res.render("viewTables", {
      title: "View Tables",
      usrname: usrName,
      privilege: priv,
    });
  } else {
    res.render("errorPage", {
      title: "Error!",
      error: "Authentication Failure.",
      message: "Please Login with correct credentials",
    });
  }
});

app.get("/addRecs", (req, res) => {
  if (priv === "Admin") {
    res.render("addRecsPage", {
      title: "Add Records",
      usrname: usrName,
      privilege: priv,
    });
  } else {
    res.render("errorPage", {
      title: "Error!",
      error: "Authentication Failure.",
      message: "Please Login with correct credentials",
    });
  }
});

app.get("/removeRecs", (req, res) => {
  if (priv === "Admin") {
    res.render("removeRecsPage", {
      title: "Remove Records",
      usrname: usrName,
      privilege: priv,
    });
  } else {
    res.render("errorPage", {
      title: "Error!",
      error: "Authentication Failure.",
      message: "Please Login with correct credentials",
    });
  }
});

//---> Login/SignUp Post
app.post("/login", (req, res) => {
  const creds = req.body;
  connection.query(
    loginQuery,
    [creds.usrname, creds.pswd],
    (err, rows, fields) => {
      if (rows[2].length > 0) {
        usrName = rows[2][0].username;
        priv = rows[2][0].privilege;

        res.redirect("/");
      } else {
        res.render("errorPage", {
          title: "Error!",
          error: "Invalid Credentials",
          message:
            "These credentials do not exist on our database. Please signup for first time users.",
        });
      }
    }
  );
});

app.post("/", (req, res) => {
  usrName = "";
  priv = "";

  res.redirect("/");
});

app.post("/signup", (req, res) => {
  const creds = req.body;
  connection.query(
    signUpQuery,
    [creds.usrname, creds.pswd, creds.ueid, creds.privilege],
    (err, rows, fields) => {
      if (!err) {
        res.redirect("/login");
      } else {
        console.log(err.message);
        res.render("errorPage", {
          title: "Error!",
          error: "Adding New User Failed",
          message:
            "These credentials are not valid for the entered UEID. Please verify the entered UEID.",
        });
      }
    }
  );
});

//---> View Tables
app.get("/view/employees", (req, res) => {
  connection.query(viewEmpQuery, (err, rows, fields) => {
    if (!err) {
      res.render("viewEmp", {
        title: "View Employees",
        employees: rows,
      });
    } else {
      console.log(err.message);
      res.render("errorPage", {
        title: "Error!",
        error: "Error in fetching data from SQL",
        message:
          "Fatal error connecting to SQL Database Server. Please try again\
                    after restarting the system.",
      });
    }
  });
});

app.get("/view/products", (req, res) => {
  connection.query(viewEmpQuery, (err, rows, fields) => {
    if (!err) {
      res.render("viewProducts", {
        title: "View Products",
        products: rows,
      });
    } else {
      res.render("errorPage", {
        title: "Error!",
        error: "Error in fetching data from SQL",
        message:
          "Fatal error connecting to SQL Database Server. Please try again\
                    after restarting the system.",
      });
    }
  });
});

app.get("/view/clients", (req, res) => {
  connection.query(viewEmpQuery, (err, rows, fields) => {
    if (!err) {
      res.render("viewClients", {
        title: "View Clients",
        clients: rows,
      });
    } else {
      console.log(err.message);
      res.render("errorPage", {
        title: "Error!",
        error: "Error in fetching data from SQL",
        message:
          "Fatal error connecting to SQL Database Server. Please try again\
                    after restarting the system.",
      });
    }
  });
});

app.get("/view/purchaseRecs", (req, res) => {
  connection.query(viewEmpQuery, (err, rows, fields) => {
    if (!err) {
      res.render("viewPurchaseRecs", {
        title: "View Purchase Records",
        purRecs: rows,
      });
    } else {
      console.log(err.message);
      res.render("errorPage", {
        title: "Error!",
        error: "Error in fetching data from SQL",
        message:
          "Fatal error connecting to SQL Database Server. Please try again\
                    after restarting the system.",
      });
    }
  });
});

app.get("/view/salesRecs", (req, res) => {
  connection.query(viewEmpQuery, (err, rows, fields) => {
    if (!err) {
      res.render("viewSalesRecs", {
        title: "View Sales Record",
        salesRec: rows,
      });
    } else {
      console.log(err.message);
      res.render("errorPage", {
        title: "Error!",
        error: "Error in fetching data from SQL",
        message:
          "Fatal error connecting to SQL Database Server. Please try again\
                    after restarting the system.",
      });
    }
  });
});

app.get("/view/purchasebills", (req, res) => {
  connection.query(viewEmpQuery, (err, rows, fields) => {
    if (!err) {
      res.render("viewPurBills", {
        title: "View Purchase Bills",
        purBills: rows,
      });
    } else {
      console.log(err.message);
      res.render("errorPage", {
        title: "Error!",
        error: "Error in fetching data from SQL",
        message:
          "Fatal error connecting to SQL Database Server. Please try again\
                    after restarting the system.",
      });
    }
  });
});

app.get("/view/salesbills", (req, res) => {
  connection.query(viewEmpQuery, (err, rows, fields) => {
    if (!err) {
      res.render("viewSalesBill", {
        title: "View Sales Bills",
        saleBills: rows,
      });
    } else {
      console.log(err.message);
      res.render("errorPage", {
        title: "Error!",
        error: "Error in fetching data from SQL",
        message:
          "Fatal error connecting to SQL Database Server. Please try again\
                    after restarting the system.",
      });
    }
  });
});

app.get("/view/salesbills", (req, res) => {
  connection.query(viewEmpQuery, (err, rows, fields) => {
    if (!err) {
      res.render("viewSalesBill", {
        title: "View Sales Bills",
        saleBills: rows,
      });
    } else {
      console.log(err.message);
      res.render("errorPage", {
        title: "Error!",
        error: "Error in fetching data from SQL",
        message:
          "Fatal error connecting to SQL Database Server. Please try again\
                    after restarting the system.",
      });
    }
  });
});

//---> Add Recs
app.get("/addRecs/addEmp", (req, res) => {
  if (usrName !== "") {
    res.render("addEmployeePage", {
      title: "Add Employee",
    });
  } else {
    res.render("errorPage", {
      title: "Error!",
      error: "Invalid Credentials",
      message:
        "These credentials do not exist on our database. Please signup for first time users.",
    });
  }
});

//----->Add Recs ----> Post Requests
app.post("/addRecs/addEmp", (req, res) => {
  if (usrName !== "") {
    const emp = req.body;
    console.log(emp);
    connection.query(
      addEmpQuery,
      [
        emp.ueid,
        emp.fname,
        emp.mname,
        emp.lname,
        emp.post,
        emp.aan,
        emp.pan,
        emp.bName,
        emp.bAccNum,
        emp.bIfsc,
      ],
      (err, rows, field) => {
        if (!err) {
          res.redirect("/view/employees");
        } else {
          res.render("errorPage", {
            title: "Error!",
            error: "Counldn't Add Employee",
            message: "Some error",
          });
        }
      }
    );
  } else {
    res.render("errorPage", {
      title: "Error!",
      error: "Invalid Credentials",
      message:
        "These credentials do not exist on our database. Please signup for first time users.",
    });
  }
});

//---> Remove Recs
app.get("/removeRecs/removeEmp", (req, res) => {
  if (usrName !== "") {
    res.render("removeEmp", {
      title: "Remove Emp",
    });
  } else {
    res.render("errorPage", {
      title: "Error!",
      error: "Invalid Credentials",
      message:
        "These credentials do not exist on our database. Please signup for first time users.",
    });
  }
});

//---> Remove Recs ----> Post Requests
app.post("/removeRecs/removeEmp", (req, res) => {
  if (usrName !== "") {
    const emp = req.body;
    connection.query(removeEmpQuery, [emp.ueid], (err, rows, fields) => {
      if (!err) {
        res.redirect("/view/employees");
      }
    });
  } else {
    res.render("errorPage", {
      title: "Error!",
      error: "Invalid Credentials",
      message:
        "These credentials do not exist on our database. Please signup for first time users.",
    });
  }
});

//Error Handling
app.use((req, res) => {
  res.status(404).render("errorPage", {
    title: "Error!",
    error: "404. Page Not Found.",
    message: "Please try inputting a proper address.",
  });
});

app.listen(4000, () => {
  console.log("ICMS SERVER Listening on Port 4000");
});
