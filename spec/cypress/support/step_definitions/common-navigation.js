import { Given, When, Then } from "cypress-cucumber-preprocessor/steps";
import { parseArgs } from "./database";

Given("scenario {string} has been ran", (scenario) => cy.appScenario(scenario));

const pagePaths = {
  cookie: "/cookies",
  start: "/",
  accessibility: "/accessibility-statement",
  dashboard: "/dashboard",
  "edit preferred name": "/preferred-name/edit",
  "sign in": "/users/sign_in",
  "core induction programme index": "/providers",
  "core induction programme show": "/test-cip-1",
  "core induction programme year": "/test-cip-1/year-1",
  "core induction programme lesson new": "/test-cip-1/create-lesson",
  "core induction programme year edit": "/test-cip-1/year-1/edit",
  "core induction programme module": "/test-cip-1/year-1/spring-1",
  "core induction programme module edit": "/test-cip-1/year-1/spring-1/edit",
  "core induction programme lesson": "/test-cip-1/year-1/spring-1/topic-1",
  "core induction programme lesson edit":
    "/test-cip-1/year-1/spring-1/topic-1/edit",
  "core induction programme lesson part":
    "/test-cip-1/year-1/spring-1/topic-1/part-1",
  "core induction programme mentor materials": "/mentor-materials",
  "core induction programme mentor material new": "/mentor-materials/new",
  "core induction programme mentor material":
    "/test-cip-1/year-1/spring-1/topic-1/mentoring/1",
  "core induction programme mentor material edit":
    "/test-cip-1/year-1/spring-1/topic-1/mentoring/1/edit",
  "core induction programme mentor material part":
    "/test-cip-1/year-1/spring-1/topic-1/mentoring/1/part-1",
  "training and support": "/training-and-support",
  privacy: "/privacy-policy",
};

Given("I am on {string} page", (page) => {
  const path = pagePaths[page];
  cy.visit(path);
});

const ID_REGEX = /:([a-z_]+)/g;

Given("I am on {string} page with {}", (page, argsString) => {
  const args = parseArgs(argsString);
  const path = pagePaths[page].replace(ID_REGEX, (_, key) => args[key]);
  cy.visit(path);
});

Given("I am on {string} page without JavaScript", (page) => {
  const path = pagePaths[page];
  cy.visit(`${path}?nojs=nojs`);
});

When("I navigate to {string} page", (page) => {
  const path = pagePaths[page];
  cy.visit(path);
});

When("I navigate to {string} page with {}", (page, argsString) => {
  const args = parseArgs(argsString);
  const path = pagePaths[page].replace(ID_REGEX, (_, key) => args[key]);
  cy.visit(path);
});

const assertOnPage = (page) => {
  const path = pagePaths[page];

  if (!path) {
    throw new Error(`Path not found for ${page}`);
  }

  if (path.includes(":")) {
    const pathRegex = new RegExp(
      path.replace(/\//g, "\\/").replace(ID_REGEX, "[^/]+")
    );
    cy.location("pathname").should("match", pathRegex);
  } else {
    cy.location("pathname").should("equal", path);
  }
};

Then("I should be on {string} page", (page) => {
  assertOnPage(page);
});

Then("I should have been redirected to {string} page", (page) => {
  assertOnPage(page);
});
