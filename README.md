Group Project: Fitness Center & Personal Training Management System
Project Overview:
Students will design and implement a relational database to manage a boutique fitness center, tracking members, trainers, individual personal training sessions, group fitness classes, and class attendance. This will give hands-on experience with data modeling, SQL DDL (Data Definition Language), DML (Data Manipulation Language), and querying with SQL.
Project Milestones:
Week 1: Database Design
•	Topic Focus: ER Modeling, Relational Schema, Primary/Foreign Keys
•	Deliverables:
o	Define entities: e.g., Members, Trainers, PrivateSessions, GroupClasses, ClassAttendance
o	Create an ER Diagram (hand-drawn or using a tool like dbdiagram.io or Draw.io)
o	Translate the ER diagram into Relational Schema
o	Identify all primary and foreign keys

•	Example Entities and Attributes:
o	Members (MemberID, FirstName, LastName, MembershipType, JoinDate, Email)
o	Trainers (TrainerID, FirstName, LastName, Specialization, HourlyRate)
o	PrivateSessions (SessionID, MemberID, TrainerID, SessionDate, FocusArea) — Tracks 1-on-1 training
o	GroupClasses (ClassID, TrainerID, ClassName, ScheduleTime, MaxCapacity) — Classes led by a trainer
o	ClassAttendance (MemberID, ClassID, CheckInTime, MemberRating) — Many-to-many bridge for class bookings

Week 1: Database Creation & DML
•	Topic Focus: Structured Query Language (SQL), Data Definition Language (DDL) & Data Manipulation Language (DML)
•	Deliverables:
o	Use SQL Server to:
	Create the tables from the schema
	Enforce primary and foreign keys
o	Insert sample data (at least 5 rows per table)
o	Submit .sql scripts with CREATE TABLE and INSERT statements
 Week 2: SQL Queries
•	Topic Focus: SELECT Queries, JOINs, Aggregation, Filtering
•	Deliverables:
o	Write and submit SQL queries for the following requirements:
	List all members and the private sessions they have booked (including trainer names).
	List all group fitness classes alongside the trainer teaching them.
	Count the total number of members enrolled in each specific membership type.
	Identify members who have attended more than 5 group classes.
	Calculate the average rating given by members per group class.
o	Encourage use of: INNER JOIN, GROUP BY, ORDER BY, WHERE, HAVING, etc.

Week 3: Reports & Wrap-up
•	Topic Focus: Views, Basic Reports, Reflection
•	Deliverables:
o	Create two Views:
	A summary of total revenue generated or total session hours booked per trainer.
	A member check-in log listing every group class attended per member.
o	Bonus: Create a stored procedure (e.g., to automatically book a member into a class) or use subqueries.
o	Submit:
	A 1-page reflection: What did you learn? What would you improve?
	Final .sql file with all table creation, inserts, queries, and views.

Assessment Criteria:
•	Proposal and Initial Setup (10%): Clarity and feasibility of the project proposal, group formation, and environment setup.
•	ER Model and Database Design (20%): Completeness and accuracy of the ER diagram and relational schema.
•	Database Creation and Constraints (15%): Correct implementation of tables and constraints.
•	Basic SQL Queries (20%): Accuracy and efficiency of SQL queries.
•	Handling Database Anomalies (10%): Identification and resolution of anomalies.
•	Database Management (15%): Implementation of stored procedures, triggers, and views.
 Final Presentation and Documentation (10%): Quality of the presentation and completeness of the documentation.
Definitions:
DML – Data Manipulation Language
Used to manage the data within the objects defined using DDL.
•	Common DML commands: INSERT, UPDATE, DELETE, SELECT

DDL – Data Definition Language
Used to define and modify the structure of database objects (like tables, schemas, indexes).
•	Common DDL commands: CREATE, ALTER, DROP, TRUNCATE

Group Project Collaboration and Submission Policy
Please note that this is a collaborative team project. To maintain streamlined and professional correspondence, only the designated team leader will be permitted to communicate directly with the Instructor or the Industry partner representative regarding project details. On the day of final evaluations, all team members must be present and each individual is required to present their specific portion of the project to receive credit. For the milestone deliverables, there will be only one final submission of the project code and SQL queries per group, which must be compiled and submitted exclusively by the team leader. However, please be aware that the final written exam is strictly an individual effort where each student must complete and submit their own exam independently via Canvas by the specified due date.

