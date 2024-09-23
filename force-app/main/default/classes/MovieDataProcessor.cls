public with sharing class MovieDataProcessor {

    public static void processMovieData(Map<Id, tmdbDetailsResponse> movieDetailsMap, Map<Id, List<tmdbCastResponse.CastMember>> movieCastsMap, Map<Id, String> movieTrailerUrlMap) {
        String imageUrl = tmdb.getImageUrl().images.secure_base_url;
        updateMovies(movieDetailsMap, imageUrl, movieTrailerUrlMap);
        ActorDataProcessor.processActors(movieCastsMap);
        CastDataProcessor.processCasts(movieCastsMap);
    }

    private static void updateMovies(Map<Id, tmdbDetailsResponse> movieDetailsMap, String imageUrl, Map<Id, String> movieTrailerUrlMap) {
        List<Movie__c> moviesToUpdate = new List<Movie__c>();
        for (Id movieId : movieDetailsMap.keySet()) {
            Movie__c movieToUpdate = buildMovieToUpdate(movieId, movieDetailsMap.get(movieId), imageUrl, movieTrailerUrlMap.get(movieId));
            moviesToUpdate.add(movieToUpdate);
        }
        if (!moviesToUpdate.isEmpty()) {
            update moviesToUpdate;
        }
    }

    private static Movie__c buildMovieToUpdate(Id movieId, tmdbDetailsResponse details, String imageUrl, String trailerUrl) {
        return new Movie__c(
            Id = movieId,
            Description__c = details.overview,
            Title__c = details.original_title,
            Revenue__c = details.revenue,
            Rating__c = details.vote_average,
            Genre__c = joinGenres(details.genres),
            Poster_URL__c = imageUrl + 'original' + details.poster_path,
            VideoUrl__c = trailerUrl,
            Budget__c = details.budget,
            TMDBSyncDate__c = System.Today()
        );
    }

    private static String joinGenres(List<tmdbDetailsResponse.Genre> genres) {
        List<String> genreNames = new List<String>();
        for (tmdbDetailsResponse.Genre genre : genres) {
            genreNames.add((genre.name).replace(' ', '_'));
        }
        return String.join(genreNames, ';');
    }
}