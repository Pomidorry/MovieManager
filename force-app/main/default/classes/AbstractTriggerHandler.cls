public virtual class AbstractTriggerHandler implements ITriggerHandler {
 
    public void handle() {
        if (Trigger.isAfter) {
            if(Trigger.isInsert) doAfterInsert();
            else if(Trigger.isUpdate) doAfterUpdate();
        }
    }
    
    public virtual void doBeforeInsert(){  }
    
    public virtual void doAfterInsert(){  }
    public virtual void doBeforeUpdate(){  }
    
    public virtual void doAfterUpdate(){  }
    public virtual void doBeforeDelete(){  }
    
    public virtual void doAfterDelete(){  }  
}