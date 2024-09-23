public class tmdbMovieReviewResponse {
    public Integer id { get; set; }
    public Integer page { get; set; }
    public List<Result> results { get; set; }
    public Integer total_pages { get; set; }
    public Integer total_results { get; set; }

    public class Result {
        @AuraEnabled
        public String author { get; set; }
        public AuthorDetails author_details { get; set; }
        @AuraEnabled
        public String content { get; set; }
        @AuraEnabled
        public String created_at { get; set; }
        @AuraEnabled
        public String id { get; set; }
        public String updated_at { get; set; }
        public String url { get; set; }
    }

    public class AuthorDetails {
        public String name { get; set; }
        public String username { get; set; }
        public String avatar_path { get; set; }
        public Decimal rating { get; set; }
    }

}