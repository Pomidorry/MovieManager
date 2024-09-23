public class JsonHandler {
    public static List<MovieWrapper> parseJsonArrayContentViaStaticResourse(String staticResourceName) {
        String jsonContent = getJsonFromStaticResource(staticResourceName);
        return parseJsonArrayContent(jsonContent);
    }

    public static List<MovieWrapper> parseJsonArrayContentViaString(String jsonString) {
        return parseJsonArrayContent(jsonString);
    }

    private static List<MovieWrapper> parseJsonArrayContent(String jsonContent) {
        if (String.isBlank(jsonContent)) {
            throw new JsonParseException('JSON content is empty or null');
        }
        
        try {
            return (List<MovieWrapper>) JSON.deserialize(jsonContent, List<MovieWrapper>.class);
        } catch (Exception e) {
            throw new JsonParseException('Failed to parse JSON', e);
        }
    }

    private static String getJsonFromStaticResource(String staticResourceName) {
        try {
            StaticResource staticResource = [SELECT Body FROM StaticResource WHERE Name = :staticResourceName LIMIT 1];
            Blob blobData = staticResource.Body;
            return blobData.toString();
        } catch (Exception e) {
            throw new ResourceAccessException('Error retrieving or parsing static resource', e);
        }
    }

    public class JsonParseException extends Exception {}
    public class ResourceAccessException extends Exception {}
}