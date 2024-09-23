public class MovieDataSyncScheduler implements Schedulable {
    public void execute(SchedulableContext context) {
        MovieSyncBatch batch = new MovieSyncBatch();
        Database.executeBatch(batch, 100); 
    }
}