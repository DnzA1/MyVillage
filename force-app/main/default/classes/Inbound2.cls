@RestResource(urlMapping='/AccountRecordInbound2/')
// General Usage
// Gelen requesti stringe çeviriyoruz. Blobdan stringe çevir. 
// Daha sonra bu string değeri class(Obje) formatına deserailze metoduyla çevir.
// Sonra istediğin gibi kullan

global with sharing class Inbound2 {
//Commendli yerlerde field apileri uyuştuğundan direkt olarak assign edip oluşturabildim.
    @HttpPost
    global static Map<String,String> oneAccAndOneConCPost(){
        Map<String,String> mpResult = new Map<String,String>();
        RestRequest rsr = RestContext.request;
        system.debug(':::RestContext.request:::' +rsr);  //TÜM RİCA
        Blob bodyJson = rsr.requestBody;  // BODY
        system.debug(':::BLOB:::' +bodyJson);
        // String JsontoString = RestContext.request.requestBody.toString();
        String JsontoString = bodyJson.toString();
        system.debug(':::JsontoString:::' +JsontoString); // BODY ====>>>> STRİNG

        mainWrapper mainWrapper = (mainWrapper)JSON.deserialize(JsontoString,mainWrapper.Class);
        system.debug(':::mainWrapper:::' +mainWrapper); //STRING =====>>>>> OBJECT


        // Account acc = mainWrapper.accObj;
        // insert acc;
        Account acc = new Account();
        acc.Name = mainWrapper.accObj.Name;
        acc.Rating = mainWrapper.accObj.Rating;
        insert acc;
        mpResult.put('Account Record Has Been Created With Id ', acc.Id);


        // Contact con = mainWrapper.conObj;
        // insert con;
        Contact con = new Contact();
        con.firstName = mainWrapper.conObj.FirstName;
        con.lastName = mainWrapper.conObj.LastName;
        insert con;
        mpResult.put('Contact Record Has Been Created With Id ', con.Id);
        return mpResult;
    }

    // public class mainWrapper{
    //     public Account accObj;
    //     public Contact conObj;
    // }

    public class mainWrapper{
        public accountWrapper accObj;
        public contactWrapper conObj;
    }

    public class accountWrapper{
        public String Name;
        public String Rating;
    }

    public class contactWrapper{
        public String FirstName;
        public String LastName;
    }


}


// {

//     "accObj" : {
//         "Name" : "New Acc",
//         "Rating" : "Hot"
//     },
//     "conObj" : {
//         "FirstName" : "New Con FirstName",
//         "LastName" : "New Con LastName"
//     }
    
//     }