/*
Answer: What are the top skills based on salary?
- Look at the average salary associated with each skill for Data Analyst positions
- Focuses on roles with specified salaries, regardless of location
- Why? It reveals how different skills impact salary levels for Data Analysts and
helps identify the most financially rewarding skills to acquire or improve
*/

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
LIMIT 25


/* 
Here's a breakdown of the results for top paying skills for Remote Data Analysts
High Demand for Big Data & ML Skills: Top salaries are associated with analysts skilled in big data tools 
(PySpark, Couchbase), machine learning platforms (DataRobot, Jupyter), and Python libraries (Pandas, NumPy), 
highlighting industry demand for data processing and predictive modeling expertise.

Software Development & Deployment Proficiency: Tools like GitLab, Kubernetes, and Airflow reflect a valuable 
crossover between data analytics and engineering, with higher pay for skills enabling automation and data pipeline management.

Cloud Computing Expertise: Familiarity with tools like Elasticsearch, Databricks, and GCP indicates that cloud 
skills are increasingly essential and strongly linked to higher earning potential in data analytics roles.
*/
