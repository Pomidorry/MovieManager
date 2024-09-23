public with sharing class CastDataProcessor {

    public static void processCasts(Map<Id, List<tmdbCastResponse.CastMember>> movieCastsMap) {
        Map<String, Contact> actorMap = ActorDataProcessor.buildActors(movieCastsMap);
        List<Cast__c> castsToInsert = buildCasts(movieCastsMap, actorMap);
        if (!castsToInsert.isEmpty()) {
            insert castsToInsert;
        }
    }

    private static List<Cast__c> buildCasts(Map<Id, List<tmdbCastResponse.CastMember>> movieCastsMap, Map<String, Contact> actorMap) {
        List<Cast__c> castsToInsert = new List<Cast__c>();
        for (Id movieId : movieCastsMap.keySet()) {
            for (tmdbCastResponse.CastMember castMember : movieCastsMap.get(movieId)) {
                Contact actor = actorMap.get(castMember.name);
                if (actor != null) {
                    castsToInsert.add(createCast(movieId, castMember, actor));
                }
            }
        }
        return castsToInsert;
    }

    private static Cast__c createCast(Id movieId, tmdbCastResponse.CastMember castMember, Contact actor) {
        return new Cast__c(
            Movie__c = movieId,
            Character__c = castMember.character,
            Actor__c = actor.Id
        );
    }
}