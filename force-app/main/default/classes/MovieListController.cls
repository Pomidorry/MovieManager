public with sharing class MovieListController {
    @AuraEnabled(cacheable=true scope='global')
    public static List<Movie__c> getAllMovies(Integer offset, Integer lim, String genre, String searchTerm){
        String query = 'SELECT Id, Title__c, Rating__c, Genre__c, Description__c, Poster_URL__c, Rating_Calculated__c FROM Movie__c';
        
        if (genre != null && genre != 'All') {
            query += ' WHERE Genre__c includes (\'' + genre + '\')';
        }
        
        if (searchTerm != null && searchTerm != '') {
            if (genre != null && genre != 'All') {
                query += ' AND Title__c LIKE \'%' + searchTerm + '%\'';
            } else {
                query += ' WHERE Title__c LIKE \'%' + searchTerm + '%\'';
            }
        }

        query += ' ORDER BY Title__c LIMIT :lim OFFSET :offset';
        
        return Database.query(query);
    }

    @AuraEnabled(cacheable=true scope='global')
    public static List<String> getGenres() {
        Values genreValues = new Values();
        return new List<String>(genreValues.genreIdByName.keySet());
    }
}