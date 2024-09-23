public class TriggerControl {
    public static Boolean getMovieSettings()
    {
    	Movie_Settings__c movieSetting  = Movie_Settings__c.getOrgDefaults();
        return movieSetting.Load_From_Json__c;
    }
}