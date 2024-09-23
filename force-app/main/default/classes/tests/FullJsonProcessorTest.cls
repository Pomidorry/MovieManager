@isTest
public class FullJsonProcessorTest {	
    @testSetup
    static void testSetup(){
    	Movie_Settings__c movieSetting  = Movie_Settings__c.getOrgDefaults();
        movieSetting.Load_From_Json__c = true;
        upsert movieSetting;
        
        Script__c script1 = new Script__c(LegacyId__c = '3', Title__c = 'Script 1');
        Script__c script2 = new Script__c(LegacyId__c = '4', Title__c = 'Script 2');
        insert new List<Script__c>{script1, script2};

       
        Movie__c movie1 = new Movie__c(TMDB_id__c = '19995', Title__c = 'Movie 1');
        Movie__c movie2 = new Movie__c(TMDB_id__c = '285', Title__c = 'Movie 2');
        insert new List<Movie__c>{movie1, movie2}; 
	}
    @isTest
    static void testProcessStaticResourseMovies() {    
       	Test.startTest();
        FullJsonProcessor.processMoviesStaticResource('MovieJson');
        Test.stopTest();

        List<Script__c> scripts = [SELECT LegacyId__c FROM Script__c WHERE LegacyId__c IN ('1', '2')];       
        System.assertEquals(2, scripts.size(), 'Two records created');

    }
    @isTest
    static void testLoadMovieDataInvalidResourse() {
        Test.startTest();    
        try {
            FullJsonProcessor.processMoviesStaticResource('skdosu');
        } catch(Exception e) {
            System.assert(e != null, 'Expected an exception to be thrown.');
        }  
        Test.stopTest();
    
        List<Movie__c> movies = [SELECT Id FROM Movie__c];
        System.assertEquals(2, movies.size(), 'New records should not be created');
    }
    
    @isTest
    static void testProcessMovies() {
       	String jsonBody = '[{"id":"1","name":"Avatar","tmdb_id":"19996","genre":"Action;Adventure;Fantasy;Science_Fiction","rating":7.2,"budget":237000000,"actual_budget":237000000,"revenue":2787965087,"script":{"id":"1","name":"Avatar","description":"In the 22nd century, a paraplegic Marine is dispatched to the moon Pandora on a unique mission, but becomes torn between following orders and protecting an alien civilization."},"release_date":"10/12/2009","status":"Released"},{"id":"2","name":"Pirates of the Caribbean: At World\'s End","tmdb_id":"286","genre":"Adventure;Fantasy;Action","rating":6.9,"budget":300000000,"actual_budget":300000000,"revenue":961000000,"script":{"id":"2","name":"Pirates of the Caribbean: At World\'s End","description":"Captain Barbossa, long believed to be dead, has come back to life and is headed to the edge of the Earth with Will Turner and Elizabeth Swann. But nothing is quite as it seems."},"release_date":"19/05/2007","status":"Released"}]';

        Test.startTest();

        FullJsonProcessor.processMoviesJson(jsonBody);

        Test.stopTest();

        List<Script__c> scripts = [SELECT LegacyId__c FROM Script__c];
        System.assertEquals(4, scripts.size());

        List<Movie__c> movies = [SELECT TMDB_id__c FROM Movie__c];
        System.assertEquals(4, movies.size());
    }

    @isTest
    static void testLoadMovieDataWithCheckNoDuplicates() {  
        String jsonBody = '[{"id":"4","tmdb_id":"tmdb1","name":"Movie 1","genre":"Action","budget":5000000,"revenue":10000000,"release_date":"01/01/2023","rating":7.5,"script":{"id":"4","name":"Script 1"}}]';

        Test.startTest();
        FullJsonProcessor.processMoviesJson(jsonBody);
        Test.stopTest();

        List<Movie__c> movies = [SELECT Id FROM Movie__c WHERE TMDB_id__c = 'tmdb1'];
        System.assertEquals(1, movies.size(), 'No dublicates');
    }
	@isTest
    static void testCreateMovieRecordsWithInvalidGenre() {       
        String jsonBody = '[{"id":"4","tmdb_id":"tmdb1","name":"Movie 1","genre":"Akjrtgu","budget":5000000,"revenue":10000000,"release_date":"01/01/2023","rating":7.5,"script":{"id":"4","name":"Script 1"}}]';

        Test.startTest();
        FullJsonProcessor.processMoviesJson(jsonBody);
        Test.stopTest();

        List<Movie__c> movies = [SELECT Id FROM Movie__c WHERE TMDB_id__c = 'tmdb1'];
        System.assertEquals(0, movies.size(), 'Invalid genre assert');
    }

    @isTest
    static void testLoadMovieDataWithEmptyJson() {
        String emptyJsonBody = '[]';
        
        Test.startTest();
        FullJsonProcessor.processMoviesJson(emptyJsonBody);
        Test.stopTest();

        List<Movie__c> movies = [SELECT Id FROM Movie__c];
        System.assertEquals(2, movies.size(), 'New records should not be created (empty json)');
    }
    
    @isTest
    static void testLoadMovieDataWithInvalidJson() {
        String invalidJsonBody = 'apkdjfjf';
    
        Test.startTest();
        
        try {
            FullJsonProcessor.processMoviesJson(invalidJsonBody);
        } catch(Exception e) {
            System.assert(e != null, 'Expected an exception to be thrown.');
        }
    
        Test.stopTest();
    
        List<Movie__c> movies = [SELECT Id FROM Movie__c];
        System.assertEquals(2, movies.size(), 'Invalid static resourse name, no records created');
    }
}