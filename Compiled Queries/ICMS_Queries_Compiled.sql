/*This is the compiled Query for Setting Up the SQL Database with all the tables, stored procedures, triggers
This file has been created for educational purposes only. Please refrain from copying, modifying and deleting from this file and/or any duplicates made thereof.
*/
/*By Harshal Dhake, 191EE212, National Institute Of Technology, Karnataka*/


/*Table Creation Query for ICMS - Inventory Control Management System*/
DROP TABLE IF EXISTS `EmployeeBankList`;
DROP TABLE IF EXISTS `DBUsers`;
DROP TABLE IF EXISTS `PurchaseRecords`;
DROP TABLE IF EXISTS `SalesRecords`;
DROP TABLE IF EXISTS `CompanyClientBankList`;
DROP TABLE IF EXISTS `EmployeeList`;
DROP TABLE IF EXISTS `ProductRefBase`;
DROP TABLE IF EXISTS `PurchaseBills`;
DROP TABLE IF EXISTS `SalesBills`;

CREATE TABLE `EmployeeList` (
	`ueid` int unsigned NOT NULL,
    `l-name` varchar(10) NOT NULL,
    `f-name` varchar(10) NOT NULL,
    `m-name` varchar(10) NOT NULL,
    `post` varchar(10) NOT NULL,
    `aan` int unsigned NOT NULL,
    `pan` int unsigned NOT NULL,
    PRIMARY KEY (`ueid`),
    
    unique key `fullname` (`l-name`, `f-name`, `m-name`),
    unique key `aan` (`aan`),
    unique key `pan` (`pan`)
);

CREATE TABLE `EmployeeBankList` (
	`ueid` int unsigned NOT NULL,
    `b-name` varchar(20) NOT NULL,
    `b-acc-num` int unsigned NOT NULL unique,
    `b-ifsc` int unsigned NOT NULL,
    
    CONSTRAINT UEID_Bank_FK FOREIGN KEY (`ueid`) REFERENCES EmployeeList(`ueid`)
    ON DELETE CASCADE
);

CREATE TABLE `DBUsers` (
	`ueid` int unsigned NOT NULL,
    `username` varchar(10) NOT NULL unique,
    `password` varchar(20) NOT NULL,
    `privilege` varchar(10) NOT NULL,
    PRIMARY KEY (`username`),
    
    unique key `login-cred` (`username`, `password`),
    CONSTRAINT UEID_DB_FK FOREIGN KEY (`ueid`) REFERENCES EmployeeList(`ueid`)
    ON DELETE CASCADE
);

DROP TABLE IF EXISTS `CompanyClientBase`;
CREATE TABLE `CompanyClientBase` (
	`cidn` int unsigned NOT NULL,
    `c-name` varchar(10) NOT NULL,
    `c-remarks` varchar(20) default NULL,
    `c-gst-in` int unsigned NOT NULL,
    PRIMARY KEY (`cidn`)
);

CREATE TABLE `CompanyClientBankList` (
	`cidn` int unsigned NOT NULL,
    `cb-name` varchar(20) NOT NULL,
    `cb-acc-num` int unsigned NOT NULL unique,
    `cb-ifsc` int unsigned NOT NULL,
    
    CONSTRAINT CIDN_Bank_FK FOREIGN KEY (`cidn`) REFERENCES CompanyClientBase(`cidn`)
    ON DELETE CASCADE
);

CREATE TABLE `ProductRefBase` (
	`pidn` int unsigned NOT NULL,
    `p-name` varchar(10) NOT NULL,
    `p-descrip` varchar(20) default NULL,
    `cidn` int unsigned NOT NULL,
    PRIMARY KEY (`pidn`),
    
    CONSTRAINT CIDN_PRD_REF_FK FOREIGN KEY (`cidn`) REFERENCES CompanyClientBase(`cidn`)
    ON DELETE CASCADE,
    UNIQUE KEY `product` (`pidn`, `cidn`)
);

CREATE TABLE `PurchaseRecords` (
	`p-rec-id` int unsigned NOT NULL,
    `pidn` int unsigned NOT NULL,
    `cidn` int unsigned NOT NULL,
    `pur-price` int unsigned NOT NULL,
    `dop` date,
    `quantity` int unsigned default NULL,
    `manfac-date` date default NULL,
    PRIMARY KEY (`p-rec-id`),
    
    CONSTRAINT PIDN_PUR_FK FOREIGN KEY (`pidn`) REFERENCES ProductRefBase(`pidn`) ON DELETE CASCADE,
    CONSTRAINT CIDN_PUR_FK FOREIGN KEY (`cidn`) REFERENCES ProductRefBase(`cidn`) ON DELETE CASCADE
);

