Feature: Misc step definition meta tests
  The miscellanious step definitions should work

  Scenario: Should be able to load seed data
    Given seed data should be loaded
    And I am logged in as existing user with email "ambition-institute-early-career-teacher@example.com"
    Then "page body" should contain "Ambition Institute ECT User"
