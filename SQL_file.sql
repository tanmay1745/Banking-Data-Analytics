# Creating Database
create database bank;

# Using Database
use bank;

# Checking all the uploaded tables
show tables;

# Seeing actual records
select * from customer; 
select * from bank_relations;
select * from gender;
select * from advisors;

# Seeing the columns and their datatype, constraints
show columns from customer;
show columns from bank_relations;
show columns from gender;
show columns from advisors;

select * from customer limit 5;
select * from bank_relations;
select * from gender;
select * from advisors limit 5;

# Checking the rows count
select "customer" as table_name, count(*) as total_rows from customer
union 
select "bank_relations" as table_name,count(*) as total_rows from bank_relations
union
select "gender" as table_name,count(*) as total_rows from gender
union
select "advisor" as table_name,count(*) as total_rows from advisors;

# Checking PK and FKs
select ClientID, count(*) from customer group by ClientID having count(*) > 1;		#contains duplicates
select count(*) from customer where ClientId is null;		# no null

select IAId, count(*) from advisors group by IAId having count(*) > 1;		# all unique
select count(*) from advisors where IAId is null;		#no null


# working on duplicate values in clientID in customer
select ClientID, count(*) as duplicate_count from customer group by ClientID having count(*) > 1 
order by duplicate_count desc;

select * from customer where ClientID in (select ClientID from customer group by ClientID having count(*) > 1)
order by ClientID;

select count(*) as total_rows, count(distinct ClientID) as duplicate_rows,
count(*)-count(distinct ClientID) as total_duplicates from customer;

select * from customer where ClientID in (select ClientID from customer group by ClientID having count(*) = 3);

# fixing duplicates i.e. adding a PK column
alter table customer add column customer_key int primary key auto_increment;

select * from customer limit 5;

# Applying PK and FK
alter table bank_relations add primary key (BRId);
alter table gender add primary key (GenderId);
alter table advisors add primary key (IAId);

describe customer;
alter table customer modify BRId int;

alter table customer add foreign key (BRId) references bank_relations(BRId);
alter table customer add foreign key (GenderId) references gender(GenderId);	
alter table customer add foreign key (IAId) references advisors(IAId);	


# Joining of tables
select
c.customer_key, c.ClientID, c.Name, c.Age, c.`Location ID`, c.`Joined Bank`, c.`Banking Contact`,
c.Nationality, c.Occupation, c.`Fee Structure`, c.`Loyalty Classification`, c.`Estimated Income`, 
c.`Superannuation Savings`, c.`Amount of Credit Cards`, c.`Credit Card Balance`, c.`Bank Loans`,
c.`Bank Deposits`, c.`Checking Accounts`, c.`Saving Accounts`, c.`Foreign Currency Account`, 
c.`Business Lending`, c.`Properties Owned`, c.`Risk Weighting`,
br.`Banking Relationship`,
g.Gender,
a.`Investment Advisor`
from customer c left join bank_relations br on c.BRId = br.BRId
left join gender g on c.GenderId = g.GenderId
left join advisors a on c.IAId = a.IAId;

# count rows
select count(*) 
from customer c left join bank_relations br on c.BRId = br.BRId
left join gender g on c.GenderId = g.GenderId
left join advisors a on c.IAId = a.IAId;

# Aggregations
select g.gender, count(*) from 
gender as g join customer as c on g.GenderID = c.GenderID
group by g.gender;

select br.`Banking Relationship`, count(*) from 
bank_relations as br join customer as c on br.BRId = c.BRId
group by br.`Banking Relationship`;

select br.`Banking Relationship`, sum(`Bank Loans`) as total_loan
from bank_relations as br join customer as c on br.BRId = c.BRId
group by br.`Banking Relationship` order by total_loan desc;

# creating view
create view customer_analysis as
select
c.customer_key, c.ClientID, c.Name, c.Age, c.`Location ID`, c.`Joined Bank`, c.`Banking Contact`,
c.Nationality, c.Occupation, c.`Fee Structure`, c.`Loyalty Classification`, c.`Estimated Income`, 
c.`Superannuation Savings`, c.`Amount of Credit Cards`, c.`Credit Card Balance`, c.`Bank Loans`,
c.`Bank Deposits`, c.`Checking Accounts`, c.`Saving Accounts`, c.`Foreign Currency Account`, 
c.`Business Lending`, c.`Properties Owned`, c.`Risk Weighting`,
br.`Banking Relationship`,
g.Gender,
a.`Investment Advisor`
from customer c left join bank_relations br on c.BRId = br.BRId
left join gender g on c.GenderId = g.GenderId
left join advisors a on c.IAId = a.IAId;

select * from customer_analysis;
select count(*) from customer_analysis;


