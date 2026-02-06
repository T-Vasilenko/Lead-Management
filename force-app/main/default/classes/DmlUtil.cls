public class DmlUtil {

    public static Database.SaveResult[] insertRecords(List<SObject> records) {
        return Database.insert(records, AccessLevel.SYSTEM_MODE);
    }

    public static Database.SaveResult[] updateRecords(List<SObject> records) {
        return Database.update(records, AccessLevel.SYSTEM_MODE);
    }

    public static Database.DeleteResult[] deleteRecords(List<SObject> records) {
        return Database.delete(records, AccessLevel.SYSTEM_MODE);
    }
}
