Feature: Mentor user interaction with Core Induction Programme
  Mentors should be able to access but not edit their mentee's course content

  Background:
    Given I am logged in as "mentor" with id "53960d7f-1308-4de1-a56d-de03ea8e1d9c"
    And scenario "mentor_cip" has been ran
    And I am on "dashboard" page

  Scenario: Mentor should be able to view ECT CIP
    When I click on "link" containing "Go to your mentee's module materials"
    Then I should be on "core induction programme year" page
    And "page body" should contain "Test Course module"
