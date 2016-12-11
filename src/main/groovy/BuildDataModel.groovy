/**
 * Created by andersbloch on 20/11/2016.
 */
class BuildDataModel {

    def static inputDir = "/Users/andersbloch/ml-20m/"
    def static outputDir = "/Users/andersbloch/neo4j/import/"

    def static movies = [:]
    static Set<String> genres = []
    static Set<String> relations = []
    static Map<String,Integer> movieRatings = new HashMap<>();
    static Map<String,StringBuilder> movieRatingsUsers = new HashMap<>();
    static Set<String> users = new HashSet<>();

    static void main(String[] args) {
        new File("${inputDir}movies.csv").eachLine() {line, i ->
            def fields1 = line.split("\"")
            if(fields1.length > 2) {
                if(fields1[0] != "movieId") {
                    movies[fields1[0].replace(',','')] = new Movie(id: Integer.parseInt(fields1[0].replace(',','')), title: fields1[1].replace(',',''))
                }
                fields1[2].replace(',','').tokenize("|").each {genre ->
                    if(genre != "genres" && genre != "(no genres listed)") {
                        relations.add("""${fields1[0].replace(',','')},${genre}""")
                        genres.add(genre)
                    }
                }
            } else {
                def fields = line.split(",")
                if(fields[0] != "movieId" && fields.length > 1) {
                    movies[fields[0]] = new Movie(id: Integer.parseInt(fields[0]), title: fields[1])
                }
                fields[2].tokenize("|").each {genre ->
                    if(genre != "genres" && genre != "(no genres listed)") {
                        relations.add("""${fields[0].replace(',','')},${genre}""")
                        genres.add(genre)
                    }
                }
            }
        }
        println "movies file passed..."

        new File("${inputDir}links.csv").eachLine() {links, n ->
            def link = links.split(",")
            if(link[0] != "movieId" && link.length == 3) {
                movies[link[0]].setImdbId(Integer.parseInt(link[1]))
                movies[link[0]].tmdbId = Integer.parseInt(link[2])
            }
        }
        println "Links file passed..."

        new File("${inputDir}Ratings.csv").eachLine() {links, n ->
            //userId,movieId,rating,timestamp
            def link = links.split(",")
            if(link[0] != "userId") {
                users.add(link[0]);
                def relation = "${link[1]},${link[2]}"
                def user = "{${link[0]}:${link[3]}}"
                def count = movieRatings.get(relation)
                if(!movieRatingsUsers.containsKey(relation)) {
                    movieRatingsUsers.put(relation,new StringBuilder());
                }
                movieRatingsUsers.get(relation).append(user).append(":");
                if(count == null) {
                    movieRatings.put(relation,1)
                } else {
                    count = count + 1
                    movieRatings.put(relation,count)
                }
            }
        }
        println "Ratings file passed..."

        new File("${outputDir}MoviesRatings.csv").withWriter { out ->
            movieRatings.each{ k, v ->
                String users = movieRatingsUsers.get(k).toString();
                users = users.substring(0, users.length()-1);
                out.println "${k},${v},${users}"
            }
        }
        movieRatings.clear()
        movieRatingsUsers.clear()
        println "MoviesRatings file created..."

        new File("${outputDir}Users.csv").withWriter { out ->
            users.each{ user ->
                out.println "${user}"
            }
        }
        println "Users file created..."

        new File("${outputDir}Movies.csv").withWriter { out ->
            movies.each{ k, v ->
                out.println "${v}"
            }
        }
        println "Movies file created..."
        new File("${outputDir}Genres.csv").withWriter { out ->
            genres.each{v ->
                out.println "${v}"
            }
        }
        println "Genres file created..."
        new File("${outputDir}MoviesGenres.csv").withWriter { out ->
            relations.each{v ->
                out.println "${v}"
            }
        }
        println "MoviesGenres file created..."
    }



    static class Movie {
        int id
        String title
        int imdbId
        int tmdbId

        String toString() {
            return """${id},${title},${imdbId},${tmdbId}"""
        }
    }

}