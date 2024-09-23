@isTest
private class MovieTriggerTest {
    @testSetup
    static void setup() {
        // Turn On Trigger
        Movie_Settings__c s = Movie_Settings__c.getOrgDefaults();
        s.Load_From_Json__c = false;
        upsert s;
    }

    // Positive Scenario - After Insert Trigger
    @isTest
    static void testAfterInsertTriggerOn() {
        Test.setMock(HttpCalloutMock.class, new TmdbHttpCalloutMock());
        Movie__c newMovie = new Movie__c(TMDB_ID__c = '550');

        Test.startTest();
        insert newMovie;
        Test.stopTest();

        Movie__c insertedMovie = [SELECT Title__c FROM Movie__c WHERE Id = :newMovie.Id];
        System.assertEquals('Fight Club', insertedMovie.Title__c);
    }

    // Positive Scenario - After Update Trigger
    @isTest
    static void testAfterUpdateTriggerOn() {
        Test.setMock(HttpCalloutMock.class, new TmdbHttpCalloutMock());
        Movie__c newMovie = new Movie__c(TMDB_ID__c = '123');
        insert newMovie;

        newMovie.TMDB_ID__c = '550';

        Test.startTest();
        update newMovie;
        Test.stopTest();

        Movie__c updatedMovie = [SELECT Title__c FROM Movie__c WHERE Id = :newMovie.Id];
        System.assertEquals('Fight Club', updatedMovie.Title__c);
    }

    // Negative Scenario - No TMDB_ID (Insert)
    @isTest
    static void testAfterInsertNoTmdbId() {
        Movie__c newMovie = new Movie__c(Title__c = 'Test Movie');

        Test.startTest();
        insert newMovie;
        Test.stopTest();

        Movie__c insertedMovie = [SELECT Title__c, TMDB_ID__c FROM Movie__c WHERE Id = :newMovie.Id];
        System.assertEquals('Test Movie', insertedMovie.Title__c);
        System.assertEquals(null, insertedMovie.TMDB_ID__c);
    }

    // Edge Case - Empty Movie List on Insert
    @isTest
    static void testEmptyMovieListInsert() {
        Test.startTest();
        MovieService.processAfterInsert(new List<Movie__c>()); 
        Test.stopTest();
    }

    // Edge Case - Empty Movie List on Update
    @isTest
    static void testEmptyMovieListUpdate() {
        Test.startTest();
        MovieService.processAfterUpdate(new List<Movie__c>(), new Map<Id, Movie__c>());  
        Test.stopTest();
    }

    // Edge Case - Bulk Insert Trigger Handling
    @isTest
    static void testBulkInsertTrigger() {
        Test.setMock(HttpCalloutMock.class, new TmdbHttpCalloutMock());

        List<Movie__c> newMovies = new List<Movie__c>();
        for (Integer i = 0; i < 10; i++) {
            newMovies.add(new Movie__c(TMDB_ID__c = String.valueOf(550 + i)));
        }

        Test.startTest();
        insert newMovies;
        Test.stopTest();

        Integer count = [SELECT COUNT() FROM Movie__c WHERE Title__c != null];
        System.assertEquals(10, count);
    }

    // Test for Settings Disabled - Insert
    @isTest
    static void testAfterInsertTriggerOff() {
        Movie_Settings__c s = Movie_Settings__c.getOrgDefaults();
        s.Load_From_Json__c = true;
        upsert s;

        Movie__c newMovie = new Movie__c(TMDB_ID__c = '550', Title__c = 'Hello');

        Test.startTest();
        insert newMovie;
        Test.stopTest();

        Movie__c insertedMovie = [SELECT Title__c FROM Movie__c WHERE Id = :newMovie.Id];
        System.assertEquals('Hello', insertedMovie.Title__c);
    }

    // Test for Settings Disabled - Update
    @isTest
    static void testAfterUpdateTriggerOff() {
        Movie_Settings__c s = Movie_Settings__c.getOrgDefaults();
        s.Load_From_Json__c = true;
        upsert s;

        Movie__c newMovie = new Movie__c(TMDB_ID__c = '123');
        insert newMovie;

        newMovie.Title__c = 'Hello';
        newMovie.TMDB_ID__c = '550';

        Test.startTest();
        update newMovie;
        Test.stopTest();

        Movie__c updatedMovie = [SELECT Title__c FROM Movie__c WHERE Id = :newMovie.Id];
        System.assertEquals('Hello', updatedMovie.Title__c);
    }
}