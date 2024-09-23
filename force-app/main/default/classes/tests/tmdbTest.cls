@IsTest
private class tmdbTest {
    @IsTest
    static void testGenreList() {
        Test.setMock(HttpCalloutMock.class, new TmdbHttpCalloutMock());
        tmdbGenreListResponse response = tmdb.genreList();
        
        System.assertNotEquals(null, response);
        System.assertEquals(2, response.genres.size());
        System.assertEquals('Action', response.genres[0].name);
    }
    
    @IsTest
    static void testSearchMovie() {
        Test.setMock(HttpCalloutMock.class, new TmdbHttpCalloutMock());
        tmdbSearchMovieResponse response = tmdb.searchMovie('Fight Club');
        
        System.assertNotEquals(null, response);
        System.assertEquals(1, response.results.size());
        System.assertEquals('Fight Club', response.results[0].title);
    }
    
    @IsTest
    static void testGetMovieDetails() {
        Test.setMock(HttpCalloutMock.class, new TmdbHttpCalloutMock());
        tmdbDetailsResponse response = tmdb.getMovieDetails('552');
        
        System.assertNotEquals(null, response);
        System.assertEquals('Fight Club', response.original_title);
        System.assertEquals(8.8, response.vote_average);
        System.assertEquals(63000000, response.budget);
        System.assertEquals(100000000, response.revenue);
        System.assertEquals('/bptfVGEQuv6vDTIMVCHjJ9Dz8PX.jpg', response.poster_path);
        System.assertEquals('Drama', response.genres[0].name);
    }
    
    @IsTest
    static void testGetImageUrl() {
        Test.setMock(HttpCalloutMock.class, new TmdbHttpCalloutMock());
        baseImageUrl response = tmdb.getImageUrl();
        
        System.assertNotEquals(null, response);
        System.assertEquals('http://image.tmdb.org/t/p/', response.images.base_url);
    }
    
    @IsTest
    static void testGetMovieTrailer() {
        Test.setMock(HttpCalloutMock.class, new TmdbHttpCalloutMock());
        MovieTrailer response = tmdb.getMovieTrailer('551');
        
        System.assertNotEquals(null, response);
        System.assertEquals(1, response.results.size());
        System.assertEquals('SUXWAEX2jlg', response.results[0].key);
    }

    @IsTest
    static void testGetMovieReviews() {
        Test.setMock(HttpCalloutMock.class, new TmdbHttpCalloutMock());
   
        tmdbMovieReviewResponse response = tmdb.getMovieReviews('550');
 
        System.assertNotEquals(null, response, 'Response is null in testGetMovieReviews');

        System.assertEquals(550, response.id, 'Expected movie ID does not match');
        System.assertEquals(1, response.page, 'Expected page number does not match');
        System.assertEquals(1, response.total_pages, 'Expected total pages does not match');
        System.assertEquals(1, response.total_results, 'Expected total results does not match');

        System.assertNotEquals(null, response.results, 'Results list should not be null');
        System.assertEquals(1, response.results.size(), 'Expected one result in the list');

        tmdbMovieReviewResponse.Result firstResult = response.results[0];

        System.assertEquals('John Doe', firstResult.author, 'Author name does not match');
        System.assertEquals('Great movie! Loved the plot twists.', firstResult.content, 'Content does not match');
        System.assertEquals('2023-01-01T00:00:00Z', firstResult.created_at, 'Created_at does not match');
        System.assertEquals('12345', firstResult.id, 'Review ID does not match');
        System.assertEquals('2023-01-01T00:00:00Z', firstResult.updated_at, 'Updated_at does not match');
        System.assertEquals('https://www.example.com/review/12345', firstResult.url, 'URL does not match');

        tmdbMovieReviewResponse.AuthorDetails authorDetails = firstResult.author_details;
        System.assertNotEquals(null, authorDetails, 'AuthorDetails should not be null');
        System.assertEquals('John Doe', authorDetails.name, 'Author name does not match');
        System.assertEquals('johndoe', authorDetails.username, 'Username does not match');
        System.assertEquals('/path/to/avatar.jpg', authorDetails.avatar_path, 'Avatar path does not match');
        System.assertEquals(8.5, authorDetails.rating, 'Rating does not match');
    }

    @IsTest
    static void testGetMovieCasts() {
        Test.setMock(HttpCalloutMock.class, new TmdbHttpCalloutMock());
        tmdbCastResponse response = tmdb.getMovieCasts('550');
        System.assertNotEquals(null, response);
    
        System.assertEquals(2, response.castMember.size());
		System.assertEquals(550, response.id);
        System.assertEquals('Edward Norton', response.castMember[0].name);
        System.assertEquals('Acting', response.castMember[0].known_for_department);
        System.assertEquals('The Narrator', response.castMember[0].character);
    }
}