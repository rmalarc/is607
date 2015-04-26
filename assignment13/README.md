# Week 13: Neo4J
**Mauricio Alarcon <rmalarc@msn.com>**

In this assignment, we will load a data set into Neo4j and manipulate it by constructing appropriate Cypher queries.

## Data-sources

* https://raw.githubusercontent.com/rmalarc/is607/master/assignment13/data-students-and-housing.csv
* https://raw.githubusercontent.com/rmalarc/is607/master/assignment13/data-courses.csv

## Nodes

* Student (firstname, lastname, id, gender, address, city, state, zipcode, phone)
* Course (department, number, title)
* Dormitory (name)

## Relationships

* Enrolled (section, instructor, grade [value of IP for in progress])
* Completed (section, instructor, grade)
* Housed (room)

## Deliverables

* Parse the CSVs into each of the specified nodes and relationships
* Provide a short paragraph commenting on whether a graph database is a better choice or a worse choice than a SQL database for this task.
* Write the Cypher query that will find all of the roommates of the student Richard Kowalski.
* Suppose you were told Richard Kowalski, who was enrolled in section 12136 of Math 120: Finite Mathematics, completed the course with a grade of B. Show the query that would find the appropriate relationship and update both the label (enrolled to completed) and the grade.
* Bonus: We have instructor as a property of the relationship “enrolled” in our model. Describe a data model that might improve on this setup by making instructor a type of node rather than an attribute. Which way do you think might make more sense? Does the use case affect your opinion? Explain. (You may wish to sketch a picture of what this new model would look like.)

* * *

## The Deliverable

### Parsing the CSVs

This script attempts to solve this part of the assginment by:

* Making sure the DB is empty
* Loading the raw CSVs into Neo4J AS-IS
* Process the nodes based upon the previously loaded data
* Process the relationships

