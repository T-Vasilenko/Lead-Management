public class LeadService {

    private static LeadSelector selector = new LeadSelector();

    public static void assignLeadsToSalesTeam(List<Lead> newLeads) {
        List<User> salesUsers = selector.selectActiveSalesUsers();

        if (salesUsers.isEmpty()) {
            return;
        }

        Integer userIndex = 0;
        List<Lead> leadsToUpdate = new List<Lead>();
        List<User> usersToUpdate = new List<User>();

        for (Lead lead : newLeads) {
            User assignedUser = salesUsers[Math.mod(userIndex, salesUsers.size())];

            leadsToUpdate.add(new Lead(Id = lead.Id, OwnerId = assignedUser.Id));

            assignedUser.Lead_Assignment_Counter__c = (assignedUser.Lead_Assignment_Counter__c == null)
                ? 1
                : assignedUser.Lead_Assignment_Counter__c + 1;

            usersToUpdate.add(assignedUser);
            userIndex++;
        }

        if (!leadsToUpdate.isEmpty()) {
            DmlUtil.updateRecords(leadsToUpdate);
        }

        if (!usersToUpdate.isEmpty()) {
            DmlUtil.updateRecords(usersToUpdate);
        }
    }

    public static void calculateLeadScores(List<Lead> leads) {
        for (Lead lead : leads) {
            Integer score = LeadScoreCalculator.calculateScore(lead);
            lead.Lead_Score__c = score;
            lead.Rating = LeadScoreCalculator.determineRating(score);
        }
    }

    public static void preventDuplicateLeads(List<Lead> newLeads) {
        Set<String> emails = new Set<String>();

        for (Lead lead : newLeads) {
            if (String.isNotBlank(lead.Email)) {
                emails.add(lead.Email.toLowerCase());
            }
        }

        if (emails.isEmpty()) {
            return;
        }

        List<Lead> existingLeads = selector.selectByEmails(emails);
        Set<String> existingEmails = new Set<String>();

        for (Lead existingLead : existingLeads) {
            existingEmails.add(existingLead.Email.toLowerCase());
        }

        for (Lead newLead : newLeads) {
            if (String.isNotBlank(newLead.Email) && existingEmails.contains(newLead.Email.toLowerCase())) {
                newLead.addError('A lead with this email address already exists in the system.');
            }
        }
    }
}
