 
create database University_Scholarship;
use University_Scholarship;

create table University (
University_name varchar(50),
University_ID varchar(10),
Street varchar(50),
City varchar(20),
State varchar(20),
primary key(University_name, University_ID));

create table Students (
    SRN char(13) primary key,
    Name varchar(30) not null,
    Semester int not null,
    Section char(1) not null,
    Branch varchar(20),
    Gender enum('Male', 'Female', 'Other'),
    Date_of_Birth date not null,
    Street varchar(50),
    City varchar(20),
    State varchar(20),
    CGPA float not null,
    SGPA float not null,
    Credits_received int not null,
    Credits_required int not null,
    Account_number bigint,
    IFSC_code varchar(11),
    Fee_category varchar(20) not null,
    Fee_amount bigint not null,
    Payment_status enum('Paid', 'Not Paid', 'Partial') not null,
    Eligibility varchar(30) default 'Not Specified'  -- Default value added
);


create table Status(
Type_of_Scholarship char(3) not null,
Scholarship_amount int not null,
Transaction_Status varchar(20) not null,
Name varchar(30),
SRN char(13) primary key);

create table Staff(
Staff_ID varchar(10) primary key,
Name varchar(30) not null,
Department_ID varchar(10) ,
Department_name varchar(20),
College_email varchar(50) unique not null);

create table GPA_Statistics(
Semester int ,
Branch varchar(20),
MRD_cutoff float not null,
CNR_cutoff float not null,
DAC_cutoff float not null default 7.75,
primary key (Semester, Branch));

create table Amount_Details(
Semester int ,
Branch varchar(20),
Fee_category varchar(20),
Fee_amount int not null,
MRD_amount int not null,
CNR_amount int not null,
DAC_amount int not null,
primary key(Semester,Fee_category,Branch));



create table Student_Phno(
SRN varchar(13),
Phone_no varchar(14),
primary key(SRN,Phone_no));

create table Student_Email(
SRN varchar(13),
Email varchar(50),
primary key(SRN,Email));

alter table Status add foreign key (SRN) references Students(SRN);
alter table Student_Phno add foreign key (SRN) references Students(SRN);
alter table Student_Email add foreign key (SRN) references Students(SRN);


insert into University values ('PES University', 'U01', 'Banashankari Stage 3', 'Bangalore' ,'Karnataka');

INSERT INTO Students (SRN, Name, Semester, Section, Branch, Gender, Date_of_Birth, Street, City, State, CGPA, SGPA, Credits_received, Credits_required, Account_number, IFSC_code, Fee_category, Fee_amount, Payment_status)
VALUES
('PES1UG22CS001', 'Rekha Singh', 5, 'B','Computer Science', 'Female', '2004-08-12', 'PEF', 'Mysore', 'Karnataka', 6.6, 6.3, 90, 92, 123456789012346, 'UBIN0564567', 'PESSAT', 410000, 'Partial'),
('PES1UG22CS002', 'Rajesh Kumar', 5, 'B','Computer Science', 'Male', '2004-06-12', 'DEF', 'Mysore', 'Karnataka', 8.2, 8.3, 92, 92, 123456789012346, 'UBIN0564567', 'PESSAT', 410000, 'Paid'),
('PES1UG22CS003', 'Ananya Gupta', 5, 'C','Computer Science', 'Female', '2004-03-23', 'GHI', 'Mangalore', 'Karnataka', 8.8, 9.0, 92, 92, 123456789012347, 'UBIN0564565', 'PESSAT', 410000, 'Paid'),
('PES1UG22CS004', 'Nikhil Jain', 5, 'A','Computer Science', 'Male', '2004-04-17', 'JKL', 'Bangalore', 'Karnataka', 7.9, 8.2, 92, 92, 123456789012348, 'UBIN0564567', 'CET', 112000, 'Paid'),
('PES1UG22CS005', 'Simran Kaur', 5, 'B','Computer Science', 'Female', '2004-08-09', 'MNO', 'Hubli', 'Karnataka', 9.0, 9.1, 92, 92, 123456789012349, 'UBIN0564567', 'PESSAT', 410000, 'Paid'),
('PES1UG22CS006', 'Arjun Mehta', 5, 'C','Computer Science', 'Male', '2004-01-15', 'PQR', 'Mysore', 'Karnataka', 8.5, 8.6, 92, 92, 123456789012350, 'UBIN0564567', 'Management', 1000000, 'Paid'),
('PES1UG22CS007', 'Nisha Verma', 5, 'A','Computer Science', 'Female', '2004-09-05', 'STU', 'Udupi', 'Karnataka', 7.6, 7.8, 92, 92, 123456789012351, 'UBIN0564567', 'PESSAT', 410000, 'Paid'),
('PES1UG22CS008', 'Deepak Nair', 5, 'B','Computer Science', 'Male', '2004-10-11', 'VWX', 'Bangalore', 'Karnataka', 8.3, 8.5, 88, 92, 123456789012352, 'UBIN0564568', 'CET', 112000, 'Not Paid'),
('PES1UG22CS009', 'Rhea Singh', 5, 'C','Computer Science', 'Female', '2004-12-20', 'YZ', 'Mangalore', 'Karnataka', 8.7, 8.9, 92, 92, 123456789012353, 'UBIN0564567', 'PESSAT', 410000, 'Paid'),
('PES1UG22CS010', 'Karthik Reddy', 5, 'A','Computer Science', 'Male', '2004-02-28', 'ABC', 'Hubli', 'Karnataka', 9.2, 9.3, 92, 92, 123456789012354, 'UBIN0564567', 'CET', 112000, 'Paid'),
('PES1UG22CS011', 'Sneha Sharma', 5, 'B','Computer Science', 'Female', '2004-11-18', 'DEF', 'Mysore', 'Karnataka', 9.4, 9.6, 92, 92, 123456789012355, 'UBIN0564567', 'PESSAT', 410000, 'Paid'),
('PES1UG22CS012', 'Ajay Menon', 5, 'C','Computer Science', 'Male', '2004-05-06', 'GHI', 'Mangalore', 'Karnataka', 7.7, 7.9, 92, 92, 123456789012356, 'UBIN0564567', 'Management', 1000000, 'Paid'),
('PES1UG22CS013', 'Maya Nair', 5, 'A','Computer Science', 'Female', '2004-01-20', 'JKL', 'Bangalore', 'Karnataka', 8.1, 8.2, 92, 92, 123456789012357, 'UBIN0564567', 'PESSAT', 410000, 'Paid'),
('PES1UG22CS014', 'Ravi Patel', 5, 'B','Computer Science', 'Male', '2004-07-12', 'MNO', 'Hubli', 'Karnataka', 8.0, 8.1, 92, 92, 123456789012358, 'UBIN0564567', 'CET', 112000, 'Paid'),
('PES1UG22CS015', 'Priya Shah', 5, 'C','Computer Science', 'Female', '2004-02-18', 'PQR', 'Mysore', 'Karnataka', 8.9, 9.0, 92, 92, 123456789012359, 'UBIN0564567', 'PESSAT', 410000, 'Paid'),
('PES1UG22CS016', 'Gaurav Desai', 5, 'A','Computer Science', 'Male', '2004-03-09', 'STU', 'Udupi', 'Karnataka', 7.8, 7.9, 92, 92, 123456789012360, 'UBIN0564571', 'Management', 1000000, 'Paid'),
('PES1UG22CS017', 'Ritika Mishra', 5, 'B','Computer Science', 'Female', '2004-04-17', 'VWX', 'Bangalore', 'Karnataka', 9.3, 9.4, 92, 92, 123456789012361, 'UBIN0564567', 'PESSAT', 410000, 'Paid'),
('PES1UG22CS018', 'Siddharth Rao', 5, 'C','Computer Science', 'Male', '2004-06-25', 'YZ', 'Mangalore', 'Karnataka', 8.6, 8.7, 92, 92, 123456789012362, 'UBIN0564567', 'CET', 112000, 'Paid'),
('PES1UG22CS019', 'Meera Yadav', 5, 'A','Computer Science', 'Female', '2004-09-12', 'ABC', 'Bangalore', 'Karnataka', 8.0, 8.1, 92, 92, 123456789012363, 'UBIN0564567', 'PESSAT', 410000, 'Paid'),
('PES1UG22CS020', 'Aditya Roy', 5, 'B','Computer Science', 'Male', '2004-10-01', 'DEF', 'Hubli', 'Karnataka', 8.4, 8.5, 92, 92, 123456789012364, 'UBIN0564567', 'Management', 1000000, 'Paid'),
('PES1UG22CS021', 'Ishita Rao', 5, 'C','Computer Science', 'Female', '2004-05-22', 'GHJ', 'Mysore', 'Karnataka', 8.3, 8.4, 92, 92, 123456789012365, 'UBIN0564567', 'PESSAT', 410000, 'Paid'),
('PES1UG22CS022', 'Aryan Singh', 5, 'B','Computer Science', 'Male', '2004-07-18', 'PQR', 'Bangalore', 'Karnataka', 8.7, 8.8, 92, 92, 123456789012366, 'UBIN0564567', 'CET', 112000, 'Paid'),
('PES1UG22CS023', 'Neha Iyer', 5, 'A','Computer Science', 'Female', '2004-02-09', 'JKL', 'Mangalore', 'Karnataka', 6.1, 6.2, 92, 92, 123456789012367, 'UBIN0564567', 'Management', 1000000, 'Paid'),
('PES1UG22CS024', 'Kunal Patel', 5, 'C','Computer Science', 'Male', '2004-06-06', 'XYZ', 'Hubli', 'Karnataka', 8.2, 8.4, 92, 92, 123456789012368, 'UBIN0564567', 'PESSAT', 410000, 'Paid'),
('PES1UG22CS025', 'Shivani Bhat', 5, 'B','Computer Science', 'Female', '2004-11-28', 'LMN', 'Udupi', 'Karnataka', 9.0, 9.1, 92, 92, 123456789012369, 'UBIN0564567', 'PESSAT', 410000, 'Paid');

