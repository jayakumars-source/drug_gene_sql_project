-- =====================================================================================================================
-- DATA CLEANING SCRIPT
-- Project: Drug–Gene Interaction Analysis
-- Description: Cleaning and preparing raw datasets imported from CSV files
-- Data Files Used:
--     1. drugs.csv
--     2. cleaned_genes.csv
--     3. interactions.csv
-- =====================================================================================================================



-- =====================================================================================================================
-- CLEANING: DRUGS TABLE
-- Source File: drugs.csv
-- Description: Cleaning drug dataset, standardizing values, removing duplicates,
--              and creating a clean table for analysis.
-- =====================================================================================================================

-- View raw data
SELECT * 
FROM drugs;

-- Remove unnecessary columns
ALTER TABLE drugs
DROP COLUMN drug_claim_name,
DROP COLUMN nomenclature,
DROP COLUMN source_db_name,
DROP COLUMN source_db_version;

-- Modify column names and data types
ALTER TABLE drugs
MODIFY drug_name VARCHAR(300),
CHANGE COLUMN concept_id drug_id VARCHAR(100);

-- Trim spaces and standardize drug names
UPDATE drugs
SET 
    drug_name = TRIM(drug_name),
    drug_id = TRIM(drug_id),
    drug_name = UPPER(drug_name);

-- Check for missing drug IDs
SELECT *
FROM drugs
WHERE drug_id IS NULL;

-- Remove rows with missing drug_id or drug_name
DELETE FROM drugs
WHERE drug_id IS NULL 
OR drug_name IS NULL;

-- Check for duplicate drug records
SELECT drug_id, drug_name, COUNT(*)
FROM drugs
GROUP BY drug_id, drug_name
HAVING COUNT(*) > 1;

-- Create cleaned drugs table
CREATE TABLE clean_drugs (
SELECT DISTINCT *
FROM drugs
);

-- Verify cleaned data
SELECT * FROM clean_drugs;
SELECT * FROM drugs;

-- Describe cleaned table structure
DESC clean_drugs;

-- Convert TRUE/FALSE text values to numeric values
UPDATE clean_drugs
SET approved = 
    CASE 
        WHEN approved = "FALSE" THEN 0
        WHEN approved = "TRUE" THEN 1 
    END;

UPDATE clean_drugs
SET immunotherapy = 
    CASE 
        WHEN immunotherapy = "FALSE" THEN 0
        WHEN immunotherapy = "TRUE" THEN 1 
    END;

UPDATE clean_drugs
SET anti_neoplastic = 
    CASE 
        WHEN anti_neoplastic = "FALSE" THEN 0
        WHEN anti_neoplastic = "TRUE" THEN 1 
    END;

-- Convert columns to BOOLEAN type
ALTER TABLE clean_drugs
MODIFY approved BOOLEAN,
MODIFY immunotherapy BOOLEAN,
MODIFY anti_neoplastic BOOLEAN;

-- Add primary key constraint
ALTER TABLE clean_drugs
ADD CONSTRAINT cd_drug_id_pk 
PRIMARY KEY (drug_id);

COMMIT;



-- =====================================================================================================================
-- CLEANING: GENES TABLE
-- Source File: cleaned_genes.csv
-- Description: Cleaning gene dataset by standardizing gene IDs and names
--               and adding a primary key.
-- =====================================================================================================================

-- View gene dataset
SELECT *
FROM cleaned_genes;

-- Rename column and adjust datatype
ALTER TABLE cleaned_genes
CHANGE COLUMN concept_id gene_id VARCHAR(50);

-- Modify gene name column datatype
ALTER TABLE cleaned_genes
MODIFY COLUMN gene_name VARCHAR(50);

-- Remove extra spaces
UPDATE cleaned_genes
SET gene_id = TRIM(gene_id);

UPDATE cleaned_genes
SET gene_name = TRIM(gene_name);

-- Standardize gene names to uppercase
UPDATE cleaned_genes
SET gene_name = UPPER(gene_name);

-- Add primary key constraint
ALTER TABLE cleaned_genes
ADD CONSTRAINT cg_gene_id_pk 
PRIMARY KEY (gene_id);

COMMIT;



-- =====================================================================================================================
-- CLEANING: INTERACTIONS TABLE
-- Source File: interactions.csv
-- Description: Cleaning drug–gene interaction dataset, removing unnecessary columns,
--              formatting IDs, handling missing values, and preparing interaction scores.
-- =====================================================================================================================

-- View raw interactions data
SELECT *
FROM interactions;

-- Remove unnecessary columns
ALTER TABLE interactions
DROP COLUMN gene_claim_name,
DROP COLUMN interaction_source_db_name,
DROP COLUMN interaction_source_db_version,
DROP COLUMN drug_claim_name,
DROP COLUMN gene_name,
DROP COLUMN drug_name,
DROP COLUMN approved,
DROP COLUMN immunotherapy,
DROP COLUMN anti_neoplastic;

-- Rename columns and adjust data types
ALTER TABLE interactions
CHANGE gene_concept_id gene_id VARCHAR(50),
CHANGE drug_concept_id drug_id VARCHAR(50);

-- Trim whitespace from IDs
UPDATE interactions
SET gene_id = TRIM(gene_id);

UPDATE interactions
SET drug_id = TRIM(drug_id);

-- Standardize interaction type
UPDATE interactions
SET interaction_type = LOWER(interaction_type);

-- Replace NULL interaction types
UPDATE interactions
SET interaction_type = "Unknown"
WHERE interaction_type IS NULL;

-- Create new column for formatted interaction score
ALTER TABLE interactions
ADD COLUMN interactionn_score DECIMAL(6,3);

-- Convert score datatype
UPDATE interactions
SET interactionn_score = CAST(interaction_score AS DECIMAL(6,3));

-- Verify score conversion
SELECT interaction_score, interactionn_score
FROM interactions
LIMIT 10;

-- Replace old score column
ALTER TABLE interactions
DROP COLUMN interaction_score,
RENAME COLUMN interactionn_score TO interaction_score;

-- Check for missing gene IDs
SELECT *
FROM interactions
WHERE gene_id IS NULL;

-- Remove rows with missing gene IDs
DELETE FROM interactions
WHERE gene_id IS NULL;

-- Check for missing drug IDs
SELECT *
FROM interactions
WHERE drug_id IS NULL;

-- Remove rows with missing drug IDs
DELETE FROM interactions
WHERE drug_id IS NULL;

-- Verify cleaned interaction data
SELECT *
FROM interactions;

-- Add foreign key constraints
ALTER TABLE interactions
ADD CONSTRAINT in_drug_id_fk 
FOREIGN KEY (drug_id) REFERENCES clean_drugs(drug_id),
ADD CONSTRAINT in_gene_id_fk 
FOREIGN KEY (gene_id) REFERENCES cleaned_genes(gene_id);

COMMIT;