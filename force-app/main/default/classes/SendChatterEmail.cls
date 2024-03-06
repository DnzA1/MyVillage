public with sharing class SendChatterEmail {
    @InvocableMethod (label = 'Send Chatter Email' 
                      description = 'Sens Email for Chatter' 
                      category = 'Chatter Email')
    public static void sendEmailtoContacts(List<campaignInfos> emailInfos){

        Id postId = emailInfos[0].posId;
        Id csId = emailInfos[0].caseId;
        Set<Id> setUsrId = new Set<Id>();
        String communityId = null;
        List<String> lstEmail = new List<String>();
    

        Case parentCase = [SELECT Id, AccountId, Account.Name, Subject FROM Case WHERE Id=:csId LIMIT 1];

        ConnectApi.FeedElement feedItem = ConnectApi.ChatterFeeds.getFeedElement(communityId, postId);
        
        List < ConnectApi.MessageSegment > messageSegments = feedItem.body.messageSegments;
        for ( ConnectApi.MessageSegment messageSegment : messageSegments ) {
            if (messageSegment instanceof ConnectApi.MentionSegment) {
                ConnectApi.MentionSegment mentionSegment = ( ConnectApi.MentionSegment ) messageSegment;
                setUsrId.add(mentionSegment.record.Id);
            }
        }
        
        List<User> userEmails = [SELECT Id, Email FROM User WHERE Id IN: setUsrId];
        for (User usr : userEmails) {
            lstEmail.add(usr.Email);
        }

        String recordPageLink = '<a href="'+ URL.getOrgDomainURL().toExternalForm()+'/'+csId+'">Case Record Page Detail</a><br/>';
        String commentLink = '<a href="'+ URL.getOrgDomainURL().toExternalForm()+'/'+postId+'">Post Comment</a><br/>Thank you';

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setSubject('Chatter Post Email Notification');
        email.setHtmlBody('You Have a new Chatter Post on the Case record, <br/> Case Subject : '+ parentCase.Subject+ '<br/> Case Account Name: '+ parentCase.Account.Name+'<br/> Click below link to see record details <br/>'+recordPageLink + 'Or You can click below link to create comment on the post <br/>'+commentLink);
        email.SetToaddresses(lstEmail);
        try {
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
        } catch (Exception ex) {
            system.debug(ex.getMessage());
        }

    }

    public class campaignInfos{
        @InvocableVariable(label = 'caseId' Description = 'caseId' required = true)
        public Id caseId;
        @InvocableVariable(label = 'posId' Description = 'posId' required = true)
        public Id posId;
    }
}


////////////////////////
// public with sharing class SendChatterEmail {
//     @InvocableMethod (label = 'Send Chatter Email' 
//                       description = 'Sens Email for Chatter' 
//                       category = 'Chatter Email')
//     public static void sendEmailtoContacts(List<campaignInfos> emailInfos){

//         Id postId = emailInfos[0].posId;
//         Id csId = emailInfos[0].caseId;
//         Set<Id> setUsrId = new Set<Id>();
//         String communityId = null;
//         List<String> lstEmail = new List<String>();

//         // FeedItem objFI = [SELECT Id, ParentId, Body FROM FeedItem where Id =: postId LIMIT 1];
//         // System.debug(objFI);
    
//         // ConnectApi.FeedElement feedItem = ConnectApi.ChatterFeeds.getFeedElement(communityId, objFI.Id);

//         Case parentCase = [SELECT Id, AccountId, Account.Name, Subject FROM Case WHERE Id=:csId LIMIT 1];

//         ConnectApi.FeedElement feedItem = ConnectApi.ChatterFeeds.getFeedElement(communityId, postId);
        
//         List < ConnectApi.MessageSegment > messageSegments = feedItem.body.messageSegments;
//         for ( ConnectApi.MessageSegment messageSegment : messageSegments ) {
//             if (messageSegment instanceof ConnectApi.MentionSegment) {
//                 ConnectApi.MentionSegment mentionSegment = ( ConnectApi.MentionSegment ) messageSegment;
//                 setUsrId.add(mentionSegment.record.Id);
//             }
//         }
//         List<User> userEmails = [SELECT Id, Email FROM User WHERE Id IN: setUsrId];
//         for (User usr : userEmails) {
//             lstEmail.add(usr.Email);
//         }

//         String recordPageLink = '<a href="'+ URL.getOrgDomainURL().toExternalForm()+'/'+csId+'">Case Record Page Detail</a><br/>';
//         String commentLink = '<a href="'+ URL.getOrgDomainURL().toExternalForm()+'/'+postId+'">Click to poct comment</a><br/>Thank you';

//         Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
//         email.setSubject('Chatter Post Email Notification');
//         email.setHtmlBody('You Have a new Chatter Post on the Case record, <br/> Case Subject : '+ parentCase.Subject+ '<br/> Case Account Name: '+ parentCase.Account.Name+'<br/> Click below link to see record details <br/>'+recordPageLink + 'Or You can click below link to create comment on the post <br/>'+commentLink);
//         // email.setHtmlBody('You Have a new Chatter Post on the Case record, <br/> Click below link to see record details <br/>'+recordPageLink+'<br/> Case Subject : '+ parentCase.Subject+ '<br/> Case Account Name: '+ parentCase.Account.Name);
//         email.SetToaddresses(lstEmail);
//         try {
//             Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
//         } catch (Exception ex) {
//             system.debug(ex.getMessage());
//         }

//     }

//     public class campaignInfos{
//         @InvocableVariable(label = 'caseId' Description = 'caseId' required = true)
//         public Id caseId;
//         @InvocableVariable(label = 'posId' Description = 'posId' required = true)
//         public Id posId;
//     }
// }