INSERT INTO Students (SRN, Name, Semester, Section, Branch, Gender, Date_of_Birth, Street, City, State, CGPA, SGPA, Credits_received, Credits_required, Account_number, IFSC_code, Fee_category, Fee_amount, Payment_status)
VALUES
('PES1UG23CS001', 'Shreya Chopra', 3, 'B', 'Computer Science', 'Female', '2005-08-12', 'PEF', 'Mysore', 'Karnataka', 6.6, 6.3, 46, 48, 123456789012346, 'UBIN0564567', 'PESSAT', 460000, 'Paid'),
('PES1UG23CS002', 'Manoj Kumar', 3, 'B', 'Computer Science', 'Male', '2005-06-12', 'DEF', 'Mysore', 'Karnataka', 8.2, 8.3, 44, 48, 123456789012346, 'UBIN0564567', 'PESSAT', 460000, 'Paid'),
('PES1UG23CS003', 'Ananya Gupta', 3, 'C', 'Computer Science', 'Female', '2005-03-23', 'GHI', 'Mangalore', 'Karnataka', 8.8, 9.0, 43, 48, 123456789012347, 'UBIN0564567', 'PESSAT', 460000, 'Paid'),
('PES1UG23CS004', 'Nikhil Jain', 3, 'A', 'Computer Science', 'Male', '2005-04-17', 'JKL', 'Bangalore', 'Karnataka', 7.9, 8.2, 48, 48, 123456789012348, 'UBIN0564567', 'CET', 112000, 'Paid'),
('PES1UG23CS005', 'Simran Kaur', 3, 'B', 'Computer Science', 'Female', '2005-08-09', 'MNO', 'Hubli', 'Karnataka', 9.0, 9.1, 48, 48, 123456789012349, 'UBIN0564567', 'PESSAT', 460000, 'Paid'),
('PES1UG23CS006', 'Arjun Mehta', 3, 'C', 'Computer Science', 'Male', '2005-01-15', 'PQR', 'Mysore', 'Karnataka', 8.5, 8.6, 48, 48, 123456789012350, 'UBIN0564567', 'Management', 1250000, 'Not Paid'),
('PES1UG23CS007', 'Nisha Verma', 3, 'A', 'Computer Science', 'Female', '2005-09-05', 'STU', 'Udupi', 'Karnataka', 7.6, 7.8, 48, 48, 123456789012351, 'UBIN0564567', 'PESSAT', 460000, 'Partial'),
('PES1UG23CS008', 'Deepak Nair', 3, 'B', 'Computer Science', 'Male', '2005-10-11', 'VWX', 'Bangalore', 'Karnataka', 8.3, 8.5, 48, 48, 123456789012352, 'UBIN0564567', 'CET', 112000, 'Paid'),
('PES1UG23CS009', 'Rhea Singh', 3, 'C', 'Computer Science', 'Female', '2005-12-20', 'YZ', 'Mangalore', 'Karnataka', 8.7, 8.9, 48, 48, 123456789012353, 'UBIN0564567', 'PESSAT', 460000, 'Paid'),
('PES1UG23CS010', 'Karthik Reddy', 3, 'A', 'Computer Science', 'Male', '2005-02-28', 'ABC', 'Hubli', 'Karnataka', 9.2, 9.3, 48, 48, 123456789012354, 'UBIN0564567', 'CET', 112000, 'Paid'),
('PES1UG23CS011', 'Sneha Sharma', 3, 'B', 'Computer Science', 'Female', '2005-11-18', 'DEF', 'Mysore', 'Karnataka', 8.4, 8.6, 48, 48, 123456789012355, 'UBIN0564567', 'PESSAT', 460000, 'Paid'),
('PES1UG23CS012', 'Ajay Roy', 3, 'C', 'Computer Science', 'Male', '2005-05-06', 'GHI', 'Mangalore', 'Karnataka', 5.7, 5.9, 48, 48, 123456789012356, 'UBIN0564567', 'Management', 1250000, 'Paid'),
('PES1UG23CS013', 'Maya Ravi', 3, 'A', 'Computer Science', 'Female', '2005-01-20', 'JKL', 'Bangalore', 'Karnataka', 8.1, 8.2, 48, 48, 123456789012357, 'UBIN0564567', 'PESSAT', 460000, 'Paid'),
('PES1UG23CS014', 'Ravi Singh', 3, 'B', 'Computer Science', 'Male', '2005-07-12', 'MNO', 'Hubli', 'Karnataka', 8.0, 8.1, 48, 48, 123456789012358, 'UBIN0564567', 'CET', 112000, 'Paid'),
('PES1UG23CS015', 'Priya Shah', 3, 'C', 'Computer Science', 'Female', '2005-02-18', 'PQR', 'Mysore', 'Karnataka', 8.9, 9.0, 48, 48, 123456789012359, 'UBIN0564567', 'PESSAT', 460000, 'Paid'),
('PES1UG23CS016', 'Gaurav Desai', 3, 'A', 'Computer Science', 'Male', '2005-03-09', 'STU', 'Udupi', 'Karnataka', 7.8, 7.9, 48, 48, 123456789012360, 'UBIN0564567', 'Management', 1250000, 'Paid'),
('PES1UG23CS017', 'Ritika Mishra', 3, 'B', 'Computer Science', 'Female', '2005-04-17', 'VWX', 'Bangalore', 'Karnataka', 9.3, 9.4, 48, 48, 123456789012361, 'UBIN0564567', 'PESSAT', 460000, 'Paid'),
('PES1UG23CS018', 'Siddharth Mukherjee', 3, 'C', 'Computer Science', 'Male', '2005-06-25', 'YZ', 'Mangalore', 'Karnataka', 8.6, 8.7, 48, 48, 123456789012362, 'UBIN0564567', 'CET', 112000, 'Paid'),
('PES1UG23CS019', 'Meera Menin', 3, 'A', 'Computer Science', 'Female', '2005-09-12', 'ABC', 'Bangalore', 'Karnataka', 7.0, 7.1, 48, 48, 123456789012363, 'UBIN0564567', 'PESSAT', 460000, 'Paid'),
('PES1UG23CS020', 'Aditya Das', 3, 'B', 'Computer Science', 'Male', '2005-10-01', 'DEF', 'Hubli', 'Karnataka', 8.4, 8.5, 48, 48, 123456789012364, 'UBIN0564567', 'Management', 1250000, 'Paid'),
('PES1UG23CS021', 'Ishaan Mishra', 3, 'A', 'Computer Science', 'Male', '2005-07-19', 'LMN', 'Mysore', 'Karnataka', 7.9, 8.0, 48, 48, 123456789012365, 'UBIN0564567', 'PESSAT', 460000, 'Paid'),
('PES1UG23CS022', 'Tara Nair', 3, 'C', 'Computer Science', 'Female', '2005-09-15', 'OPQ', 'Bangalore', 'Karnataka', 8.3, 8.4, 48, 48, 123456789012366, 'UBIN0564567', 'Management', 1250000, 'Paid'),
('PES1UG23CS023', 'Rohit Shetty', 3, 'B', 'Computer Science', 'Male', '2005-05-22', 'RST', 'Hubli', 'Karnataka', 8.1, 8.2, 44, 48, 123456789012367, 'UBIN0564567', 'PESSAT', 460000, 'Paid'),
('PES1UG23CS024', 'Aditi Sharma', 3, 'A', 'Computer Science', 'Female', '2005-10-02', 'UVW', 'Mangalore', 'Karnataka', 8.7, 8.9, 48, 48, 123456789012368, 'UBIN0564567', 'Management', 1250000, 'Paid'),
('PES1UG23CS025', 'Vikram Singh', 3, 'C', 'Computer Science', 'Male', '2005-11-11', 'XYZ', 'Udupi', 'Karnataka', 8.5, 8.6, 48, 48, 123456789012369, 'UBIN0564567', 'PESSAT', 460000, 'Paid');