The entire script is available [here](https://raw.githubusercontent.com/rmalarc/is607/master/assignment13/week_14.cypher). It can be executed from the

```
wget https://raw.githubusercontent.com/rmalarc/is607/master/assignment13/week_14.cypher
neo4j-shell --file ./week_14.cypher

```
####Emptying the DB

```
# clean existing records
match (n:data_students_and_housing ) optional match (n)-[r]-() delete n,r;
match (n:data_courses ) optional match (n)-[r]-() delete n,r;


match (n:Dormitory ) optional match (n)-[r]-() delete n,r;
match (n:Course ) optional match (n)-[r]-() delete n,r;
match (n:Student ) optional match (n)-[r]-() delete n,r;
```

#### Loading the CSVs

```
###################
# LOAD RAW DATA
###################

# source schema
# id  Gender  GivenName Surname StreetAddress City  State ZipCode TelephoneNumber Dormitory Room

LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/rmalarc/is607/master/assignment13/data-students-and-housing.csv" as records
create (n:data_students_and_housing)
set n = records

CREATE INDEX ON :data_students_and_housing(id)


# source schema:
# id  GivenName Surname CourseDept  CourseNumber  CourseName  Grade Section Instructor

LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/rmalarc/is607/master/assignment13/data-courses.csv" as records
create (n:data_courses)
set n = records

CREATE INDEX ON :data_courses(id)
```

####Processing the Nodes

#####Dormitory

```
# Load Dormitory
# Dormitory (name)
MATCH (source_data:data_students_and_housing)
WITH source_data, source_data.Dormitory as label
MERGE (n:Dormitory {name:label
                    }
      );

CREATE INDEX ON :Dormitory(name)

```

#####Student

```
# Load Student
# Student (firstname, lastname, id, gender, address, city, state, zipcode, phone)
MATCH (source_data:data_students_and_housing)
WITH source_data
    ,source_data.GivenName as firstname
    ,source_data.Surname as lastname
    ,source_data.id as id
    ,source_data.Gender as gender
    ,source_data.StreetAddress as address
    ,source_data.City as city
    ,source_data.State as state
    ,source_data.ZipCode as zipcode
    ,source_data.TelephoneNumber as phone
MERGE (n:Student {id:id
                  ,firstname:firstname
                  ,lastname:lastname
                  ,gender:gender
                  ,address:address
                  ,city:city
                  ,state:state
                  ,zipcode:zipcode
                  ,phone:phone
                  }
        );

CREATE INDEX ON :Student(id)

```

#####Course

```
# Load Course
# Course (department, number, title)
MATCH (source_data:data_courses)
WITH source_data
    ,source_data.CourseDept as department
    ,source_data.CourseNumber as number
    ,source_data.CourseName as title
MERGE (n:Course { department:department
                  ,number:number
                  ,title:title
                  }
        );

CREATE INDEX ON :Course(title)
CREATE INDEX ON :Course(number)
CREATE INDEX ON :Course(department)

```

####Processing the Relationships

#####Enrolled

```
# Enrolled (section, instructor, grade [value of IP for in progress])

MATCH (a: Student)
    ,(b:data_courses {id: a.id})
    ,(c: Course {department: b.CourseDept
                , number :b.CourseNumber
                ,title:b.CourseName
              }
      )
WHERE b.Grade ="IP"
CREATE (a) -[r:Enrolled {section:b.Section
                          ,instructor:b.Instructor
                          , grade:b.Grade
                        }]-> (c)

```

#####Completed

```
#Completed (section, instructor, grade)
MATCH (a: Student)
    ,(b:data_courses {id: a.id})
    ,(c: Course {department: b.CourseDept
                , number :b.CourseNumber
                ,title:b.CourseName
              }
      )
WHERE NOT b.Grade ="IP"
CREATE (a) -[r:Completed {section:b.Section
                          ,instructor:b.Instructor
                          , grade:b.Grade
                        }]-> (c)

```

#####Housed

```
#Housed (room)
MATCH (a:Student)
    ,(b:data_students_and_housing {id: a.id})
    ,(c:Dormitory {name:b.Dormitory})
CREATE (a) -[r:Housed {room:b.Room
                        }]-> (c)


```



###How does this compare to SQL?

Graph databases are interesting indeed. Although there's nothing in this exercise that cannot be implemented in SQL, here's a brief pros and cons list:

PROs
* It's schema-less
* It is relatively easy to import CSV data and model the relationships in few steps.
* Navigating the data is fairly intuitive

CONs
* There is a learning curve
* The Cypher language is not as common as SQL
* The number of applications that can use Neo4J data is limited.


###Who are the roommates of Richard Kowalski

Write the Cypher query that will find all of the roommates of the student Richard Kowalski.

```

MATCH (rich_kowalski:Student { firstname:'Richard',lastname:'Kowalski' })
      -[r1:Housed]->
          (richs_dorm:Dormitory)
              <-[r2:Housed]-
                (dorm_mates:Student)
RETURN rich_kowalski,richs_dorm,dorm_mates

```

###Richard Kowalski finishes a class

Suppose you were told Richard Kowalski, who was enrolled in section 12136 of Math 120: Finite Mathematics, completed the course with a grade of B. Show the query that would find the appropriate relationship and update both the label (enrolled to completed) and the grade.

```
# Create the Complete relationship

MATCH (rich_kowalski:Student { firstname:'Richard',lastname:'Kowalski' })
      -[r1:Enrolled {section:"12136"
                    ,grade:"IP"}]->
            (class:Course {number:"120"
                          ,title:"Finite Mathematics"
                        }
            )
CREATE (rich_kowalski) -[r:Completed {section:r1.section
                          ,instructor:r1.instructor
                          , grade:"B"
                        }]-> (class)


#Delete the Enrolled relationship

MATCH (rich_kowalski:Student { firstname:'Richard',lastname:'Kowalski' })
      -[r1:Enrolled {section:"12136"
                    ,grade:"IP"}]->
            (class:Course {number:"120"
                          ,title:"Finite Mathematics"
                        }
            )
DELETE r1

```

###Bonus

We have instructor as a property of the relationship “enrolled” in our model. Describe a data model that might improve on this setup by making instructor a type of node rather than an attribute. Which way do you think might make more sense? Does the use case affect your opinion? Explain. (You may wish to sketch a picture of what this new model would look like.)


* I would create a node Instructor(Name) with a relationship Teaches (term) to a course. Here's a definition of the proposed schema:

```
# Load Instructor
# Instructor (name)
MATCH (source_data:data_courses)
WITH source_data
    ,source_data.Instructor as name
MERGE (n:Instructor { name:name
                  }
        );

CREATE INDEX ON :Instructor(name)

```

and the Teaches relationship

```
# Teaches (term)

MATCH (a: Instructor)
    ,(b:data_courses {Instructor: a.name})
    ,(c: Course {department: b.CourseDept
                , number :b.CourseNumber
                ,title:b.CourseName
              }
      )
MERGE (a) -[r:Teaches {term:"Fall 2014"
                        }]-> (c)
```

I think the above schema makes more sense for the use case as it would allow to track the term and eventually be able to query professors and the classes they teach.
