public with sharing class First {
    public static void myFirstMethod2(Integer k, Integer l){
        if(k > l){
            System.debug(k +' '+ l + ' den büyktür.');
        } else if(l > k){
            System.debug(l +' '+ k + ' den büyktür.');
        } else {
            System.debug(l +' ve '+ k + ' eşittir');
        }
        
    }
}