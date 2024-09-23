public with sharing class tmdb {
    private static final String API_KEY = '5bfef77f0d03fea766a8ab7ddfe11ab1';
    private static final String API_KEY_PARAM_NAME = 'api_key';
    private static final String API_VERSION = '3';
	public static tmdbDetailsResponse result;
    private static String authQueryParameter {
        get {
            return API_KEY_PARAM_NAME + '=' + API_KEY;
        }
    }

    private static final String BASE_URL = 'https://api.themoviedb.org/';

    private static string buildResourceUrl(String resourceName) {
        return BASE_URL + API_VERSION + resourceName;
    }

    private static HttpRequest authenticateRequest(HttpRequest request) {
        String endpoint = request.getEndpoint();
        if (endpoint.contains('?')) {
            endpoint += '&' + authQueryParameter;
        } else {
            endpoint += '?' + authQueryParameter;
        }
        request.setEndpoint(endpoint);

        return request;
    }

    public static tmdbGenreListResponse genreList() {
        String resourceName = '/genre/movie/list';
        String endpoint = buildResourceUrl(resourceName);
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(endpoint);
        request = authenticateRequest(request);
        Http http = new Http();
        HttpResponse response = http.send(request);

        tmdbGenreListResponse tmdbResponse = (tmdbGenreListResponse) JSON.deserialize(response.getBody(), tmdbGenreListResponse.class);
        return tmdbResponse;
    }

    public static tmdbSearchMovieResponse searchMovie(String title) {
        String resourceName = '/search/movie';
        String endpoint = buildResourceUrl(resourceName);
        endpoint += '?query=' + EncodingUtil.urlEncode(title, 'UTF-8');
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(endpoint);

        request = authenticateRequest(request);
        Http http = new Http();
        HttpResponse response = http.send(request);
        System.debug(response.getBody());

        tmdbSearchMovieResponse result = (tmdbSearchMovieResponse) JSON.deserialize(response.getBody(), tmdbSearchMovieResponse.class);
        return result;
    }
    public static tmdbDetailsResponse getMovieDetails(String movieId) {
        String resourceName = '/movie/' + EncodingUtil.urlEncode(movieId, 'UTF-8');
        String endpoint = buildResourceUrl(resourceName);
        
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(endpoint);

        request = authenticateRequest(request);
        Http http = new Http();
        HttpResponse response;
       	response = http.send(request);
        
      	tmdbDetailsResponse detailsResponse = (tmdbDetailsResponse) JSON.deserialize(response.getBody(), tmdbDetailsResponse.class);
        return detailsResponse;
    }
    public static baseImageUrl getImageUrl() {
        String resourceName = '/configuration';
        String endpoint = buildResourceUrl(resourceName);
        
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(endpoint);

        request = authenticateRequest(request);
        Http http = new Http();
        HttpResponse response;
       	response = http.send(request);
      	baseImageUrl imageResponse = (baseImageUrl) JSON.deserialize(response.getBody(), baseImageUrl.class);
        return imageResponse;
    }
    public static MovieTrailer getMovieTrailer(String movieId){
        String resourceName = '/movie/' + EncodingUtil.urlEncode(movieId, 'UTF-8') + '/videos';
        String endpoint = buildResourceUrl(resourceName);
        
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(endpoint);

        request = authenticateRequest(request);
        Http http = new Http();
        HttpResponse response;
       	response = http.send(request);
      	MovieTrailer trailerResponse = (MovieTrailer) JSON.deserialize(response.getBody(), MovieTrailer.class);
        return trailerResponse;
    }
    
    public static tmdbCastResponse getMovieCasts(String movieId) {
        String resourceName = '/movie/' + EncodingUtil.urlEncode(movieId, 'UTF-8') + '/credits';
        String endpoint = buildResourceUrl(resourceName);
        
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(endpoint);

        request = authenticateRequest(request);
        Http http = new Http();
        HttpResponse response;
       	response = http.send(request);
        
        String newJson = response.getBody().replaceAll('cast', 'castMember');
      	tmdbCastResponse castResponse = (tmdbCastResponse) JSON.deserialize(newJson, tmdbCastResponse.class);
        return castResponse;
    }
    
    public static tmdbMovieReviewResponse getMovieReviews(String movieId) {
        String resourceName = '/movie/' + EncodingUtil.urlEncode(movieId, 'UTF-8') + '/reviews';
        String endpoint = buildResourceUrl(resourceName);
        
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(endpoint);

        request = authenticateRequest(request);
        Http http = new Http();
        HttpResponse response;
       	response = http.send(request);
        
      	tmdbMovieReviewResponse reviewResponse = (tmdbMovieReviewResponse) JSON.deserialize(response.getBody(), tmdbMovieReviewResponse.class);
        return reviewResponse;
    }
    
}