public class accountController {
    @AuraEnabled
    public static List<Account> fetchAccountRecords(){
        list<Account_Custom__c> customList = [select Standard_Account_ID__c from Account_Custom__c];
        list<Id> custAccID = new list<Id>();
        for(Account_Custom__c objCustAcc : customList){
            custAccId.add(objCustAcc.Standard_Account_ID__c);
        }
        return[SELECT AccountNumber,AccountSource,Active__c,AnnualRevenue,BillingAddress,BillingCity,BillingCountry,BillingGeocodeAccuracy,BillingLatitude,
               BillingLongitude,BillingPostalCode,BillingState,BillingStreet,CleanStatus,CreatedById,CreatedDate,CustomerPriority__c,DandbCompanyId,Description,
               DunsNumber,Fax,Id,Industry,IsDeleted,Jigsaw,JigsawCompanyId,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,
               MasterRecordId,NaicsCode,NaicsDesc,Name,NumberOfEmployees,NumberofLocations__c,OperatingHoursId,OwnerId,Ownership,ParentId,Phone,PhotoUrl,Rating,
               ShippingAddress,ShippingCity,ShippingCountry,ShippingGeocodeAccuracy,ShippingLatitude,ShippingLongitude,ShippingPostalCode,ShippingState,ShippingStreet,
               Sic,SicDesc,Site,SLAExpirationDate__c,SLASerialNumber__c,SLA__c,SystemModstamp,TickerSymbol,Tradestyle,Type,UpsellOpportunity__c,Website,YearStarted 
               FROM Account where Id NOT IN:custAccID];
    }
    
    @AuraEnabled
    public static string SendSelectedAccount(list<Account> accList){
        try{
            
            list<Account_Custom__c> custAccList = new list<Account_Custom__c>();
            list<Contact_Custom__c> custConList = new list<Contact_Custom__c>();
            list<Contact> conList = new list<Contact>();
            set<Id> cusAccIdSet = new set<Id>();
            list<Account_Custom__c> accCustFetchList= new list<Account_Custom__c>();
            map<Id,Account_Custom__c> accCustMap = new map<Id,Account_Custom__c>();
            //iteration over accList(i.e. selected records from aura component) and inserting it in custom Account object 'Account_Custom__c'
            for(Account objAcc : accList){
                Account_Custom__c custAccObj =new Account_Custom__c();
                custAccObj.Standard_Account_ID__c=objAcc.Id;
                custAccObj.Account_Name__c=objAcc.Name;
                custAccObj.Account_Phone__c=objAcc.Phone;
                custAccObj.Account_Type__c=objAcc.Type;
                
                custAccList.add(custAccObj);
                // getting the contacts related to selected Accounts and adding it to the conList
                for(Contact objCon : [select Id,AccountId,FirstName,LastName from Contact Where AccountId =: objacc.Id]){
                    conList.add(objCon);
                }
            }
            
            
            database.saveResult[] srList = Database.insert(custAccList,false);
            Id custAccId;
            for (database.saveResult sr : srList){
                custAccId = sr.getId();
                cusAccIdSet.add(custAccId);
                
            }
            // getting data from custom Account Object which were inserted recently to get there unique record Id's
            for(Account_Custom__c fetchAccCust : [select Id, Standard_Account_ID__c,Account_Name__c from Account_Custom__c where Id IN:cusAccIdSet]){
                accCustMap.put(fetchAccCust.Standard_Account_ID__c,fetchAccCust);
            }
            
            //iteration over conList(i.e. the contacts related to the accounts selected) and inserting in custom contact object 'Contact_Custom__c'
            for(Contact objCon : conList){
                // if(accCustMap.containsKey(objCon.AccountId)){
                Contact_Custom__c custConObj = new Contact_Custom__c();
                custConObj.Name=objCon.Id;
                custConObj.Account__c=accCustMap.get(objCon.AccountId).Id;
                custConObj.First_Name__c=objCon.FirstName;
                custConObj.Last_Name__c=objCon.LastName;
                
                custConList.add(custConObj);
                // }
            }
            Database.insert(custConList,false);
             return 'Success';
        }
        catch(Exception ex){
            system.debug('Error');
             return null;
        }
    }
    
}