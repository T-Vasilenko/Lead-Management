public class LeadScoreCalculator {

    private static final Integer INDUSTRY_TECHNOLOGY_POINTS = 20;
    private static final Integer INDUSTRY_FINANCE_POINTS = 15;
    private static final Integer INDUSTRY_DEFAULT_POINTS = 5;

    private static final Integer TITLE_EXECUTIVE_POINTS = 20;
    private static final Integer TITLE_DIRECTOR_POINTS = 15;
    private static final Integer TITLE_MANAGER_POINTS = 10;
    private static final Integer TITLE_DEFAULT_POINTS = 5;

    private static final Integer EMPLOYEES_LARGE_POINTS = 20;
    private static final Integer EMPLOYEES_MEDIUM_POINTS = 10;
    private static final Integer EMPLOYEES_SMALL_POINTS = 5;

    private static final Integer LARGE_COMPANY_THRESHOLD = 1000;
    private static final Integer MEDIUM_COMPANY_THRESHOLD = 500;

    private static final Integer HOT_LEAD_THRESHOLD = 50;
    private static final Integer WARM_LEAD_THRESHOLD = 30;

    public static Integer calculateScore(Lead lead) {
        Integer score = 0;
        score += calculateIndustryScore(lead.Industry);
        score += calculateTitleScore(lead.Title);
        score += calculateCompanySizeScore(lead.NumberOfEmployees);
        return score;
    }

    public static String determineRating(Integer score) {
        if (score >= HOT_LEAD_THRESHOLD) {
            return 'Hot';
        } else if (score >= WARM_LEAD_THRESHOLD) {
            return 'Warm';
        }
        return 'Cold';
    }

    private static Integer calculateIndustryScore(String industry) {
        if (industry == 'Technology') {
            return INDUSTRY_TECHNOLOGY_POINTS;
        } else if (industry == 'Finance') {
            return INDUSTRY_FINANCE_POINTS;
        }
        return INDUSTRY_DEFAULT_POINTS;
    }

    private static Integer calculateTitleScore(String title) {
        if (String.isBlank(title)) {
            return TITLE_DEFAULT_POINTS;
        }

        String titleLower = title.toLowerCase();

        if (titleLower.contains('vp') || titleLower.contains('chief') || titleLower.contains('ceo')
            || titleLower.contains('cto') || titleLower.contains('cfo')) {
            return TITLE_EXECUTIVE_POINTS;
        } else if (titleLower.contains('director')) {
            return TITLE_DIRECTOR_POINTS;
        } else if (titleLower.contains('manager')) {
            return TITLE_MANAGER_POINTS;
        }
        return TITLE_DEFAULT_POINTS;
    }

    private static Integer calculateCompanySizeScore(Integer numberOfEmployees) {
        if (numberOfEmployees == null) {
            return EMPLOYEES_SMALL_POINTS;
        }

        if (numberOfEmployees > LARGE_COMPANY_THRESHOLD) {
            return EMPLOYEES_LARGE_POINTS;
        } else if (numberOfEmployees >= MEDIUM_COMPANY_THRESHOLD) {
            return EMPLOYEES_MEDIUM_POINTS;
        }
        return EMPLOYEES_SMALL_POINTS;
    }
}
