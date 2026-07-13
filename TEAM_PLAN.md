# Team Plan

## What We're Actually Making

We are making a SQL Server database for a fitness center / personal training system.

We are not making an app or website. We are also not importing data from a spreadsheet.

The project is basically:

- design the database
- create the tables in SQL Server
- add sample data
- write queries and views to prove the database works

The database is for a gym that tracks members, trainers, membership plans, group classes, private sessions, attendance, rooms, and payments.

## What We Already Have Done

We already have:

- GitHub repo set up
- folders made for docs, ER diagram, SQL, and final submission
- assignment instructions in the repo
- database design document
- ER diagram source and image
- SQL Server / SSMS installed
- SQL Server connection working through `localhost`
- database created: `FitnessCenterDB`

We also already created and tested these tables:

- `Members`
- `MembershipPlans`
- `MemberMemberships`
- `Trainers`
- `Rooms`

## Full Table List

The final database should have 10 tables:

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

## Michael's Part

Michael is handling the database structure.

That means:

- `CREATE DATABASE`
- `CREATE TABLE`
- primary keys
- foreign keys
- `UNIQUE` constraints
- `CHECK` constraints
- `DEFAULT` constraints

Michael already finished the first 5 tables.

Michael still needs to create:

- `GroupClasses`
- `ClassSchedules`
- `ClassAttendance`
- `PrivateSessions`
- `Payments`

Once those are done, the full database structure is ready for sample data and queries.

## Remy's Part

Remy is handling the data and reports side.

That means:

- sample `INSERT` statements
- required SQL queries
- views
- testing query results
- optional stored procedure if we have time

Remy can start sample data now for the tables that already exist:

- `Members`
- `MembershipPlans`
- `Trainers`
- `Rooms`
- `MemberMemberships`

Use this insert order:

1. `Members`
2. `MembershipPlans`
3. `Trainers`
4. `Rooms`
5. `MemberMemberships`

`MemberMemberships` has to come after `Members` and `MembershipPlans` because it uses their IDs.

Remy should wait on these until Michael creates the rest of the tables:

- `GroupClasses`
- `ClassSchedules`
- `ClassAttendance`
- `PrivateSessions`
- `Payments`

## What Remy's Data Needs To Show

The sample data should not just be random. It needs to help the queries work.

Try to include:

- at least 5 members
- multiple membership plans
- at least 5 trainers
- at least 5 rooms
- at least 5 membership records
- enough class attendance later so one member has more than 5 classes
- ratings for group classes
- private sessions and payments so revenue reports work

## Required Queries

We need queries that:

1. list members and their private sessions with trainer names
2. list group classes and the trainer teaching them
3. count members by membership type
4. find members who attended more than 5 group classes
5. calculate average rating per group class

We should also make sure the final SQL shows joins, grouping, `HAVING`, ordering, aggregates, and maybe a subquery or `CASE`.

## Required Views

We need at least two views:

1. trainer revenue or total session hours
2. member group class check-in log

Extra views if we have time:

- active memberships
- popular classes
- trainer schedule

## Optional Stored Procedure

If we have time, we can add:

`BookGroupClass`

It would:

- take a `MemberID`
- take a `ClassScheduleID`
- check if the member exists
- check if the class exists
- make sure the member is not already booked
- check class capacity
- add the booking

This is optional, but it would help the project look stronger.

## Current Next Steps

1. Michael finishes the remaining 5 tables.
2. Remy starts inserts for the first 5 tables.
3. After all tables exist, Remy finishes the rest of the sample data.
4. Remy writes the required queries.
5. We test everything in SSMS.
6. We commit/push working chunks.
7. We prepare the final submission.

## Stuff We Both Need To Help With

After the basic table structure and sample data are done, both of us should help clean up and test the project.

Shared work:

- run the full SQL script from top to bottom
- fix errors together
- check that all foreign keys work
- make sure every table has at least 5 rows
- make sure the required queries actually return results
- make sure the views run correctly
- check the ER diagram matches the SQL tables
- clean up comments and formatting in the SQL file
- make sure the final files are in the right folders
- help with the reflection / presentation

Presentation split:

- Michael explains the database structure, relationships, keys, constraints, and normalization.
- Remy explains the sample data, queries, views, reports, and what the results show.
- Both of us should understand the full project enough to answer basic questions.

Final review checklist:

- all 10 tables exist
- primary keys work
- foreign keys work
- constraints make sense
- sample data is realistic
- required queries are included
- required views are included
- optional stored procedure is included if we have time
- final `.sql` file runs without errors

## Team Rule

Do not write a huge chunk and hope it works.

Write a small part, run it, fix it, then commit it.

That will make the project way easier to debug.
