Drug–Gene Interaction Analysis using SQL
Project Overview
This project focuses on analyzing drug–gene interaction data using SQL. In bioinformatics research, understanding how drugs interact with genes is essential for identifying therapeutic targets, studying drug mechanisms, and improving treatment strategies.
The goal of this project is to:
•	Import biological datasets into a relational database
•	Clean and structure the data using SQL
•	Establish relationships between drugs, genes, and their interactions
•	Perform SQL-based exploratory data analysis (EDA)
•	Extract meaningful insights about drug targeting and gene interaction patterns
The analysis highlights patterns such as highly targeted genes, drugs interacting with multiple genes, and high-confidence drug–gene interaction scores.
This project demonstrates practical skills in data cleaning, relational database design, and SQL-based bioinformatics analysis.
________________________________________
Objectives of the Project
The main objectives of this project include:
•	Import and organize raw bioinformatics datasets into a structured MySQL database
•	Clean and standardize the datasets for analysis
•	Design a relational database schema
•	Establish relationships using primary keys and foreign keys
•	Perform SQL-based exploratory data analysis
•	Identify patterns in drug–gene interactions
•	Generate insights useful for drug discovery and genomic research
________________________________________
Dataset Description
The datasets used in this project contain information about drugs, genes, and their biological interactions.
1. Drugs Dataset (drugs.csv)
Contains information about different drugs and their biological classification.

Column	Description
drug_claim_name	Original claimed drug name
drug_name	Standardized drug name
concept_id	Unique identifier for the drug
approved	Indicates whether the drug is approved
immunotherapy	Indicates if the drug is used in immunotherapy
anti_neoplastic	Indicates if the drug is used in cancer treatment
nomenclature	Drug naming standard
source_db_name	Source database
source_db_version	Version of the source database

________________________________________
2. Genes Dataset (cleaned_genes.csv)
Contains gene identifiers and gene names.

Column	Description
concept_id	Unique gene identifier
gene_name	Name of the gene

________________________________________





3. Drug–Gene Interactions Dataset (interactions.csv)
Contains information describing biological interactions between drugs and genes.
Column	Description
gene_concept_id	Gene identifier
gene_name	Gene name
interaction_type	Type of biological interaction
interaction_score	Confidence score for interaction
drug_concept_id	Drug identifier
drug_name	Drug name
approved	Drug approval status
immunotherapy	Immunotherapy classification
anti_neoplastic	Anti-cancer drug classification
________________________________________
Database Schema / Table Structure
The project organizes the datasets into three relational tables.
Tables Used
clean_drugs
Column	Description
drug_id	Primary key for drugs
drug_name	Name of the drug
approved	Approval status
immunotherapy	Immunotherapy classification
anti_neoplastic	Anti-cancer drug classification
________________________________________
cleaned_genes
Column	Description
gene_id	Primary key for genes
gene_name	Name of the gene
________________________________________
interactions
Column	Description
gene_id	Foreign key referencing genes
drug_id	Foreign key referencing drugs
interaction_type	Type of interaction
interaction_score	Interaction confidence score
________________________________________
Relationships
•	clean_drugs → interactions
drug_id acts as a foreign key.
•	cleaned_genes → interactions
gene_id acts as a foreign key.
This structure enables many-to-many relationships between drugs and genes through the interactions table.
________________________________________
Project Workflow
The project follows the following workflow:
1.	Imported CSV datasets into a MySQL database
2.	Cleaned and standardized the raw data
3.	Created relational tables for drugs, genes, and interactions
4.	Established primary key and foreign key relationships
5.	Performed SQL-based exploratory data analysis
6.	Generated insights about drug–gene interaction patterns and the drug behavior.
________________________________________
Project Folder Structure
 
________________________________________
Data Cleaning Steps
Several preprocessing steps were performed to prepare the dataset for analysis:
•	Removed unnecessary columns from raw datasets
•	Standardized column names
•	Converted text (Yes/No) into boolean values (true/false)(1/0) 
•	Trimmed whitespace from text fields
•	Checked and removed duplicate entries
•	Ensured consistent drug and gene identifiers
•	Created cleaned relational tables
•	Implemented primary key and foreign key constraints
These steps ensured the dataset was consistent, reliable, and optimized for SQL analysis.
________________________________________