INSERT INTO Students (SRN, Name, Semester, Section, Branch, Gender, Date_of_Birth, Street, City, State, CGPA, SGPA, Credits_received, Credits_required, Account_number, IFSC_code, Fee_category, Fee_amount, Payment_status)
VALUES
('PES1UG22AM001', 'Aarav Nair', 5, 'B', 'AIML', 'Male', '2004-08-12', 'PEF', 'Mysore', 'Karnataka', 7.5, 7.3, 90, 92, 123456789012346, 'UBIN0564567', 'PESSAT', 410000, 'Paid'),
('PES1UG22AM002', 'Naina Rao', 5, 'B', 'AIML', 'Female', '2004-06-12', 'DEF', 'Mysore', 'Karnataka', 6.3, 6.1, 92, 92, 123456789012346, 'UBIN0564567', 'PESSAT', 410000, 'Paid'),
('PES1UG22AM003', 'Karan Gupta', 5, 'C', 'AIML', 'Male', '2004-03-23', 'GHI', 'Mangalore', 'Karnataka', 9.0, 9.2, 92, 92, 123456789012347, 'UBIN0564565', 'PESSAT', 410000, 'Paid'),
('PES1UG22AM004', 'Tanvi Sharma', 5, 'A', 'AIML', 'Female', '2004-04-17', 'JKL', 'Bangalore', 'Karnataka', 7.1, 7.4, 92, 92, 123456789012348, 'UBIN0564567', 'CET', 112000, 'Paid'),
('PES1UG22AM005', 'Devansh Singh', 5, 'B', 'AIML', 'Male', '2004-08-09', 'MNO', 'Hubli', 'Karnataka', 8.9, 9.0, 92, 92, 123456789012349, 'UBIN0564567', 'PESSAT', 410000, 'Paid'),
('PES1UG22AM006', 'Sanya Verma', 5, 'C', 'AIML', 'Female', '2004-01-15', 'PQR', 'Mysore', 'Karnataka', 8.2, 8.5, 92, 92, 123456789012350, 'UBIN0564567', 'Management', 1000000, 'Not Paid'),
('PES1UG22AM007', 'Rohan Mehta', 5, 'A', 'AIML', 'Male', '2004-09-05', 'STU', 'Udupi', 'Karnataka', 7.8, 8.0, 92, 92, 123456789012351, 'UBIN0564567', 'PESSAT', 410000, 'Partial'),
('PES1UG22AM008', 'Megha Nair', 5, 'B', 'AIML', 'Female', '2004-10-11', 'VWX', 'Bangalore', 'Karnataka', 8.6, 8.9, 88, 92, 123456789012352, 'UBIN0564568', 'CET', 112000, 'Paid'),
('PES1UG22AM009', 'Ritik Joshi', 5, 'C', 'AIML', 'Male', '2004-12-20', 'YZ', 'Mangalore', 'Karnataka', 8.4, 8.5, 92, 92, 123456789012353, 'UBIN0564567', 'PESSAT', 410000, 'Paid'),
('PES1UG22AM010', 'Diya Patil', 5, 'A', 'AIML', 'Female', '2004-02-28', 'ABC', 'Hubli', 'Karnataka', 9.1, 9.3, 92, 92, 123456789012354, 'UBIN0564567', 'CET', 112000, 'Paid'),
('PES1UG22AM011', 'Kunal Iyer', 5, 'B', 'AIML', 'Male', '2004-11-18', 'DEF', 'Mysore', 'Karnataka', 9.5, 9.6, 92, 92, 123456789012355, 'UBIN0564567', 'PESSAT', 410000, 'Paid'),
('PES1UG22AM012', 'Anika Bhat', 5, 'C', 'AIML', 'Female', '2004-05-06', 'GHI', 'Mangalore', 'Karnataka', 7.3, 7.5, 92, 92, 123456789012356, 'UBIN0564567', 'Management', 1000000, 'Paid'),
('PES1UG22AM013', 'Shivam Roy', 5, 'A', 'AIML', 'Male', '2004-01-20', 'JKL', 'Bangalore', 'Karnataka', 8.4, 8.6, 92, 92, 123456789012357, 'UBIN0564567', 'PESSAT', 410000, 'Paid'),
('PES1UG22AM014', 'Aditi Reddy', 5, 'B', 'AIML', 'Female', '2004-07-12', 'MNO', 'Hubli', 'Karnataka', 7.0, 7.1, 92, 92, 123456789012358, 'UBIN0564567', 'CET', 112000, 'Paid'),
('PES1UG22AM015', 'Vikrant Kaur', 5, 'C', 'AIML', 'Male', '2004-02-18', 'PQR', 'Mysore', 'Karnataka', 8.9, 9.0, 92, 92, 123456789012359, 'UBIN0564567', 'PESSAT', 410000, 'Paid'),
('PES1UG22AM016', 'Siddharth Kumar', 5, 'A', 'AIML', 'Male', '2004-03-09', 'STU', 'Udupi', 'Karnataka', 7.8, 7.9, 92, 92, 123456789012360, 'UBIN0564571', 'Management', 1000000, 'Paid'),
('PES1UG22AM017', 'Tanya Desai', 5, 'B', 'AIML', 'Female', '2004-04-17', 'VWX', 'Bangalore', 'Karnataka', 9.3, 9.4, 92, 92, 123456789012361, 'UBIN0564567', 'PESSAT', 410000, 'Paid'),
('PES1UG22AM018', 'Arnav Sharma', 5, 'C', 'AIML', 'Male', '2004-06-25', 'YZ', 'Mangalore', 'Karnataka', 5.6, 5.7, 92, 92, 123456789012362, 'UBIN0564567', 'CET', 112000, 'Paid'),
('PES1UG22AM019', 'Sanya Patel', 5, 'A', 'AIML', 'Female', '2004-09-12', 'ABC', 'Bangalore', 'Karnataka', 8.0, 8.1, 92, 92, 123456789012363, 'UBIN0564567', 'PESSAT', 410000, 'Paid'),
('PES1UG22AM020', 'Harsh Singh', 5, 'B', 'AIML', 'Male', '2004-10-01', 'DEF', 'Hubli', 'Karnataka', 8.4, 8.5, 92, 92, 123456789012364, 'UBIN0564567', 'Management', 1000000, 'Paid'),
('PES1UG22AM021', 'Niharika Roy', 5, 'C', 'AIML', 'Female', '2004-05-22', 'GHJ', 'Mysore', 'Karnataka', 8.3, 8.4, 92, 92, 123456789012365, 'UBIN0564567', 'PESSAT', 410000, 'Paid'),
('PES1UG22AM022', 'Yash Agarwal', 5, 'B', 'AIML', 'Male', '2004-07-28', 'MNO', 'Udupi', 'Karnataka', 7.2, 7.4, 92, 92, 123456789012366, 'UBIN0564567', 'CET', 112000, 'Paid'),
('PES1UG22AM023', 'Aditi Yadav', 5, 'C', 'AIML', 'Female', '2004-03-14', 'PQR', 'Mangalore', 'Karnataka', 9.0, 9.1, 92, 92, 123456789012367, 'UBIN0564567', 'PESSAT', 410000, 'Paid'),
('PES1UG22AM024', 'Raghav Joshi', 5, 'A', 'AIML', 'Male', '2004-10-05', 'STU', 'Bangalore', 'Karnataka', 8.1, 8.3, 92, 92, 123456789012368, 'UBIN0564567', 'Management', 1000000, 'Paid'),
('PES1UG22AM025', 'Meera Nair', 5, 'B', 'AIML', 'Female', '2004-12-18', 'YZ', 'Hubli', 'Karnataka', 8.5, 8.7, 92, 92, 123456789012369, 'UBIN0564567', 'CET', 112000, 'Paid');

