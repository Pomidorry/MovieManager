@IsTest
public class MovieDataSyncSchedulerTest {
    
    @IsTest
    static void testSchedulerExecute() {
        MovieDataSyncScheduler scheduler = new MovieDataSyncScheduler();
        
        Test.startTest();
        String jobId = System.schedule('TestJob', '0 0 0 * * ?', scheduler);
        System.abortJob(jobId);  
        scheduler.execute(null);
        Test.stopTest();
        
        Integer batchJobCount = [SELECT COUNT() FROM AsyncApexJob WHERE JobType='BatchApex' AND Status = 'Completed'];
        System.assertEquals(1, batchJobCount, 'Batch must be completed');
    }
}