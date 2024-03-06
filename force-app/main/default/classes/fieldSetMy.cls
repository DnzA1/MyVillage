public with sharing class fieldSetMy {

    public static Map<String,Schema.FieldSet> getFieldSets(String parObject) {
        List<Schema.FieldSet> listOfFieldSets = new List<Schema.FieldSet>();
        Map<String, Schema.SObjectType> objects = Schema.getGlobalDescribe();
        Schema.SObjectType targetObject = objects.get(parObject);
        Schema.DescribeSObjectResult describeObject = targetObject.getDescribe();
        Map<String,Schema.FieldSet> fsetsObject = describeObject.fieldSets.getMap();
        System.debug('describeObject.fieldSets::: '+ fsetsObject);
        return fsetsObject;
    }

    public static List<String> getFieldSetMemberNames(String parObject, String parFieldSetName) {
        List<Schema.FieldSetMember> listOfFieldSetMembers = new List<Schema.FieldSetMember>();
        List<String> listOfMemberNames = new List<String>();
        Map<String,Schema.FieldSet> fieldSets = getFieldSets(parObject);
        for (String fSetName : fieldSets.keySet()) {
            if (fSetName == parFieldSetName) {
                for (Schema.FieldSetMember fieldSetMember : fieldSets.get(fSetName).getFields()) {
                    listOfMemberNames.add(fieldSetMember.getFieldPath());
                }
            }
        }
        System.debug('listOfMemberNames::: '+ listOfMemberNames);
        return listOfMemberNames;
    }

    public static List<Contact> dynamicSoqlWithSetMembers(String parObject, String parFieldSetName) {
        List<String> listOfMemberNames = getFieldSetMemberNames(parObject, parFieldSetName);
        String query = 'SELECT ';
        for (String fieldName : listOfMemberNames) {
            query += fieldName + ', ';
        }
        query += 'Id, Name FROM ' +parObject;
        System.debug('Database.query(query)::: '+ Database.query(query));
        return Database.query(query);
    }
    // Aşağısı dynamic query empty fieldleri önmüyor onu gidermek için.
    /* String[] fields = new String[]{'Name','Phone'};

    Account[] accts = Database.query('SELECT ' + String.join(fields,',') + ' FROM Account);
    for (Account a : accts){
        Map<String, Object> acctMap = a.getPopulatedFieldsAsMap();
        for (String field : fields){
            if (!acctMap.containsKey(field)){
                a.put(field,null);
            }
        }                                  
    }                                 
    System.debug(accts); */
////////////////////////////////////////////////////////INERNET ORNEKLERİ//////////////////////////////////////////////
    // @AuraEnabled
    public static List<String> getTypeNames() {
        Map<String, Schema.SObjectType> types = Schema.getGlobalDescribe();
        List<String> typeNames = new List<String>();
        String typeName = null;
        List<String> fsNames;
        for (String name : types.keySet()) {
            if (hasFieldSets(name)) {
                typeNames.add(name);        
            }
        }
        return typeNames;
    }

    // @AuraEnabled
    public static Boolean hasFieldSets(String typeName) {
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(typeName);
        Schema.DescribeSObjectResult describe = targetType.getDescribe();
        Map<String, Schema.FieldSet> fsMap = describe.fieldSets.getMap();
        return !fsMap.isEmpty();
    }

    // @AuraEnabled
    public static List<String> getFieldSetNames(String typeName) {
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(typeName);
        Schema.DescribeSObjectResult describe = targetType.getDescribe();
        Map<String, Schema.FieldSet> fsMap = describe.fieldSets.getMap();
        List<String> fsNames = new List<String>();
        for (String name : fsMap.keySet()) {
            fsNames.add(name);
        }
        return fsNames;
    }

    // @AuraEnabled
    public static List<FieldSetMember> getFields(String typeName, String fsName) {
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(typeName);
        Schema.DescribeSObjectResult describe = targetType.getDescribe();
        Map<String, Schema.FieldSet> fsMap = describe.fieldSets.getMap();
        Schema.FieldSet fs = fsMap.get(fsName);
        List<Schema.FieldSetMember> fieldSet = fs.getFields();
        List<FieldSetMember> fset = new List<FieldSetMember>();
        for (Schema.FieldSetMember f: fieldSet) {
            // fset.add(f);
            // fset.add(new FieldSetMember(f));
        }
        return fset;
    }
}