CREATE TABLE `SalesRecords` (
	`s-rec-id` int unsigned NOT NULL,
    `pidn` int unsigned NOT NULL,
    `cidn` int unsigned NOT NULL,
    `sale-price` int unsigned NOT NULL,
    `dos` date,
    `quantity` int unsigned default NULL,
    PRIMARY KEY (`s-rec-id`),
    
    CONSTRAINT PIDN_SALE_FK FOREIGN KEY (`pidn`) REFERENCES ProductRefBase(`pidn`) ON DELETE CASCADE,
    CONSTRAINT CIDN_SALE_FK FOREIGN KEY (`cidn`) REFERENCES ProductRefBase(`cidn`) ON DELETE CASCADE
);

CREATE TABLE `PurchaseBills` (
	`bill-num` varchar(20),
    `p-rec-id` int unsigned NOT NULL,
    `bill-date` date,
    `pur-price` int unsigned NOT NULL,
    
    PRIMARY KEY (`bill-num`)
);

CREATE TABLE `SalesBills` (
	`bill-num` varchar(20),
    `s-rec-id` int unsigned NOT NULL,
    `bill-date` date,
    `sale-price` int unsigned NOT NULL,
    
    PRIMARY KEY (`bill-num`)
);


/*Query for Createing Stored Procedures for ICMS - Inventory Control Management System*/
DROP PROCEDURE IF EXISTS `Verify_User`;
DROP PROCEDURE IF EXISTS `Add_DB_User`;
DROP PROCEDURE IF EXISTS `Remove_DB_User`;
DROP PROCEDURE IF EXISTS `Add_Employee`;
DROP PROCEDURE IF EXISTS `Remove_Employee`;
DROP PROCEDURE IF EXISTS `Add_Prd`;
DROP PROCEDURE IF EXISTS `Remove_Prd`;
DROP PROCEDURE IF EXISTS `Add_Company_Client`;
DROP PROCEDURE IF EXISTS `Remove_Company_Client`;
DROP PROCEDURE IF EXISTS `Add_Pur_Rec`;
DROP PROCEDURE IF EXISTS `Remove_Pur_Rec`;
DROP PROCEDURE IF EXISTS `Add_Sale_Rec`;
DROP PROCEDURE IF EXISTS `Remove_Sale_Rec`;
DROP PROCEDURE IF EXISTS `GetAllProducts`;
DROP PROCEDURE IF EXISTS `GetAllCompanyClients`;
DROP PROCEDURE IF EXISTS `GetAllPurchaseBills`;
DROP PROCEDURE IF EXISTS `GetAllSalesBills`;


DELIMITER $$

CREATE DEFINER=`root`@`localhost` 
PROCEDURE Verify_User(
	IN `usrname` varchar(10),
    IN `pswd` varchar(20)
)
BEGIN
	SELECT username, privilege
    FROM DBUsers
    WHERE username = usrname AND password = pswd;
END $$

CREATE DEFINER=`root`@`localhost` 
PROCEDURE Add_DB_User(
	IN `usrname` varchar(10),
    IN `pswd` varchar(20),
    IN `uid` int unsigned,
    IN `priv` varchar(10)
)
BEGIN
	INSERT INTO DBUsers VALUES (uid, usrname, pswd, priv);
END $$

CREATE DEFINER=`root`@`localhost` 
PROCEDURE Remove_DB_User(
	IN `usrname` varchar(10)
)
BEGIN
	DELETE FROM DBUsers WHERE DBUsers.username = usrname;
END $$

CREATE DEFINER=`root`@`localhost` 
PROCEDURE Add_Employee(
	IN `ueid` int unsigned,
	IN `fname` varchar(10),
    IN `mname` varchar(10),
    IN `lname` varchar(10),
    IN `post` varchar(10),
    IN `aadhar` int unsigned,
    IN `panNum` int unsigned,
    IN `bName` varchar(20),
    IN `bAccNum` int unsigned,
    IN `bIfsc` int unsigned
)
BEGIN
	INSERT INTO EmployeeList VALUES (ueid, lname, fname, mname, post, aadhar, panNum);
    INSERT INTO EmployeeBankList VALUES (ueid, bName, bAccNum, bIfsc);
END $$

CREATE DEFINER=`root`@`localhost` 
PROCEDURE Remove_Employee(
	IN `uid` int unsigned
)
BEGIN
	DELETE FROM DBUsers WHERE DBUsers.ueid = uid;
    DELETE FROM EmployeeBankList WHERE EmployeeBankList.ueid = uid;
    DELETE FROM EmployeeList WHERE EmployeeList.ueid = uid;
END $$

CREATE DEFINER=`root`@`localhost` 
PROCEDURE Add_Prd(
	IN `pid` int unsigned,
	IN `pname` varchar(10),
    IN `pdescrip` varchar(20),
    IN `cid` int unsigned
)
BEGIN
	INSERT INTO ProductRefBase VALUES (pid, pname, pdescrip, cid);
END $$

