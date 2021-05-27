Feature: factory_bot helper meta tests
  Cucumber step definitions should define helpers to interact with factory_bot

  Scenario: Should be able to log in as a new user
    Given I am admin and logged in with full_name "Lance Schimmel"
    Then "page body" should contain "Lance Schimmel"

  Scenario: Should be able to log in as existing users
    Given user was created as "mentor" with email "user@example.com" and full_name "Micheal Kunze"
    And I am logged in as existing user with email "user@example.com"
    Then "page body" should contain "Micheal Kunze"
