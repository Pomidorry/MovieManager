public with sharing class ActorDataProcessor {

    public static void processActors(Map<Id, List<tmdbCastResponse.CastMember>> movieCastsMap) {
        Map<String, Contact> actorMap = buildActors(movieCastsMap);
        if (!actorMap.isEmpty()) {
            insertActors(actorMap);
        }
    }

    public static Map<String, Contact> buildActors(Map<Id, List<tmdbCastResponse.CastMember>> movieCastsMap) {
        Map<String, Contact> actorMap = new Map<String, Contact>();
        Id recordTypeId = getActorRecordTypeId();

        List<Contact> existingActors = [SELECT Id, LastName FROM Contact WHERE RecordTypeId = :recordTypeId];
        for (Contact actor : existingActors) {
            actorMap.put(actor.LastName, actor);
        }

        for (List<tmdbCastResponse.CastMember> casts : movieCastsMap.values()) {
            for (tmdbCastResponse.CastMember castMember : casts) {
                if (!actorMap.containsKey(castMember.name)) {
                    actorMap.put(castMember.name, createActor(castMember.name, recordTypeId));
                }
            }
        }

        return actorMap;
    }

    private static Contact createActor(String name, Id recordTypeId) {
        return new Contact(
            RecordTypeId = recordTypeId,
            LastName = name,
            Role__c = 'Actor'
        );
    }

    private static void insertActors(Map<String, Contact> actorMap) {
        List<Contact> newActors = new List<Contact>();
        for (Contact actor : actorMap.values()) {
            if (actor.Id == null) {
                newActors.add(actor);
            }
        }
        if (!newActors.isEmpty()) {
            insert newActors;
        }
    }

    private static Id getActorRecordTypeId() {
        return [SELECT Id FROM RecordType WHERE Name = 'Actor' AND SObjectType = 'Contact' LIMIT 1].Id;
    }
}