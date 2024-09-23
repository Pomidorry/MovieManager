public class MovieJsonDataProcessor {
    public static List<Movie__c> buildNewMovies(List<MovieWrapper> movieData, Map<String, Script__c> scriptMap) {
        Map<String, Movie__c> existingMovies = getExistingMovies(movieData);
        Set<String> validGenres = getValidGenreList();
        List<Movie__c> newMovies = new List<Movie__c>();

        for (MovieWrapper movie : movieData) {
            if (!existingMovies.containsKey(movie.tmdb_id) && isValidGenre(movie.genre, validGenres)) {
                Movie__c newMovie = createMovie(movie, scriptMap);
                newMovies.add(newMovie);
            }
        }

        return newMovies;
    }

    private static Movie__c createMovie(MovieWrapper mv, Map<String, Script__c> scriptMap) {
        Movie__c movie = new Movie__c(
            LegacyId__c = mv.id,
            TMDB_id__c = mv.tmdb_id,
            Budget__c = mv.budget,
            Title__c = mv.name,
            genre__c = mv.genre,
            rating__c = mv.rating,
            Revenue__c = mv.revenue,
            ReleaseDate__c = Date.parse(mv.release_date.replace('/', '.'))
        );

        Script__c relatedScript = scriptMap.get(mv.script.id);
        movie.Script__c = relatedScript != null ? relatedScript.Id : null;

        return movie;
    }

    private static Map<String, Movie__c> getExistingMovies(List<MovieWrapper> movieData) {
        Set<String> tmdbIds = new Set<String>();
        for (MovieWrapper movie : movieData) {
            tmdbIds.add(movie.tmdb_id);
        }

        List<Movie__c> existingMovies = [
            SELECT Id, TMDB_id__c 
            FROM Movie__c 
            WHERE TMDB_id__c IN :tmdbIds
    	];

        Map<String, Movie__c> movieMap = new Map<String, Movie__c>();
        for (Movie__c movie : existingMovies) {
            movieMap.put(movie.TMDB_id__c, movie);
        }
    
        return movieMap;
    }

    private static Set<String> getValidGenreList() {
        Set<String> validGenres = new Set<String>();
        Schema.DescribeFieldResult genreField = Movie__c.Genre__c.getDescribe();
        for (Schema.PicklistEntry entry : genreField.getPicklistValues()) {
            validGenres.add(entry.getValue());
        }
        return validGenres;
    }

    private static Boolean isValidGenre(String genreString, Set<String> validGenres) {
        for (String genre : genreString.split(';')) {
            if (!validGenres.contains(genre.trim())) {
                return false;
            }
        }
        return true;
    }
}