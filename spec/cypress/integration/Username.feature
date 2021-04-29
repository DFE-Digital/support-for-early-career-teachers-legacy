Feature: Changing username
  Users should be able to set and change their preferred name

  Scenario: Should be prompted to set username on first login
    Given user was created as "early_career_teacher" with email "ect@example.com" and full_name "Demo User" and account_created "false"
    And I am on "sign in" page
    When I type "ect@example.com" into "email input"
    And I click the submit button
    Then I should be on "create username" page

    When I type "Demo Username" into "username input"
    And I click the submit button
    Then "page heading" should contain "Welcome Demo Username"

  Scenario: Should be able to change username
    Given I am logged in as "early_career_teacher" with full_name "Charles Darwin"
    Then I should be on "dashboard" page
    And the page should be accessible
    And "page body" should contain "Charles Darwin"

    When I click on "edit username link"
    Then I should be on "edit username" page
    And the page should be accessible
    And percy should be sent snapshot

    When I type "Charlie" into "name input"
    And I click the submit button
    Then I should be on "dashboard" page
    And "page body" should contain "Charlie"
    And "page body" should not contain "Charles Darwin"

    When I click on "edit username link"
    And I clear "name input"
    And I click the submit button
    Then I should be on "dashboard" page
    And "page body" should not contain "Charlie"
    And "page body" should contain "Charles Darwin"
