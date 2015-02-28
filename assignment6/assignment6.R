library(ggplot2)

# 1. Choose and load any R dataset (except for diamonds!)
data <- midwest

# 2. Generate summary level descriptive statistics: Show the mean, median, 
# 25th and 75th quartiles, min, and max for each of the applicable variables
# in your data set.

summary(data)

#3. Determine the frequency for one of the categorical variables.

table(data$state)

# 4. Determine the frequency for one of the categorical variables, 
# by a different categorical variable.

table(data$state,data$category)

# 5. Create a graph for a single numeric variable.

boxplot(data$percbelowpoverty
        ,main="Percent of Population Below Poverty Line")
hist(data$percbelowpoverty
     ,main="Percent of Population Below Poverty Line")

# 6. Create a scatterplot of two numeric variables.
# Percent 
plot(data$percbelowpoverty ~ data$percollege
      ,main="Percent of Population College Educated / Below Poverty Line")


# BONUS ( for zero points)
#
# Turn a numerical variable into categorical using : percchildbelowpovert
# and get the frequencies by state
#
data$percchildbelowpovert_bin <- (data$percchildbelowpovert%/%10)*10

table(data$state,data$percchildbelowpovert_bin)

