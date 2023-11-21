@RestResource(urlMapping='/myAccounts/*')
global class AccountProvider {

    @httpGet
    global static List<Account_Custom__c> getAllAccounts(){
               
	  RestRequest req = RestContext.request;
      RestResponse res = Restcontext.response;

      //String accountType = RestContext.request.params.get('accType');
      //String accountRating = RestContext.request.params.get('accRating');
        
        //if(String.isNotBlank(accountType) && String.isNotBlank(accountRating)){     
      		 return ([SELECT Id,Account_Name__c,Account_Phone__c,Account_Type__c,Name FROM Account_Custom__c]);
        /*}
        else{
            return null;
        }*/

    }
        /*@httpPut
    global static Account getAllAccounts(){
      RestRequest req = RestContext.request;
      RestResponse res = Restcontext.response;

      String jsonString=req.requestBody.tostring();
      responseWrapper objResWrap =(responseWrapper) JSON.deserialize(jsonString,responseWrapper.class);        
        
        Account objAcc = [select Id, Name,Type, Rating from Account where Name=:objResWrap.name LIMIT 1];
        objAcc.Rating = objResWrap.rating;
        Database.update(objAcc, false);
        
        
        return objAcc ;

    }
    
        global class responseWrapper{
		   global Id Id;
		   global string name;
		   global String type;
		   global String rating;  
		   global String sla; 
      }
*/
    
  
}