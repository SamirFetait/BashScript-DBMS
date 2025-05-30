# BashScript-DBMS
🧠 Features

Main Menu

Create Database

List Databases

Connect to Database

Drop Database

Connected Database Menu

Create Table (define columns, types, and primary key)

List Tables

Drop Table

Insert into Table (with type & primary key checks)

Select From Table (formatted output)

Delete From Table (by primary key)

Update Table (by primary key)

🛠️ How It Works

Databases are folders

Tables are files that store:

Line 1: Column names (comma-separated)

Line 2: Column types (int or str)

Line 3: Primary key column index (zero-based)

Line 4+: Data rows (comma-separated)

▶️ Running the Project

Give execution permission:

chmod +x dbms.sh

Run the script:

./dbms.sh

🧪 Example Table File (users)

id,name,age
int,str,int
0
1,Ali,25
2,Sara,30

🧰 Bash Commands Used

mkdir, rm, ls, read, echo

cut, sed, tr, grep

Bash arrays, loops, conditionals
