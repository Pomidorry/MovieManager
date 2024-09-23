@isTest
public class MovieBatchTest {
    @testSetup
    static void setup() {
        Movie_Settings__c movieSetting  = Movie_Settings__c.getOrgDefaults();
        movieSetting.Load_From_Json__c=true;
        upsert movieSetting;
        
        List<Movie__c> movies = new List<Movie__c>();
        movies.add(new Movie__c(tmdb_Id__c = '67890', TMDBSyncDate__c = Date.today().addMonths(-2)));
        movies.add(new Movie__c(tmdb_Id__c = '67891', TMDBSyncDate__c = Date.today().addMonths(2)));
        insert movies;
    }
    @isTest
    static void testMovieSyncBatch() {
        Test.setMock(HttpCalloutMock.class, new TmdbHttpCalloutMock());
       
        Test.startTest();     
        Database.executeBatch(new MovieSyncBatch()); 
       	Test.stopTest();      
        
        List<Movie__c> moviesUpd = [SELECT Title__c, Revenue__c, Rating__c, Poster_URL__c, Budget__c, TMDBSyncDate__c FROM Movie__c];
        System.assertEquals(Date.Today(), moviesUpd[0].TMDBSyncDate__c, 'TMDBSyncDate should be today');
        System.assertNotEquals(Date.Today(), moviesUpd[1].TMDBSyncDate__c, 'TMDBSyncDate should not be today');
    }
}