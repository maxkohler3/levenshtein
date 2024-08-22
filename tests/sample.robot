*** Settings ***
#Resource               ../resources/common.robot
#Resource               ../resources/locator.robot
Library                ../resources/levenshtein_bridge.py
Library                QForce
Suite Setup            OpenBrowser  about:blank  chrome
Library                String
Library                DateTime
Suite Teardown         CloseAllBrowsers

 
*** Test Cases ***

TC02  
    [Tags]             TC02                        BEAU_Order_POC
    [Documentation]    BEAU Testing POC

    #logging in to System Admin
    ${levi_result}=    Get Levenshtein Distance    Srijan  Vishisth
