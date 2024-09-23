@isTest
private class tmdbDetailsResponseTest {
	@isTest 
    static void isEmptyPositiveTest(){
        tmdbDetailsResponse emptyVal = new tmdbDetailsResponse();
        System.assert(emptyVal.isEmpty());
    }
    
    @isTest 
    static void isEmptyNegativeTest(){
        tmdbDetailsResponse notEmptyVal = new tmdbDetailsResponse();
        notEmptyVal.overview = 'overview';
        notEmptyVal.revenue = 10;
        notEmptyVal.poster_path = 'poster_path';

        System.assert(!notEmptyVal.isEmpty());
    }
}