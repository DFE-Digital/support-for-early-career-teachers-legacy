Feature: ECT user interaction with Core Induction Programme
  Early Career Teachers should be able to access but not edit course content

  Background:
    Given I am logged in as "early_career_teacher" with id "53960d7f-1308-4de1-a56d-de03ea8e1d9c"
    And scenario "ect_cip" has been ran
    When I click on "link" containing "Go to your module materials"

  Scenario: ECT shouldn't be able to edit anything
    Then I should be on "core induction programme year" page
    And "link" containing "Edit year content" should not exist

    When I click on "link" containing "Test Course module"
    Then I should be on "core induction programme module" page
    And "link" containing "Edit module content" should not exist

    When I click on "link" containing "Work through the self-study material"
    Then I should be on "core induction programme lesson part" page
    And "link" containing "Edit lesson" should not exist
    And "link" containing "Edit lesson part" should not exist

  Scenario: Displaying lesson progress
    When I click on "link" containing "Test Course module"
    Then "tag component" should contain "to do"
    And percy should be sent snapshot

    When I click on "link" containing "Work through the self-study material"
    And I click on "No, I’d like to spend more time on this topic" label
    And I click the submit button
    Then "tag component" should contain "in progress"

    When I click on "link" containing "Work through the self-study material"
    And I click on "I have not started this topic yet and was just browsing the materials" label
    And I click the submit button
    Then "tag component" should contain "to do"

    When I click on "link" containing "Work through the self-study material"
    And I click on "Yes, I’ve understood the topic materials and am ready to put my learning into practice in the classroom" label
    And I click the submit button
    Then "tag component" should contain "complete"
