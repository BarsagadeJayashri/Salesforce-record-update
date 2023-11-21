trigger CustomContact on Contact_Custom__c (before update) {
    for(Contact_Custom__c objCustCon : trigger.new){
        if((objCustCon != trigger.oldMap.get(objCustCon.Id)) && (objCustCon.Updated_Record__c == trigger.oldMap.get(objCustCon.Id).Updated_Record__c)){
            objCustCon.Updated_Record__c=true;
        }
        
    }
}