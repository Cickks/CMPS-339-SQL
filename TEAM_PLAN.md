# CMPS 339 Team Plan

## Project Summary

We are building a SQL Server relational database for a Fitness Center & Personal Training Management System.

The database will track:

- members
- membership plans
- member membership history
- trainers
- rooms
- group classes
- scheduled class meetings
- class attendance
- private training sessions
- payments

This is not a website or full application. The main deliverable is a database design plus SQL scripts.

## What We Already Have Done

Current completed setup:

- GitHub repository created: `CMPS-339-SQL`
- Folder structure created:
  - `docs/`
  - `er-diagram/`
  - `sql/`
  - `final-submission/`
- Assignment instructions added to the repo.
- Design document created for the database.
- ER diagram source created in DBML format.
- ER diagram image exported.
- SQL Server and SSMS installed on the main machine.
- SSMS successfully connected to `localhost`.

Design work already completed:

- final database scope chosen
- 10-table schema selected
- relationships planned
- normalization/anomaly discussion drafted
- ER diagram generated from the schema

## Current Database Design

The planned tables are:

1. `Members`
2. `MembershipPlans`
3. `MemberMemberships`
4. `Trainers`
5. `Rooms`
6. `GroupClasses`
7. `ClassSchedules`
8. `ClassAttendance`
9. `PrivateSessions`
10. `Payments`

Important relationship:

- `ClassAttendance` is the bridge table between members and scheduled group classes.

## Recommended Work Split

### Michael: Database Structure

Responsible for:

- creating the database
- writing the first version of `CREATE TABLE` statements
- primary keys
- foreign keys
- `UNIQUE` constraints
- `CHECK` constraints
- `DEFAULT` constraints

Suggested tables:

- `Members`
- `MembershipPlans`
- `MemberMemberships`
- `Trainers`
- `Rooms`

### Remy: Data, Queries, and Reports

Responsible for:

- sample data inserts
- required SQL queries
- views
- optional stored procedure
- testing query results

Suggested tables/query focus:

- `GroupClasses`
- `ClassSchedules`
- `ClassAttendance`
- `PrivateSessions`
- `Payments`

## Required SQL Queries

The final SQL file must include queries that:

1. List all members and the private sessions they booked, including trainer names.
2. List all group fitness classes with the trainer teaching them.
3. Count members by membership type.
4. Identify members who attended more than 5 group classes.
5. Calculate average member rating per group class.

We should also include examples of:

- `INNER JOIN`
- `LEFT JOIN`
- `GROUP BY`
- `HAVING`
- `ORDER BY`
- aggregate functions
- subqueries or `EXISTS`
- `CASE`

## Required Views

The final project should include at least two views:

1. Trainer revenue or total session hours summary.
2. Member class check-in log.

Recommended extra views if time allows:

- active memberships
- popular classes
- trainer schedule

## Optional Stored Procedure

Recommended stored procedure:

`BookGroupClass`

Purpose:

- accept `MemberID` and `ClassScheduleID`
- check whether the member exists
- check whether the class exists
- prevent duplicate bookings
- check class capacity
- insert the booking into `ClassAttendance`

This is a good bonus feature because it shows real database management logic.

## Next Steps

1. Confirm SQL Server test queries work in SSMS:
   - `SELECT @@VERSION AS SQLServerVersion;`
   - `SELECT DB_NAME() AS CurrentDatabase;`
2. Create the first SQL file in `sql/`.
3. Start with only the database and first three tables:
   - `Members`
   - `MembershipPlans`
   - `MemberMemberships`
4. Run and test those tables before adding more.
5. Commit small working changes to GitHub.
6. Continue table-by-table until all 10 tables are created.
7. Add sample data.
8. Add required queries.
9. Add views.
10. Add stored procedure if time allows.

## Team Rule

Do not write the whole SQL file at once.

Write a small section, run it, fix errors, commit it, then move to the next section. This will make the project easier to debug and easier to explain during presentation.
