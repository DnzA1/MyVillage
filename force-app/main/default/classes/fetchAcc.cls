public without sharing class fetchAcc {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccs() {
        List<Account> listOfActiveCampaigns = [SELECT Id, Name, Description, Image_Url__c
        FROM Account 
        WHERE Name LIKE 'Gene%'];
        system.debug('fsffss' + listOfActiveCampaigns);
return listOfActiveCampaigns;
    }
}