SQL Analysis Performed
The project includes multiple analytical queries across different categories:
Basic Data Exploration
1.	Find the total number of drugs.
2.	Find the total number of genes.
3.	Find the total number of drug–gene interactions.
4.	Find the number of approved drugs in the drug table.
5.	Find the number of drugs that are immunotherapy drugs.
6.	Find the number of drugs that are anti-neoplastic drugs.
Drug Analysis
7.	Find the number of drugs that are BOTH approved and anti-neoplastic.
8.	Find the number of drugs that are BOTH approved and immunotherapy drugs.
9.	Find the number of drugs that are NOT approved.
10.	Find the number of drugs that are neither immunotherapy nor anti-neoplastic.
11.	Find the total number of unique drugs that appear in the interactions table.
12.	Find the total number of unique genes that appear in the interactions table.
Gene Analysis
13.	Find the top 10 genes that have the highest number of drug interactions.
14.	Find the top 10 drugs that interact with the highest number of genes.
15.	Find genes that interact with more than 50 drugs.
16.	Find drugs that interact with more than 20 genes.
17.	Find the average number of drug interactions per gene.
18.	Find the average number of gene interactions per drug.
Drug–Gene Interaction Analysis
19.	Top 10 genes with the highest drug interactions and display their gene names.
20.	Find the top 10 drugs that interact with the highest number of genes and show their drug names.
21.	Find the number of drug interactions for each gene and show the gene name.
22.	Find the number of gene interactions for each drug and show the drug name.
23.	Find drugs that interact with genes involved in more than 100 interactions.
Advanced Bioinformatics Insights
24.	Find the top 15 strongest drug–gene interactions based on interaction score.
25.	Find the top 10 genes with the highest average interaction score across all drugs.
26.	Find the top 10 drugs with the highest average interaction score across all genes.
27.	Find genes that interact only with approved drugs.
28.	Find drugs that interact with more than 20 genes and have an average interaction score higher than the overall dataset average.
29.	Find genes that interact with both immunotherapy drugs and anti-neoplastic drugs.
30.	Find the top 10 genes that interact with the highest number of approved drugs and have above-average interaction scores.
________________________________________
Sample SQL Queries
Total Number of Drugs
SELECT 
    COUNT(drug_id) AS total_no_of_drugs
FROM
    clean_drugs;________________________________________
Top Genes with the Highest Drug Interactions
SELECT 
    gene_id, COUNT(*) AS drug_interaction_count
FROM
    interactions
GROUP BY gene_id
ORDER BY drug_interaction_count DESC
LIMIT 10;________________________________________
Strongest Drug–Gene Interactions
SELECT 
    ins.gene_id,
    cg.gene_name,
    ins.drug_id,
    cd.drug_name,
    ins.interaction_type,
    ins.interaction_score
FROM
    interactions AS ins
        INNER JOIN
    cleaned_genes AS cg ON ins.gene_id = cg.gene_id
        INNER JOIN
    clean_drugs AS cd ON ins.drug_id = cd.drug_id
ORDER BY ins.interaction_score DESC
LIMIT 15;
________________________________________
Top Genes with High Approved Drug Interaction and above Average Interaction Score
SELECT 
    ins.gene_id,
    cg.gene_name,
    COUNT(ins.drug_id) AS approved_drug_interaction_count,
    AVG(ins.interaction_score) AS avg_interaction_score
FROM
    interactions AS ins
        INNER JOIN
    cleaned_genes AS cg ON ins.gene_id = cg.gene_id
        INNER JOIN
    clean_drugs AS cd ON ins.drug_id = cd.drug_id
GROUP BY ins.gene_id , cg.gene_name
HAVING avg_interaction_score > (SELECT 
        AVG(interaction_score)
    FROM
        interactions)
    AND SUM(CASE
    WHEN cd.approved = 1 THEN 0
    ELSE 1
END) = 0
ORDER BY approved_drug_interaction_count DESC , avg_interaction_score DESC
LIMIT 10;
________________________________________
Key Insights from the Analysis
•	Many drugs interact with multiple genes, demonstrating polypharmacology, where a single drug targets several biological pathways.
•	Certain genes show very high numbers of drug interactions, acting as central hubs in the drug–gene interaction network, which suggests their importance in disease mechanisms.
•	Several drugs interact with a large number of genes, indicating broad biological activity and potential influence on multiple cellular pathways.
•	Analysis of interaction scores helped identify strong drug–gene relationships, which may represent high-confidence therapeutic interactions.
•	Some genes interact only with approved drugs, suggesting these genes are clinically validated therapeutic targets.
•	A subset of genes interacts with both immunotherapy drugs and anti-neoplastic (cancer) drugs, highlighting the overlap between immune system regulation and cancer treatment.
•	Genes that interact with multiple approved drugs and maintain high interaction scores may represent important targets for future drug discovery and precision medicine.
________________________________________
Author
Jayakumar S
Biotechnology Graduate with an interest in Bioinformatics, Data Analysis, and Drug Discovery.  
This project demonstrates the use of SQL for analyzing drug–gene interaction datasets.
GitHub: https://github.com/jayakumars-source
LinkedIn: https://www.linkedin.com/in/jayakumarsbio05