INSERT INTO Students (SRN, Name, Semester, Section, Branch, Gender, Date_of_Birth, Street, City, State, CGPA, SGPA, Credits_received, Credits_required, Account_number, IFSC_code, Fee_category, Fee_amount, Payment_status)
VALUES
('PES1UG23AM001', 'Ananya Rao', 3, 'B', 'AIML', 'Female', '2005-08-12', 'PEF', 'Mysore', 'Karnataka', 6.9, 6.8, 46, 48, 123456789012346, 'UBIN0564567', 'PESSAT', 460000, 'Paid'),
('PES1UG23AM002', 'Vikram Desai', 3, 'B', 'AIML', 'Male', '2005-06-12', 'DEF', 'Mysore', 'Karnataka', 8.4, 8.5, 44, 48, 123456789012346, 'UBIN0564567', 'PESSAT', 460000, 'Paid'),
('PES1UG23AM003', 'Priya Mehta', 3, 'C', 'AIML', 'Female', '2005-03-23', 'GHI', 'Mangalore', 'Karnataka', 8.6, 8.8, 43, 48, 123456789012347, 'UBIN0564567', 'PESSAT', 460000, 'Paid'),
('PES1UG23AM004', 'Karan Singh', 3, 'A', 'AIML', 'Male', '2005-04-17', 'JKL', 'Bangalore', 'Karnataka', 7.3, 7.6, 48, 48, 123456789012348, 'UBIN0564567', 'CET', 112000, 'Paid'),
('PES1UG23AM005', 'Rhea Sharma', 3, 'B', 'AIML', 'Female', '2005-08-09', 'MNO', 'Hubli', 'Karnataka', 9.1, 9.3, 48, 48, 123456789012349, 'UBIN0564567', 'PESSAT', 460000, 'Paid'),
('PES1UG23AM006', 'Arjun Iyer', 3, 'C', 'AIML', 'Male', '2005-01-15', 'PQR', 'Mysore', 'Karnataka', 8.5, 8.6, 48, 48, 123456789012350, 'UBIN0564567', 'Management', 1250000, 'Not Paid'),
('PES1UG23AM007', 'Simran Kaur', 3, 'A', 'AIML', 'Female', '2005-09-05', 'STU', 'Udupi', 'Karnataka', 7.8, 8.0, 48, 48, 123456789012351, 'UBIN0564567', 'PESSAT', 460000, 'Partial'),
('PES1UG23AM008', 'Deepak Rao', 3, 'B', 'AIML', 'Male', '2005-10-11', 'VWX', 'Bangalore', 'Karnataka', 8.3, 8.5, 48, 48, 123456789012352, 'UBIN0564567', 'CET', 112000, 'Paid'),
('PES1UG23AM009', 'Maya Nair', 3, 'C', 'AIML', 'Female', '2005-12-20', 'YZ', 'Mangalore', 'Karnataka', 8.7, 8.9, 48, 48, 123456789012353, 'UBIN0564567', 'PESSAT', 460000, 'Paid'),
('PES1UG23AM010', 'Karthik Reddy', 3, 'A', 'AIML', 'Male', '2005-02-28', 'ABC', 'Hubli', 'Karnataka', 9.2, 9.3, 48, 48, 123456789012354, 'UBIN0564567', 'CET', 112000, 'Paid'),
('PES1UG23AM011', 'Sneha Sharma', 3, 'B', 'AIML', 'Female', '2005-11-18', 'DEF', 'Mysore', 'Karnataka', 8.4, 8.6, 48, 48, 123456789012355, 'UBIN0564567', 'PESSAT', 460000, 'Paid'),
('PES1UG23AM012', 'Ajay Roy', 3, 'C', 'AIML', 'Male', '2005-05-06', 'GHI', 'Mangalore', 'Karnataka', 5.7, 5.9, 48, 48, 123456789012356, 'UBIN0564567', 'Management', 1250000, 'Paid'),
('PES1UG23AM013', 'Ravi Singh', 3, 'A', 'AIML', 'Male', '2005-01-20', 'JKL', 'Bangalore', 'Karnataka', 8.1, 8.2, 48, 48, 123456789012357, 'UBIN0564567', 'PESSAT', 460000, 'Paid'),
('PES1UG23AM014', 'Tara Kapoor', 3, 'B', 'AIML', 'Female', '2005-07-12', 'MNO', 'Hubli', 'Karnataka', 7.0, 7.1, 48, 48, 123456789012358, 'UBIN0564567', 'CET', 112000, 'Paid'),
('PES1UG23AM015', 'Nikhil Gupta', 3, 'C', 'AIML', 'Male', '2005-02-18', 'PQR', 'Mysore', 'Karnataka', 8.9, 9.0, 48, 48, 123456789012359, 'UBIN0564567', 'PESSAT', 460000, 'Paid'),
('PES1UG23AM016', 'Gaurav Desai', 3, 'A', 'AIML', 'Male', '2005-03-09', 'STU', 'Udupi', 'Karnataka', 7.8, 7.9, 48, 48, 123456789012360, 'UBIN0564567', 'Management', 1250000, 'Paid'),
('PES1UG23AM017', 'Ritika Joshi', 3, 'B', 'AIML', 'Female', '2005-04-17', 'VWX', 'Bangalore', 'Karnataka', 9.3, 9.4, 48, 48, 123456789012361, 'UBIN0564567', 'PESSAT', 460000, 'Paid'),
('PES1UG23AM018', 'Siddharth Mukherjee', 3, 'C', 'AIML', 'Male', '2005-06-25', 'YZ', 'Mangalore', 'Karnataka', 8.6, 8.7, 48, 48, 123456789012362, 'UBIN0564567', 'CET', 112000, 'Paid'),
('PES1UG23AM019', 'Aarav Menon', 3, 'A', 'AIML', 'Male', '2005-09-12', 'ABC', 'Bangalore', 'Karnataka', 7.0, 7.1, 48, 48, 123456789012363, 'UBIN0564567', 'PESSAT', 460000, 'Paid'),
('PES1UG23AM020', 'Aditya Das', 3, 'B', 'AIML', 'Male', '2005-10-01', 'DEF', 'Hubli', 'Karnataka', 8.4, 8.5, 48, 48, 123456789012364, 'UBIN0564567', 'Management', 1250000, 'Paid'),
('PES1UG23AM021', 'Ishaan Sharma', 3, 'A', 'AIML', 'Male', '2005-07-19', 'LMN', 'Mysore', 'Karnataka', 7.9, 8.0, 48, 48, 123456789012365, 'UBIN0564567', 'PESSAT', 460000, 'Paid'),
('PES1UG23AM022', 'Tara Nair', 3, 'C', 'AIML', 'Female', '2005-09-15', 'OPQ', 'Bangalore','Karnataka',9.5,9.7,48,48,123456789012366,'UBIN0564567', 'PESSAT', 460000, 'Paid');

