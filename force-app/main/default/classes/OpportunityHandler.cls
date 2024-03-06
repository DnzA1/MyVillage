public with sharing class OpportunityHandler {
    public static void sendEmailTest(List<Opportunity> Triggernew, List<Opportunity> Triggerold, Map<Id, Opportunity> TriggernewMap,  Map<Id, Opportunity> TriggeroldMap){
        Set<Id> setIds = new Set<Id>();
        Set<Id> setQuoteIds = new Set<Id>();
        Set<Id> setUserId = new Set<Id>();
        List<String> lstEmail = new List<String>();

        for (Opportunity opp : Triggernew) {
            if (opp.StageName == 'Closed Won' && opp.StageName != TriggeroldMap.get(opp.Id).StageName) {
                setIds.add(opp.Id);
                setUserId.add(opp.Project_Manager__c);
            }
        }
        List<Quote> lstQuote = [SELECT Id, Name, OpportunityId, Opportunity.Name FROM Quote WHERE OpportunityId IN: setIds];

        for(Quote qu : lstQuote){
            setQuoteIds.add(qu.Id);
        }
        List<QuoteLineItem> lstQuoteLineItem = [SELECT Id, QuoteId, Product2Id, Product2.Name, OpportunityLineItemId FROM QuoteLineItem 
                                        WHERE QuoteId IN:setQuoteIds 
                                        AND 
                                        (Product2.Name='SLA: Platinum' OR Product2.Name='SLA: Gold')];
        if (!lstQuoteLineItem.isEmpty()) {

            List<User> listUser = [SELECT Id, Email FROM User WHERE ID IN:setUserId];

            for (User usr : listUser) {
                lstEmail.add(usr.Email);
            }   
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject('BIRTHDAY MESSAGE');
            email.setHtmlBody('Hello, <br/><br/>Happy Birthday<br/>');
            email.SetToaddresses(lstEmail);
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
        }
    }
    //Geken
      // US:1551 Aaron Dolapci 02/06/24
      public static void updateOppPriority(List<Opportunity> oppList){
        Set<Id> accIdsList= new Set<Id>();
        
        for(Opportunity eachOpp: oppList){
            accIdsList.add(eachOpp.AccountId);
        }
        Map<Id, Decimal> accountIdsToTotalOppAmount = new Map<Id, Decimal>();
        
        for(AggregateResult aggResult : [SELECT AccountId, SUM(Amount) totalAmount FROM Opportunity WHERE AccountId IN:accIdsList AND IsClosed = false GROUP BY AccountId]){
            accountIdsToTotalOppAmount.put((Id)aggResult.get('AccountId'),(Decimal)aggResult.get('totalAmount'));
        }
        List<Opportunity> oppListToUpdate = new List<Opportunity>();
        for(Opportunity eachOpp: [Select Id,AccountId, Priority__c from Opportunity 
                                  where AccountId IN:accIdsList AND isClosed= False ]){
                                      
                                      if(!accountIdsToTotalOppAmount.isEmpty()){                           
                                          Decimal totalOpenOppAmount=  accountIdsToTotalOppAmount.get(eachOpp.AccountId);
                                          if(totalOpenOppAmount !=null){
                                              if(totalOpenOppAmount>10000) {
                                                  eachOpp.Priority__c= 'High';
                                              }else if(totalOpenOppAmount>5000){
                                                  eachOpp.Priority__c= 'Medium';    
                                              }else{
                                                  eachOpp.Priority__c= 'Low';
                                              }
                                              oppListToUpdate.add(eachOpp);
                                          }   
                                      }                                      
                                  } 
        if(!oppListToUpdate.isEmpty()){
            update oppListToUpdate; 
        }
    }

}
