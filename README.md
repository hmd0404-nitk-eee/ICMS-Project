# Manual for ICMS SQL DB Compiled Query,
**Created by Harshal Dhake, 191EE212, National Institute Of Technology, Karantaka.**

## 1. Stored Procedures and How to call them:
**Syntax: ```CALL <Stored Procedure Name> (<Parameters>);```**

	1. Verify_User(username, password)
	2. Add_DB_User(username, password, ueid, privilege)
	3. Remove_DB_User(username)
	4. Add_Employee(ueid, fname, mname, lname, post, aan, pan, bname, bAccNum, bIfsc)
	5. Remove_Employee(ueid)
	6. Add_Prd(pidn, pname, pdescrip, cidn)
	7. Remove_Prd(pidn)
	8. Add_Company_Client(cidn, cname, cremark, cgstin, cbName, cbAccNum, cbIfsc
	9. Remove_Company_Client(cidn)
	10. Add_Pur_Rec(precid, pidn, cidn, purPrice, dop, quantity, manfacturing date)
	11. Remove_Pur_Rec(precid)
	12. Add_Sale_Rec(srecid, pidn, cidn, salePrice, dos, quantity)
	13. Remove_Sale_Rec(srecid)
	14. GetAllProducts()
	15. GetAllCompanyClients()
	16. GetAllPurchaseBills()
	17. GetAllSalesBills()
	
## Tests: 
	1. Check all the stored procedures using the following pattern:
		CALL <Add procedures> <multiple procedures>
		
		CALL <Getting procedures>
		<Verify the data>
		
		CALL <Remove Procedures>
		
	2. Triggers need not be checked, Just check if the correct data is input in the tables PurchaseBills and SalesBills
	
	3. Report for any Errors and Mismatches.
