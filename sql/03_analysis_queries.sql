-- =======================================================================================================================
-- BASIC DATA EXPLORATION
-- =======================================================================================================================

-- Q1 Find the total number of drugs. 
SELECT 
    COUNT(drug_id) AS total_no_of_drugs
FROM
    clean_drugs;
    
-- Q2 Find the total number of genes.
SELECT 
    COUNT(gene_id) AS total_no_of_genes
FROM
    cleaned_genes;

-- Q3 Find the total number of drug–gene interactions.
SELECT 
    COUNT(*) AS total_no_of_drug_gene_interactions
FROM
    interactions;
    
-- Q4 Find the number of approved drugs in the drug table. 
SELECT 
    COUNT(*) AS approved_drugs
FROM
    clean_drugs
WHERE
    approved = 1;

-- Q5 Find the number of drugs that are immunotherapy drugs
SELECT 
    COUNT(*) AS immunotherapy_drugs
FROM
    clean_drugs
WHERE
    immunotherapy = 1;

-- Q6 Find the number of drugs that are anti-neoplastic drugs
SELECT 
    COUNT(*) AS anti_neoplastic_drugs
FROM
    clean_drugs
WHERE
    anti_neoplastic = 1;

-- ==========================================================================================================================================
-- DRUG ANALYSIS
-- ==========================================================================================================================================

-- Q7 Find the number of drugs that are BOTH approved and anti-neoplastic.
SELECT 
    COUNT(*) AS approved_antineoplastic_drugs
FROM
    clean_drugs
WHERE
    approved = 1 AND anti_neoplastic = 1;

-- Q8 Find the number of drugs that are BOTH approved and immunotherapy drugs.
SELECT 
    COUNT(*) AS approved_immunotherapy_drugs
FROM
    clean_drugs
WHERE
    approved = 1 AND immunotherapy = 1;

-- Q9 Find the number of drugs that are NOT approved.
SELECT 
    COUNT(*) AS not_approved_drugs
FROM
    clean_drugs
WHERE
    approved = 0;

-- Q10 Find the number of drugs that are neither immunotherapy nor anti-neoplastic.
SELECT 
    COUNT(*) AS other_drugs
FROM
    clean_drugs
WHERE
    immunotherapy = 0
        AND anti_neoplastic = 0;

-- Q11 Find the total number of unique drugs that appear in the interactions table.
SELECT 
    COUNT(DISTINCT drug_id) AS unique_drugs_in_interactions
FROM
    interactions;

-- Q12 Find the total number of unique genes that appear in the interactions table.
SELECT 
    COUNT(DISTINCT gene_id) AS unique_genes_in_interactions
FROM
    interactions;

-- ======================================================================================================================================
-- GENE ANALYSIS
-- ======================================================================================================================================

-- Q13 Find the top 10 genes that have the highest number of drug interactions.
SELECT 
    gene_id, COUNT(*) AS drug_interaction_count
FROM
    interactions
GROUP BY gene_id
ORDER BY drug_interaction_count DESC
LIMIT 10;

-- Q14 Find the top 10 drugs that interact with the highest number of genes.
SELECT 
    drug_id, COUNT(*) AS gene_interaction_count
FROM
    interactions
GROUP BY drug_id
ORDER BY gene_interaction_count DESC
LIMIT 10;

-- Q15 Find genes that interact with more than 50 drugs.
SELECT 
    gene_id, COUNT(*) AS drug_interaction_count
FROM
    interactions
GROUP BY gene_id
HAVING drug_interaction_count > 50
ORDER BY drug_interaction_count DESC;

-- Q16 Find drugs that interact with more than 20 genes.
SELECT 
    drug_id, COUNT(*) AS gene_interaction_count
FROM
    interactions
GROUP BY drug_id
HAVING gene_interaction_count > 20
ORDER BY gene_interaction_count DESC;

-- Q17 Find the average number of drug interactions per gene.
SELECT 
    AVG(drug_interaction_count) AS avg_drug_interaction_per_gene
FROM
    (SELECT 
        gene_id, COUNT(*) AS drug_interaction_count
    FROM
        interactions
    GROUP BY gene_id) AS gene_counts;

-- Q18 Find the average number of gene interactions per drug.
SELECT 
    AVG(gene_interaction_count) AS avg_gene_interaction_per_drug
FROM
    (SELECT 
        drug_id, COUNT(*) AS gene_interaction_count
    FROM
        interactions
    GROUP BY drug_id) AS drug_counts;

-- =============================================================================================================================================
-- DRUG - GENE INTERACTION ANALYSIS
-- =============================================================================================================================================

-- Q19 top 10 genes with the highest drug interactions and display their gene names.
SELECT 
    ins.gene_id,
    cg.gene_name,
    COUNT(ins.drug_id) AS drug_interaction_count
FROM
    interactions AS ins
        INNER JOIN
    cleaned_genes AS cg ON ins.gene_id = cg.gene_id
GROUP BY ins.gene_id, cg.gene_name 
ORDER BY drug_interaction_count DESC
LIMIT 10;

-- Q20 Find the top 10 drugs that interact with the highest number of genes and show their drug names.
SELECT 
    ins.drug_id,
    cd.drug_name,
    COUNT(ins.gene_id) AS gene_interaction_count
