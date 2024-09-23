public with sharing class tmdbDetailsResponse {
    public String overview;
    public String original_title;
    public Decimal revenue;
    public Decimal vote_average;
    public String poster_path;
    public Decimal budget;
    @AuraEnabled
    public List<Genre> genres;
    public class Genre {
        public Integer id;
        public String name;
    }
    public Boolean isEmpty() {
        return String.isEmpty(overview) &&
               String.isEmpty(original_title) &&
               revenue == null &&
               vote_average == null &&
               String.isEmpty(poster_path) &&
               budget == null;
    }
}