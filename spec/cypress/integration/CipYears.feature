Feature: Core Induction Programme years
  Users should be able to view and sometimes edit cip years.

  Scenario: Admins can edit years
    Given core_induction_programme was created as "with_course_year" with id "a4dc302c-ab71-4d7b-a10a-3116a778e8d5"
    And I am admin and logged in
    And I am on "core induction programme show" page with id "a4dc302c-ab71-4d7b-a10a-3116a778e8d5"

    When I click on "link" containing "Edit year content"
    Then I should be on "core induction programme year edit" page
    And the page should be accessible
    And percy should be sent snapshot

    When I clear "title input"
    And I type "New test title" into "year title input"
    And I clear "content input"
    And I type "New test content" into "content input"
    And I click on "button" containing "See preview"
    Then "page heading" should contain "preview"
    And "govspeak content" should contain "New test content"

    When I click on "button" containing "Save changes"
    Then "page body" should contain "Your changes have been saved"
    Then "page body" should contain "New test content"
    And the page should be accessible

  Scenario: ECTs can view but not edit years
    Given I am logged in as "early_career_teacher" with id "53960d7f-1308-4de1-a56d-de03ea8e1d9c"
    And scenario "ect_cip" has been ran

    When I click on "link" containing "Go to your module materials"
    Then I should be on "core induction programme year" page
    And "page body" should contain "Test Course year"
    And "page body" should not contain "Mentor title"
    And "link" containing "Edit year content" should not exist

  Scenario: Mentors can view but not edit years
    Given I am logged in as "mentor" with id "53960d7f-1308-4de1-a56d-de03ea8e1d9c"
    And scenario "mentor_cip" has been ran
    And I am on "dashboard" page

    When I click on "start now button"
    Then I should be on "core induction programme year" page
    And "page body" should contain "Mentor title"
    And "page body" should not contain "Test Course year"
    And "page body" should contain "Test Course module"
    And "link" containing "Edit year content" should not exist
