Feature: CIP change alert

  Background:
    Given seed data should be loaded

  Scenario: User selects to start now
    Given I am logged in as existing user with email "cip-change-early-career-teacher@example.com"
    And I am on "dashboard" page
    When I click on "start now button"
    Then I should be on "cip change alert start" page
    And I click on "continue button"
    Then I should be on "ambition year 1 show" page

    When I navigate to "dashboard" page
    And I click on "start now button"
    Then I should be on "ambition year 1 show" page

  Scenario: User selects to view guidance
    Given I am logged in as existing user with email "cip-change-early-career-teacher@example.com"
    And I am on "dashboard" page
    When I click on "link" containing "brief guide"
    Then I should be on "cip change alert guidance" page
    And I click on "continue button"
    Then I should be on "training and support" page

    When I navigate to "dashboard" page
    And I click on "link" containing "brief guide"
    Then I should be on "training and support" page

