// Heads up, this is NOT used in the Cucumber specs - see factory-bot.js
Cypress.Commands.add("login", (...traits) => {
  cy.appFactories([["create", "user", ...traits]])
    .as("userData")
    .then(([user]) => {
      if (traits.includes("admin")) {
        cy.visit(`/users/confirm-sign-in?login_token=${user.login_token}`);
        cy.get('[action="/users/sign-in-with-token"] [name="commit"]').click();
      } else {
        cy.visit("/users/sign_in");
        cy.get("[name*=email]").type(`${user.email}{enter}`);
      }
    });
});

Cypress.Commands.add("logout", () => {
  cy.get("#navigation").contains("Sign out").click();

  cy.location("pathname").should("eq", "/users/signed-out");
});

Cypress.Commands.add("clickCommitButton", () => {
  cy.get("[name=commit]").click();
});
