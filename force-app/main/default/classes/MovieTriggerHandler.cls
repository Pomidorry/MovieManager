public class MovieTriggerHandler extends AbstractTriggerHandler {
    private List<Movie__c> newMovies = Trigger.new;
    private Map<Id, Movie__c> oldMovieMap = (Map<Id, Movie__c>) Trigger.oldMap;

    public override void doAfterInsert() {
        MovieService.processAfterInsert(newMovies);
    }
    
    public override void doAfterUpdate() {
        MovieService.processAfterUpdate(newMovies, oldMovieMap);
    }
}