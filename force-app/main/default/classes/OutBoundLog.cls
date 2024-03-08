public with sharing class OutBoundLog {
    @AuraEnabled
    public static Callout_Log__c postMethod(String recordId){
        Callout_Log__c newCallout = new Callout_Log__c();

        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://putsreq.com/k85uz2PsGJXm8Eq0svP2');
        request.setMethod('POST');
        Account lstCon =[SELECT Name FROM Account WHERE ID =: recordId];
        // system.debug('lstCon:::::::::::'+ lstCon);
        String jsonBody = JSON.serialize(lstCon);
        // system.debug('josnBody:::::::'+ jsonBody);
        request.setBody(jsonBody);
        request.setHeader('Content-Type','application/json;charset=UTF-8');
        
        // 2- Prapare Http
        Http http = new Http();
        
        // 3- Send Request and Receive Response
        HttpResponse response = http.send(request);
        
        // 4- Process the Response  
        if (response.getStatusCode() == 200) {
            // system.debug('Posting Okay!!!');
            // system.debug(response.getBody());
            //Create Callout log
            Callout_Log__c cl = new Callout_Log__c();
            cl.Callout_Time__c = Datetime.now();
            cl.Account__c = recordId;
            cl.Payload__c = response.getBody();
            insert cl;
            newCallout = cl;
        } else {
            system.debug('Posting NOTTT Okay!!!');
        }
        return newCallout;
    }
}

// public with sharing class OutBoundLog {
//     @AuraEnabled
//     public static Callout_Log__c postMethod(String recordId){
//         Callout_Log__c newCallout = new Callout_Log__c();

//         HttpRequest request = new HttpRequest();
//         request.setEndpoint('https://putsreq.com/2DDbwmqTza3DMniaxGPJ');
//         request.setMethod('POST');
//         Account lstCon =[SELECT Name FROM Account WHERE ID =: recordId];
//         // system.debug('lstCon:::::::::::'+ lstCon);
//         String jsonBody = JSON.serialize(lstCon);
//         // system.debug('josnBody:::::::'+ jsonBody);
//         request.setBody(jsonBody);
//         request.setHeader('Content-Type','application/json;charset=UTF-8');
        
//         // 2- Prapare Http
//         Http http = new Http();
        
//         // 3- Send Request and Receive Response
//         HttpResponse response = http.send(request);
        
//         // 4- Process the Response  
//         if (response.getStatusCode() == 200) {
//             // system.debug('Posting Okay!!!');
//             // system.debug(response.getBody());
//             //Create Callout log
//             Callout_Log__c cl = new Callout_Log__c();
//             cl.Callout_Time__c = Datetime.now();
//             cl.Account__c = recordId;
//             cl.Payload__c = response.getBody();
//             insert cl;
//             newCallout = cl;
//         } else {
//             system.debug('Posting NOTTT Okay!!!');
//         }
//         return newCallout;
//     }
// }