Create database Project1;
Use Project1;

Select * From Finance_1;
Select * From Finance_2;


DESC Finance_1;
Alter Table Finance_1 modify Column Issue_d date;

DESC Finance_2;
Alter Table Finance_2 Modify Column last_credit_pull_d date;
Alter Table Finance_2 Modify Column last_pymnt_d date;
ALter table Finance_2 Modify Column earliest_cr_line date;

-- Combine two tables
Select * From Finance_1
Inner JOIN Finance_2
On Finance_1.ID = Finance_2.ID;


-- Total Members Received Loan from Bank
Select Count(ID) as "Total Members" 
From Finance_1;

-- Total Loan Amount
Select Concat(Round(Sum(Loan_amnt)/1000000,2)," M") as "Total Loan Amount" 
From Finance_1;

-- Total Funded Amount
Select Concat(Round(Sum(Funded_amnt)/1000000,2)," M") as "Total Funded Amount" 
From Finance_1;

-- Total Payment
Select Concat(Round(Sum(Total_pymnt)/1000000,2)," M") As "Total Payment"  
From Finance_2;

-- Total Rec Interest
Select Concat(Round(Sum(total_rec_int)/1000000,2)," M") as "Total Rec Interest" 
From Finance_2;

-- Total Rec Late Fees
Select Concat(Round(Sum(total_rec_late_fee)/1000,2)," K") as "Total_Rec_Late_Fee"
From Finance_2;

-- Total Revol Balance
Select Concat(Round(Sum(revol_bal)/1000000,2)," M") as "Total Revol Balance"
From Finance_2;

-- Year Wise Total Loan Amount
Select Year(Issue_d) as Year, Concat(Round(SUM(loan_amnt)/1000000, 2), "M") as "Total Loan Amnt"
From Finance_1
Group By Year
Order By Year;

-- Total Payment and Total Loan Amount By Verification Status
Select Distinct(F1.verification_status) as "Verification Status", Concat(Round(Sum(F1.Loan_Amnt)/1000000,2)," M") as "Total Loan Amount", 
Concat(Round(Sum(F2.total_pymnt)/1000000,2)," M") as "Total Payment"
From Finance_1 as F1
Inner Join
Finance_2 as F2
On F1.ID = F2.ID
Group By (F1.verification_status);
 
-- Total Payment Vs Total Rec Int By Home Ownership
Select Distinct(F1.home_ownership) as "Home Ownership", Concat(Round(Sum(F2.Total_pymnt)/1000,2),"K") as "Total Payment", 
Concat(Round(Sum(F2.total_rec_int)/1000,2),"K") as "Total Rec Interest"
From Finance_1 as F1
Inner JOIN Finance_2 as F2
ON F1.ID = F2.ID
Group By (F1.home_ownership) ;

-- Total Loan Amount Vs Total Rec. Int. By Purpose
Select Distinct(F1.Purpose) as "Purpose", Concat(Round(Sum(F1.Loan_Amnt)/1000000,2)," M") as "Total Loan Amnt", 
Concat(Round(Sum(F2.total_rec_int)/1000000,2)," M") as "Total Rec. Int."
From Finance_1 as F1
Inner Join
Finance_2 as F2
On F1.ID = F2.ID
Group By Purpose
Order by Purpose;


-- Total Loan Amount By Emp Length
Select Distinct(emp_Length), Concat(Round(Sum(Loan_Amnt)/1000000,2)," M") as "Total Loan Amount"
From Finance_1
Group By emp_Length
Order By emp_Length;

-- Total Loan Amount by Loan Status
Select Distinct(Loan_Status) as "Loan Status",
Concat(Round(Sum(Loan_amnt)/1000000,2),"M") as "Total Loan Amount"
from Finance_1
Group By Loan_Status
Order By Sum(Loan_amnt) Desc;

-- Total Bad Loan / Written off Loan
Select Loan_Status, Concat(Round(Sum(loan_amnt)/1000000,2), "M") as "Total Loan Amount" From Finance_1
Where Loan_Status = "Charged Off";

-- Total Loan Amount by Verification Status
Select Distinct(Verification_Status) as "Verification Status",
Concat(Round(Sum(Loan_amnt)/1000000,2),"M") as "Total Loan Amount"
from Finance_1
Group By Verification_Status
Order By Sum(Loan_amnt) Desc;

-- Total Loan Amount by Home Ownership
Select Distinct(home_ownership) as "Home Ownership",
Concat(Round(Sum(Loan_amnt)/1000000,2),"M") as "Total Loan Amount"
from Finance_1
Group By home_ownership
Order By Sum(Loan_amnt) Desc;



-- Term Wise Count of Loan
Select Distinct(Term) as "Term", Count(Loan_Amnt) as "Count of Loan"
From Finance_1
Group By Term;

-- Top 10 States by Loan Amount
Select Distinct(addr_state) as "State", Concat(Round(Sum(Loan_amnt)/1000000,2)," M") as "Total Loan Amount"
From  Finance_1
Group By State
Order By Sum(Loan_amnt) Desc
Limit 10;

-- Bottom 10 States by Loan Amount
Select Distinct(addr_state) as "State", Concat(Round(Sum(Loan_amnt)/1000,2)," K") as "Total Loan Amount"
From  Finance_1
Group By State
Order By Sum(Loan_amnt) Asc
Limit 10;


-- Home Ownership Vs Last Payment Status

Select Distinct(F1.Home_Ownership) as HomeOwnership, Round(SUM(F2.Last_Pymnt_Amnt),0) as "Total Last Payment"
From Finance_1 as F1
Inner Join
Finance_2 as F2
On F1.ID = F2.ID
Group By HomeOwnership
Order By HomeOwnership;

-- Grade and Sub Grade Wise Revol Balance
 Select Distinct(F1.Grade) as "Grade", F1.Sub_Grade as "Sub Grade", Concat(Round(SUM(F2.Revol_Bal)/1000000,2)," M") as "Revol Bal"
From Finance_1 as F1
INNER JOIN
Finance_2 as F2
On F1.ID = F2.ID
Group BY Grade, Sub_Grade
Order By Grade, Sub_Grade;
 

--  Detail report as View
-- (Purpose, Home OwnerShip, Loan Status Wise Total Loan Amount, Total Funded Amount, Total Payment, Total Rec Int. and Total Revol Balance)

Create View Detail_Report as Select F1.Purpose, F1.Home_Ownership, F1.Loan_Status, 
Sum(F1.Loan_Amnt) as "Total Loan Amnt", Sum(F1.Funded_Amnt) as "Total Funded Amnt", Round(Sum(F2.total_pymnt),0) as "Total Paymnt", Round(Sum(F2.total_rec_int),0) "Total Rec Int", Sum(F2.Revol_Bal) as "Total Revol Bal"
From Finance_1 as F1
Inner JOIN
Finance_2 as F2
On F1.ID = F2.ID
Group By Purpose, Home_Ownership, Loan_Status
Order By Purpose, Home_Ownership, Loan_Status;

Select * from Detail_Report;




