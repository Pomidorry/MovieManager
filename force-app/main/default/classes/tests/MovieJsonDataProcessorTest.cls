@IsTest
private class MovieJsonDataProcessorTest {
    @IsTest
    static void testBuildNewMovies_EmptyMovieData() {
        List<MovieWrapper> movieData = new List<MovieWrapper>();
        Map<String, Script__c> scriptMap = new Map<String, Script__c>();

        List<Movie__c> result = MovieJsonDataProcessor.buildNewMovies(movieData, scriptMap);
        System.assertEquals(0, result.size(), 'The result should be an empty list when no movie data is provided.');
    }
    
    @IsTest
    static void testBuildNewMovies_NewMovieWithValidGenre() {
        MovieWrapper movie = new MovieWrapper();
        movie.id = '1';
        movie.tmdb_id = 'tmdb_1';
        movie.genre = 'Action';
        movie.name = 'Test Movie';
        movie.rating = 8.5;
        movie.budget = 1000000;
        movie.revenue = 5000000;
        movie.release_date = '10/12/2023';
        
        MovieWrapper.ScriptWrapper script = new MovieWrapper.ScriptWrapper();
        script.id = '1';
        movie.script = script;

        List<MovieWrapper> movieData = new List<MovieWrapper>{movie};
        
        Script__c scriptRecord = new Script__c();
        Map<String, Script__c> scriptMap = new Map<String, Script__c>{
            '1' => scriptRecord
        };

        Test.startTest();
        List<Movie__c> result = MovieJsonDataProcessor.buildNewMovies(movieData, scriptMap);
        Test.stopTest();
 
        System.assertEquals(1, result.size(), 'One new movie should be created.');
        System.assertEquals('Test Movie', result[0].Title__c, 'The movie title should match the input data.');
        System.assertEquals('Action', result[0].Genre__c, 'The genre should match the input data.');
        System.assertEquals(8.5, result[0].Rating__c, 'The rating should match the input data.');
        System.assertEquals(1000000, result[0].Budget__c, 'The budget should match the input data.');
        System.assertEquals(5000000, result[0].Revenue__c, 'The revenue should match the input data.');
        System.assertEquals('2023-12-10', String.valueOf(result[0].ReleaseDate__c), 'The release date should be correctly parsed.');
    }
    
    @IsTest
    static void testBuildNewMovies_NewMovieWithInvalidGenre() {
        MovieWrapper movie = new MovieWrapper();
        movie.id = '1';
        movie.tmdb_id = 'tmdb_1';
        movie.genre = 'Invalid Genre';
        movie.name = 'Test Movie';
        movie.rating = 8.5;
        movie.budget = 1000000;
        movie.revenue = 5000000;
        movie.release_date = '10/12/2023';
		
        MovieWrapper.ScriptWrapper script = new MovieWrapper.ScriptWrapper();
        script.id = '1';
        movie.script = script;
        
        List<MovieWrapper> movieData = new List<MovieWrapper>{movie};

        Map<String, Script__c> scriptMap = new Map<String, Script__c>();

        Test.startTest();
        List<Movie__c> result = MovieJsonDataProcessor.buildNewMovies(movieData, scriptMap);
        Test.stopTest();

        System.assertEquals(0, result.size(), 'No new movie should be created with an invalid genre.');
    }
    
    @IsTest
    static void testBuildNewMovies_ExistingMovieData() {
        Test.setMock(HttpCalloutMock.class, new TmdbHttpCalloutMock());
        MovieWrapper movie = new MovieWrapper();
        movie.id = '1';
        movie.tmdb_id = '550';
        movie.genre = 'Action';
        movie.name = 'Test Movie';
        movie.rating = 8.5;
        movie.budget = 1000000;
        movie.revenue = 5000000;
        movie.release_date = '10/12/2023';
		
        MovieWrapper.ScriptWrapper script = new MovieWrapper.ScriptWrapper();
        script.id = '1';
        movie.script = script;

        List<MovieWrapper> movieData = new List<MovieWrapper>{movie};
		
        Movie__c existingMovie = new Movie__c(TMDB_id__c = '550');
        insert existingMovie;

        Map<String, Script__c> scriptMap = new Map<String, Script__c>();

        Test.startTest();
        List<Movie__c> result = MovieJsonDataProcessor.buildNewMovies(movieData, scriptMap);
        Test.stopTest();

        System.assertEquals(0, result.size(), 'No new movie should be created if the movie already exists.');
    }
}