Feature: Login
  All users should be able to login in

  Scenario: Failed login: blank email
    Given I am on "sign in" page
    When I click the submit button
    Then "error summary" should contain "Enter an email address"
    And the page should be accessible
    And percy should be sent snapshot

  Scenario: Failed login: invalid email
    Given I am on "sign in" page
    When I type "invalid" into "email input"
    And I click the submit button
    Then "error summary" should contain "Enter an email address in the correct format, like name@school.org"
    And the page should be accessible
    And percy should be sent snapshot

  Scenario: Failed login: unknown email
    Given I am on "sign in" page
    When I type "nope@example.com" into "email input"
    And I click the submit button
    Then "error summary" should contain "Enter the email address your school used when they registered your account"
    And the page should be accessible
    And percy should be sent snapshot

  Scenario: ECT login
    Given user was created as "early_career_teacher" with email "ect@example.com" and full_name "Demo User" and account_created "false"
    And I am on "sign in" page
    When I type "ect@example.com" into "email input"
    And I click the submit button
    Then "page body" should contain "Welcome Demo User"

  Scenario: NQT plus one login
    Given user was created as "early_career_teacher" with email "nqt_plus_one@example.com" and full_name "Demo User" and account_created "false" and registration_completed "false" and cohort_year "2020"
    And I am on "sign in" page
    When I type "nqt_plus_one@example.com" into "email input"
    And I click the submit button
    Then "page body" should contain "Welcome Demo User"

  Scenario: Mentor login
    Given user was created as "mentor" with email "mentor@example.com" and full_name "Demo Mentor User" and account_created "false"
    And I am on "sign in" page
    When I type "mentor@example.com" into "email input"
    And I click the submit button
    Then "page body" should contain "Welcome Demo Mentor User"

