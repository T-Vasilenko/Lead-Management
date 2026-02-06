@IsTest
private class LeadSelectorTest {

    @IsTest
    static void selectActiveSalesUsers_activeUsersExist_returnsUsers() {
        TestDataFactory.createUsers(3);
        LeadSelector selector = new LeadSelector();

        Test.startTest();
        List<User> result = selector.selectActiveSalesUsers();
        Test.stopTest();

        Assert.isTrue(result.size() >= 3, 'Should return at least the 3 created users');
    }

    @IsTest
    static void selectActiveSalesUsers_orderedByCounter_returnsLowestFirst() {
        List<User> users = TestDataFactory.createUsers(2);
        users[0].Lead_Assignment_Counter__c = 10;
        users[1].Lead_Assignment_Counter__c = 2;
        update users;

        LeadSelector selector = new LeadSelector();

        Test.startTest();
        List<User> result = selector.selectActiveSalesUsers();
        Test.stopTest();

        Assert.isTrue(result.size() >= 2, 'Should return at least 2 users');
        Assert.isTrue(
            result[0].Lead_Assignment_Counter__c <= result[1].Lead_Assignment_Counter__c,
            'Users should be ordered by counter ascending'
        );
    }

    @IsTest
    static void selectByEmails_matchingEmails_returnsLeads() {
        Lead testLead = TestDataFactory.createLead('Technology', 'VP Sales', 1500);
        testLead.Email = 'selector-test@example.com';
        insert testLead;

        LeadSelector selector = new LeadSelector();
        Set<String> emails = new Set<String>{ 'selector-test@example.com' };

        Test.startTest();
        List<Lead> result = selector.selectByEmails(emails);
        Test.stopTest();

        Assert.areEqual(1, result.size(), 'Should return one matching lead');
        Assert.areEqual('selector-test@example.com', result[0].Email, 'Should return lead with matching email');
    }

    @IsTest
    static void selectByEmails_noMatchingEmails_returnsEmptyList() {
        LeadSelector selector = new LeadSelector();
        Set<String> emails = new Set<String>{ 'nonexistent@example.com' };

        Test.startTest();
        List<Lead> result = selector.selectByEmails(emails);
        Test.stopTest();

        Assert.areEqual(0, result.size(), 'Should return empty list for non-matching emails');
    }
}
