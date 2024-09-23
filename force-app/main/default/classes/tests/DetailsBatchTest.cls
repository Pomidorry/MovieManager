@isTest
public class DetailsBatchTest {
    @testSetup
    static void setup() {
        Movie_Settings__c movieSetting  = Movie_Settings__c.getOrgDefaults();
        movieSetting.Load_From_Json__c=true;
        upsert movieSetting;
        
        List<Movie__c> movies = new List<Movie__c>();
        movies.add(new Movie__c(tmdb_Id__c = '67890', Poster_URL__c = 'https://image.tmdb.org/t/p/w500//posterurl', VideoUrl__c='/video'));
        movies.add(new Movie__c(tmdb_Id__c = '67891'));
        insert movies;
    }
    @isTest
    static void testDetailsBatch() {
        Test.setMock(HttpCalloutMock.class, new TmdbHttpCalloutMock());
       
        Test.startTest();     
        Database.executeBatch(new DetailsBatch()); 
       	Test.stopTest();      
        
        List<Movie__c> moviesUpd = [SELECT Title__c, Revenue__c, Rating__c, Poster_URL__c, Budget__c, TMDBSyncDate__c FROM Movie__c];
        System.assertEquals('https://image.tmdb.org/t/p/w500//posterurl', moviesUpd[0].Poster_URL__c);
        System.assertEquals('https://image.tmdb.org/t/p/original/bptfVGEQuv6vDTIMVCHjJ9Dz8PX.jpg', moviesUpd[1].Poster_URL__c);
    }
}