@IsTest
public class TestDataFactory {

    private static final String STANDARD_USER_PROFILE = 'Standard User';
    private static final String DEFAULT_TIMEZONE = 'America/Los_Angeles';
    private static final String DEFAULT_LOCALE = 'en_US';
    private static final String DEFAULT_ENCODING = 'UTF-8';
    private static final String DEFAULT_LANGUAGE = 'en_US';

    public static List<User> createUsers(Integer count) {
        List<User> users = new List<User>();
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name = :STANDARD_USER_PROFILE LIMIT 1];

        for (Integer i = 0; i < count; i++) {
            users.add(
                new User(
                    FirstName = 'Test',
                    LastName = 'User' + i,
                    Email = 'testuser' + i + '@example.com',
                    Username = 'testuser' + i + System.currentTimeMillis() + '@leadmgmt.test',
                    Alias = 'tuser' + i,
                    ProfileId = standardProfile.Id,
                    TimeZoneSidKey = DEFAULT_TIMEZONE,
                    LocaleSidKey = DEFAULT_LOCALE,
                    EmailEncodingKey = DEFAULT_ENCODING,
                    LanguageLocaleKey = DEFAULT_LANGUAGE,
                    IsActive = true,
                    Lead_Assignment_Counter__c = 0
                )
            );
        }

        insert users;
        return users;
    }

    public static List<Lead> createLeads(Integer count) {
        List<Lead> leads = new List<Lead>();
        List<String> industries = new List<String>{ 'Technology', 'Finance', 'Healthcare' };
        List<String> titles = new List<String>{ 'VP Sales', 'Director Marketing', 'Manager Operations' };

        for (Integer i = 0; i < count; i++) {
            leads.add(
                new Lead(
                    FirstName = 'Test',
                    LastName = 'Lead' + i,
                    Company = 'Company' + i,
                    Email = 'lead' + i + System.currentTimeMillis() + '@example.com',
                    Industry = industries[Math.mod(i, industries.size())],
                    Title = titles[Math.mod(i, titles.size())],
                    NumberOfEmployees = (Math.mod(i, 2) == 0) ? 1500 : 800
                )
            );
        }

        return leads;
    }

    public static Lead createLead(String industry, String title, Integer employees) {
        return new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Email = 'test' + System.currentTimeMillis() + '@example.com',
            Industry = industry,
            Title = title,
            NumberOfEmployees = employees
        );
    }
}
