

// clean existing records
match (n:pm_absolute_count_entry ) optional match (n)-[r]-() delete n,r;
match (n:pm_absolute_count_entry_docs ) optional match (n)-[r]-() delete n,r;


match (n:pm_document ) optional match (n)-[r]-() delete n,r;
match (n:pm_diagnosis_category ) optional match (n)-[r]-() delete n,r;
match (n:pm_diagnosis ) optional match (n)-[r]-() delete n,r;
match (n:pm_pubmed_doc) optional match (n)-[r]-() delete n,r;

// Loading the CSVs

//////////////////////////////////////
// LOAD RAW DATA
//////////////////////////////////////

// DIAGNOSIS


LOAD CSV WITH HEADERS FROM "file:///Users/malarcon/Google Drive/CUNY/IS607/submissions/project5/absolute_count_entry.csv" as records
create (n:pm_absolute_count_entry)
set n = records;

//CREATE CONSTRAINT ON (c:pm_absolute_count_entry) ASSERT c.ccs_diagnosis_categories IS UNIQUE;

//CREATE INDEX ON :pm_absolute_count_entry(url_params);

//DROP INDEX ON :pm_absolute_count_entry_docs(url_params);

USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "file:///Users/malarcon/Google Drive/CUNY/IS607/submissions/project5/absolute_count_entry_docs.csv" as records
create (n:pm_absolute_count_entry_docs)
set n = records;

//CREATE INDEX ON :pm_absolute_count_entry_docs(url_params);


LOAD CSV WITH HEADERS FROM "file:///Users/malarcon/Google Drive/CUNY/IS607/submissions/project5/dxref_2015.csv" as records
with records, trim(records.`CCS CATEGORY`) as `CCS CATEGORY`
create (n:pm_dxref_2015)
set n = records;

CREATE INDEX ON :pm_dxref_2015(`CCS CATEGORY`);
CREATE INDEX ON :pm_dxref_2015(`ICD-9-CM CODE`);


MATCH (a: pm_dxref_2015)
SET a.`CCS CATEGORY` = trim(a.`CCS CATEGORY`);


////////Processing the Nodes


/////// pm_diagnosis_category

CREATE INDEX ON :pm_diagnosis_category(search_terms_url_encoded);
CREATE INDEX ON :pm_diagnosis_category(category_id);

MATCH (a: pm_absolute_count_entry)
WITH a
    ,a.ccs_diagnosis_categories as category_id
    ,a.ccs_diagnosis_categories_labels as category_description
    ,a.url_params as search_terms
    ,a.disease_phrase as search_terms_url_encoded
    ,a.Count as frequency
MERGE (n:pm_diagnosis_category {category_id:category_id
                  ,category_description:category_description
                  ,search_terms:search_terms
                  ,search_terms_url_encoded:search_terms_url_encoded
                  ,frequency:frequency
                  }
        );




/////// pm_diagnosis

CREATE INDEX ON :pm_diagnosis(icd9_code);
CREATE INDEX ON :pm_diagnosis(icd9_code_description);
CREATE INDEX ON :pm_diagnosis(category_id);

MATCH (a: pm_dxref_2015)
WITH a
  ,a.`ICD-9-CM CODE` as icd9_code
  ,a.`ICD-9-CM CODE DESCRIPTION` as icd9_code_description
  ,a.`CCS CATEGORY` as category_id
merge (m:pm_diagnosis {icd9_code:icd9_code
                  ,icd9_code_description:icd9_code_description
                  ,category_id:category_id
        });


MATCH (a: pm_diagnosis_category)
SET a.category_description_short = trim(a.category_description_short);

MATCH (a: pm_dxref_2015),(b:pm_diagnosis_category {category_id:a.`CCS CATEGORY`})
SET b.category_description_short = a.`CCS CATEGORY DESCRIPTION`;


/////////// diagnosis relationships

MATCH (b:pm_diagnosis)
      ,(c:pm_diagnosis_category {category_id:b.category_id})
CREATE (b) -[r:BELONGS_TO]-> (c);

MATCH (b:pm_diagnosis) REMOVE b.category_id


/////////// pubmed documents

CREATE INDEX ON :pm_pubmed_doc(pubmed_id);

USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "file:///Users/malarcon/Google Drive/CUNY/IS607/submissions/project5/pubmed_docs.csv" as records
create (n:pm_pubmed_doc)
set n = records;


/////////// document diagnosis category relationship
create index on :pm_pubmed_doc(pubmed_id);
create index on :pm_absolute_count_entry_docs(Id);
create index on :pm_absolute_count_entry_docs(url_params);
create index on :pm_diagnosis_category(search_terms);

