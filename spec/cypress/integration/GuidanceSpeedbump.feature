Feature: Guidance Speedbump
  Guidance speedbump for first-time ECT and Mentors

  Background:
    Given seed data should be loaded

  Scenario: First-time ECT user taken to guidance speedbump
    Given I am logged in as existing user with email "ambition-institute-early-career-teacher@example.com"
    And I am on "dashboard" page
    When I click on "start now button"
    Then I should be on "guidance speedbump" page

  Scenario: ECT selects to view guidance
    Given I am logged in as existing user with email "ambition-institute-early-career-teacher@example.com"
    And I am on "guidance speedbump" page
    When I click on "view guidance radio"
    And I click on "continue button"
    Then I should be on "training and support" page
    And "page body" should contain "Information about training and support"

  Scenario: ECT selects not to view guidance
    Given I am logged in as existing user with email "ambition-institute-early-career-teacher@example.com"
    And I am on "guidance speedbump" page
    When I click on "skip guidance radio"
    And I click on "continue button"
    Then I should be on "ambition year 1 show" page

  Scenario: Mentor selects to view guidance
    Given I am logged in as existing user with email "ambition-institute-mentor@example.com"
    And I am on "guidance speedbump" page
    When I click on "view guidance radio"
    And I click on "continue button"
    Then I should be on "training and support" page
    And "page body" should contain "Mentoring early career teachers"

  Scenario: Mentor selects not to view guidance
    Given I am logged in as existing user with email "ambition-institute-mentor@example.com"
    And I am on "guidance speedbump" page
    When I click on "skip guidance radio"
    And I click on "continue button"
    Then I should be on "ambition year 1 show" page

  Scenario: ECT only hits guidance speedbump once
    Given I am logged in as existing user with email "ambition-institute-early-career-teacher@example.com"
    And I am on "dashboard" page
    When I click on "start now button"
    Then I should be on "guidance speedbump" page
    When I click on "skip guidance radio"
    And I click on "continue button"
    Then I should be on "ambition year 1 show" page
    When I click on "service name in navigation"
    And I click on "start now button"
    Then I should be on "ambition year 1 show" page

  Scenario: Mentor only hits guidance speedbump once
    Given I am logged in as existing user with email "ambition-institute-mentor@example.com"
    And I am on "dashboard" page
    When I click on "start now button"
    Then I should be on "guidance speedbump" page
    When I click on "skip guidance radio"
    And I click on "continue button"
    Then I should be on "ambition year 1 show" page
    When I click on "service name in navigation"
    And I click on "start now button"
    Then I should be on "ambition year 1 show" page

  Scenario: ECT does not hit speedbump if they have already read the guidance
    Given I am logged in as existing user with email "ambition-institute-early-career-teacher@example.com"
    And I am on "dashboard" page
    Then I click on "link" containing "brief guide"
    Then I click on "service name in navigation"
    And I am on "dashboard" page
    When I click on "start now button"
    Then I should be on "ambition year 1 show" page

  Scenario: Mentor does not hit speedbump if they have already read the guidance
    Given I am logged in as existing user with email "ambition-institute-mentor@example.com"
    And I am on "dashboard" page
    Then I click on "link" containing "this summary"
    Then I click on "service name in navigation"
    And I am on "dashboard" page
    When I click on "start now button"
    Then I should be on "ambition year 1 show" page





