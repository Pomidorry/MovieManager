public with sharing class MovieUploaderController {
    @AuraEnabled
    public static void uploadMovieRecords(String jsonBody){
        FullJsonProcessor.processMoviesJson(jsonBody);
        DetailsBatch batch = new DetailsBatch();
        Database.executeBatch(batch, 40); 
    }
}