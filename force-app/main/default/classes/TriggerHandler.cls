public abstract class TriggerHandler {

    @TestVisible
    public Boolean isBefore;
    @TestVisible
    public Boolean isAfter;
    @TestVisible
    public Boolean isInsert;
    @TestVisible
    public Boolean isUpdate;
    @TestVisible
    public Boolean isDelete;
    @TestVisible
    public Boolean isUndelete;

    private static Set<String> executedHandlers = new Set<String>();

    public void run() {
        setTriggerContext();

        String handlerName = getHandlerName();

        if (executedHandlers.contains(handlerName)) {
            return;
        }

        executedHandlers.add(handlerName);
        dispatch();
    }

    private void setTriggerContext() {
        this.isBefore = Trigger.isBefore;
        this.isAfter = Trigger.isAfter;
        this.isInsert = Trigger.isInsert;
        this.isUpdate = Trigger.isUpdate;
        this.isDelete = Trigger.isDelete;
        this.isUndelete = Trigger.isUndelete;
    }

    private String getHandlerName() {
        return String.valueOf(this).substring(0, String.valueOf(this).indexOf(':'));
    }

    @TestVisible
    private void dispatch() {
        if (this.isBefore && this.isInsert) {
            this.beforeInsert();
        } else if (this.isBefore && this.isUpdate) {
            this.beforeUpdate();
        } else if (this.isBefore && this.isDelete) {
            this.beforeDelete();
        } else if (this.isAfter && this.isInsert) {
            this.afterInsert();
        } else if (this.isAfter && this.isUpdate) {
            this.afterUpdate();
        } else if (this.isAfter && this.isDelete) {
            this.afterDelete();
        } else if (this.isAfter && this.isUndelete) {
            this.afterUndelete();
        }
    }

    @TestVisible
    public static void resetExecutedHandlers() {
        executedHandlers.clear();
    }

    protected virtual void beforeInsert() {
    }

    protected virtual void beforeUpdate() {
    }

    protected virtual void afterInsert() {
    }

    protected virtual void afterUpdate() {
    }

    protected virtual void beforeDelete() {
    }

    protected virtual void afterDelete() {
    }

    protected virtual void afterUndelete() {
    }
}
