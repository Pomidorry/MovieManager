@isTest
public class MovieListControllerTest {
    
    @testSetup
    static void setupTestData() {
        // Create test movie records
        Movie_Settings__c s = Movie_Settings__c.getOrgDefaults();
        s.Load_From_Json__c = true;
        upsert s;
        List<Movie__c> movies = new List<Movie__c>();
        movies.add(new Movie__c(Title__c = 'Action Movie', Genre__c = 'Action', Rating__c = 5));
        movies.add(new Movie__c(Title__c = 'Adventure Movie', Genre__c = 'Adventure', Rating__c = 4));
        movies.add(new Movie__c(Title__c = 'Comedy Movie', Genre__c = 'Comedy', Rating__c = 3));
        movies.add(new Movie__c(Title__c = 'Horror Movie', Genre__c = 'Horror', Rating__c = 2));
        insert movies;
    }
    
    @isTest
    static void testGetAllMovies_NoFilters() {
        // Test with no filters
        List<Movie__c> movies = MovieListController.getAllMovies(0, 10, null, null);
        System.assertEquals(4, movies.size(), 'Expected 4 movies');
    }

    @isTest
    static void testGetAllMovies_WithGenreFilter() {
        // Test filtering by genre
        List<Movie__c> actionMovies = MovieListController.getAllMovies(0, 10, 'Action', null);
        System.assertEquals(1, actionMovies.size(), 'Expected 1 Action movie');
        System.assertEquals('Action Movie', actionMovies[0].Title__c, 'Expected Action Movie title');
    }

    @isTest
    static void testGetAllMovies_WithSearchTerm() {
        // Test filtering by search term
        List<Movie__c> comedyMovies = MovieListController.getAllMovies(0, 10, null, 'Comedy');
        System.assertEquals(1, comedyMovies.size(), 'Expected 1 Comedy movie');
        System.assertEquals('Comedy Movie', comedyMovies[0].Title__c, 'Expected Comedy Movie title');
    }

    @isTest
    static void testGetAllMovies_WithGenreAndSearchTerm() {
        // Test filtering by both genre and search term
        List<Movie__c> adventureMovies = MovieListController.getAllMovies(0, 10, 'Adventure', 'Movie');
        System.assertEquals(1, adventureMovies.size(), 'Expected 1 Adventure movie');
        System.assertEquals('Adventure Movie', adventureMovies[0].Title__c, 'Expected Adventure Movie title');
    }

    @isTest
    static void testGetAllMovies_WithPagination() {
        // Test with pagination (offset and limit)
        List<Movie__c> paginatedMovies = MovieListController.getAllMovies(2, 2, null, null);
        System.assertEquals(2, paginatedMovies.size(), 'Expected 2 movies due to pagination');
    }

    @isTest
    static void testGetGenres() {
        // Test the getGenres method
        List<String> genres = MovieListController.getGenres();
        System.assertEquals(19, genres.size(), 'Expected 19 genres');
        System.assert(genres.contains('Action'), 'Expected genre list to contain Action');
        System.assert(genres.contains('Comedy'), 'Expected genre list to contain Comedy');
    }
}