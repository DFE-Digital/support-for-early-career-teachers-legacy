Feature: Login
  All users should be able to login in

  Scenario: Failed login
    Given I am on "sign in" page
    When I type "nope@example.com" into "email input"
    And I click the submit button
    Then "error summary" should contain "Enter the email address your school used when they registered your account"
    And "service name in navigation" should contain "Support for early career teachers"
    And the page should be accessible
    And percy should be sent snapshot

  Scenario: ECT login
    Given user was created as "early_career_teacher" with email "ect@example.com" and full_name "Demo User" and account_created "false"
    And I am on "sign in" page
    When I type "ect@example.com" into "email input"
    And I click the submit button
    Then I should be on "create username" page

    When I click the submit button
    Then "page heading" should contain "Welcome Demo User"
    And "service name in navigation" should contain "Support for early career teachers"

  Scenario: Mentor login
    Given user was created as "mentor" with email "mentor@example.com" and full_name "Demo Mentor User" and account_created "false"
    And I am on "sign in" page
    When I type "mentor@example.com" into "email input"
    And I click the submit button
    Then I should be on "create username" page

    When I click the submit button
    Then "page heading" should contain "Welcome Demo Mentor User"
    And "service name in navigation" should contain "Mentoring for early career teachers"

