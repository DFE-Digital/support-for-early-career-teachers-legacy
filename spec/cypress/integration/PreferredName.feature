Feature: Changing preferred name
  Users should be able to set and change their preferred name

  Scenario: Should be able to change preferred name
    Given I am logged in as "early_career_teacher" with full_name "Charles Darwin"
    Then I should be on "dashboard" page
    And the page should be accessible
    And "page body" should contain "Charles Darwin"

    When I click on "edit name link"
    Then I should be on "edit preferred name" page
    And the page should be accessible
    And percy should be sent snapshot

    When I type "Charlie" into "name input"
    And I click the submit button
    Then I should be on "dashboard" page
    And "page body" should contain "Charlie"
    And "page body" should not contain "Charles Darwin"

    When I click on "edit name link"
    And I clear "name input"
    And I click the submit button
    Then I should be on "dashboard" page
    And "page body" should not contain "Charlie"
    And "page body" should contain "Charles Darwin"