SET SQL_SAFE_UPDATES = 0;

UPDATE Students
SET Eligibility = CASE 
    WHEN CGPA > 7.75 
         AND Credits_received = Credits_required 
         AND Payment_status = 'Paid' THEN 'Eligible'
    ELSE 'Not Eligible'
END;

SET SQL_SAFE_UPDATES = 1;  

INSERT INTO Staff (Staff_ID, Name, Department_ID, Department_name, College_email) VALUES
('S001', 'Aarav Sharma', 'D001', 'Computer Science', 'aarav.sharma@pesu.pes.edu'),
('S002', 'Diya Gupta', 'D002', 'AI & ML', 'diya.gupta@pesu.pes.edu'),
('S003', 'Vivaan Mehta', 'D003', 'Computer Science', 'vivaan.mehta@pesu.pes.edu'),
('S004', 'Anaya Reddy', 'D004', 'AI & ML', 'anaya.reddy@pesu.pes.edu'),
('S005', 'Ishaan Patel', 'D005', 'Computer Science', 'ishaan.patel@pesu.pes.edu');

select * from staff;



SET SQL_SAFE_UPDATES = 0;
INSERT INTO GPA_Statistics (Semester, Branch, MRD_cutoff, CNR_cutoff, DAC_cutoff)
SELECT 
    Semester,
    Branch,
    GREATEST(MIN(CGPA), 9) AS MRD_cutoff,  -- Ensure MRD cutoff is at least 9
    0 AS CNR_cutoff,  -- Placeholder, will be updated later
    7.75 AS DAC_cutoff   -- Default DAC cutoff
