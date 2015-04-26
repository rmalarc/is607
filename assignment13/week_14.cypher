
// clean existing records
match (n:data_students_and_housing ) optional match (n)-[r]-() delete n,r;
match (n:data_courses ) optional match (n)-[r]-() delete n,r;


match (n:Dormitory ) optional match (n)-[r]-() delete n,r;
match (n:Course ) optional match (n)-[r]-() delete n,r;
match (n:Student ) optional match (n)-[r]-() delete n,r;

// Loading the CSVs

//////////////////////////////////////
// LOAD RAW DATA
//////////////////////////////////////

// source schema
// id  Gender  GivenName Surname StreetAddress City  State ZipCode TelephoneNumber Dormitory Room

LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/rmalarc/is607/master/assignment13/data-students-and-housing.csv" as records
create (n:data_students_and_housing)
set n = records;

CREATE INDEX ON :data_students_and_housing(id);


// source schema:
// id  GivenName Surname CourseDept  CourseNumber  CourseName  Grade Section Instructor

LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/rmalarc/is607/master/assignment13/data-courses.csv" as records
create (n:data_courses)
set n = records;

CREATE INDEX ON :data_courses(id);


////////Processing the Nodes

//////////Dormitory

// Load Dormitory
// Dormitory (name)
MATCH (source_data:data_students_and_housing)
WITH source_data, source_data.Dormitory as label
MERGE (n:Dormitory {name:label
                    }
      );

CREATE INDEX ON :Dormitory(name);

//////////Student

// Load Student
// Student (firstname, lastname, id, gender, address, city, state, zipcode, phone)
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

CREATE INDEX ON :Student(id);


//////////Course

// Load Course
// Course (department, number, title)
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

CREATE INDEX ON :Course(title);
CREATE INDEX ON :Course(number);
CREATE INDEX ON :Course(department);


////////Processing the Relationships

//////////Enrolled

// Enrolled (section, instructor, grade [value of IP for in progress])

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
                        }]-> (c);



//////////Completed


//Completed (section, instructor, grade)
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
                        }]-> (c);


//////////Housed

//Housed (room)
MATCH (a:Student)
    ,(b:data_students_and_housing {id: a.id})
    ,(c:Dormitory {name:b.Dormitory})
CREATE (a) -[r:Housed {room:b.Room
                        }]-> (c);

