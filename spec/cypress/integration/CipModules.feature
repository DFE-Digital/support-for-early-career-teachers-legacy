Feature: Core Induction Programme modules
  Users should be able to view and sometimes edit cip modules.

  Scenario: Admins can edit modules
    Given I am logged in as "admin"
    And course_module was created
    And I am on "core induction programme module" page

    When I click on "link" containing "Edit module content"
    Then I should be on "core induction programme module edit" page
    And the page should be accessible
    And percy should be sent snapshot

    When I clear "title input"
    And I type "New module title" into "title input"
    And I clear "ect summary input"
    And I type "New test module content" into "ect summary input"
    And I click on "button" containing "See preview"
    Then "page heading" should contain "preview"
    And "govspeak content" should contain "New test module content"

    When I click on "button" containing "Save changes"
    Then "page body" should contain "Your changes have been saved"
    And "page body" should contain "Spring new module title"
    And the page should be accessible

  Scenario: The module title is replaced when a page header is added
    Given I am logged in as "admin"
    And course_module was created as "with_previous"
    And I am on "core induction programme module" page
    Then "page heading" should contain "Spring test previous module"

    When I click on "link" containing "Edit module content"
    Then I should be on "core induction programme module edit" page

    When I type "A page header" into "page header input"
    And I click on "button" containing "Save changes"
    Then "page body" should contain "A page header"
    And "page body" should not contain "Spring test course module"

  Scenario: ECTs can view but not edit modules
    Given I am logged in as "early_career_teacher" with id "53960d7f-1308-4de1-a56d-de03ea8e1d9c"
    And scenario "ect_cip" has been ran
    When I click on "link" containing "Start now"
    And I click on "skip guidance radio"
    Then I click on "continue button"

    And I click on "link" containing "Test Course module"
    Then I should be on "core induction programme module" page
    And "link" containing "Edit module content" should not exist
