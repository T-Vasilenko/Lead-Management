public class LeadTriggerHandler extends TriggerHandler {

    protected override void beforeInsert() {
        LeadService.preventDuplicateLeads(Trigger.new);
        LeadService.calculateLeadScores(Trigger.new);
    }

    protected override void beforeUpdate() {
        LeadService.calculateLeadScores(Trigger.new);
    }

    protected override void afterInsert() {
        LeadService.assignLeadsToSalesTeam(Trigger.new);
    }
}
