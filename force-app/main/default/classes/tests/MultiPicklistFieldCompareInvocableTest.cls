@IsTest
public class MultiPicklistFieldCompareInvocableTest {

    @IsTest
    static void testWithCommonValues() {
        MultiPicklistFieldCompareInvocable.Request request = new MultiPicklistFieldCompareInvocable.Request();
        request.picklistA = 'Apple;Banana;Cherry';
        request.picklistB = 'Banana;Cherry;Date';

        List<MultiPicklistFieldCompareInvocable.Request> requests = new List<MultiPicklistFieldCompareInvocable.Request>{ request };

        List<MultiPicklistFieldCompareInvocable.Response> responses = MultiPicklistFieldCompareInvocable.execute(requests);

        System.assertEquals(1, responses.size());

        MultiPicklistFieldCompareInvocable.Response response = responses[0];
        System.assert(response.commonValues != null);
        System.assertEquals(2, response.commonValues.size());
        System.assertEquals(new Set<String>{'Banana', 'Cherry'}, new Set<String>(response.commonValues));

        System.assert(response.uniqueValuesA != null);
        System.assertEquals(1, response.uniqueValuesA.size());
        System.assertEquals('Apple', response.uniqueValuesA[0]);

        System.assert(response.uniqueValuesB != null);
        System.assertEquals(1, response.uniqueValuesB.size());
        System.assertEquals('Date', response.uniqueValuesB[0]);
    }

    @IsTest
    static void testWithNoCommonValues() {
        MultiPicklistFieldCompareInvocable.Request request = new MultiPicklistFieldCompareInvocable.Request();
        request.picklistA = 'Apple;Banana';
        request.picklistB = 'Cherry;Date';

        List<MultiPicklistFieldCompareInvocable.Request> requests = new List<MultiPicklistFieldCompareInvocable.Request>{ request };

        List<MultiPicklistFieldCompareInvocable.Response> responses = MultiPicklistFieldCompareInvocable.execute(requests);

        System.assertEquals(1, responses.size());

        MultiPicklistFieldCompareInvocable.Response response = responses[0];
        System.assert(response.commonValues == null);

        System.assert(response.uniqueValuesA != null);
        System.assertEquals(2, response.uniqueValuesA.size());
        System.assertEquals(new Set<String>{'Apple', 'Banana'}, new Set<String>(response.uniqueValuesA));

        System.assert(response.uniqueValuesB != null);
        System.assertEquals(2, response.uniqueValuesB.size());
        System.assertEquals(new Set<String>{'Cherry', 'Date'}, new Set<String>(response.uniqueValuesB));
    }

    @IsTest
    static void testWithAllCommonValues() {
        MultiPicklistFieldCompareInvocable.Request request = new MultiPicklistFieldCompareInvocable.Request();
        request.picklistA = 'Apple;Banana;Cherry';
        request.picklistB = 'Cherry;Banana;Apple';

        List<MultiPicklistFieldCompareInvocable.Request> requests = new List<MultiPicklistFieldCompareInvocable.Request>{ request };

        List<MultiPicklistFieldCompareInvocable.Response> responses = MultiPicklistFieldCompareInvocable.execute(requests);

        System.assertEquals(1, responses.size());

        MultiPicklistFieldCompareInvocable.Response response = responses[0];
        System.assert(response.commonValues != null);
        System.assertEquals(3, response.commonValues.size());
        System.assertEquals(new Set<String>{'Apple', 'Banana', 'Cherry'}, new Set<String>(response.commonValues));

        System.assert(response.uniqueValuesA == null);
        System.assert(response.uniqueValuesB == null);
    }

    @IsTest
    static void testWithEmptyPicklists() {
        MultiPicklistFieldCompareInvocable.Request request = new MultiPicklistFieldCompareInvocable.Request();
        request.picklistA = '';
        request.picklistB = '';

        List<MultiPicklistFieldCompareInvocable.Request> requests = new List<MultiPicklistFieldCompareInvocable.Request>{ request };

        List<MultiPicklistFieldCompareInvocable.Response> responses = MultiPicklistFieldCompareInvocable.execute(requests);

        System.assertEquals(1, responses.size());

        MultiPicklistFieldCompareInvocable.Response response = responses[0];
        System.assert(response.commonValues == null);
        System.assert(response.uniqueValuesA == null);
        System.assert(response.uniqueValuesB == null);
    }

    @IsTest
    static void testWithNullPicklists() {
        MultiPicklistFieldCompareInvocable.Request request = new MultiPicklistFieldCompareInvocable.Request();
        request.picklistA = null;
        request.picklistB = null;

        List<MultiPicklistFieldCompareInvocable.Request> requests = new List<MultiPicklistFieldCompareInvocable.Request>{ request };

        List<MultiPicklistFieldCompareInvocable.Response> responses = MultiPicklistFieldCompareInvocable.execute(requests);

        System.assertEquals(1, responses.size());

        MultiPicklistFieldCompareInvocable.Response response = responses[0];
        System.assert(response.commonValues == null);
        System.assert(response.uniqueValuesA == null);
        System.assert(response.uniqueValuesB == null);
    }
}