# Introduction
This project dives into the data analyst job market to uncover which skills are most in demand and which roles offer the highest salaries. By analyzing real job posting data, I aimed to find where high demand meets high pay—helping both myself and others target the right skills for breaking into data analytics.

SQL queries? Check them out here: [project_sql folder](/project_sql/)

# Background

As I work toward breaking into the data analyst job market, this project helps me identify the top-paying roles and the most in-demand skills. It’s designed to cut through the noise and focus my learning on what really matters for landing a great job.

The data comes from the SQL course I’m following ([Luke Barousse’s SQL for Data Analytics](https://lukebarousse.com/sql)), which provides rich information on job titles, salaries, locations, and key skills.

### The questions I wanted to answer through my SQL queries were:

1. What are the top-paying data analyst jobs?  
2. What skills do these top-paying jobs require?  
3. Which skills are most in demand for data analysts?  
4. What skills tend to lead to higher salaries?  
5. Based on this, what are the most optimal skills for me to learn?  

# Tools I Used

To explore the data analyst job market and practice real-world SQL, I used the following tools:

- **SQL**: The core of my analysis—used to write queries, clean data, and extract insights directly from the database.
- **PostgreSQL**: My database of choice for this project. It handled all the job posting data and made querying efficient and reliable.
- **Visual Studio Code**: My go-to code editor for writing and running SQL queries with ease.
- **Git & GitHub**: I used Git for version control and GitHub to track progress and share my SQL scripts—great for documenting my learning and showing my work.

# The Analysis

Each SQL query in this project helped me dig into different aspects of the data analyst job market. I designed them to answer practical questions that matter to someone like me—actively transitioning into the field and trying to align my learning with in-demand skills.

### 1. Top Paying Data Analyst Jobs
I started by identifying the highest-paying data analyst roles. I filtered for jobs with non-null average yearly salaries and focused on remote positions, since that flexibility is important to me. This helped surface the most lucrative opportunities and gave me a benchmark for salary expectations in the field.

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```
Here's the breakdown of the top data analyst jobs in 2023:
- **Wide Salary Range:** The top 10 highest-paying data analyst roles range from $184,000 to $650,000, showing just how high the salary ceiling can be in this field.
- **Diverse Employers:** Companies like SmartAsset, Meta, and AT&T are offering top compensation, highlighting strong demand across industries—from tech to finance to telecom.
- **Job Title Variety:** High-paying roles span a wide spectrum of titles, from “Data Analyst” to “Director of Analytics,” reflecting the different levels of responsibility and specialization within the data analytics space.

### 2. Skills for Top Paying Jobs
To figure out what skills are actually required for the top-paying data analyst roles, I joined the job postings with the skills data. This helped me identify which tools and technologies employers are looking for when offering the highest salaries.

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)
SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC;
```
Here’s the breakdown of the most in-demand skills from the top 10 highest-paying data analyst jobs in 2023:  
**SQL** – 8 mentions  
**Python** – 7 mentions  
**Tableau** – 6 mentions

### 3. In-Demand Skills for Data Analysts
This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

```sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_work_from_home = TRUE
GROUP BY 
    skills
ORDER BY 
    demand_count DESC
LIMIT 5;
```
Here's the breakdown of the most in-demand skills for data analysts in 2023:
- **SQL** and **Excel** lead, highlighting core skills in data querying and spreadsheets.  
- Tools like **Python**, **Tableau**, and **Power BI** show the growing demand for programming and data visualization.


| Skill     | Demand Count |
|-----------|--------------|
| SQL       | 7,291        |
| Excel     | 4,611        |
| Python    | 4,330        |
| Tableau   | 3,745        |
| Power BI  | 2,609        |

_Table of the demand for the top 5 skills in data analyst job postings_

### 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.
```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' 
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY 
    skills
ORDER BY 
    avg_salary DESC
LIMIT 25;
```
Here's a breakdown of the results for top-paying skills for Data Analysts:

- **High Demand for Big Data & ML Skills:**  
  Top salaries are commanded by analysts skilled in big data technologies (*PySpark, Couchbase*), machine learning tools (*DataRobot, Jupyter*), and Python libraries (*Pandas, NumPy*), reflecting the industry's high valuation of data processing and predictive modeling capabilities.

- **Software Development & Deployment Proficiency:**  
  Knowledge in tools like *GitLab, Kubernetes,* and *Airflow* shows a strong crossover between analysis and engineering, with a premium on automation and pipeline management skills.

- **Cloud Computing Expertise:**  
  Familiarity with *Elasticsearch, Databricks,* and *GCP* highlights the growing demand for cloud-native analytics, suggesting that cloud proficiency significantly boosts earning potential.

| Skill         | Average Salary ($) |
|---------------|--------------------|
| PySpark       | 208,172            |
| Bitbucket     | 189,155            |
| Couchbase     | 160,515            |
| Watson        | 160,515            |
| DataRobot     | 155,486            |
| GitLab        | 154,500            |
| Swift         | 153,750            |
| Jupyter       | 152,777            |
| Pandas        | 151,821            |
| Elasticsearch | 145,000            |

_Table of the most optimal skills for data analyst sorted by salary_

### Most Optimal Skills for Data Analysts in 2023

Based on my analysis of job postings, here's a breakdown of the most optimal skills to focus on as an aspiring data analyst:

- **High-Demand Programming Languages:**  
  *Python* and *R* are consistently sought after, with demand counts of 236 and 148. While the average salaries for these are around $101,397 (Python) and $100,499 (R), their wide availability in the job market slightly levels out their earning potential. Still, they remain essential technical skills in any analyst’s toolkit.

- **Cloud Tools and Technologies:**  
  Skills like *Snowflake, Azure, AWS,* and *BigQuery* show strong demand paired with above-average salaries. These tools are increasingly central to modern data analytics workflows, especially in cloud-first companies.

- **Business Intelligence & Visualization Tools:**  
  *Tableau* (demand count: 230, avg. salary: $99,288) and *Looker* (demand count: 49, avg. salary: $103,795) reinforce the importance of being able to translate complex data into actionable insights through dashboards and visual storytelling.

- **Database Technologies:**  
  Whether it's traditional systems like *Oracle* and *SQL Server* or modern *NoSQL* databases, these skills are still highly relevant. With salaries ranging from $97,786 to $104,534, database fluency supports both data integrity and access in analytics workflows.

# What I Learned

As I worked through this project, I sharpened my SQL skills and built confidence tackling real-world data questions:

🧩 **Complex Query Crafting:**  Learned to join multiple tables effectively and use `WITH` clauses to simplify complex queries and stay organized.

📊 **Data Aggregation:**  Got comfortable using `GROUP BY`, `COUNT()`, `AVG()`, and other aggregate functions to summarize key trends in the job market.

💡 **Analytical Thinking:**  Improved my ability to break down open-ended questions into focused SQL queries that uncover meaningful insights from data.

# Conclusions

### Insights

From this analysis, several key takeaways stood out:

- 💼 **Top-Paying Data Analyst Jobs:**    Remote data analyst roles offer wide salary ranges, with top positions reaching up to **$650,000**, showing strong earning potential in the field.

- 🛠️ **Skills for Top-Paying Jobs:**    High-paying roles consistently require **advanced SQL proficiency**, confirming it as a must-have skill for maximizing salary.

- 📈 **Most In-Demand Skills:**    **SQL** also dominates in job postings, making it a foundational skill for anyone aiming to break into data analytics.

- 💰 **Skills with Higher Salaries:**    Specialized tools like **SVN** and **Solidity** are tied to the highest average salaries, suggesting a premium on niche, technical expertise.

- 🎯 **Optimal Skills for Market Value:**    SQL stands out as the most balanced skill in terms of **demand and salary**, making it one of the most strategic skills to focus on.

### Closing Thoughts

This project helped me level up my SQL skills while giving me a clearer picture of what the job market values most. It not only strengthened my technical ability, but also gave me direction on where to invest my time as I transition into the data analytics field. 

By focusing on high-demand and high-paying skills, I feel more equipped to prioritize what to learn next and how to better target my job search. It’s clear that staying adaptable and continually sharpening relevant skills is key to standing out in a competitive market.