FROM 
    (SELECT *,
        NTILE(20) OVER (PARTITION BY Semester, Branch ORDER BY CGPA DESC) AS percentile
     FROM Students) AS ranked
WHERE percentile = 1  -- Top 5%
GROUP BY Semester, Branch;
UPDATE GPA_Statistics g
JOIN (
    SELECT 
        s.Semester,
        s.Branch,
        GREATEST(MIN(s.SGPA), 8.5) AS CNR_cutoff
    FROM 
        Students s
    JOIN 
        GPA_Statistics m ON s.Semester = m.Semester AND s.Branch = m.Branch
    WHERE 
        s.SGPA >= 8.5  -- Only consider SGPA >= 8.5
        AND s.CGPA < m.MRD_cutoff  -- Exclude those who meet or exceed MRD cutoff
    GROUP BY s.Semester, s.Branch
) AS CNR_Cutoffs
ON g.Semester = CNR_Cutoffs.Semester AND g.Branch = CNR_Cutoffs.Branch
SET g.CNR_cutoff = CNR_Cutoffs.CNR_cutoff;

SET SQL_SAFE_UPDATES = 0;
select * from gpa_statistics;
-- select * from mrd_cutoff_table;
-- select * from cnr_cutoff_Table;

-- delete from amount_details;
-- drop table fees;
CREATE TABLE fees AS
SELECT DISTINCT 
    s.Fee_category,
    s.Branch,
    s.Semester,
    s.Fee_amount AS Original_Fee_amount,  -- Store the original fee
    CASE 
        WHEN s.Fee_category = 'Management' THEN 
            (SELECT Fee_amount FROM Students WHERE Fee_category = 'PESSAT' AND Branch = s.Branch AND Semester = s.Semester LIMIT 1) 
        ELSE s.Fee_amount 
    END AS Modified_Fee_amount  -- Store the modified fee
FROM Students s;



select * from fees;

INSERT INTO Amount_Details (Semester, Branch, Fee_category, Fee_amount, MRD_amount, CNR_amount, DAC_amount)
SELECT 
    Semester,
    Branch,
    Fee_category,
    Original_Fee_amount,
    Modified_Fee_amount * 0.5 AS MRD_amount,  -- 50% of Fee_amount
    Modified_Fee_amount * 0.4 AS CNR_amount,  -- 40% of Fee_amount
    2000 AS DAC_amount                -- Fixed amount for DAC
FROM fees;

select * from amount_details;

INSERT INTO Student_Phno (SRN, Phone_no) VALUES
('PES1UG22CS001', '+91 1234567890'),
('PES1UG22CS002', '+91 9876543210'),
('PES1UG22CS003', '+91 1234567891'),
('PES1UG22CS004', '+91 9876543211'),
('PES1UG22CS005', '+91 1234567892'),
('PES1UG22CS006', '+91 9876543212'),
('PES1UG22CS007', '+91 1234567893'),
('PES1UG22CS008', '+91 9876543213'),
('PES1UG22CS009', '+91 1234567894'),
('PES1UG22CS010', '+91 9876543214'),
('PES1UG22CS011', '+91 1234567895'),
('PES1UG22CS012', '+91 9876543215'),
('PES1UG22CS013', '+91 1234567896'),
('PES1UG22CS014', '+91 9876543216'),
('PES1UG22CS015', '+91 1234567897'),
('PES1UG22CS016', '+91 9876543217'),
('PES1UG22CS017', '+91 1234567898'),
('PES1UG22CS018', '+91 9876543218'),
('PES1UG22CS019', '+91 1234567899'),
('PES1UG22CS020', '+91 9876543219'),
('PES1UG22CS021', '+91 1234567800'),
('PES1UG22CS022', '+91 9876547801'),
('PES1UG22CS023', '+91 1234567802'),
('PES1UG22CS024', '+91 9876547803'),
('PES1UG22CS025', '+91 1234567804'),
('PES1UG22CS025', '+91 1234567805');

INSERT INTO Student_Phno (SRN, Phone_no) VALUES
('PES1UG22AM001', '+91 2345678901'),
('PES1UG22AM002', '+91 8765432102'),
('PES1UG22AM003', '+91 2345678903'),
('PES1UG22AM004', '+91 8765432104'),
('PES1UG22AM005', '+91 2345678905'),
('PES1UG22AM006', '+91 8765432106'),
('PES1UG22AM007', '+91 2345678907'),
('PES1UG22AM008', '+91 8765432108'),
('PES1UG22AM009', '+91 2345678909'),
('PES1UG22AM010', '+91 8765432100'),
('PES1UG22AM011', '+91 2345678911'),
('PES1UG22AM012', '+91 8765432112'),
('PES1UG22AM013', '+91 2345678913'),
('PES1UG22AM014', '+91 8765432114'),
('PES1UG22AM015', '+91 2345678915'),
('PES1UG22AM016', '+91 8765432116'),
('PES1UG22AM017', '+91 2345678917'),
('PES1UG22AM018', '+91 8765432118'),
('PES1UG22AM019', '+91 2345678919'),
('PES1UG22AM020', '+91 8765432120'),
('PES1UG22AM021', '+91 2345678921'),
('PES1UG22AM022', '+91 8765432122'),
('PES1UG22AM023', '+91 2345678923'),
('PES1UG22AM024', '+91 8765432124'),
('PES1UG22AM024', '+91 8765432129'),
('PES1UG22AM025', '+91 2345678925');

INSERT INTO Student_Phno (SRN, Phone_no) VALUES
('PES1UG23CS001', '+91 3456789012'),
('PES1UG23CS002', '+91 7654321093'),
('PES1UG23CS003', '+91 3456789014'),
('PES1UG23CS004', '+91 7654321095'),
('PES1UG23CS005', '+91 3456789016'),
('PES1UG23CS006', '+91 7654321097'),
('PES1UG23CS007', '+91 3456789018'),
('PES1UG23CS008', '+91 7654321099'),
('PES1UG23CS009', '+91 3456789020'),
('PES1UG23CS010', '+91 7654321101'),
('PES1UG23CS011', '+91 3456789022'),
('PES1UG23CS012', '+91 7654321103'),
('PES1UG23CS013', '+91 3456789024'),
('PES1UG23CS014', '+91 7654321105'),
('PES1UG23CS015', '+91 3456789026'),
('PES1UG23CS016', '+91 7654321107'),
('PES1UG23CS017', '+91 3456789028'),
('PES1UG23CS018', '+91 7654321109'),
('PES1UG23CS019', '+91 3456789030'),
('PES1UG23CS020', '+91 7654321111'),
('PES1UG23CS021', '+91 3456789032'),
('PES1UG23CS022', '+91 7654321113'),
('PES1UG23CS023', '+91 3456789034'),
('PES1UG23CS023', '+91 3456789038'),
('PES1UG23CS024', '+91 7654321115'),
('PES1UG23CS025', '+91 3456789036');

