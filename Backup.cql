//USING PERIODIC COMMIT
//LOAD CSV WITH HEADERS FROM "file:///ratings.csv" AS line
//MATCH (user:User {id: toInt(line.userId)})
//MATCH (movie:Movie {id: toInt(line.movieId)})
//MERGE (movie)-[r:ratedBy]->(user);
//ON CREATE SET r.timestamp = line.timestamp, r.rating = toFloat(line.rating);