CREATE DEFINER=`root`@`localhost` 
PROCEDURE Remove_Prd(
    IN `pid` int unsigned
)
BEGIN
    DELETE FROM PurchaseRecords WHERE PurchaseRecords.pidn = pid;
    DELETE FROM SalesRecords WHERE SalesRecords.pidn = pid;
	DELETE FROM ProductRefBase WHERE ProductRefBase.pidn = pid;
END $$

CREATE DEFINER=`root`@`localhost` 
PROCEDURE Add_Company_Client(
	IN `cid` int unsigned,
	IN `cname` varchar(10),
    IN `cremarks` varchar(20),
    IN `cgstin` int unsigned,
    IN `cbName` varchar(10),
    IN `cbAccNum` int unsigned,
    IN `cbIfsc` int unsigned
)
BEGIN
	INSERT INTO CompanyClientBase VALUES (cid, cname, cremarks, cgstin);
    INSERT INTO CompanyClientBankList VALUES (cid, cbName, cbAccNum, cbIfsc);
END $$

CREATE DEFINER=`root`@`localhost` 
PROCEDURE Remove_Company_Client(
    IN `cid` int unsigned
)
BEGIN
	DELETE FROM CompanyClientBankList WHERE CompanyClientBankList.cidn = cid;
    DELETE FROM ProductRefBase WHERE ProductRefBase.cidn = cid;
    DELETE FROM PurchaseRecords WHERE PurchaseRecords.cidn = cid;
    DELETE FROM SalesRecords WHERE SalesRecords.cidn = cid;
    DELETE FROM CompanyClientBase WHERE CompanyClientBase.cidn = cid;
END $$

CREATE DEFINER=`root`@`localhost` 
PROCEDURE Add_Pur_Rec(
	IN `precid` int unsigned,
    IN `pid` int unsigned,
    IN `cid` int unsigned,
    IN `purPrice` int unsigned,
    IN `dOPur` date,
    IN `quan` int unsigned,
    IN `manfac_date` date
)
BEGIN
	INSERT INTO PurchaseRecords VALUES (precid, pid, cid, purPrice, dOPur, quan, manfac_date);
END $$

CREATE DEFINER=`root`@`localhost` 
PROCEDURE Add_Sale_Rec(
	IN `srecid` int unsigned,
    IN `pid` int unsigned,
    IN `cid` int unsigned,
    IN `salePrice` int unsigned,
    IN `dOSale` date,
    IN `quan` int unsigned
)
BEGIN
	INSERT INTO SalesRecords VALUES (srecid, pid, cid, salePrice, dOSale, quan);
END $$

CREATE DEFINER=`root`@`localhost` 
PROCEDURE Remove_Pur_Rec(
    IN `precid` int unsigned
)
BEGIN
	DELETE FROM PurchaseBills WHERE PurchaseBills.`p-rec-id` = precid;
    DELETE FROM PurchaseRecords WHERE PurchaseRecords.`p-rec-id` = precid;
END $$

CREATE DEFINER=`root`@`localhost` 
PROCEDURE Remove_Sale_Rec(
    IN `srecid` int unsigned
)
BEGIN
	DELETE FROM SalesBills WHERE SalesBills.s-rec-id = srecid;
    DELETE FROM SalesRecords WHERE SalesRecords.s-rec-id = srecid;
END $$

CREATE PROCEDURE GetAllProducts()
BEGIN
	SELECT p-name, p-descrip FROM ProductRefBase;
END $$

CREATE PROCEDURE GetAllCompanyClients()
BEGIN
	SELECT c-name, c-remarks FROM CompanyClientBase;
END $$

CREATE PROCEDURE GetAllPurchaseBills()
BEGIN
	SELECT bill-num, bill-date, pur-price FROM PurchaseBills;
END $$

CREATE PROCEDURE GetAllSalesBills()
BEGIN
	SELECT bill-num, bill-date, sale-price FROM SalesBills;
END $$

DELIMITER ;


/*Query for Createing Triggers for ICMS - Inventory Control Management System*/
DROP TRIGGER IF EXISTS `Add_Pur_Bill`;
DROP TRIGGER IF EXISTS `Add_Sale_Bill`;

DELIMITER $$
CREATE TRIGGER Add_Pur_Bill
AFTER INSERT ON PurchaseRecords
FOR EACH ROW
BEGIN
	IF (NEW.`p-rec-id` IS NOT NULL) THEN
		INSERT INTO PurchaseBills VALUES (
			NEW.`pidn`,
			NEW.`p-rec-id`,
			NEW.`dop`,
			NEW.`pur-price`
		);
	END IF;
END $$

CREATE TRIGGER Add_Sale_Bill
BEFORE INSERT ON SalesRecords
FOR EACH ROW
BEGIN
	IF (NEW.`s-rec-id` IS NOT NULL) THEN
		INSERT INTO SalesBills VALUES (
			NEW.pidn,
			NEW.`s-rec-id`,
			NEW.`dos`,
			NEW.`sale-price`
    );
    END IF;
END $$

DELIMITER ;
