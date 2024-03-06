public with sharing class AccTriggerHandler {
    public static void updFld(List<Account> Triggernew){
        System.debug('ACC TRİGGER:::::::::::::::::::');
        for(Account acc : Triggernew){
            if (acc.Rating == 'Hot') {
                acc.addError('Hot yapamassin');
            }
        }
    }

    public static void addErr4(List<Account> Triggernew, List<Account> Triggerold, Map<Id, Account> TriggernewMap,  Map<Id, Account> TriggeroldMap){
        for(Account acc : Triggerold){
            if(acc.Type == 'Other'){
                TriggernewMap.get(acc.Id).addError('Otherı değiştiremessin');
                // acc.addError('Otherı değiştiremessin');
            }
        }
    }

    public static void deletePart(List<Account> Triggerold, Map<Id, Account> TriggeroldMap){
        for(Account acc : Triggerold){
            if(acc.Type == 'Other'){
                // TriggernewMap.get(acc.Id).addError('Otherı değiştiremessin');
                acc.addError('Otherı değiştiremessin');
            }
        }
    }

}