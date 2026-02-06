@IsTest
private class LeadServiceTest {

    @TestSetup
    static void setupTestData() {
        TestDataFactory.createUsers(3);
    }

    @IsTest
    static void assignLeadsToSalesTeam_multipleLeads_distributesEvenly() {
        List<Lead> leads = TestDataFactory.createLeads(9);

        Test.startTest();
        insert leads;
        Test.stopTest();

        List<Lead> insertedLeads = [SELECT Id, OwnerId FROM Lead WHERE Id IN :leads];
        Assert.areEqual(9, insertedLeads.size(), 'All 9 leads should be inserted');

        Map<Id, Integer> ownerCountMap = new Map<Id, Integer>();
        for (Lead lead : insertedLeads) {
            Assert.isNotNull(lead.OwnerId, 'Lead should have an owner assigned');
            Integer count = ownerCountMap.containsKey(lead.OwnerId) ? ownerCountMap.get(lead.OwnerId) : 0;
            ownerCountMap.put(lead.OwnerId, count + 1);
        }
    }

    @IsTest
    static void assignLeadsToSalesTeam_noSalesUsers_keepsDefaultOwner() {
        List<User> users = [SELECT Id FROM User WHERE Profile.Name = 'Standard User' AND IsActive = TRUE];
        for (User u : users) {
            u.IsActive = false;
        }
        update users;

        Lead testLead = TestDataFactory.createLead('Technology', 'VP Sales', 1500);

        Test.startTest();
        insert testLead;
        Test.stopTest();

        Lead insertedLead = [SELECT Id, OwnerId FROM Lead WHERE Id = :testLead.Id];
        Assert.isNotNull(insertedLead.OwnerId, 'Lead should still have an owner');
    }

    @IsTest
    static void calculateLeadScores_bulkLeads_allScoresCalculated() {
        List<Lead> leads = TestDataFactory.createLeads(200);

        Test.startTest();
        insert leads;
        Test.stopTest();

        List<Lead> insertedLeads = [SELECT Id, Lead_Score__c, Rating FROM Lead WHERE Id IN :leads];

        for (Lead lead : insertedLeads) {
            Assert.isNotNull(lead.Lead_Score__c, 'Lead score should be calculated');
            Assert.isNotNull(lead.Rating, 'Rating should be assigned');
            Assert.isTrue(lead.Lead_Score__c > 0, 'Score should be positive');
        }
    }

    @IsTest
    static void calculateLeadScores_technologyVPLargeCompany_hotRating() {
        Lead testLead = TestDataFactory.createLead('Technology', 'VP Sales', 1500);

        Test.startTest();
        insert testLead;
        Test.stopTest();

        Lead insertedLead = [SELECT Id, Lead_Score__c, Rating FROM Lead WHERE Id = :testLead.Id];
        Assert.areEqual(60, insertedLead.Lead_Score__c, 'Technology + VP + Large company should score 60');
        Assert.areEqual('Hot', insertedLead.Rating, 'Score of 60 should be Hot');
    }

    @IsTest
    static void calculateLeadScores_onUpdate_recalculatesScore() {
        Lead testLead = TestDataFactory.createLead('Healthcare', 'Intern', 100);
        insert testLead;

        TriggerHandler.resetExecutedHandlers();

        Test.startTest();
        testLead.Industry = 'Technology';
        testLead.Title = 'VP Sales';
        testLead.NumberOfEmployees = 1500;
        update testLead;
        Test.stopTest();

        Lead updatedLead = [SELECT Id, Lead_Score__c, Rating FROM Lead WHERE Id = :testLead.Id];
        Assert.areEqual(60, updatedLead.Lead_Score__c, 'Updated lead should score 60');
        Assert.areEqual('Hot', updatedLead.Rating, 'Updated lead should be Hot');
    }

    @IsTest
    static void preventDuplicateLeads_duplicateEmail_blocksInsert() {
        Lead existingLead = TestDataFactory.createLead('Technology', 'VP', 1000);
        existingLead.Email = 'duplicate@test.com';
        insert existingLead;

        TriggerHandler.resetExecutedHandlers();

        Lead duplicateLead = TestDataFactory.createLead('Finance', 'Director', 500);
        duplicateLead.Email = 'duplicate@test.com';

        Test.startTest();
        Database.SaveResult result = Database.insert(duplicateLead, false);
        Test.stopTest();

        Assert.isFalse(result.isSuccess(), 'Duplicate lead insert should fail');
        Assert.isTrue(result.getErrors()[0].getMessage().contains('email'), 'Error message should mention email');
    }

    @IsTest
    static void preventDuplicateLeads_uniqueEmail_allowsInsert() {
        Lead firstLead = TestDataFactory.createLead('Technology', 'VP', 1000);
        firstLead.Email = 'unique1@test.com';
        insert firstLead;

        TriggerHandler.resetExecutedHandlers();

        Lead secondLead = TestDataFactory.createLead('Finance', 'Director', 500);
        secondLead.Email = 'unique2@test.com';

        Test.startTest();
        Database.SaveResult result = Database.insert(secondLead, false);
        Test.stopTest();

        Assert.isTrue(result.isSuccess(), 'Lead with unique email should be inserted');
    }

    @IsTest
    static void preventDuplicateLeads_nullEmail_allowsInsert() {
        Lead testLead = TestDataFactory.createLead('Technology', 'VP', 1000);
        testLead.Email = null;

        Test.startTest();
        Database.SaveResult result = Database.insert(testLead, false);
        Test.stopTest();

        Assert.isTrue(result.isSuccess(), 'Lead with null email should be inserted');
    }

    @IsTest
    static void preventDuplicateLeads_caseInsensitiveMatch_blocksInsert() {
        Lead existingLead = TestDataFactory.createLead('Technology', 'VP', 1000);
        existingLead.Email = 'CaseSensitive@test.com';
        insert existingLead;

        TriggerHandler.resetExecutedHandlers();

        Lead duplicateLead = TestDataFactory.createLead('Finance', 'Director', 500);
        duplicateLead.Email = 'casesensitive@test.com';

        Test.startTest();
        Database.SaveResult result = Database.insert(duplicateLead, false);
        Test.stopTest();

        Assert.isFalse(result.isSuccess(), 'Case-insensitive duplicate should be blocked');
    }
}
