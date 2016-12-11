CREATE INDEX ON :Movie(id);
CREATE INDEX ON :Genre(name);
CREATE INDEX ON :Star(id);
CREATE INDEX ON :Tag(id);
CREATE INDEX ON :Year(year);
CREATE INDEX ON :User(id);

USING PERIODIC COMMIT
LOAD CSV FROM "file:///Genres.csv" AS line
CREATE (:Genre { name: line[0]});

USING PERIODIC COMMIT
LOAD CSV FROM "file:///Years.csv" AS line
CREATE (:Year { year: toInt(line[0])});

USING PERIODIC COMMIT
LOAD CSV FROM "file:///Users.csv" AS line
CREATE (:User { id: toInt(line[0])});

USING PERIODIC COMMIT
LOAD CSV FROM "file:///Movies.csv" AS line
CREATE (:Movie { id: toInt(line[0]), title: line[1], imdbId: line[2], tmdbId: line[3]});

USING PERIODIC COMMIT
LOAD CSV FROM "file:///Stars.csv" AS line
CREATE (:Star { id: toFloat(line[0])});

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///genome-tags.csv" AS line
CREATE (:Tag { id: toInt(line.tagId), tag: line.tag});

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///MovieYear.csv" AS line
MATCH (year:Year {year: toInt(line.Year)})
MATCH (movie:Movie {id: toInt(line.movieId)})
MERGE (movie)-[:IN]->(year);

USING PERIODIC COMMIT
LOAD CSV FROM "file:///MoviesGenres.csv" AS line
MATCH (genre:Genre {name: line[1]})
MATCH (movie:Movie {id: toInt(line[0])})
MERGE (movie)-[:HAS]->(genre);

USING PERIODIC COMMIT LOAD CSV FROM "file:///MoviesRatings.csv" AS line 
MATCH (star:Star {id: toFloat(line[1])}) 
MATCH (movie:Movie {id: toInt(line[0])}) 
MERGE (movie)-[s:MOVIE_STAR]->(star) ON CREATE SET s.count = toInt(line[2]), s.users = line[3];

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///genome-scores.csv" AS line
MATCH (tag:Tag {id: toInt(line.tagId)})
MATCH (movie:Movie {id: toInt(line.movieId)})
MERGE (movie)-[s:SCORE]->(tag)
ON CREATE SET s.relevance = toFloat(line.relevance);

#USING PERIODIC COMMIT
#LOAD CSV WITH HEADERS FROM "file:///ratings.csv" AS line
#MATCH (user:User {id: toInt(line.userId)})
#MATCH (movie:Movie {id: toInt(line.movieId)})
#MERGE (movie)-[r:ratedBy]->(user);
#ON CREATE SET r.timestamp = line.timestamp, r.rating = toFloat(line.rating);
