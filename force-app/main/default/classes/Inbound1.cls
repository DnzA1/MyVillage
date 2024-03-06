@RestResource(urlMapping='/AccountRecordInbound/')
global with sharing class Inbound1 {

    // Inbound Process - Client(Postman) Process
    //1- Authorization Process
    // a- New Connected App oluştur.
    // b- 
    // c- Share Consumer Secret and Consumer Key with client (Postman).
    // d- Client(Postman) using Consumer Secret and Consumer Key, Postman will send request to get Access token to Org.
    // e - Then it will return access token.
    // İlk token alırken url de bunu kullan ==>> https://login.salesforce.com/services/oauth2/token?
    // Daha sonraki requestlerin urlinde bunu kullan ==>> https://abc814-dev-ed.develop.my.salesforce.com/services/apexrest/AccountRecordInbound/ ==>> Bunu token aldığımız yerdeki  "instance_url": kısmından alıyoruz.
    // Son olarak org da oluşturduğumuz connected sayfasında öamage tıklayıp Edit Policies e tıklayıtp. IP Relaxation kısmını Relax Ip Restrictions yapıyoruz.

    // Yukarı yıldız koyarak şöyle yapardakda olur. '/AccountRecordInbound/*' Soql deki wild card demek bu. Buna bi ara bak tam ne demek. * koyunca URL de AccountRecordInbound den sonra başka şeylerde gelse dışardan gelen request bu classı bulabiliyor. Biraz daha hata almayı azaltıyor. ok.

    // workbanchde  parametrelerden önce ? işareti koymassak param kısmı boş gelir unutma. O zamamn urlden başka türlü çrkmrmiz lazım. short videolarda örnek var. Yani parametreleri paramdan değil direkt url den çekebiliriz.

    // post, put ve putch metodlarında body yi parametre olarak almak yerine dönüştüürme yapıp bu işlemleri yapmayı tercih et. Diğeri çok kullnışlı değil. 

    @HttpGet
    global static List<Account> getRecord(){

        system.debug('::::REST CONTEXT REQUEST:::::' + RestContext.request);
        system.debug('::::REST CONTEXT REQUEST headers:::::' + RestContext.request.headers);
        system.debug('::::REST CONTEXT REQUEST headers2:::::' + RestContext.request.headers.get('CipherSuite'));
        system.debug('::::REST CONTEXT REQUEST headers3:::::' + RestContext.request.headers.values());
        system.debug('::::REST CONTEXT REQUEST httpMethod:::::' + RestContext.request.httpMethod);
        system.debug('::::REST CONTEXT REQUEST remoteAddress:::::' + RestContext.request.remoteAddress);
        system.debug('::::REST CONTEXT REQUEST requestBody:::::' + RestContext.request.requestBody);
        system.debug('::::REST CONTEXT REQUEST requestURI:::::' + RestContext.request.requestURI);
        system.debug('::::REST CONTEXT REQUEST PARAMS:::::' + RestContext.request.params);
        system.debug('::::REST CONTEXT REQUEST PARAMS:::::' + RestContext.request.params.get('Rating'));

        String paramRating = RestContext.request.params.get('Rating');
        String paramIndustry = RestContext.request.params.get('Industry');

        List<Account> lstAcc = [SELECT Name FROM Account WHERE Rating =: paramRating OR Industry =: paramIndustry ];
        return lstAcc;
    }

    @HttpPost
    global static Account postRecord(String Name, String Rating, String Industry, Decimal AnnualRevenue){
        Account acc = new Account();
        acc.Name = Name;
        acc.Rating = Rating;
        acc.Industry = Industry;
        acc.AnnualRevenue = AnnualRevenue;
        insert acc;
        Contact con = new Contact();
        con.LastName = Name;
        con.AccountId = acc.Id;
        insert con;

        return acc;
    }

    @HttpDelete
    global static String deleteRecord(){
        Map<String,String> allParam = RestContext.request.params;
        String paramId = allParam.get('Id');
        delete [SELECT Id, Name FROM Account WHERE Id =:paramId];
        return 'Record has been deleted';
    }
    
    @HttpPatch // 1. Yol
    global static Account patchRecord() {

        RestRequest req = RestContext.request;
        String reqBody = req.requestBody.toString();
        System.debug('req Body:::'+ reqBody);
        Map<String,Object> getBody = (Map<String,Object>)JSON.deserializeUntyped(reqBody);
        Account acc = new Account();
        for (String a : getBody.keySet()) {
            acc.put(a, getBody.get(a));
        }
        update acc;
        return acc;
    }

    // @HttpPatch // 2. Yol
    // global static Account patchRecord(String Name, String Rating, String Industry, Decimal AnnualRevenue) {

    //     RestRequest request = RestContext.request;
    //     // String requestBody = request.requestBody.toString();// Çünkü body deki fieldlere parametre olarak ulaşırsam body kısmı null gelir.
    //     Account acc = [SELECT Id FROM Account WHERE Id =: RestContext.request.params.get('Id')];
    //     acc.Name = Name;
    //     acc.Rating = Rating;
    //     acc.Industry = Industry;
    //     acc.AnnualRevenue = AnnualRevenue;
    //     update acc;
    //     return acc;
    // }

    @HttpPut
    global static Account putRecords() {

        RestRequest req = RestContext.request;
        String reqBody = req.requestBody.toString();
        Account acc = (Account)JSON.deserialize(reqBody, Account.class);
        upsert acc;
        return acc;


        // Id siz gönderilen
        // {
            //     "Name" : "Deneme"
            //   }
        //---------------------------    
        // Id li gönderilen
        // {
        //     "Id" : "001Dn00000KUXufIAH",
        //     "Name" : "Deneme2"
        //   }
    }

    // @HttpPut // 2.ŞEKİL
    // global static Account putRecords(String Name, String Rating, String Industry, Decimal AnnualRevenue) {
    //     Account acc =  new Account();
    //     acc.Id = RestContext.request.Params.get('Id');
    //     acc.Name = Name;
    //     acc.Rating = Rating;
    //     acc.Industry = Industry;
    //     acc.AnnualRevenue = AnnualRevenue;
    //     upsert acc;
    //     return acc;
    // }

}
