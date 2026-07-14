public class AIReplyGenerator {
    @InvocableMethod(label='Generate AI Reply')
    public static List<Response> generateReply(List<Request> requests) {
        List<Response> responses = new List<Response>();
        for(Request req : requests){
            Case c = [SELECT Id, Subject, Description, Warranty_Status__c FROM Case WHERE Id = :req.caseId];
            ConnectApi.EinsteinPromptTemplateGenerationsInput promptInput = new ConnectApi.EinsteinPromptTemplateGenerationsInput();
            promptInput.isPreview = false;
            ConnectApi.EinsteinPromptTemplateGenerationsRepresentation output =
                ConnectApi.EinsteinLLM.generateMessagesForPromptTemplate('Customer_Support_Reply_Generator', promptInput);
            c.AI_Draft_Reply__c = output.generations[0].text;
            update c;
            Response res = new Response(); res.aiReply = c.AI_Draft_Reply__c; responses.add(res);
        }
        return responses;
    }
    public class Request{ @InvocableVariable public Id caseId; }
    public class Response{ @InvocableVariable public String aiReply; }
}