INSERT INTO Student_Phno (SRN, Phone_no) VALUES
('PES1UG23AM001', '+91 4567890123'),
('PES1UG23AM002', '+91 6543210987'),
('PES1UG23AM003', '+91 4567890124'),
('PES1UG23AM004', '+91 6543210988'),
('PES1UG23AM005', '+91 4567890125'),
('PES1UG23AM006', '+91 6543210989'),
('PES1UG23AM007', '+91 4567890126'),
('PES1UG23AM008', '+91 6543210990'),
('PES1UG23AM009', '+91 4567890127'),
('PES1UG23AM010', '+91 6543210991'),
('PES1UG23AM011', '+91 4567890128'),
('PES1UG23AM012', '+91 6543210992'),
('PES1UG23AM013', '+91 4567890129'),
('PES1UG23AM014', '+91 6543210993'),
('PES1UG23AM015', '+91 4567890130'),
('PES1UG23AM016', '+91 6543210994'),
('PES1UG23AM017', '+91 4567890131'),
('PES1UG23AM018', '+91 6543210995'),
('PES1UG23AM019', '+91 4567890132'),
('PES1UG23AM020', '+91 6543210996'),
('PES1UG23AM021', '+91 4567890133'),
('PES1UG23AM021', '+91 4567890138'),
('PES1UG23AM022', '+91 6543210997');


INSERT INTO Student_Email (SRN, Email) VALUES
('PES1UG22CS001', 'pes1ug22cs001@pesu.pes.edu'),
('PES1UG22CS001', 'rekha.singh@gmail.com'),
('PES1UG22CS002', 'pes1ug22cs002@pesu.pes.edu'),
('PES1UG22CS003', 'pes1ug22cs003@pesu.pes.edu'),
('PES1UG22CS004', 'pes1ug22cs004@pesu.pes.edu'),
('PES1UG22CS005', 'pes1ug22cs005@pesu.pes.edu'),
('PES1UG22CS006', 'pes1ug22cs006@pesu.pes.edu'),
('PES1UG22CS007', 'pes1ug22cs007@pesu.pes.edu'),
('PES1UG22CS008', 'pes1ug22cs008@pesu.pes.edu'),
('PES1UG22CS009', 'pes1ug22cs009@pesu.pes.edu'),
('PES1UG22CS010', 'pes1ug22cs010@pesu.pes.edu'),
('PES1UG22CS011', 'pes1ug22cs011@pesu.pes.edu'),
('PES1UG22CS012', 'pes1ug22cs012@pesu.pes.edu'),
('PES1UG22CS013', 'pes1ug22cs013@pesu.pes.edu'),
('PES1UG22CS014', 'pes1ug22cs014@pesu.pes.edu'),
('PES1UG22CS015', 'pes1ug22cs015@pesu.pes.edu'),
('PES1UG22CS016', 'pes1ug22cs016@pesu.pes.edu'),
('PES1UG22CS017', 'pes1ug22cs017@pesu.pes.edu'),
('PES1UG22CS018', 'pes1ug22cs018@pesu.pes.edu'),
('PES1UG22CS019', 'pes1ug22cs019@pesu.pes.edu'),
('PES1UG22CS020', 'pes1ug22cs020@pesu.pes.edu'),
('PES1UG22CS021', 'pes1ug22cs021@pesu.pes.edu'),
('PES1UG22CS022', 'pes1ug22cs022@pesu.pes.edu'),
('PES1UG22CS023', 'pes1ug22cs023@pesu.pes.edu'),
('PES1UG22CS024', 'pes1ug22cs024@pesu.pes.edu'),
('PES1UG22CS025', 'pes1ug22cs025@pesu.pes.edu');


INSERT INTO Student_Email (SRN, Email) VALUES
('PES1UG22AM001', 'pes1ug22am001@pesu.pes.edu'),
('PES1UG22AM001', 'aarav.nair@gmail.com'),
('PES1UG22AM002', 'pes1ug22am002@pesu.pes.edu'),
('PES1UG22AM003', 'pes1ug22am003@pesu.pes.edu'),
('PES1UG22AM004', 'pes1ug22am004@pesu.pes.edu'),
('PES1UG22AM005', 'pes1ug22am005@pesu.pes.edu'),
('PES1UG22AM006', 'pes1ug22am006@pesu.pes.edu'),
('PES1UG22AM007', 'pes1ug22am007@pesu.pes.edu'),
('PES1UG22AM008', 'pes1ug22am008@pesu.pes.edu'),
('PES1UG22AM009', 'pes1ug22am009@pesu.pes.edu'),
('PES1UG22AM010', 'pes1ug22am010@pesu.pes.edu'),
('PES1UG22AM011', 'pes1ug22am011@pesu.pes.edu'),
('PES1UG22AM012', 'pes1ug22am012@pesu.pes.edu'),
('PES1UG22AM013', 'pes1ug22am013@pesu.pes.edu'),
('PES1UG22AM014', 'pes1ug22am014@pesu.pes.edu'),
('PES1UG22AM015', 'pes1ug22am015@pesu.pes.edu'),
('PES1UG22AM016', 'pes1ug22am016@pesu.pes.edu'),
('PES1UG22AM017', 'pes1ug22am017@pesu.pes.edu'),
('PES1UG22AM018', 'pes1ug22am018@pesu.pes.edu'),
('PES1UG22AM019', 'pes1ug22am019@pesu.pes.edu'),
('PES1UG22AM020', 'pes1ug22am020@pesu.pes.edu'),
('PES1UG22AM021', 'pes1ug22am021@pesu.pes.edu'),
('PES1UG22AM022', 'pes1ug22am022@pesu.pes.edu'),
('PES1UG22AM023', 'pes1ug22am023@pesu.pes.edu'),
('PES1UG22AM024', 'pes1ug22am024@pesu.pes.edu'),
('PES1UG22AM025', 'pes1ug22am025@pesu.pes.edu');

