Feature: User dashboards
  All users should see a dashboard after logging in

  Scenario: ECT Dashboard
    Given I am logged in as "early_career_teacher" with full_name "Charles Darwin"
    And I am on "dashboard" page
    Then "page body" should contain "Welcome Charles Darwin"
    And the page should be accessible
    And percy should be sent snapshot

  Scenario: Mentor Dashboard
    Given I am logged in as "mentor" with full_name "Some Mentor"
    And I am on "dashboard" page
    Then "page body" should contain "Welcome Some Mentor"
    And the page should be accessible
    And percy should be sent snapshot
