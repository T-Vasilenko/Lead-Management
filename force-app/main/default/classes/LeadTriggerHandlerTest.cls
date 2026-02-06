@IsTest
private class LeadTriggerHandlerTest {

    @TestSetup
    static void setupTestData() {
        TestDataFactory.createUsers(2);
    }

    @IsTest
    static void beforeInsert_newLead_calculatesScore() {
        Lead testLead = TestDataFactory.createLead('Technology', 'VP Sales', 1500);

        Test.startTest();
        insert testLead;
        Test.stopTest();

        Lead insertedLead = [SELECT Id, Lead_Score__c, Rating FROM Lead WHERE Id = :testLead.Id];
        Assert.areEqual(60, insertedLead.Lead_Score__c, 'Score should be calculated on insert');
        Assert.areEqual('Hot', insertedLead.Rating, 'Rating should be set on insert');
    }

    @IsTest
    static void beforeInsert_duplicateEmail_preventsInsert() {
        Lead firstLead = TestDataFactory.createLead('Technology', 'VP', 1000);
        firstLead.Email = 'handler-dup@test.com';
        insert firstLead;

        TriggerHandler.resetExecutedHandlers();

        Lead duplicateLead = TestDataFactory.createLead('Finance', 'Director', 500);
        duplicateLead.Email = 'handler-dup@test.com';

        Test.startTest();
        Database.SaveResult result = Database.insert(duplicateLead, false);
        Test.stopTest();

        Assert.isFalse(result.isSuccess(), 'Duplicate email should prevent insert');
    }

    @IsTest
    static void beforeUpdate_fieldChange_recalculatesScore() {
        Lead testLead = TestDataFactory.createLead('Healthcare', 'Intern', 100);
        insert testLead;

        TriggerHandler.resetExecutedHandlers();

        Test.startTest();
        testLead.Industry = 'Technology';
        testLead.Title = 'CEO';
        testLead.NumberOfEmployees = 2000;
        update testLead;
        Test.stopTest();

        Lead updatedLead = [SELECT Id, Lead_Score__c, Rating FROM Lead WHERE Id = :testLead.Id];
        Assert.areEqual(60, updatedLead.Lead_Score__c, 'Score should be recalculated on update');
        Assert.areEqual('Hot', updatedLead.Rating, 'Rating should be recalculated on update');
    }

    @IsTest
    static void afterInsert_newLead_assignsToSalesUser() {
        Lead testLead = TestDataFactory.createLead('Technology', 'VP Sales', 1500);

        Test.startTest();
        insert testLead;
        Test.stopTest();

        Lead insertedLead = [SELECT Id, OwnerId FROM Lead WHERE Id = :testLead.Id];
        Assert.isNotNull(insertedLead.OwnerId, 'Lead should be assigned to a user');
    }

    @IsTest
    static void afterInsert_bulkLeads_assignsAllLeads() {
        List<Lead> leads = TestDataFactory.createLeads(10);

        Test.startTest();
        insert leads;
        Test.stopTest();

        List<Lead> insertedLeads = [SELECT Id, OwnerId, Lead_Score__c, Rating FROM Lead WHERE Id IN :leads];
        Assert.areEqual(10, insertedLeads.size(), 'All leads should be inserted');

        for (Lead lead : insertedLeads) {
            Assert.isNotNull(lead.OwnerId, 'Each lead should have an owner');
            Assert.isNotNull(lead.Lead_Score__c, 'Each lead should have a score');
            Assert.isNotNull(lead.Rating, 'Each lead should have a rating');
        }
    }
}
