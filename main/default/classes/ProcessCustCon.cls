public class ProcessCustCon{
    
    List<Contact_Custom__c> ids = new list<Contact_Custom__c>();
    list<Contact_Custom__c> updatedCon{get;set;}
    public list<contactWrapper> wrapperList {get; set;}
    
    public Integer offsetSize;
    public Integer limitSize;
    public Integer totalRecords {get; set;}
    public Integer currentRecord {get; set;}
    
    public Decimal totalPages {get; set;}
    public decimal currentPage {get; set;}
    
    public boolean disableFirstButtonFlag {get; set;}
    public boolean disablepreviousButtonFlag {get; set;}
    public boolean disableNextButtonFlag {get; set;}
    public boolean disableLastButtonFlag {get; set;}
    Contact_Custom__c CustConObj = new Contact_Custom__c();
    Contact conObj {get; set;}
    

    public ProcessCustCon(ApexPages.standardSetcontroller controller){
        ids = (list<Contact_Custom__c>)controller.getSelected();
        offsetSize=0;
        limitSize=1;
        disableFirstButtonFlag= true;
        disablepreviousButtonFlag= true;
        getContacts();
        if(offsetSize == (totalPages - 1)){
            disableNextButtonFlag = true;
            disableLastButtonFlag = true;
        }
        Else{
            disableNextButtonFlag = false;
            disableLastButtonFlag = false;
        }
        currentRecord=1;
        currentPage=1;
    }
    public ProcessCustCon(ApexPages.standardController controller){
        conObj = (Contact)controller.getRecord();
    }
    integer size;
    public pagereference getContacts(){
        wrapperList = new list<contactWrapper>();
        List<Contact_Custom__c> selectedRecords = [select Id,Updated_Record__c from Contact_custom__c where Id IN:ids];
        CustConObj = [SELECT Account_Name__c,Account__c,First_Name__c,Id,Last_Name__c,Name,Updated_Record__c,Account__r.Standard_Account_ID__c FROM Contact_Custom__c where Id In:ids LIMIT: limitSize OFFSET: offsetSize]; 
        
        ConObj = [select Id, FirstName, LastName,AccountId,Account.Name from Contact Where Id=: CustConObj.Name];
        
        
        contactWrapper objConWrap = new contactWrapper();        
        objConWrap.updatedCon=CustConObj;
        objConWrap.originalCon=ConObj;
        wrapperList.add(objConWrap);
        
        totalRecords  = selectedRecords.size();
        size=selectedRecords.size();
        Decimal tR = Decimal.valueOf(totalRecords);
        Decimal limitR = Decimal.valueOf(limitSize);
        totalPages = Math.ceil( tR/limitR);
        return null;
    }
    
    
    
    
    public void firstMethod(){
        currentPage = 1;
        offsetSize = 0;
        getContacts();
        
        disableFirstButtonFlag= true;
        disablepreviousButtonFlag = true;
        disableNextButtonFlag = false;
        disableLastButtonFlag = false;
        currentRecord =1;
    }
    
    public void previousMethod(){
        
        offsetSize = offsetSize - limitSize ;
        if(offsetSize !=0){                
            getContacts();
            currentRecord = offsetSize+1;
            disableNextButtonFlag= false;
            disableLastButtonFlag = false;
            currentPage --;
        }
        
        else{
            getContacts();
            
            disableFirstButtonFlag= true;
            disablepreviousButtonFlag = true;
            disableNextButtonFlag= false;
            disableLastButtonFlag = false;
            currentRecord = offsetSize+1;
            
            currentPage --;
        }
    }
    public void nextMethod(){
        offsetSize = offsetSize + limitSize ;
        if(offsetSize < (totalPages - 1)){
            getContacts();
            
            currentRecord  =  offsetSize+1;
            currentPage ++;
            
            disableFirstButtonFlag= false;
            disablepreviousButtonFlag = false;
        }
        else{
            getContacts();
            
            currentRecord  =  offsetSize+1;
            currentPage ++;
            disableNextButtonFlag= true;
            disableLastButtonFlag = true;
            disableFirstButtonFlag= false;
            disablepreviousButtonFlag = false;
        }
        
    }
    
    
    public void lastMethod(){
        offsetSize =size-1;
        getContacts();
        currentPage = totalPages;
        currentRecord  =  offsetSize+1;
        disableFirstButtonFlag= false;
        disablepreviousButtonFlag = false;
        disableNextButtonFlag= true;
        disableLastButtonFlag = true;
    }
    
    public void updateRec(){
        try{
            for(contactWrapper objConWrap : wrapperList){
                conObj.Id = CustConObj.Name;
                if(objConWrap.isAccount){
                    conObj.AccountId = CustConObj.Account__r.Standard_Account_ID__c;
                }
                if(objConWrap.isFirstName){
                    conObj.FirstName = CustConObj.First_Name__c;
                }
                if(objConWrap.isLastName){
                    conObj.LastName = CustConObj.Last_Name__c;
                }
                CustConObj.Updated_Record__c = False;
            }
            update CustConObj;
            update conObj;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Record updated successfully...!!!'));
        }
        catch(DmlException ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Something went wrong...!!!'));
        }
    }
    public void skipRec(){
        try{
            CustConObj.Updated_Record__c = False;
            update CustConObj;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Record Changes Skipped ...!!!'));
        }
        catch(DmlException ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Something went wrong...!!!'));
        }
    }
    
    public class contactWrapper{
        public Contact_Custom__c updatedCon {get; set;}
        public Contact originalCon {get; set;}
        
        public boolean isAccount {get; set;}
        public boolean isFirstName {get; set;}
        public boolean isLastName {get; set;}
        public contactWrapper(){
            this.updatedCon = new Contact_Custom__c();
            this.originalCon = new Contact();
            this.isAccount = false;
            this.isFirstName = false;
            this.isLastName = false;
        }
        
        
    }
    
}