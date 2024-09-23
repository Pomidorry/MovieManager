public with sharing class tmdbSearchMovieResponse {

    public Integer total_pages;
    public Integer total_results;
    public Integer page;
    @AuraEnabled
    public List<tmdbSearchMovieResult> results;
}