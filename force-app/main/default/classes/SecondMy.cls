public with sharing class SecondMy {
    public static void myFirstMethod(Integer k, Integer l){
        if(k > l){
            System.debug(k +' '+ l + ' den büyktür.');
        } else if(l > k){
            System.debug(l +' '+ k + ' den büyktür.');
        } else {
            System.debug(l +' ve '+ k + ' eşittir');
        }
        
    }
}