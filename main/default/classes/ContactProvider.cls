@RestResource(urlMapping='/myContacts/*')
global class ContactProvider {
    
    @httpGet
    global static List<Contact_Custom__c> getAllContacts(){
        
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        
        String accountType = RestContext.request.params.get('accType');
        //String accountRating = RestContext.request.params.get('accRating');
        try {
            // Query optimization
            //  //if(String.isNotBlank(accountType) && String.isNotBlank(accountRating)){  
            List<Contact_Custom__c> contacts = [SELECT Id,Account__c, First_Name__c, Last_Name__c, Account_Name__c FROM Contact_Custom__c LIMIT 1000];
            
            return contacts;
        } catch (Exception ex) {
            // Error handling
            return null;
        }
    }
    
    @httpPut
    global static list<String> updateContacts() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        // Deserialize input JSON payload
        List<responseWrapper> objResWrapList = (List<responseWrapper>) JSON.deserialize(req.requestBody.toString(), List<responseWrapper>.class);
        
        // Create a map to map the Id values to the corresponding input objects
        Map<Id, responseWrapper> idToObjMap = new Map<Id, responseWrapper>();
        for (responseWrapper objResWrap : objResWrapList) {
            idToObjMap.put(objResWrap.Id, objResWrap);
        }
        
        // Fetch all the records that match the Id values in the input payload
        List<Contact_Custom__c> conList = [SELECT Id, Account__c, First_Name__c, Last_Name__c, Account_Name__c FROM Contact_Custom__c WHERE Id IN :idToObjMap.keySet()];
        
        // Update fields for each record in the list
        for (Contact_Custom__c objCon : conList) {
            responseWrapper objResWrap = idToObjMap.get(objCon.Id);
            objCon.Account__c = objResWrap.AccountId;
            objCon.First_Name__c = objResWrap.FirstName;
            objCon.Last_Name__c = objResWrap.LastName;
            objCon.Account_Name__c = objResWrap.AccountName;
        }
        
        // Update records
        database.saveResult[] result= Database.update(conList, false);
        
        integer index=0;
        list<string> resList = new list<string>();
        for(Database.SaveResult sr : result){// 2/4
            if(sr.isSuccess()){
                // Operation was successful, so get the ID of the record that was processed
                System.debug('#Successfully Updated Contact ID: ' + conList[index].Id);
                resList.add('#Successfully Updated Contact ID: ' + conList[index].Id);
                index++;
            }
            else{
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Contact fields that affected this error: ' + err.getFields());
                    
                    System.debug('@Failed Contact Id = '+conList[index].Id );                           
                    resList.add('@Failed Contact Id = '+conList[index].Id+' The following error has occurred.'+err.getStatusCode() + ': ' + err.getMessage()+' Contact fields that affected this error: ' + err.getFields());
                    index++;
                }
                
                
            }
        }
        return resList;
    }
            
            global class responseWrapper{
                global Id Id;
                global string AccountId;
                global String FirstName;
                global String LastName;  
                global String AccountName; 
            }
            
            
            
        }