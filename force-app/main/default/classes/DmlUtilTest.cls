@IsTest
private class DmlUtilTest {

    @IsTest
    static void insertRecords_validRecords_returnsSuccessResults() {
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name = 'Test Account 1'));
        accounts.add(new Account(Name = 'Test Account 2'));

        Test.startTest();
        Database.SaveResult[] results = DmlUtil.insertRecords(accounts);
        Test.stopTest();

        Assert.areEqual(2, results.size(), 'Should return two save results');
        Assert.isTrue(results[0].isSuccess(), 'First record should be inserted successfully');
        Assert.isTrue(results[1].isSuccess(), 'Second record should be inserted successfully');
    }

    @IsTest
    static void updateRecords_validRecords_returnsSuccessResults() {
        Account account = new Account(Name = 'Original Name');
        insert account;

        account.Name = 'Updated Name';

        Test.startTest();
        Database.SaveResult[] results = DmlUtil.updateRecords(new List<Account>{ account });
        Test.stopTest();

        Assert.areEqual(1, results.size(), 'Should return one save result');
        Assert.isTrue(results[0].isSuccess(), 'Record should be updated successfully');

        Account updatedAccount = [SELECT Name FROM Account WHERE Id = :account.Id];
        Assert.areEqual('Updated Name', updatedAccount.Name, 'Account name should be updated');
    }

    @IsTest
    static void deleteRecords_validRecords_returnsSuccessResults() {
        Account account = new Account(Name = 'To Delete');
        insert account;

        Test.startTest();
        Database.DeleteResult[] results = DmlUtil.deleteRecords(new List<Account>{ account });
        Test.stopTest();

        Assert.areEqual(1, results.size(), 'Should return one delete result');
        Assert.isTrue(results[0].isSuccess(), 'Record should be deleted successfully');

        List<Account> remaining = [SELECT Id FROM Account WHERE Id = :account.Id];
        Assert.areEqual(0, remaining.size(), 'Account should be deleted');
    }
}
