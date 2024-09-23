public with sharing class DetailsBatch implements Database.Batchable<SObject>, Database.AllowsCallouts {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, tmdb_Id__c FROM Movie__c WHERE Poster_URL__c = null OR VideoUrl__c = null';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Movie__c> scope) {
        String imgUrl = getBaseImageUrl();
        List<Movie__c> moviesToUpdate = new List<Movie__c>();

        for (Movie__c movie : scope) {
            if (movie.tmdb_Id__c != null) {
                tmdbDetailsResponse details = tmdb.getMovieDetails(movie.tmdb_Id__c);
                MovieTrailer trailer = tmdb.getMovieTrailer(movie.tmdb_Id__c);
                
                if (details != null && details.poster_path != null) {
                    movie.Poster_URL__c = imgUrl + 'original' + details.poster_path;
                }

                if (trailer != null && !trailer.results.isEmpty()) {
                    movie.VideoUrl__c = trailer.results[0].key;
                }

                moviesToUpdate.add(movie);
            }
        }

        if (!moviesToUpdate.isEmpty()) {
            update moviesToUpdate;
        }
    }

    public void finish(Database.BatchableContext bc) {
        
    }

    private static String getBaseImageUrl() {
        baseImageUrl baseUrlStruct = tmdb.getImageUrl();
        return baseUrlStruct != null ? baseUrlStruct.images.secure_base_url : '';
    }
}