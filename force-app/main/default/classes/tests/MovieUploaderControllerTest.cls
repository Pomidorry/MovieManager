@isTest
public class MovieUploaderControllerTest {
    @testSetup
    static void setup() {
        Movie_Settings__c s = Movie_Settings__c.getOrgDefaults();
        s.Load_From_Json__c = true;
        upsert s;
    }
    @isTest
    static void testUploadMovieRecords() {
        String jsonBody = '[{"id":"1","name":"Avatar","tmdb_id":"19996","genre":"Action;Adventure;Fantasy;Science_Fiction","rating":7.2,"budget":237000000,"actual_budget":237000000,"revenue":2787965087,"script":{"id":"1","name":"Avatar","description":"In the 22nd century, a paraplegic Marine is dispatched to the moon Pandora on a unique mission, but becomes torn between following orders and protecting an alien civilization."},"release_date":"10/12/2009","status":"Released"},{"id":"2","name":"Pirates of the Caribbean: At World\'s End","tmdb_id":"286","genre":"Adventure;Fantasy;Action","rating":6.9,"budget":300000000,"actual_budget":300000000,"revenue":961000000,"script":{"id":"2","name":"Pirates of the Caribbean: At World\'s End","description":"Captain Barbossa, long believed to be dead, has come back to life and is headed to the edge of the Earth with Will Turner and Elizabeth Swann. But nothing is quite as it seems."},"release_date":"19/05/2007","status":"Released"}]';
       	Test.setMock(HttpCalloutMock.class, new TmdbHttpCalloutMock());
        
        Test.startTest();
        MovieUploaderController.uploadMovieRecords(jsonBody);  
        Test.stopTest();

        List<Movie__c> movies = [SELECT Id, Name, Poster_URL__c FROM Movie__c];
        System.assertEquals(2, movies.size(), 'There should be two movie records created.');
        System.assertEquals('https://image.tmdb.org/t/p/original/bptfVGEQuv6vDTIMVCHjJ9Dz8PX.jpg', movies[0].Poster_URL__c);

    }
    //todo: more records
}