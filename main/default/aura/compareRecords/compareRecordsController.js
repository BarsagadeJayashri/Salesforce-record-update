({
	doInit : function(component, event, helper) {
        console.log('On Load');
		
        helper.customContactHelper(component, event, helper);
        
	},
    
    approveUpdateController : function(component, event, helper){
        console.log('Update');
        helper.approveUpdateHelper(component, event, helper);
        
    },
    
    SkipUpdateController : function(component, event, helper){
        console.log('Skip');
        //helper.skipUpdateHelper(component, event, helper);
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    }
})