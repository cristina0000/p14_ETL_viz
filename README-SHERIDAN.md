# DEMO Enrollment Project
This is a project involving ETL/ELT, and data visualization, and uses synthetic (fake) data.

Tools used: Docker Desktop, Windows Powershell, DBeaver, SQL, Python/Visual Studio Code/Windows Powershell and Tableau.

To summarize, I created an Oracle database container in Docker, connected with it in the SQL editor DBeaver, ran SQL scripts to create the schema and populate the tables, and then ran SQL queries to explore, transform and join the data from the multiple tables. I took the JOINED transformed data to Tableau and created a story with insights. Additionally, I looked at connecting programatically with Python to the Oracle db, loading the tables into pandas dataframes, transforming at this level, and then loading the clean tables back to the database.

The output is a Tableau dashboard:
https://public.tableau.com/app/profile/c.sheridan/viz/IRUniversityInsightsDEMO-syntheticdata/Story

Credit and thanks go to Aaron for the inspiration for the setup of the Oracle database.


## Useful Links

### Tableau Public IR University Insights DEMO Dashboard Link
I used  the free version, Tableau Public, to create the Tableau dashboard that is in the github account above, and anyone can access it at this link (no license and no account needed to view and download workbook):

https://public.tableau.com/app/profile/c.sheridan/viz/IRUniversityInsightsDEMO-syntheticdata/Story

This Tableau dashboard is a story containing two dashboards, accessible through the arrows near the top center.

### Link to my most recent DEMO Enrollment project solution on my github account:

https://github.com/cristina0000/p14_ETL_viz

### Other github links of possible interest:
I would like to share with you a few additional links for your reference, if/when you have time:
https://github.com/cristina0000/2025_git_projects/ - contains a few practice/learning projects, and there is a sample **PowerBI** dashboard here
https://github.com/cristina0000/About-me - contains some of the certificates that I acquired in the last 5 years

https://github.com/cristina0000/p13_py_psm - contains a Propensity Score Matching (PSM) project using Python libraries

### My Tableau Public Dashboards Link:

https://public.tableau.com/app/profile/c.sheridan/vizzes - a few of my Tableau public dashboards (no license and no Tableau public account needed)

## Overview of My Solution Steps

I used synthetic student course enrollment data. 

I dowloaded and opened Docker.

From Windows Powershell command line, I ran a Docker Oracle DB container.

In DBeaver, I connected to the Oracle database and ran the scripts to create the schema and populate the tables.

In DBeaver, I then explored the data by running queries in DBeaver - please see exploratory queries in SQL-Exploratory.sql

In DBeaver, I created two main SQL queries - please see SQL-Short.sql:
1.  One SQL query for Joining the tables with some data reduction and transformation
2.  One SQL query for determining Retention rates

In Tableau Public, I imported the Joined data CSV file JOINED-DATA.csv and created visualizations, and two dashboards, which I then combined into a story.

In Visual Studio Code, I used Python code to connect to the Oracle database, import the tables into a python dictionary of dataframes, transform/clean and then upload the clean tables back onto the database. Please see app_cs_short.py. I plan to further improve this code to do more. Ran python app_cs_short.py from the windows powershell command line.

## Next Steps: 
1.  augment the synthetic data so there are multiple lines per student id (EMPLID), which will make it easier to get retention rates.
2.  Improve python script to clean the new data, upload CLEAN tables back to the database
3.  Use PowerBI to either connect directly to the Oracle database to get the CLEAN tables, or import CLEAN CSVs into PowerBI, transform further if needed, create model, and dashboard with visualizations
4.  Improve the Tableau dashboard

## Challenges I encountered
1.  Challenges with the setup. My main issue was attempting to run the SQL scripts from Windows Powershell, instead of a SQL editor like DBeaver. 
    I later found a free version of DBeaver which worked great.
2.  Intrinsic challenges arising from the data being synthetic.
3.  Connecting to the Oracle data base using Python was initially a challenge, as I would get errors related to cx_Oracle, however I found a better solution using oracledb instead.
4.  Writing the CLEAN tables back to the oracle data base using Python gave me some trouble in the beginning as well.

## What I learned
Short answer is a lot!! First time using Docker, and DBeaver. And I had a python refresher.
In the past, I used SQL in SSMS and SQL Developer and I connected to Banner or Datawarehouse or Colleague using Tableau or PowerBI or SQL Developer or SAS EG, however this was a new experience 😊.  

### Key Questions to Answer - I will update this section

*   What key insights do I see in the data?
*   How would I present this data to leadership/decision makers?
I would present insights to the leadership using either a Tableau or PowerBI dashboard - please see Useful Links above for the Tableau dashboard.

## The Setup

The setup process involves:
1.  Installing Docker Desktop.
2.  Running an Oracle database container.
3.  Initializing the database schema and loading the data using SQL scripts (connected to database and ran the scripts in DBeaver Community Edition, which is free https://dbeaver.io/download/ ).


## The Data
Main tables:
*   `PS_STDNT_ENRL`: Student enrollment records.
*   `PS_TERM_TBL`: Term and academic career information.
*   `PC_CLASS_TBL`: Class/course details.

## Conclusion

Any questions? Please let me know. I wish you an enjoyable day!
Best regards,
Cristina
