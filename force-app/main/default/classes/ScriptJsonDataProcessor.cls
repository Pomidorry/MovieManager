public class ScriptJsonDataProcessor {
    public static Map<String, Script__c> getExistingScripts(List<MovieWrapper> movieData) {
        Set<String> legacyIds = new Set<String>();
        for (MovieWrapper mv : movieData) {
            legacyIds.add(mv.script.id);
        }

        List<Script__c> existingScripts = [
        SELECT Id, LegacyId__c 
        FROM Script__c 
        WHERE LegacyId__c IN :legacyIds
    ];

        Map<String, Script__c> scriptMap = new Map<String, Script__c>();
        for (Script__c script : existingScripts) {
            scriptMap.put(script.LegacyId__c, script);
        }
    
        return scriptMap;
    }

    public static List<Script__c> createNewScripts(List<MovieWrapper> movieData, Map<String, Script__c> existingScripts) {
        List<Script__c> newScripts = new List<Script__c>();

        for (MovieWrapper mv : movieData) {
            if (!existingScripts.containsKey(mv.script.id)) {
                newScripts.add(new Script__c(
                    Title__c = mv.script.name,
                    LegacyId__c = mv.script.id
                ));
            }
        }

        if (!newScripts.isEmpty()) {
            insert newScripts;
        }

        return newScripts;
    }

    public static Map<String, Script__c> mergeScriptMaps(Map<String, Script__c> existingScripts, List<Script__c> newScripts) {
        Map<String, Script__c> scriptMap = new Map<String, Script__c>(existingScripts);
        for (Script__c script : newScripts) {
            scriptMap.put(script.LegacyId__c, script);
        }
        return scriptMap;
    }
}