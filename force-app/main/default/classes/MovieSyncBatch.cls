public with sharing class MovieSyncBatch implements Database.Batchable<SObject>, Database.AllowsCallouts {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        Date oneMonthAgo = System.today().addMonths(-1);

        String query = 'SELECT Id, tmdb_Id__c FROM Movie__c WHERE (TMDBSyncDate__c = NULL OR TMDBSyncDate__c < :oneMonthAgo) AND (tmdb_Id__c != NULL)';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Movie__c> scope) {
        for (Movie__c movie : scope) {
            if (movie.tmdb_Id__c != null) {    
                tmdbDetailsResponse details = tmdb.getMovieDetails(movie.tmdb_Id__c);
                movie.Description__c = details.overview;
                movie.Title__c = details.original_title;
                movie.Revenue__c = details.revenue;
                movie.Rating__c = details.vote_average;
                movie.Poster_URL__c = 'https://image.tmdb.org/t/p/w500/'+details.poster_path;
                movie.Budget__c = details.budget;
                movie.TMDBSyncDate__c = Date.Today();
            }
        } 
        update scope;
    }

    public void finish(Database.BatchableContext bc) {
        
    }
}