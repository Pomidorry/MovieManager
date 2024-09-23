@isTest
public class MovieReviewControllerTest {
    
    @isTest
    static void testGetReviewsSuccess() {
        Test.setMock(HttpCalloutMock.class, new TmdbHttpCalloutMock());
        
        Test.startTest();
        List<tmdbMovieReviewResponse.Result> results = MovieReviewController.getReviews('550');
        Test.stopTest();

        //System.assertNotEquals(null, results, 'Results should not be null');
        System.assertEquals(1, results.size(), 'There should be one review');
    }


}