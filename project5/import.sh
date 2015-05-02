#!/bin/sh

rm -r pubmed_db

neo4j-import --nodes pubmed_docs_columns.csv,pubmed_docs2.csv \
	    --nodes absolute_count_entry_columns.csv,absolute_count_entry2.csv \
	    --relationships absolute_count_entry_docs_columns.csv,absolute_count_entry_docs2.csv \
	    --into pubmed_db
