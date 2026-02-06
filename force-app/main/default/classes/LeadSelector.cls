public class LeadSelector {

    private static final String SALES_PROFILE_NAME = 'Standard User';

    public List<User> selectActiveSalesUsers() {
        return [
            SELECT Id, Lead_Assignment_Counter__c
            FROM User
            WHERE IsActive = TRUE AND Profile.Name = :SALES_PROFILE_NAME
            ORDER BY Lead_Assignment_Counter__c ASC
            LIMIT 100
        ];
    }

    public List<Lead> selectByEmails(Set<String> emails) {
        return [SELECT Id, Email, FirstName, LastName FROM Lead WHERE Email IN :emails];
    }
}
