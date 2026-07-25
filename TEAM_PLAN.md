# Final Team and Presentation Plan

## Project Status

Our database and dashboard are complete and merged. We tested the final SQL
script from an empty database and confirmed:

- all 10 tables were created
- every table has at least five sample rows
- all five required queries work
- both required views work
- the Docker SQL Server setup works
- all dashboard pages display the correct database data
- the administrator login and logout work

Our remaining work is to prepare the final submission package and practice the
presentation.

## Team Contributions

### Michael

Michael completed and maintained the core tables, database integration, Docker
setup, branch reviews, clean testing, and the admin dashboard. He is also the
team lead and final submitter.

### Remy

Remy completed the core sample data, membership data, and the query that counts
the number of members in each membership plan.

### Nicholas

Nicholas completed GroupClasses, ClassSchedules, ClassAttendance, the three
group-class and attendance queries, and `vw_MemberCheckInLog`.

Nicholas cannot attend the presentation because he has court. His completed
work will remain clearly credited in the project and presentation. Michael
will contact the instructor before presentation day and ask whether Nicholas
needs to provide documentation, notes, a recording, or an alternate
presentation.

### Areeba

Areeba completed PrivateSessions, Payments, the private-session query, and
`vw_TrainerRevenue`.

## Presentation Team

The live presentation will be handled by Michael, Remy, and Areeba. We will
divide Nicholas's presentation section without changing the record of who
created that work.

## Presentation Order

### 1. Michael: Introduction and Database Design

Estimated time: 3 minutes

Michael will explain:

- the fitness center problem our database solves
- the 10 tables and the major relationships
- why we separated the data into related tables
- primary keys, foreign keys, checks, defaults, and unique constraints
- how GroupClasses, ClassSchedules, and ClassAttendance connect
- how the team combined and tested each person's work

Michael should say that Nicholas created the group-class portion before
explaining how it fits into the final database.

### 2. Remy: Members, Memberships, and Required Queries

Estimated time: 4 minutes

Remy will explain:

- Members, MembershipPlans, and MemberMemberships
- why MemberMemberships connects members and plans
- the sample data for the core tables
- the membership-plan member-count query
- why `COUNT(DISTINCT mm.MemberID)` avoids duplicate member counts

Remy will also present these queries created by Nicholas:

- group classes with their trainer and room
- members who attended more than five classes using `GROUP BY` and `HAVING`
- average class rating using `AVG`

Remy should credit Nicholas when introducing those three queries.

### 3. Areeba: Private Training, Payments, and Views

Estimated time: 4 minutes

Areeba will explain:

- how PrivateSessions connects a member, trainer, and room
- session date, start time, duration, focus area, fee, and status
- how Payments can reference either a membership or a private session
- the check constraint that prevents a payment from referencing both
- the member, private-session, and trainer query
- how `vw_TrainerRevenue` includes completed sessions only

Areeba will also explain `vw_MemberCheckInLog`, which Nicholas created. She
should credit Nicholas and explain that the view joins members, attendance,
schedules, and classes into one reusable report.

### 4. Michael: Docker, Dashboard, Testing, and Conclusion

Estimated time: 4 minutes

Michael will demonstrate:

1. The running SQL Server Docker container.
2. `FitnessCenterDB` and its 10 tables in SSMS.
3. The two database views.
4. The administrator login.
5. Overview totals from the live database.
6. Members, Classes, Attendance, Sessions, and Payments pages.
7. Trainer revenue matching the SQL view.
8. Logout protection.

Michael will finish by explaining that the team rebuilt the database from
scratch, verified all table row counts, tested both views, ran the automated
dashboard tests, and manually tested every page.

## What Nicholas Should Do Before Presentation Day

If his schedule allows, Nicholas should:

- send Michael a short written explanation of his tables, queries, and view
- send his paragraph for the team reflection
- review the final wording used to describe his contribution
- provide any alternate presentation requested by the instructor

The team must not claim that someone else created his work. We will say who
created it and who is presenting it in his absence.

## Questions Everyone Must Be Ready to Answer

Michael, Remy, and Areeba should all know:

- what a primary key does
- what a foreign key does
- why the database uses separate tables
- the difference between `INNER JOIN` and `LEFT JOIN`
- what `WHERE`, `ORDER BY`, `GROUP BY`, and `HAVING` do
- what `ASC` and `DESC` mean
- what a view is and why it is useful
- how the database prevents invalid data
- why the dashboard is read-only
- how the dashboard connects to SQL Server

## Final Submission Responsibilities

### Michael

- update the ER diagram to match the final SQL
- update the README and setup instructions
- create and organize the `final-submission` folder
- combine the reflection paragraphs into one page
- run the final clean database and dashboard test
- complete the final checklist
- submit the project for the team

### Remy

- verify the core sample data and membership query one last time
- verify Nicholas's three required queries return the expected results
- send Michael a reflection paragraph
- practice his assigned presentation queries

### Areeba

- verify PrivateSessions, Payments, and `vw_TrainerRevenue`
- verify `vw_MemberCheckInLog` for her presentation section
- send Michael a reflection paragraph
- practice her tables, query, and both views

### Nicholas

- send his reflection paragraph and presentation notes if possible
- complete any alternate presentation required by the instructor

## Final Submission Package

The package should contain:

- the final `FitnessCenterDB.sql`
- the final ER diagram
- the one-page team reflection
- the README or setup instructions
- any required relational schema or supporting documentation
- the dashboard source as the above-and-beyond feature

We will not include `.env`, passwords, user secrets, `.vs`, `bin`, or `obj`.

## Final Work Order

1. Notify the instructor about Nicholas's court conflict.
2. Pull and confirm the final merged `main` branch.
3. Update the ER diagram.
4. Update the README.
5. Collect reflection paragraphs from all four members.
6. Create the one-page team reflection.
7. Organize the final submission folder.
8. Run the final SQL script from an empty database.
9. Test both views and every dashboard page.
10. Rehearse the presentation in the order above.
11. Practice teacher questions and simple SQL queries.
12. Perform the final file and requirement check.
13. Michael submits the complete project.

## Presentation-Day Checklist

Michael will bring the presentation computer and confirm:

- Docker Desktop is open
- the SQL Server container is running
- SSMS connects to `localhost,1433`
- the database and SQL file are ready
- the dashboard starts successfully
- the administrator login is configured locally
- no password is displayed during the presentation
- backup screenshots are available in case Docker or the network fails

Remy and Areeba will have their query explanations and speaking notes ready.
Before presenting, the three speakers will run through the handoffs once so
the presentation sounds like one team project.
