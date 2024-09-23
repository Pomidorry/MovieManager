public with sharing class MovieReviewController {
    @AuraEnabled(cacheable=true)
    public static List<tmdbMovieReviewResponse.Result> getReviews(String movieId){
        tmdbMovieReviewResponse review = tmdb.getMovieReviews(movieId);
        List<tmdbMovieReviewResponse.Result> results = review.results;
        return results;
    }
}