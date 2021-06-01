import { Given } from "cypress-cucumber-preprocessor/steps";

const parseArgs = (argsString) => {
  const args = {};
  argsString.split(/ and |, /).forEach((argString) => {
    const [, key, value] = /([^ ]+) "([^"]+)"/.exec(argString);
    args[key] = value;
  });

  return args;
};

expect(parseArgs('start_year "2021"')).to.deep.equal({ start_year: "2021" });
expect(parseArgs('a "a b" and b "b c"')).to.deep.equal({ a: "a b", b: "b c" });
expect(parseArgs('a "a b", b "b" and c "d"')).to.deep.equal({
  a: "a b",
  b: "b",
  c: "d",
});

Given("{word} was created", (factory) => {
  cy.appFactories([["create", factory]]);
});

Given("{word} was created with {}", (factory, args) => {
  cy.appFactories([["create", factory, parseArgs(args)]]);
});

Given("{word} was created as {string}", (factory, traits) => {
  cy.appFactories([["create", factory, ...traits.split(", ")]]);
});

Given("{word} was created as {string} with {}", (factory, traits, args) => {
  cy.appFactories([
    ["create", factory, ...traits.split(", "), parseArgs(args)],
  ]);
});

const login = (traits, args) => {
  const factoryArgs = ["create", "user", ...traits.split(", ")];

  if (args) {
    factoryArgs.push(parseArgs(args));
  }

  if (factoryArgs.includes("admin")) {
    cy.appFactories([factoryArgs])
      .as("userData")
      .then(([user]) => {
        cy.visit(`/users/confirm-sign-in?login_token=${user.login_token}`);
      });

    cy.get('[action="/users/sign-in-with-token"] [name="commit"]').click();
  } else {
    cy.appFactories([factoryArgs])
      .as("userData")
      .then(([user]) => {
        cy.visit("/users/sign_in");
        cy.get("[name*=email]").type(`${user.email}{enter}`);
      });
  }
};

Given("I am logged in as {string}", (traits) => login(traits));
Given("I am logged in as {string} with {}", (traits, args) =>
  login(traits, args)
);

Given("I am logged in as existing user with {}", (argsStr) => {
  const args = parseArgs(argsStr);

  const argsStrRails = Object.entries(args)
    .map(([key, value]) => `${key}: "${value}"`)
    .join(", ");

  cy.appEval(`User.find_by(${argsStrRails})`).then((user) => {
    cy.visit("/users/sign_in");
    cy.get("[name*=email]").type(`${user.email}{enter}`);
  });
});
