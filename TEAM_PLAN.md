# Our Team Plan

## What We're Building

We're building a SQL Server database for a fitness center and personal
training business. The database will keep track of members, membership plans,
trainers, rooms, group classes, attendance, private training sessions, and
payments.

By the end of the project, we need:

- an ER diagram that matches our database
- all 10 tables with the correct keys and constraints
- at least five useful sample rows in every table
- the five queries required by the assignment
- two views for our reports
- one final SQL file that runs without errors
- our reflection, documentation, and presentation

## What We Have So Far

The repository, ER diagram, Docker setup, and first five tables are already in
place. Those tables are:

1. `Members`
2. `MembershipPlans`
3. `MemberMemberships`
4. `Trainers`
5. `Rooms`

We still need to build:

6. `GroupClasses`
7. `ClassSchedules`
8. `ClassAttendance`
9. `PrivateSessions`
10. `Payments`

To keep us from doing the same work twice or causing unnecessary Git
conflicts, each of us will own a specific part of the database.

## Michael (me)

I will:

- maintain the first five tables
- maintain the Docker setup
- review everyone's branches
- combine our work into `sql/FitnessCenterDB.sql`
- check the table and insert order
- make sure the foreign keys and constraints work
- compare the final SQL with the ER diagram
- run the complete project from a clean database before submission

I do not need to recreate Nicholas's or Areeba's tables. my job is to review them, help fix integration problems, and make sure everything works together.

my current Branch: `MIKEDEV`

Presentation section: database design, relationships, constraints, Docker,
and how the whole project fits together.

## Remy

Remy will handle the sample data for the first five tables.

Remy will:

- remove the incorrect `MembershipPlans` insert that uses `DurationMonths`
- keep the correct membership-plan insert
- add at least five `MemberMemberships` records
- make sure `Members`, `MembershipPlans`, `MemberMemberships`, `Trainers`, and
  `Rooms` each have at least five useful rows
- write the query that counts members in each membership plan
- test the inserts and query before asking for a review

 current Branch: `remy-sample-data`

Presentation section: members, membership plans, memberships, trainers,
rooms, and sample data.

## Nicholas

Nicholas will handle the group fitness class side of the database.

Nicholas will create:

- `GroupClasses`
- `ClassSchedules`
- `ClassAttendance`

He will also:

- add the correct primary keys, foreign keys, checks, defaults, and unique
  constraints
- add at least five useful sample rows to each table
- include enough attendance data for at least one member to attend more than
  five classes
- include ratings so we can calculate an average rating for each class
- write the query that lists group classes with their trainers
- write the query that finds members who attended more than five classes
- write the query that calculates the average rating for each class
- create the member class check-in view
- test everything before asking for a review

Branch: `what ever u want lol `

Working file: `dont matter to me`

Presentation section: classes, schedules, attendance, ratings, and the
check-in report.

## Areeba

Areeba will handle private training and payments.

Areeba will create:

- `PrivateSessions`
- `Payments`

She will also:

- add the correct primary keys, foreign keys, checks, defaults, and unique
  constraints
- add at least five useful sample rows to each table
- write the query that lists members, their private sessions, and their
  trainers
- create the trainer revenue or total-session-hours view
- help with the optional booking procedure if we have time
- test everything before asking for a review

Branch: `up to you`

Working file: `up to u`

Presentation section: private sessions, payments, trainer revenue, and
reports.

## How We'll Work Together

Before starting a new part, we'll update our branch from the latest `main`.
We'll work in small sections, test each section in SQL Server, and make clear
commits instead of waiting until everything is finished.

Nicholas and Areeba will work in their own SQL files so they do not have to
edit the shared file at the same time. After their work passes review, I will combine it into `sql/FitnessCenterDB.sql`.

If one person's work depends on another person's tables or data, we'll talk
about the IDs and insert order before writing the inserts. We will not change
someone else's section without letting them know.

## The Order We'll Follow

1. Remy fixes and finishes the sample data for the first five tables.
2. Nicholas creates and tests the group-class tables and data.
3. Areeba creates and tests the private-session and payment tables and data.
4. We merge and test each branch one at a time.
5. We finish all five queries and both views.
6. If we have time, we add the optional stored procedure.
7. We run the full SQL file from a clean Docker database.
8. We finish the reflection, documentation, and presentation.

## Before We Submit

As a team, we'll check that:

- all 10 tables exist
- every table has at least five rows
- all keys and constraints work
- the sample data makes our queries return useful results
- all five required queries work
- both required views work
- the ER diagram and SQL match
- the final SQL file runs from top to bottom without errors
- Docker can build and initialize the database
- our final files are organized correctly
- each of us understands our presentation section
- our reflection and documentation are finished

The goal is not just to finish our individual sections. We all need to help
test the final project and understand enough of the database to answer basic
questions during the presentation.
