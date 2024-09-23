public with sharing class MovieAddController {
    
    @AuraEnabled
    public static List<tmdbSearchMovieResult> searchMovies(String title) {
        tmdbSearchMovieResponse searchResponse = tmdb.searchMovie(title);
        return searchResponse.results;
    }
    
    @AuraEnabled
    public static void createMovieRecord(String movieId) {
        Movie__c newMovie = new Movie__c(
            TMDB_Id__c = movieId
        );
        insert newMovie;
    }
}