INSERT INTO Student_Email (SRN, Email) VALUES
('PES1UG23CS001', 'pes1ug23cs001@pesu.pes.edu'),
('PES1UG23CS001', 'shreya.chopra@gmail.com'),
('PES1UG23CS002', 'pes1ug23cs002@pesu.pes.edu'),
('PES1UG23CS003', 'pes1ug23cs003@pesu.pes.edu'),
('PES1UG23CS004', 'pes1ug23cs004@pesu.pes.edu'),
('PES1UG23CS005', 'pes1ug23cs005@pesu.pes.edu'),
('PES1UG23CS006', 'pes1ug23cs006@pesu.pes.edu'),
('PES1UG23CS007', 'pes1ug23cs007@pesu.pes.edu'),
('PES1UG23CS008', 'pes1ug23cs008@pesu.pes.edu'),
('PES1UG23CS009', 'pes1ug23cs009@pesu.pes.edu'),
('PES1UG23CS010', 'pes1ug23cs010@pesu.pes.edu'),
('PES1UG23CS011', 'pes1ug23cs011@pesu.pes.edu'),
('PES1UG23CS012', 'pes1ug23cs012@pesu.pes.edu'),
('PES1UG23CS013', 'pes1ug23cs013@pesu.pes.edu'),
('PES1UG23CS014', 'pes1ug23cs014@pesu.pes.edu'),
('PES1UG23CS015', 'pes1ug23cs015@pesu.pes.edu'),
('PES1UG23CS016', 'pes1ug23cs016@pesu.pes.edu'),
('PES1UG23CS017', 'pes1ug23cs017@pesu.pes.edu'),
('PES1UG23CS018', 'pes1ug23cs018@pesu.pes.edu'),
('PES1UG23CS019', 'pes1ug23cs019@pesu.pes.edu'),
('PES1UG23CS020', 'pes1ug23cs020@pesu.pes.edu'),
('PES1UG23CS021', 'pes1ug23cs021@pesu.pes.edu'),
('PES1UG23CS022', 'pes1ug23cs022@pesu.pes.edu'),
('PES1UG23CS023', 'pes1ug23cs023@pesu.pes.edu'),
('PES1UG23CS024', 'pes1ug23cs024@pesu.pes.edu'),
('PES1UG23CS025', 'pes1ug23cs025@pesu.pes.edu');

INSERT INTO Student_Email (SRN, Email) VALUES
('PES1UG23AM001', 'pes1ug23am001@pesu.pes.edu'),
('PES1UG23AM001', 'ananya.rao@gmail.com'),
('PES1UG23AM002', 'pes1ug23am002@pesu.pes.edu'),
('PES1UG23AM003', 'pes1ug23am003@pesu.pes.edu'),
('PES1UG23AM004', 'pes1ug23am004@pesu.pes.edu'),
('PES1UG23AM005', 'pes1ug23am005@pesu.pes.edu'),
('PES1UG23AM006', 'pes1ug23am006@pesu.pes.edu'),
('PES1UG23AM007', 'pes1ug23am007@pesu.pes.edu'),
('PES1UG23AM008', 'pes1ug23am008@pesu.pes.edu'),
('PES1UG23AM009', 'pes1ug23am009@pesu.pes.edu'),
('PES1UG23AM010', 'pes1ug23am010@pesu.pes.edu'),
('PES1UG23AM011', 'pes1ug23am011@pesu.pes.edu'),
('PES1UG23AM012', 'pes1ug23am012@pesu.pes.edu'),
('PES1UG23AM013', 'pes1ug23am013@pesu.pes.edu'),
('PES1UG23AM014', 'pes1ug23am014@pesu.pes.edu'),
('PES1UG23AM015', 'pes1ug23am015@pesu.pes.edu'),
('PES1UG23AM016', 'pes1ug23am016@pesu.pes.edu'),
('PES1UG23AM017', 'pes1ug23am017@pesu.pes.edu'),
('PES1UG23AM018', 'pes1ug23am018@pesu.pes.edu'),
('PES1UG23AM019', 'pes1ug23am019@pesu.pes.edu'),
('PES1UG23AM020', 'pes1ug23am020@pesu.pes.edu'),
('PES1UG23AM021', 'pes1ug23am021@pesu.pes.edu'),
('PES1UG23AM022', 'pes1ug23am022@pesu.pes.edu');

INSERT INTO Status (Type_of_Scholarship, Scholarship_amount, Transaction_Status, Name, SRN)
SELECT 
    CASE 
        WHEN s.Eligibility = 'Not Eligible' THEN 'N/A'  -- Not applicable for non-eligible students
        ELSE 
            CASE 
                WHEN s.CGPA >= g.MRD_cutoff THEN 'MRD'
                WHEN s.SGPA >= g.CNR_cutoff THEN 'CNR'
                WHEN s.CGPA >= g.DAC_cutoff THEN 'DAC'
                ELSE 'N/A'  -- No applicable scholarship
            END
    END AS Type_of_Scholarship,
    CASE 
        WHEN s.Eligibility = 'Not Eligible' THEN 0  -- No scholarship for non-eligible students
        ELSE 
            CASE 
                WHEN s.CGPA >= g.MRD_cutoff THEN a.Fee_amount  -- Fetching from Amount_Details for MRD
                WHEN s.SGPA >= g.CNR_cutoff THEN a.Fee_amount  -- Fetching from Amount_Details for CNR
                WHEN s.CGPA >= g.DAC_cutoff THEN a.Fee_amount  -- Fetching from Amount_Details for DAC
                ELSE 0  -- No applicable scholarship
            END
    END AS Scholarship_amount,
    'Completed' AS Transaction_Status,  -- Assuming all transactions are completed for this example
    s.Name,
    s.SRN
FROM Students s
LEFT JOIN GPA_Statistics g ON s.Semester = g.Semester AND s.Branch = g.Branch
LEFT JOIN Amount_Details a ON s.Semester = a.Semester AND s.Branch = a.Branch AND s.Fee_category = a.Fee_category;
select * from status order by SRN;

desc Amount_Details;

ALTER TABLE Students
ADD COLUMN password VARCHAR(15);  -- SRN is 13 chars, Section is 1 char, so total 14

UPDATE Students
SET password = CONCAT(SRN, '_', Section);

select * from students;
-- select * from staff;
alter table staff add column password varchar(15);
update staff set password = concat(Staff_ID,'_',Department_ID);
UPDATE Status set Transaction_Status= "N/A" WHERE Type_of_Scholarship="N/A";

select * from staff;

select * from students;

select * from Student_Phno ;
select * from student_email;
select * from gpa_statistics;

DELIMITER $$

CREATE TRIGGER delete_student_records
BEFORE DELETE ON Students
FOR EACH ROW
BEGIN

	-- Delete associated records from the 'status' table
    DELETE FROM status WHERE SRN = OLD.SRN;
    
    -- Delete associated phone numbers
    DELETE FROM Student_Phno WHERE SRN = OLD.SRN;
    
    -- Delete associated emails
    DELETE FROM Student_Email WHERE SRN = OLD.SRN;
END$$

DELIMITER ;

 

DELIMITER //

CREATE PROCEDURE GetTransactionDetails(IN srn VARCHAR(20))
BEGIN
    SELECT Transaction_Status, Type_of_Scholarship, Scholarship_amount, Name
    FROM Status WHERE SRN = srn;
END //

DELIMITER ;


DELIMITER ;



create role student;
create role management;

grant select on students to student;
grant select on status to student;
grant all on University_Scholarship.* to management;
 
