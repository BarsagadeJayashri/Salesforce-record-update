({
    sendRecordsHelper:function(component, event, helper){
        console.log('send Helper');
        var action = component.get("c.SendSelectedAccount");
        action.setParams({"accList": component.get('v.selectedAccountRecordsList')});
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
        this.showSuccess(component, event, helper);
    },
    showSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success',
            message: 'selected Accounts are sucessfully inserted in custom Account object',
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
            message:'Something went Wrong',
            duration:' 5000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
    }
})