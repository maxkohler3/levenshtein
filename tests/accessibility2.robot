*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}    https://example.com
${BROWSER}    chrome

*** Test Cases ***
Open Website And Verify Title
    Open Browser    ${URL}    ${BROWSER}
    Title Should Be    Example Domain
    Close Browser

*** Keywords ***
Title Should Be
    [Arguments]    ${expected_title}
    ${title}=    Get Title
    Should Be Equal As Strings    ${title}    ${expected_title}
