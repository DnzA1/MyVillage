public with sharing class BatchLeadOwnerEmail implements Database.Batchable<sObject>{
    public Id leadId;

    @InvocableMethod
    public static void executeCustomBatch(List<Id> leadsId) {
        System.debug(leadsId);
        Database.executeBatch(new BatchLeadOwnerEmail(leadsId[0]));
    }
    
    public BatchLeadOwnerEmail(Id ldId){
            leadId = ldId;
    }
        
    public Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug(leadId);
        return Database.getQueryLocator([
            SELECT Id, OwnerId, Owner.Email, Name, Status
            FROM Lead
            WHERE Id =: leadId
        ]);
    }

    public void execute(Database.BatchableContext BC, List<Lead> scope) {
        System.debug(scope);
        try {
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            for (Lead lead : scope) {
                // Construct the email message
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new List<String>{ lead.Owner.Email });
                email.setSubject('Lead Contacted Notification');
                email.setPlainTextBody('The lead ' + lead.Name + ' has been contacted today.');
                emails.add(email);
            }
            // Send the emails
            Messaging.sendEmail(emails);
        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }
    }

    public void finish(Database.BatchableContext BC) {
        // Do any post-processing here if needed
    }
}