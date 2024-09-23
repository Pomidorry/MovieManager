public class FullJsonProcessor {
    private static List<MovieWrapper> movieData;

    public static void processMoviesJson(String jsonBody) {
        loadMovieData(jsonBody, true);
        createAndInsertMovies();
    }

    public static void processMoviesStaticResource(String staticResource) {
        loadMovieData(staticResource, false);
        createAndInsertMovies();
    }

    private static void loadMovieData(String source, Boolean isJson) {
        if (isJson) {
        	movieData = JsonHandler.parseJsonArrayContentViaString(source);
        } else {
            movieData = JsonHandler.parseJsonArrayContentViaStaticResourse(source); 
        }
    }

    private static void createAndInsertMovies() {
        Map<String, Script__c> existingScripts = ScriptJsonDataProcessor.getExistingScripts(movieData);
        List<Script__c> newScripts = ScriptJsonDataProcessor.createNewScripts(movieData, existingScripts);
        Map<String, Script__c> allScripts = ScriptJsonDataProcessor.mergeScriptMaps(existingScripts, newScripts);

        List<Movie__c> newMovies = MovieJsonDataProcessor.buildNewMovies(movieData, allScripts);

        if (!newMovies.isEmpty()) {
            insert newMovies;
        }
    }
}