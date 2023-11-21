({
    
    customContactHelper : function(component, event, helper) {
        console.log('cust con');
        
        var action = component.get('c.getcustCon');
        action.setParams({"key" : component.get('v.recordId')});
        action.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS'){
                console.log("success" + JSON.stringify(response.getReturnValue()));
                component.set('v.objCustCon',response.getReturnValue());
            }
            else{
                console.log("something went wrong");
            }
            
        });
        $A.enqueueAction(action);
        
        this.standardContactHelper(component, event, helper);
    },
    standardContactHelper : function(component, event, helper) {
        console.log('std Con');
        var action = component.get('c.getoriginalCon');
        action.setParams({"key" : component.get('v.recordId')});
        action.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS'){
                console.log("success original" + JSON.stringify(response.getReturnValue()));
                component.set('v.objOriginalCon',response.getReturnValue());
            }
            else{
                console.log("something went wrong");
            }
            
        });
        $A.enqueueAction(action);
    },
    approveUpdateHelper : function(component, event, helper){
        
        var action = component.get('c.updateOriginalCon');
        action.setParams({"objCustCon" : component.get('v.objCustCon')});
        action.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS'){
                console.log("success update" );
                if(response.getReturnValue() == 'Success'){
                    this.showSuccess(component, event, helper);
                }
            }
            else{
                console.log("something went wrong");
                this.showerror(component, event, helper);
            }
            
        });
        $A.enqueueAction(action);
        //window.location.reload()
        setTimeout(function () {
            window.location.reload(1);
        }, 1000);
        
    },
    /*skipUpdateHelper : function(component, event, helper){
         var action = component.get('c.rejectUpdatedCon');
        action.setParams({"objCustCon" : component.get('v.objCustCon')});
        action.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS'){
                console.log("success update" );
                if(response.getReturnValue() == 'Success'){
                    this.showSuccess(component, event, helper);
                }
            }
            else{
                console.log("something went wrong");
                this.showerror(component, event, helper);
            }
            
        });
        $A.enqueueAction(action);
        //window.location.reload()
        setTimeout(function () {
            window.location.reload(1);
        }, 1000);
    },*/
    showSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success',
            message: 'This is a success message',
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
    },
    showError : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message:'This is an error message',
            duration:' 5000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
    }
    
})