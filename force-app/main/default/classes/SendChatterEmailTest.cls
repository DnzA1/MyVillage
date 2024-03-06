// @isTest(SeeAllData=true)
@isTest(SeeAllData=true)
public with sharing class SendChatterEmailTest {

    @isTest
    public static void sendEmailtoContactsTest(){

        // Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        // User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        // EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        // LocaleSidKey='en_US', ProfileId = p.Id,
        // TimeZoneSidKey='America/Los_Angeles',
        // UserName='deneme123ert46@sf.com');
        // system.runAs(u){
        // Case cs = new Case();
        // cs.Subject = 'Apex Case Test Class';
        // insert cs;
        // // POST
        // ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
        // ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
        // ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();

        // messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

        // // post body
        // String postBody = 'Test Body'+'\n\n';

        // textSegmentInput.text = postBody;
        // messageBodyInput.messageSegments.add(textSegmentInput);
        // feedItemInput.body = messageBodyInput;

        // ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
        // mentionSegmentInput.id = u.Id;
        // messageBodyInput.messageSegments.add(mentionSegmentInput);

        // feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
        // feedItemInput.subjectId = cs.id;
        // ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(null, feedItemInput);  
        // System.debug(feedElement);

        
        Case cs = new Case();
        cs.Subject = 'Apex Case Test Class';
        insert cs;

        FeedItem feed = new FeedItem();
        feed.ParentId = cs.Id;
        feed.Body = '2222 Message which you want to post @My Village';
        insert feed;

        List<SendChatterEmail.campaignInfos> lstCmpInfos = new List<SendChatterEmail.campaignInfos>();  

        SendChatterEmail.campaignInfos cmpInfo = new SendChatterEmail.campaignInfos();
            cmpInfo.caseId = cs.Id;
            cmpInfo.posId = feed.Id;
            lstCmpInfos.add(cmpInfo);

            Test.startTest();
            SendChatterEmail.sendEmailtoContacts(lstCmpInfos);
            Integer numnerOfEmails = Limits.getEmailInvocations();
            Test.stopTest();
    
            System.assertEquals(0, numnerOfEmails);
    

        }


        // @isTest
        // public static void sendMassEmailToDonorsTest() {
    
        //     List<String> listEmail = new List<String>();
    
        //     Campaign cmp = new Campaign();
        //     cmp.Name = 'Test';
        //     cmp.Target_Donation_Amount__c = 100;
        //     cmp.EndDate = Date.today();
        //     insert cmp;
    
        //     Account acc = new Account();
        //     acc.FirstName = 'Test Acc';
        //     acc.LastName = 'Name';
        //     acc.PersonEmail = 'denis.adamm7@gmail.com';
        //     insert acc;
    
        //     listEmail.add(acc.PersonEmail);
    
        //     EmailTemplate temp = [SELECT Id, Name, DeveloperName, IsActive FROM EmailTemplate WHERE DeveloperName = 'Email_About_Campaigns'];
            
        //     List<SendingMassEmail.campaignInfos> lstCmpInfos = new List<SendingMassEmail.campaignInfos>();
    
        //     SendingMassEmail.campaignInfos cmpInfo = new SendingMassEmail.campaignInfos();
        //     cmpInfo.donorEmails = listEmail;
        //     cmpInfo.campaignId = cmp.Id;
        //     lstCmpInfos.add(cmpInfo);
    
        //     Test.startTest();
        //     SendingMassEmail.sendMassEmailToDonors(lstCmpInfos);
        //     Integer numnerOfEmails = Limits.getEmailInvocations();
        //     Test.stopTest();
    
        //     System.AssertEquals(1,cmpInfo.donorEmails.size());
        //     System.assertEquals(1, numnerOfEmails);
        // }



    }


    //////////////////////////////////////////////
    // @isTest
    // public static void sendEmailtoContactsTest(){
    //     Case cs = new Case();
    //     cs.Subject = 'Apex Case';
    //     insert cs;

    //     FeedItem feed = new FeedItem();
    //     feed.ParentId = cs.Id;
    //     feed.Body = '2222 Message which you want to post @My Village';
    //     insert feed;

    //     Test.startTest();
    //     Integer numnerOfEmails = Limits.getEmailInvocations();
    //     Test.stopTest();

    //     System.assertEquals(0, numnerOfEmails);

    // }
//////////////////////////////////////////////
    // @isTest
    // public static void sendMassEmailToDonorsTest() {

    //     List<String> listEmail = new List<String>();

    //     Case cs = new Case();
    //     cs.Subject = 'Apex Case';
    //     insert cs;

    //     FeedItem feed = new FeedItem();
    //     feed.ParentId = cs.Id;
    //     feed.Body = '2222 Message which you want to post @My Village';
    //     insert feed;

    //     List<SendChatterEmail.campaignInfos> lstCmpInfos = new List<SendChatterEmail.campaignInfos>();

    //     SendChatterEmail.campaignInfos cmpInfo = new SendChatterEmail.campaignInfos();
    //     cmpInfo.caseId = cs.Id;
    //     cmpInfo.posId = feed.Id;
    //     lstCmpInfos.add(cmpInfo);

    //     Test.startTest();
    //     SendChatterEmail.sendEmailtoContacts(lstCmpInfos);
    //     Integer numnerOfEmails = Limits.getEmailInvocations();
    //     Test.stopTest();

    //     // System.assertEquals(1, numnerOfEmails);
    // }

