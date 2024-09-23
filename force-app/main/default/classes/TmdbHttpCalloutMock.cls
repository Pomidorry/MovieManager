public class TmdbHttpCalloutMock implements HttpCalloutMock {

    private static final String GENRE_LIST_RESPONSE = '{"genres":[{"id":28,"name":"Action"},{"id":12,"name":"Adventure"}]}';
    private static final String SEARCH_MOVIE_RESPONSE = '{"results":[{"id":550,"title":"Fight Club","overview":"A description."}]}';
    private static final String MOVIE_DETAILS_RESPONSE = '{"overview":"A description.","original_title":"Fight Club","revenue":100000000,"vote_average":8.8,"poster_path":"/bptfVGEQuv6vDTIMVCHjJ9Dz8PX.jpg","budget":63000000,"genres":[{"id":18,"name":"Drama"}]}';
    private static final String CONFIGURATION_RESPONSE = '{"images":{"base_url":"http://image.tmdb.org/t/p/", "secure_base_url": "https://image.tmdb.org/t/p/"}}';
    private static final String VIDEOS_RESPONSE = '{"results":[{"key":"SUXWAEX2jlg"}]}';
    private static final String REVIEWS_RESPONSE = '{"id":550,"page":1,"results":[{"author":"John Doe","author_details":{"name":"John Doe","username":"johndoe","avatar_path":"/path/to/avatar.jpg","rating":8.5},"content":"Great movie! Loved the plot twists.","created_at":"2023-01-01T00:00:00Z","id":"12345","updated_at":"2023-01-01T00:00:00Z","url":"https://www.example.com/review/12345"}],"total_pages":1,"total_results":1}';
    private static final String CAST_RESPONSE = '{"id":550,"cast":[{"known_for_department":"Acting","name":"Edward Norton","character":"The Narrator"},{"known_for_department":"Acting","name":"Brad Pitt","character":"Tyler Durden"}]}';



    public HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        String endpoint = req.getEndpoint();

        res.setStatusCode(200); // Default to success code

        if (isGenreListRequest(endpoint)) {
            res.setBody(GENRE_LIST_RESPONSE);
        } else if (isSearchMovieRequest(endpoint)) {
            res.setBody(SEARCH_MOVIE_RESPONSE);
        } else if (isMovieDetailsRequest(endpoint)) {
            res.setBody(MOVIE_DETAILS_RESPONSE);
        } else if (isConfigurationRequest(endpoint)) {
            res.setBody(CONFIGURATION_RESPONSE);
        } else if (isVideosRequest(endpoint)) {
            res.setBody(VIDEOS_RESPONSE);
        } else if (isReviewsRequest(endpoint)) { 
            res.setBody(REVIEWS_RESPONSE);
        } else if (isCastRequest(endpoint)) {
            System.debug('Returning mock cast response: ' + CAST_RESPONSE);
            res.setBody(CAST_RESPONSE);
        }else {
            System.debug('Unknown endpoint: ' + endpoint);
        }

        return res;
    }

    private Boolean isGenreListRequest(String endpoint) {
        return endpoint.contains('/genre/movie/list');
    }

    private Boolean isSearchMovieRequest(String endpoint) {
        return endpoint.contains('/search/movie');
    }

    private Boolean isMovieDetailsRequest(String endpoint) {
        return endpoint.contains('/movie/') && !endpoint.contains('/videos') && !endpoint.contains('/reviews') && !endpoint.contains('/credits');
    }

    private Boolean isConfigurationRequest(String endpoint) {
        return endpoint.contains('/configuration');
    }

    private Boolean isVideosRequest(String endpoint) {
        return endpoint.contains('/videos');
    }

    private Boolean isReviewsRequest(String endpoint) {
        return endpoint.contains('/reviews');
    }
    private Boolean isCastRequest(String endpoint) {
        return endpoint.contains('/credits');
    }
}