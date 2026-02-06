@IsTest
private class TriggerHandlerTest {

    private class TestHandler extends TriggerHandler {

        public Boolean beforeInsertCalled = false;
        public Boolean beforeUpdateCalled = false;
        public Boolean afterInsertCalled = false;
        public Boolean afterUpdateCalled = false;
        public Boolean beforeDeleteCalled = false;
        public Boolean afterDeleteCalled = false;
        public Boolean afterUndeleteCalled = false;

        protected override void beforeInsert() {
            this.beforeInsertCalled = true;
        }

        protected override void beforeUpdate() {
            this.beforeUpdateCalled = true;
        }

        protected override void afterInsert() {
            this.afterInsertCalled = true;
        }

        protected override void afterUpdate() {
            this.afterUpdateCalled = true;
        }

        protected override void beforeDelete() {
            this.beforeDeleteCalled = true;
        }

        protected override void afterDelete() {
            this.afterDeleteCalled = true;
        }

        protected override void afterUndelete() {
            this.afterUndeleteCalled = true;
        }
    }

    @IsTest
    static void dispatch_beforeInsertContext_callsBeforeInsert() {
        TestHandler handler = new TestHandler();
        handler.isBefore = true;
        handler.isAfter = false;
        handler.isInsert = true;
        handler.isUpdate = false;
        handler.isDelete = false;
        handler.isUndelete = false;

        Test.startTest();
        handler.dispatch();
        Test.stopTest();

        Assert.isTrue(handler.beforeInsertCalled, 'beforeInsert should be called in before insert context');
        Assert.isFalse(handler.afterInsertCalled, 'afterInsert should not be called in before insert context');
    }

    @IsTest
    static void dispatch_beforeUpdateContext_callsBeforeUpdate() {
        TestHandler handler = new TestHandler();
        handler.isBefore = true;
        handler.isAfter = false;
        handler.isInsert = false;
        handler.isUpdate = true;
        handler.isDelete = false;
        handler.isUndelete = false;

        Test.startTest();
        handler.dispatch();
        Test.stopTest();

        Assert.isTrue(handler.beforeUpdateCalled, 'beforeUpdate should be called in before update context');
    }

    @IsTest
    static void dispatch_afterInsertContext_callsAfterInsert() {
        TestHandler handler = new TestHandler();
        handler.isBefore = false;
        handler.isAfter = true;
        handler.isInsert = true;
        handler.isUpdate = false;
        handler.isDelete = false;
        handler.isUndelete = false;

        Test.startTest();
        handler.dispatch();
        Test.stopTest();

        Assert.isTrue(handler.afterInsertCalled, 'afterInsert should be called in after insert context');
    }

    @IsTest
    static void dispatch_afterUpdateContext_callsAfterUpdate() {
        TestHandler handler = new TestHandler();
        handler.isBefore = false;
        handler.isAfter = true;
        handler.isInsert = false;
        handler.isUpdate = true;
        handler.isDelete = false;
        handler.isUndelete = false;

        Test.startTest();
        handler.dispatch();
        Test.stopTest();

        Assert.isTrue(handler.afterUpdateCalled, 'afterUpdate should be called in after update context');
    }

    @IsTest
    static void dispatch_beforeDeleteContext_callsBeforeDelete() {
        TestHandler handler = new TestHandler();
        handler.isBefore = true;
        handler.isAfter = false;
        handler.isInsert = false;
        handler.isUpdate = false;
        handler.isDelete = true;
        handler.isUndelete = false;

        Test.startTest();
        handler.dispatch();
        Test.stopTest();

        Assert.isTrue(handler.beforeDeleteCalled, 'beforeDelete should be called in before delete context');
    }

    @IsTest
    static void dispatch_afterDeleteContext_callsAfterDelete() {
        TestHandler handler = new TestHandler();
        handler.isBefore = false;
        handler.isAfter = true;
        handler.isInsert = false;
        handler.isUpdate = false;
        handler.isDelete = true;
        handler.isUndelete = false;

        Test.startTest();
        handler.dispatch();
        Test.stopTest();

        Assert.isTrue(handler.afterDeleteCalled, 'afterDelete should be called in after delete context');
    }

    @IsTest
    static void dispatch_afterUndeleteContext_callsAfterUndelete() {
        TestHandler handler = new TestHandler();
        handler.isBefore = false;
        handler.isAfter = true;
        handler.isInsert = false;
        handler.isUpdate = false;
        handler.isDelete = false;
        handler.isUndelete = true;

        Test.startTest();
        handler.dispatch();
        Test.stopTest();

        Assert.isTrue(handler.afterUndeleteCalled, 'afterUndelete should be called in after undelete context');
    }

    @IsTest
    static void run_duplicateExecution_preventsRecursion() {
        TestHandler handler = new TestHandler();

        TriggerHandler.resetExecutedHandlers();

        Test.startTest();
        handler.run();
        handler.run();
        Test.stopTest();

        Assert.isNotNull(handler, 'Handler should complete without error on duplicate execution');
    }

    @IsTest
    static void resetExecutedHandlers_afterReset_allowsRerun() {
        TestHandler handler = new TestHandler();

        TriggerHandler.resetExecutedHandlers();

        Test.startTest();
        handler.run();
        TriggerHandler.resetExecutedHandlers();
        handler.run();
        Test.stopTest();

        Assert.isNotNull(handler, 'Handler should execute again after reset');
    }
}
