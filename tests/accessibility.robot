*** Settings ***
Library                SeleniumLibrary
Library                AxeLibrary
Suite Setup            OpenBrowser                 About:blank               Chrome
Suite Teardown         CloseAllBrowsers


*** Test Cases ***
Google Accessibility Test
   Open Browser    https://www.google.com/    Chrome
   
   # execute accessibility tests
   &{results}=    Run Accessibility Tests    google.json
   Log   Violations Count: ${results.violations}

   # log violation result to log.html
   Log Readable Accessibility Result    violations
   [Teardown]    Close All Browsers








# *** Settings ***
# Documentation                   https://www.deque.com/axe/
# Library                         SeleniumLibrary
# Library                         QVision    #Only for screenshot in the report
# Library                         AxeLibrary
# Library                         JSONLibrary
# Test Setup                      Open Browser    about:blank    chrome
# Test Template                   Test Page For Accessibility

# *** Test Cases ***            page
# Main Page                     ${baseUrl}
# Journey Planner               ${baseUrl}/transport-and-directions/getting-to-central-london/journey-planner
# Heathrow Parking              ${baseUrl}/transport-and-directions/heathrow-parking

# *** Keywords ***
# Test Page For Accessibility
#     [Arguments]                 ${page}
#     # Open Browser                ${page}                     Chrome
#     Set Selenium Timeout	       15 seconds
#     Go To                       ${page}
#     Sleep                       5
#     Click Element               //button[@id\="tealium_ensCloseBanner"]
#     Sleep                       5
#     Log Screenshot
#     # execute accessibility tests
#     # &{results}=                 Wait Until Keyword Succeeds	    15 sec	2 sec    Run Accessibility Tests     results.json
#     &{results}=                 Run Accessibility Tests     results.json
#     ${json_obj}=                Get Json Accessibility Result
#     Log                         Violations Count: ${results.violations}
#     Log                         Inapplicable Count: ${results.inapplicable}
#     Log                         Incomplete Count: ${results.incomplete}
#     Log                         Passes Count: ${results.passes}

#     # log violation result to log.html
#     Log Readable Accessibility Result                       violations
#     [Teardown]                  Close All Browsers




# *** Settings ***

# Documentation           New test suite
# # You can change imported library to "QWeb" if testing generic web application, not Salesforce.
# Library                 QForce 
# Library                 AxeLibrary
# Suite Setup             Open Browser    about:blank    chrome
# Suite Teardown          Close All Browsers

# *** Test Cases ***
# Accessibility Tests with Axe
#     GoTo    https://www.google.com
#     Setup Axe lib
#     &{results}=            Run Accessibility Tests     ${OUTPUTDIR}/google123.json   lib_instance=QForce



# *** Keywords ***
# Setup Axe lib
#     ${driver}=     ReturnBrowser
#     ${QForce}=     Get Library Instance    QForce
#     Evaluate       setattr($QForce, "driver", $driver)
#     Set Global Variable                    ${QForce}