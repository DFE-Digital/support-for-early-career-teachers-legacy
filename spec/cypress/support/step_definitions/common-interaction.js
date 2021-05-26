import { When, Then } from "cypress-cucumber-preprocessor/steps";

const inputs = {
  "email input": "input[name*=email]",
  "name input": '[name*="name"]',
  "title input": '[name*="title"]',
  "year title input": '[name*="[title]"]',
  "mentor year title input": '[name*="mentor_title"]',
  "content input": '[name*="content"]',
  "ect summary input": '[name*="ect_summary"]',
  "mentor summary input": '[name*="mentor_summary"]',
  "time input": '[name*="time"]',
  "cookie consent radio": '[name="cookies_form[analytics_consent]"]',
};

const links = {
  link: "a",
  "edit name link": '[data-test="edit-name"]',
};

const elements = {
  ...inputs,
  ...links,
  "page body": "main",
  "page heading": "h1",
  "cookie banner": ".js-cookie-banner",
  "phase banner": ".govuk-phase-banner",
  "govspeak content": ".govuk-govspeak",
  button: "button,input[type=submit],input[type=button]",
  "tag component": ".govuk-tag",
  "service name in navigation": '[data-test="service-name"]',
  "service navigation item": ".govuk-header__navigation-item",
  "error summary": ".govuk-error-summary",
};

const get = (element) => cy.get(elements[element] || element);

When("I set {string} to {string}", (element, value) => {
  get(element).get(`[value="${value}"]`).click();
});

When("I clear {string}", (element) => {
  get(element).clear();
});

When("I type {string} into {string}", (value, element) => {
  get(element).type(value);
});

When("I click on {string}", (element) => {
  get(element).click();
});

When("I click on {string} containing {string}", (element, containing) => {
  get(element).contains(containing).click();
});

When("I click on {string} label", (text) => {
  cy.get("label").contains(text).click();
});

When("I click the submit button", () => {
  cy.get("[name=commit]").click();
});

When("I click the back link", () => {
  cy.clickBackLink();
});

Then("{string} should be unchecked", (element) => {
  get(element).should("not.be.checked");
});

Then("{string} with value {string} is checked", (element, value) => {
  get(element).get(`[value="${value}"]`).should("be.checked");
});

Then("{string} should have value {string}", (element, value) => {
  get(element).should("have.value", value);
});

Then("{string} should contain {string}", (element, value) => {
  get(element).should("contain", value);
});

Then("{string} should not contain {string}", (element, value) => {
  get(element).should("not.contain", value);
});

Then("{string} should be hidden", (element) => {
  get(element).should("not.be.visible");
});

Then("{string} should exist", (element) => {
  get(element).should("exist");
});

Then("{string} containing {string} should exist", (element, text) => {
  get(element).contains(text).should("exist");
});

Then("{string} should not exist", (element) => {
  get(element).should("not.exist");
});

Then("{string} containing {string} should not exist", (element, text) => {
  get(element).contains(text).should("not.exist");
});

Then("{string} label should be checked", (text) => {
  cy.get("label")
    .contains(text)
    .invoke("attr", "for")
    .then((inputId) => {
      if (!inputId) {
        throw new Error("for not available on this label");
      }

      cy.get(`#${inputId}`).should("be.checked");
    });
});

Then("{string} label should be unchecked", (text) => {
  cy.get("label")
    .contains(text)
    .invoke("attr", "for")
    .then((inputId) => {
      if (!inputId) {
        throw new Error("for not available on this label");
      }

      cy.get(`#${inputId}`).should("not.be.checked");
    });
});
