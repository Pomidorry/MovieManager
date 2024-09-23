@IsTest
public class ScriptJsonDataProcessorTest {

    @TestSetup
    static void setup() {
        Script__c script1 = new Script__c(LegacyId__c = '1', Title__c = 'Script 1');
        Script__c script2 = new Script__c(LegacyId__c = '2', Title__c = 'Script 2');
        insert new List<Script__c>{script1, script2};
    }

    @IsTest
    static void testGetExistingScripts() {
        MovieWrapper movie1 = new MovieWrapper();
        MovieWrapper.ScriptWrapper script1 = new MovieWrapper.ScriptWrapper();
        script1.id = '1';
        script1.name = 'Script 1';
        movie1.script = script1;
        
        MovieWrapper movie3 = new MovieWrapper();
        MovieWrapper.ScriptWrapper script3 = new MovieWrapper.ScriptWrapper();
        script3.id = '3';
        script3.name = 'Script 3';
        movie3.script = script3;
        List<MovieWrapper> movieData = new List<MovieWrapper>{movie1,movie3};

        Map<String, Script__c> existingScripts = ScriptJsonDataProcessor.getExistingScripts(movieData);

        System.assertEquals(1, existingScripts.size());
        System.assert(existingScripts.containsKey('1'));
        System.assert(!existingScripts.containsKey('3'));
    }

    @IsTest
    static void testCreateNewScripts() {
        MovieWrapper movie3 = new MovieWrapper();
        MovieWrapper.ScriptWrapper script3 = new MovieWrapper.ScriptWrapper();
        script3.id = '3';
        script3.name = 'Script 3';
        movie3.script = script3;
        
        MovieWrapper movie4 = new MovieWrapper();
        MovieWrapper.ScriptWrapper script4 = new MovieWrapper.ScriptWrapper();
        script4.id = '4';
        script4.name = 'Script 4';
        movie4.script = script4;
        
        List<MovieWrapper> movieData = new List<MovieWrapper>{movie3, movie4};

        Map<String, Script__c> existingScripts = ScriptJsonDataProcessor.getExistingScripts(new List<MovieWrapper>());
        List<Script__c> newScripts = ScriptJsonDataProcessor.createNewScripts(movieData, existingScripts);

        System.assertEquals(2, newScripts.size());
        System.assertEquals('Script 3', newScripts[0].Title__c);
        System.assertEquals('Script 4', newScripts[1].Title__c);
   
        List<Script__c> insertedScripts = [SELECT Id, Title__c, LegacyId__c FROM Script__c WHERE LegacyId__c IN ('3', '4')];
        System.assertEquals(2, insertedScripts.size());
    }

    @IsTest
    static void testMergeScriptMaps() {
        Map<String, Script__c> existingScripts = new Map<String, Script__c>{
            '1' => [SELECT Id, LegacyId__c, Title__c FROM Script__c WHERE LegacyId__c = '1' LIMIT 1]
        };

        List<Script__c> newScripts = new List<Script__c>{
            new Script__c(LegacyId__c = '2', Title__c = 'Script 2'),
            new Script__c(LegacyId__c = '3', Title__c = 'Script 3')
        };

        Map<String, Script__c> mergedScripts = ScriptJsonDataProcessor.mergeScriptMaps(existingScripts, newScripts);

        System.assertEquals(3, mergedScripts.size());
        System.assert(mergedScripts.containsKey('1'));
        System.assert(mergedScripts.containsKey('2'));
        System.assert(mergedScripts.containsKey('3'));
    }

    @IsTest
    static void testNoDuplicateScriptsCreated() {
        MovieWrapper movie1 = new MovieWrapper();
        MovieWrapper.ScriptWrapper script1 = new MovieWrapper.ScriptWrapper();
        script1.id = '1';
        script1.name = 'Script 1';
        movie1.script = script1;
        
        MovieWrapper movie2 = new MovieWrapper();
        MovieWrapper.ScriptWrapper script2 = new MovieWrapper.ScriptWrapper();
        script2.id = '2';
        script2.name = 'Script 2';
        movie2.script = script2;
        
        MovieWrapper movie5 = new MovieWrapper();
        MovieWrapper.ScriptWrapper script5 = new MovieWrapper.ScriptWrapper();
        script5.id = '5';
        script5.name = 'Script 5';
        movie5.script = script5;
        
        List<MovieWrapper> movieData = new List<MovieWrapper>{movie1, movie2, movie5};

        Map<String, Script__c> existingScripts = ScriptJsonDataProcessor.getExistingScripts(movieData);

        List<Script__c> newScripts = ScriptJsonDataProcessor.createNewScripts(movieData, existingScripts);
		System.debug(newScripts+' '+newScripts.size());

        System.assertEquals(1, newScripts.size());
        System.assertEquals('Script 5', newScripts[0].Title__c);
    }
}