FROM
    interactions AS ins
        INNER JOIN
    clean_drugs AS cd ON ins.drug_id = cd.drug_id
GROUP BY ins.drug_id, cd.drug_name
ORDER BY gene_interaction_count DESC
LIMIT 10;

-- Q21 Find the number of drug interactions for each gene and show the gene name.
SELECT 
    ins.gene_id,
    cg.gene_name,
    COUNT(ins.drug_id) AS drug_interaction_count
FROM
    interactions AS ins
        INNER JOIN
    cleaned_genes AS cg ON ins.gene_id = cg.gene_id
GROUP BY ins.gene_id , cg.gene_name
ORDER BY drug_interaction_count DESC;

-- Q22 Find the number of gene interactions for each drug and show the drug name.
SELECT 
    ins.drug_id,
    cd.drug_name,
    COUNT(ins.gene_id) AS gene_interaction_count
FROM
    interactions AS ins
        INNER JOIN
    clean_drugs AS cd ON ins.drug_id = cd.drug_id
GROUP BY ins.drug_id , cd.drug_name
ORDER BY gene_interaction_count DESC;

-- Q23 Find drugs that interact with genes involved in more than 100 interactions.
SELECT DISTINCT
    ins.drug_id, cd.drug_name, ins.gene_id
FROM
    interactions AS ins
        INNER JOIN
    clean_drugs AS cd ON ins.drug_id = cd.drug_id
WHERE
    ins.gene_id IN (SELECT 
            gene_id
        FROM
            interactions
        GROUP BY gene_id
        HAVING COUNT(*) > 100);

-- ===============================================================================================================================
-- ADVANCED BIOINFORMATICS INSIGHTS
-- ===============================================================================================================================

-- Q24 Find the top 15 strongest drug–gene interactions based on interaction score.
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

-- Q25 Find the top 10 genes with the highest average interaction score across all drugs.
SELECT 
    ins.gene_id,
    cg.gene_name,
    COUNT(ins.drug_id) AS drug_interaction_count,
    AVG(ins.interaction_score) AS average_interaction_score
FROM
    interactions AS ins
        INNER JOIN
    cleaned_genes AS cg ON ins.gene_id = cg.gene_id
GROUP BY ins.gene_id, cg.gene_name
ORDER BY average_interaction_score DESC
LIMIT 10;

-- Q26 Find the top 10 drugs with the highest average interaction score across all genes.
SELECT 
    ins.drug_id,
    cd.drug_name,
    COUNT(ins.gene_id) AS gene_interaction_count,
    AVG(ins.interaction_score) AS average_interaction_score
FROM
    interactions AS ins
        INNER JOIN
    clean_drugs AS cd ON ins.drug_id = cd.drug_id
GROUP BY ins.drug_id , cd.drug_name
ORDER BY average_interaction_score DESC
LIMIT 10;

-- Q27 Find genes that interact only with approved drugs.
SELECT 
    ins.gene_id,
    cg.gene_name,
    COUNT(ins.drug_id) AS total_drugs_interacting
FROM
    interactions AS ins
        INNER JOIN
    cleaned_genes AS cg ON ins.gene_id = cg.gene_id
        INNER JOIN
    clean_drugs AS cd ON ins.drug_id = cd.drug_id
GROUP BY ins.gene_id , cg.gene_name
HAVING SUM(CASE
    WHEN cd.approved = 0 THEN 1
    ELSE 0
END) = 0;

-- Q28 Find drugs that interact with more than 20 genes and have an average interaction score higher than the overall dataset average.
SELECT 
    ins.drug_id,
    cd.drug_name,
    COUNT(ins.gene_id) AS gene_interaction_count,
    AVG(ins.interaction_score) AS avg_interaction_score
FROM
    interactions AS ins
        INNER JOIN
    clean_drugs AS cd ON ins.drug_id = cd.drug_id
GROUP BY ins.drug_id , cd.drug_name
HAVING gene_interaction_count > 20
    AND avg_interaction_score > (SELECT 
        AVG(interaction_score)
    FROM
        interactions);
        
-- Q29 Find genes that interact with both immunotherapy drugs and anti-neoplastic drugs.
SELECT 
    ins.gene_id,
    cg.gene_name,
    SUM(CASE WHEN cd.immunotherapy = 1 THEN 1 ELSE 0 END) AS immunotherapy_drug_count,
    SUM(CASE WHEN cd.anti_neoplastic = 1 THEN 1 ELSE 0 END) AS antineoplastic_drug_count
FROM
    interactions AS ins
INNER JOIN
    cleaned_genes AS cg 
        ON ins.gene_id = cg.gene_id
INNER JOIN
    clean_drugs AS cd 
        ON ins.drug_id = cd.drug_id
GROUP BY 
    ins.gene_id, cg.gene_name
HAVING 
    immunotherapy_drug_count > 0
    AND antineoplastic_drug_count > 0
ORDER BY 
    immunotherapy_drug_count DESC,
    antineoplastic_drug_count DESC;

-- Q30 Find the top 10 genes that interact with the highest number of approved drugs and have above-average interaction scores.
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