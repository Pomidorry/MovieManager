@isTest
public class MovieAddControllerTest {

    @isTest
    static void testSearchMovie() {
        Test.setMock(HttpCalloutMock.class, new TmdbHttpCalloutMock());  
        
        Test.startTest();
        List<tmdbSearchMovieResult> results = MovieAddController.searchMovies('Fight Club');
        Test.stopTest();
    
        System.assertNotEquals(null, results);
        System.assertEquals(1, results.size());
        System.assertEquals('Fight Club', results[0].title);
    }
    
    @isTest
    static void testAddMovie() {
        Test.setMock(HttpCalloutMock.class, new TmdbHttpCalloutMock());
        Test.startTest();
        MovieAddController.createMovieRecord('12345');
        Test.stopTest();
        
        Movie__c insertedMovie = [SELECT TMDB_Id__c, Title__c FROM Movie__c WHERE TMDB_Id__c = '12345' LIMIT 1];
        
        System.assertNotEquals(null, insertedMovie);
        System.assertEquals('12345', insertedMovie.TMDB_Id__c);
        System.assertEquals('Fight Club', insertedMovie.Title__c);
    }
}