public class custConController {
	
    @auraEnabled
    public static Contact_Custom__c getcustCon(string key){
        //this methods return the Contact Custom record with the id provided to the component
        Contact_Custom__c objCustCon1 = new Contact_Custom__c();
        objCustCon1 = [select Id,First_Name__c,Last_Name__c,Account__c,Name,Account_Name__c,Account__r.Standard_Account_ID__c,Account__r.Name from Contact_Custom__c where Id=:key];
        
        return objCustCon1;
    }
    
    @Auraenabled
    public static Contact getoriginalCon(string key){
        //this methods return the Contact record related to Contact Custom with the id provided to the component
        Contact_Custom__c objCustCon2 = [select Id,First_Name__c,Last_Name__c,Account__c,Account_Name__c,Name from Contact_Custom__c where Id=:key];
        
        contact objCon;
        objCon = [select Id,FirstName,LastName,AccountId,Account.Name from Contact where Id=:objCustCon2.Name];
        return objCon;
        
    }
    
    @AuraEnabled
    public static string updateOriginalCon(Contact_Custom__c objCustCon){
        
         contact updateCon = [select Id,FirstName,LastName,AccountId,Account.Name from Contact where Id=:objCustCon.Name];
            updateCon.FirstName=objCustCon.First_Name__c;
            updateCon.LastName=objCustCon.Last_Name__c;
            updateCon.AccountId=objCustCon.Account__r.Standard_Account_ID__c;
            //updateCon.Id=objCustCon.Name;
       
update(updateCon);        
        Contact_Custom__c objCustConUpdate = [select Id,Updated_Record__c from Contact_Custom__c where Id=:objCustCon.Id];
       objCustConUpdate.Updated_Record__c = False;
        update(objCustConUpdate);
        
        system.debug('@@@@'+objCustConUpdate);
        
        return 'Success';
    }
    
    /* @AuraEnabled
    public static string rejectUpdatedCon(Contact_Custom__c objCustCon){
    Contact_Custom__c objCustConUpdate = [select Id,Updated_Record__c from Contact_Custom__c where Id=:objCustCon.Id];
       objCustConUpdate.Updated_Record__c = False;
        update(objCustConUpdate);
        
        system.debug('@@@@'+objCustConUpdate);
        return 'Success';
    }*/
}