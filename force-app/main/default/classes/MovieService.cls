public with sharing class MovieService {

    public static void processAfterInsert(List<Movie__c> newMovies) {
        Map<Id, String> movieIdToTmdbIdMap = collectTmdbIds(newMovies);
        if (!movieIdToTmdbIdMap.isEmpty()) {
            asyncTmdbCallout(movieIdToTmdbIdMap);
        }
    }

    public static void processAfterUpdate(List<Movie__c> updatedMovies, Map<Id, Movie__c> oldMovieMap) {
        Map<Id, String> movieIdToTmdbIdMap = collectTmdbIdsForUpdatedMovies(updatedMovies, oldMovieMap);
        if (!movieIdToTmdbIdMap.isEmpty()) {
            asyncTmdbCallout(movieIdToTmdbIdMap);
        }
    }

    private static Map<Id, String> collectTmdbIds(List<Movie__c> movies) {
        Map<Id, String> movieIdToTmdbIdMap = new Map<Id, String>();
        for (Movie__c movie : movies) {
            if (movie.TMDB_ID__c != null) {
                movieIdToTmdbIdMap.put(movie.Id, movie.TMDB_ID__c);
            }
        }
        return movieIdToTmdbIdMap;
    }

    private static Map<Id, String> collectTmdbIdsForUpdatedMovies(List<Movie__c> updatedMovies, Map<Id, Movie__c> oldMovieMap) {
        Map<Id, String> movieIdToTmdbIdMap = new Map<Id, String>();
        for (Movie__c movie : updatedMovies) {
            if (isTmdbIdChanged(movie, oldMovieMap.get(movie.Id))) {
                movieIdToTmdbIdMap.put(movie.Id, movie.TMDB_ID__c);
            }
        }
        return movieIdToTmdbIdMap;
    }

    private static Boolean isTmdbIdChanged(Movie__c newMovie, Movie__c oldMovie) {
        return newMovie.TMDB_ID__c != oldMovie.TMDB_ID__c && newMovie.TMDB_ID__c != null;
    }

    @future(callout = true)
    private static void asyncTmdbCallout(Map<Id, String> movieIdToTmdbIdMap) {
        Map<Id, tmdbDetailsResponse> movieDetailsMap = fetchTmdbDetails(movieIdToTmdbIdMap);
        Map<Id, List<tmdbCastResponse.CastMember>> movieCastsMap = fetchTmdbCasts(movieIdToTmdbIdMap);
        Map<Id, String> movieTrailerUrlMap = fetchMovieTrailerUrls(movieIdToTmdbIdMap);

        MovieDataProcessor.processMovieData(movieDetailsMap, movieCastsMap, movieTrailerUrlMap);
    }

    private static Map<Id, tmdbDetailsResponse> fetchTmdbDetails(Map<Id, String> movieIdToTmdbIdMap) {
        Map<Id, tmdbDetailsResponse> movieDetailsMap = new Map<Id, tmdbDetailsResponse>();
        for (Id movieId : movieIdToTmdbIdMap.keySet()) {
            String tmdbId = movieIdToTmdbIdMap.get(movieId);
            movieDetailsMap.put(movieId, tmdb.getMovieDetails(tmdbId));
        }
        return movieDetailsMap;
    }

    private static Map<Id, List<tmdbCastResponse.CastMember>> fetchTmdbCasts(Map<Id, String> movieIdToTmdbIdMap) {
        Map<Id, List<tmdbCastResponse.CastMember>> movieCastsMap = new Map<Id, List<tmdbCastResponse.CastMember>>();
        for (Id movieId : movieIdToTmdbIdMap.keySet()) {
            String tmdbId = movieIdToTmdbIdMap.get(movieId);
            movieCastsMap.put(movieId, tmdb.getMovieCasts(tmdbId).castMember);
        }
        return movieCastsMap;
    }

    private static Map<Id, String> fetchMovieTrailerUrls(Map<Id, String> movieIdToTmdbIdMap) {
        Map<Id, String> movieTrailerUrlMap = new Map<Id, String>();
        for (Id movieId : movieIdToTmdbIdMap.keySet()) {
            String tmdbId = movieIdToTmdbIdMap.get(movieId);
            movieTrailerUrlMap.put(movieId, fetchTrailerUrl(tmdbId));
        }
        return movieTrailerUrlMap;
    }

    private static String fetchTrailerUrl(String tmdbId) {
        List<MovieTrailer.Result> trailers = tmdb.getMovieTrailer(tmdbId).results;
        return (!trailers.isEmpty()) ? trailers[0].key : null;
    }
}