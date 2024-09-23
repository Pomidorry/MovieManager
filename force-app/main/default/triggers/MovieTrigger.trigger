trigger MovieTrigger on Movie__c (after insert, after update) {
    if(!TriggerControl.getMovieSettings()){
     	new MovieTriggerHandler().handle();   
    }
}