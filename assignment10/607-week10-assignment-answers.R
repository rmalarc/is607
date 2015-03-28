# title: Assignment 10
# author: "Mauricio Alarcon"
# Note: For Convenience, I added the answers to the provided code


# 607-week10-assignment.R
# [For your convenience], here is provided code based in Jared Lander's R for Everyone, 

install.packages("XML")
library(XML)
theURL <- "http://www.jaredlander.com/2012/02/another-kind-of-super-bowl-pool/"
bowlPool <- readHTMLTable(theURL, which = 1, header = FALSE, stringsAsFactors = FALSE)
bowlPool

# 1. What type of data structure is bowlpool? 
 
# Answer: Dataframe

# 2. Suppose instead you call readHTMLTable() with just the URL argument,
# against the provided URL, as shown below

theURL <- "http://www.w3schools.com/html/html_tables.asp"
hvalues <- readHTMLTable(theURL)

# What is the type of variable returned in hvalues?

# Answer: List

# 3. Write R code that shows how many HTML tables are represented in hvalues

tables_in_html <- sapply( hvalues, function(m) class(m)=="data.frame" ) 
sum(tables_in_html)


# 4. Modify the readHTMLTable code so that just the table with Number, 
# FirstName, LastName, # and Points is returned into a dataframe

# Table is not available
# fetching the last table in the page
last_table_in_page <- max(which(tables_in_html))
last_table <- readHTMLTable(theURL, which = last_table_in_page, header = FALSE, stringsAsFactors = FALSE)


# 5. Modify the returned data frame so only the Last Name and Points columns are shown.

#columns not available, keeping all columns but the second column
last_table <- last_table[-2]

# 6 Identify another interesting page on the web with HTML table values.  
# This may be somewhat tricky, because while
# HTML tables are great for web-page scrapers, many HTML designers now prefer 
# creating tables using other methods (such as <div> tags or .png files).  

# Wikipedia's Gross World Product page, contains recent and historical data in two tables
theURL <- "http://en.wikipedia.org/wiki/Gross_world_product"
gross_world_product_recent <- readHTMLTable(theURL, which = 1, header = TRUE, stringsAsFactors = FALSE)
gross_world_product_recent


# 7 How many HTML tables does that page contain?

tables_in_html <- sapply( hvalues, function(m) class(m)=="data.frame" ) 
sum(tables_in_html)


# 8 Identify your web browser, and describe (in one or two sentences) 
# how you view HTML page source in your web browser.

# Answer: 
# Chrome: Right click on page and select VIEW SOURCE. Also from the menu: VIEW | DEVELOPER | VIEW SOURCE

# 9 (Optional challenge exercise)
# Instead of using readHTMLTable from the XML package, use the functionality in the rvest package to perform the same task.  
# Which method do you prefer?  Why might one prefer one package over the other?

install.packages("rvest")

library(rvest)
gwp_rvest <- html(theURL)

# we can get the xpath of each table from the web broser and pull each table individually
gross_world_product_recent_rvest <-  gwp_rvest %>% 
  html_nodes(xpath='//*[@id="mw-content-text"]/table[1]') %>%
  html_table() %>%
  data.frame()

gross_world_product_hist_rvest <- gwp_rvest %>% 
  html_nodes(xpath='//*[@id="mw-content-text"]/table[2]') %>%
  html_table() %>%
  data.frame()



# I like the fact that Rvest can select elements based on the css and xpath. 
# This makes it much easier and precise to translate what you're seeing and what you're pulling.



