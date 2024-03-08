@isTest
public with sharing class AccountTests {

    @isTest
    public static void updFldTest(){
        try {
            Account acc = new Account();
            acc.Name = 'Test';
            acc.Rating = 'Hot';
            insert acc;
        } catch (Exception ex) {
            system.debug(ex);
        }


        Integer numAcc = [SELECT Count() FROM Account];
        System.AssertEquals(numAcc, 0);
    }

//fdsadfds


}