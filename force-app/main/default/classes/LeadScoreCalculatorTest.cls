@IsTest
private class LeadScoreCalculatorTest {

    @IsTest
    static void calculateScore_technologyVPLargeCompany_returns60Points() {
        Lead testLead = TestDataFactory.createLead('Technology', 'VP Sales', 1500);

        Test.startTest();
        Integer score = LeadScoreCalculator.calculateScore(testLead);
        Test.stopTest();

        Assert.areEqual(60, score, 'Technology + VP + Large company should equal 60 points');
    }

    @IsTest
    static void calculateScore_financeDirectorMediumCompany_returns40Points() {
        Lead testLead = TestDataFactory.createLead('Finance', 'Director of Sales', 750);

        Test.startTest();
        Integer score = LeadScoreCalculator.calculateScore(testLead);
        Test.stopTest();

        Assert.areEqual(40, score, 'Finance + Director + Medium company should equal 40 points');
    }

    @IsTest
    static void calculateScore_healthcareManagerSmallCompany_returns20Points() {
        Lead testLead = TestDataFactory.createLead('Healthcare', 'Manager Operations', 200);

        Test.startTest();
        Integer score = LeadScoreCalculator.calculateScore(testLead);
        Test.stopTest();

        Assert.areEqual(20, score, 'Healthcare + Manager + Small company should equal 20 points');
    }

    @IsTest
    static void calculateScore_nullTitleAndEmployees_returns15Points() {
        Lead testLead = TestDataFactory.createLead('Technology', null, null);

        Test.startTest();
        Integer score = LeadScoreCalculator.calculateScore(testLead);
        Test.stopTest();

        Assert.areEqual(30, score, 'Technology + null title + null employees should equal 30 points');
    }

    @IsTest
    static void calculateScore_chiefTitle_returns20TitlePoints() {
        Lead testLead = TestDataFactory.createLead('Healthcare', 'Chief Technology Officer', 100);

        Test.startTest();
        Integer score = LeadScoreCalculator.calculateScore(testLead);
        Test.stopTest();

        Assert.areEqual(30, score, 'Healthcare + Chief + Small company should equal 30 points');
    }

    @IsTest
    static void calculateScore_ceoTitle_returns20TitlePoints() {
        Lead testLead = TestDataFactory.createLead('Healthcare', 'CEO', 100);

        Test.startTest();
        Integer score = LeadScoreCalculator.calculateScore(testLead);
        Test.stopTest();

        Assert.areEqual(30, score, 'Healthcare + CEO + Small company should equal 30 points');
    }

    @IsTest
    static void calculateScore_ctoTitle_returns20TitlePoints() {
        Lead testLead = TestDataFactory.createLead('Healthcare', 'CTO', 100);

        Test.startTest();
        Integer score = LeadScoreCalculator.calculateScore(testLead);
        Test.stopTest();

        Assert.areEqual(30, score, 'Healthcare + CTO + Small company should equal 30 points');
    }

    @IsTest
    static void calculateScore_cfoTitle_returns20TitlePoints() {
        Lead testLead = TestDataFactory.createLead('Healthcare', 'CFO', 100);

        Test.startTest();
        Integer score = LeadScoreCalculator.calculateScore(testLead);
        Test.stopTest();

        Assert.areEqual(30, score, 'Healthcare + CFO + Small company should equal 30 points');
    }

    @IsTest
    static void calculateScore_unknownTitle_returns5TitlePoints() {
        Lead testLead = TestDataFactory.createLead('Healthcare', 'Intern', 100);

        Test.startTest();
        Integer score = LeadScoreCalculator.calculateScore(testLead);
        Test.stopTest();

        Assert.areEqual(15, score, 'Healthcare + Intern + Small company should equal 15 points');
    }

    @IsTest
    static void calculateScore_exactlyAtMediumThreshold_returns10EmployeePoints() {
        Lead testLead = TestDataFactory.createLead('Healthcare', 'Intern', 500);

        Test.startTest();
        Integer score = LeadScoreCalculator.calculateScore(testLead);
        Test.stopTest();

        Assert.areEqual(20, score, 'Healthcare + Intern + 500 employees should equal 20 points');
    }

    @IsTest
    static void calculateScore_exactlyAtLargeThreshold_returns10EmployeePoints() {
        Lead testLead = TestDataFactory.createLead('Healthcare', 'Intern', 1000);

        Test.startTest();
        Integer score = LeadScoreCalculator.calculateScore(testLead);
        Test.stopTest();

        Assert.areEqual(20, score, 'Healthcare + Intern + 1000 employees should equal 20 points (medium tier)');
    }

    @IsTest
    static void determineRating_highScore_returnsHot() {
        Test.startTest();
        String rating = LeadScoreCalculator.determineRating(55);
        Test.stopTest();

        Assert.areEqual('Hot', rating, 'Score of 55 should result in Hot rating');
    }

    @IsTest
    static void determineRating_exactlyAtHotThreshold_returnsHot() {
        Test.startTest();
        String rating = LeadScoreCalculator.determineRating(50);
        Test.stopTest();

        Assert.areEqual('Hot', rating, 'Score of 50 should result in Hot rating');
    }

    @IsTest
    static void determineRating_mediumScore_returnsWarm() {
        Test.startTest();
        String rating = LeadScoreCalculator.determineRating(40);
        Test.stopTest();

        Assert.areEqual('Warm', rating, 'Score of 40 should result in Warm rating');
    }

    @IsTest
    static void determineRating_exactlyAtWarmThreshold_returnsWarm() {
        Test.startTest();
        String rating = LeadScoreCalculator.determineRating(30);
        Test.stopTest();

        Assert.areEqual('Warm', rating, 'Score of 30 should result in Warm rating');
    }

    @IsTest
    static void determineRating_lowScore_returnsCold() {
        Test.startTest();
        String rating = LeadScoreCalculator.determineRating(20);
        Test.stopTest();

        Assert.areEqual('Cold', rating, 'Score of 20 should result in Cold rating');
    }

    @IsTest
    static void determineRating_zeroScore_returnsCold() {
        Test.startTest();
        String rating = LeadScoreCalculator.determineRating(0);
        Test.stopTest();

        Assert.areEqual('Cold', rating, 'Score of 0 should result in Cold rating');
    }
}
