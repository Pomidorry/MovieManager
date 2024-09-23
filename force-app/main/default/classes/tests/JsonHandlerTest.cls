@IsTest
private class JsonHandlerTest {

    @IsTest
    static void testParseJsonArrayContentWithEmptyJsonString() {        
        String jsonContent = '[]';
        List<MovieWrapper> movies = JsonHandler.parseJsonArrayContentViaString(jsonContent);
        System.assertEquals(0, movies.size(), 'List must be empty');
    }

    @IsTest
    static void testParseJsonArrayContentWithInvalidJsonString() {
        String invalidJsonContent = '[{id:1, name:"Inception"}'; 
        try {
            JsonHandler.parseJsonArrayContentViaString(invalidJsonContent);
            System.assert(false, 'Expected JsonParseException to be thrown');
        } catch (JsonHandler.JsonParseException e) {
            System.assertEquals('Failed to parse JSON', e.getMessage(), 'Expected JsonParseException message did not match');
        }
    }

    @IsTest
    static void testParseJsonArrayContentWithEmptyJson() {
        String emptyJsonContent = '';
        try {
            JsonHandler.parseJsonArrayContentViaString(emptyJsonContent);
            System.assert(false, 'Expected JsonParseException to be thrown');
        } catch (JsonHandler.JsonParseException e) {
            System.assertEquals('JSON content is empty or null', e.getMessage(), 'Expected JsonParseException message did not match');
        }
    }

    @IsTest
    static void testParseJsonArrayContentWithNullJson() {
        String nullJsonContent = null;
        try {
            JsonHandler.parseJsonArrayContentViaString(nullJsonContent);
            System.assert(false, 'Expected JsonParseException to be thrown');
        } catch (JsonHandler.JsonParseException e) {
            System.assertEquals('JSON content is empty or null', e.getMessage(), 'Expected JsonParseException message did not match');
        }
    }

    @IsTest
    static void testParseJsonArrayContentWithMissingStaticResource() {
        String missingResourceName = 'NonExistentResource';
        try {
            JsonHandler.parseJsonArrayContentViaStaticResourse(missingResourceName);
            System.assert(false, 'Expected ResourceAccessException to be thrown');
        } catch (JsonHandler.ResourceAccessException e) {
            System.assertEquals('Error retrieving or parsing static resource', e.getMessage(), 'Expected ResourceAccessException message did not match');
        }
    }

    @IsTest
    static void testParseJsonArrayContentWithStaticResource() {
        String staticResourceName = 'MovieJson';        
        Test.startTest();
        List<MovieWrapper> movies = JsonHandler.parseJsonArrayContentViaStaticResourse(staticResourceName);
        Test.stopTest();
       
        System.assertNotEquals(null, movies, 'List mustn\'t be null');
        System.assertEquals(2, movies.size(), 'List size must be 2');
    }
    
    @IsTest
    static void testParseJsonArrayContentWithInvalidResource() {
        String nonExistentResourceName = '[jsdkfkj';
    	try {
            JsonHandler.parseJsonArrayContentViaStaticResourse(nonExistentResourceName);
            System.assert(false, 'Must throw ResourceAccessException');
        } catch (JsonHandler.ResourceAccessException e) {
            System.assertEquals('Error retrieving or parsing static resource', e.getMessage());
        }
    }
    
    @IsTest
    static void testParseJsonArrayContentWithJsonString() {
        
        String jsonContent = '[{' +
            '"id": "1", "name": "Inception", "tmdb_id": "1001", "genre": "Sci-Fi", "rating": 8.8, "budget": 160000000, "revenue": 829895144, "release_date": "2010-07-16", "status": "Released", ' +
            '"script": {"id": "101", "name": "Nolan", "description": "Written by Christopher Nolan"}}, ' +
            '{"id": "2", "name": "The Matrix", "tmdb_id": "1002", "genre": "Action", "rating": 8.7, "budget": 63000000, "revenue": 463517727, "release_date": "1999-03-31", "status": "Released", ' +
            '"script": {"id": "102", "name": "Wachowskis", "description": "Written by the Wachowskis"}}]';

        List<MovieWrapper> movies = JsonHandler.parseJsonArrayContentViaString(jsonContent);

        System.assertNotEquals(null, movies, 'List mustn\'t be null');
        System.assertEquals(2, movies.size(), 'List size must be 2');
        
        MovieWrapper firstMovie = movies[0];
        System.assertEquals('1', firstMovie.id, 'The id of the first movie should be 1.');
        
        MovieWrapper.ScriptWrapper firstScript = firstMovie.script;
        System.assertEquals('101', firstScript.id, 'The id of the first movie\'s script should be 101.');

        MovieWrapper secondMovie = movies[1];
        System.assertEquals('2', secondMovie.id, 'The id of the second movie should be 2.');
       
        MovieWrapper.ScriptWrapper secondScript = secondMovie.script;
        System.assertEquals('102', secondScript.id, 'The id of the second movie\'s script should be 102.');
    }
}