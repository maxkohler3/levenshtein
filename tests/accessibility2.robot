*** Settings ***
Library    SeleniumLibrary
Library    AXELibrary

*** Variables ***
${URL}    https://www.example.com
${BROWSER}    chrome

*** Test Cases ***
Accessibility Test For Example Site
    Open Browser    ${URL}    ${BROWSER}
    Inject AXE Accessibility Script
    Run Accessibility Test
    Report Accessibility Violations
    Close Browser

*** Keywords ***
Inject AXE Accessibility Script
    Inject Axe JavaScript    https://cdn.jsdelivr.net/npm/axe-core@4.3.1/axe.min.js

Run Accessibility Test
    Execute Javascript    axe.run(function (err, results) { window.axeResults = results; })
    ${violations}=    Get Javascript Result    return window.axeResults.violations
    Run Keyword If    ${violations} != []    Fail    Accessibility violations found!

Report Accessibility Violations
    ${violations}=    Get Javascript Result    return window.axeResults.violations
    :FOR    ${violation}    IN    @{violations}
    \    Log    Violation: ${violation.id} - ${violation.description}
    \    :FOR    ${node}    IN    @{violation.nodes}
    \    \    Log    Node: ${node.html}
    \    \    Log    Impact: ${node.impact}
