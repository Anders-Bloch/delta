docker exec neo4j /var/lib/neo4j/bin/neo4j stop
docker cp ./dist/Genres.csv neo4j:/var/lib/neo4j/import
docker cp ./dist/Movies.csv neo4j:/var/lib/neo4j/import
docker cp ./dist/Stars.csv neo4j:/var/lib/neo4j/import
docker cp ./dist/genome-tags.csv neo4j:/var/lib/neo4j/import
docker cp ./dist/genome-scores.csv neo4j:/var/lib/neo4j/import
docker cp ./dist/MoviesGenres.csv neo4j:/var/lib/neo4j/import
docker cp ./dist/MoviesRatings.csv neo4j:/var/lib/neo4j/import
docker cp ./dist/Years.csv neo4j:/var/lib/neo4j/import
docker cp ./dist/MovieYear.csv neo4j:/var/lib/neo4j/import
docker cp ./dist/Users.csv neo4j:/var/lib/neo4j/import
docker cp neo4j.conf neo4j:/var/lib/neo4j/conf
docker cp neo4j-wrapper.conf neo4j:/var/lib/neo4j/conf
docker exec neo4j /var/lib/neo4j/bin/neo4j start