({
    Accountcontroller : function(component, event, helper) {
        component.set('v.ShowRecordsColumn', [
            {label: 'Name', fieldName: 'Name', type: 'text'},
            {label: 'Type', fieldName: 'Type', type: 'text'},
            {label: 'Phone', fieldName: 'Phone', type: 'text'},
        ]);
        
        console.log('Fecth table');
        var action = component.get("c.fetchAccountRecords");
        action.setCallback(this,function(response){
            component.set("v.ShowRecords",response.getReturnValue());
        });
        $A.enqueueAction(action);
            
    },
    
    SelectedController : function(component, event, helper) {
        console.log('selected record');
        
        var selectedAccountRows=  event.getParam('selectedRows');  
        var selectedAccRows=[];
        for(var i=0;i<selectedAccountRows.length;i++){
            selectedAccRows.push(selectedAccountRows[i]);
        }
        component.set('v.selectedAccountRecordsList',selectedAccRows);
    },
    
    sendRecordsController :function(component, event, helper){
        
        helper.sendRecordsHelper(component, event, helper);
        setTimeout(function(){
            window.location.reload();
        }, 2000);
    },
    
     
})