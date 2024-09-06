*** Settings ***
Library                   QWeb
Library                   QForce
Library                   String
Library                   DateTime 
Library                   Collections
Library                   RequestsLibrary
Library                   FakerLibrary
Library                   ExcelLibrary
Library                   levenshtein_bridge.py
Library                   dates.py
Library                   pendulum   #https://pendulum.eustace.io/docs/
 
*** Variables ***
${BROWSER}                chrome
${username}               crt-short@copado.com
${login_url}              https://slockard-dev-ed.lightning.force.com/          
${home_url}               ${login_url}/lightning/page/home
${api}                    https://slockard-dev-ed.my.salesforce.com/ 
${file}                   ${CURDIR}/**/files/account.json 


*** Keywords ***

Setup Browser
    Set Library Search Order                   QWeb    QForce    QVision
    Evaluate              random.seed()
    &{chrome_prefs}=    Create Dictionary
    ...    "profile.default_content_setting_values.notifications"=2
    ...    "autofill.profile_enabled"=false
    ...    "credentials_enable_service"=false
    Open Browser    about:blank    ${BROWSER}    options=--disable-notifications    prefs=${chrome_prefs}
    SetConfig             LineBreak                   ${EMPTY}               #\ue000
    SetConfig             DefaultTimeout              20s                    #sometimes salesforce is slow

End suite
    Set Library Search Order                          QWeb
    Close All Browsers
    DeleteAllCookies
    

Login
    [Documentation]       Login to Salesforce instance
    GoTo                  ${login_url}
    TypeText              Username                    ${username}             delay=1
    TypeText              Password                    ${password}
    ClickText             Log In
    ${isMFA}=  IsText     Verify Your Identity                          #Determines MFA is prompted
    IF  ${isMFA}                                                        #Conditional Statement for if MFA verification is required to proceed
        ${mfa_code}=    GetOTP    ${username}    ${secret}    ${password}
        TypeSecret      Code      ${mfa_code}
        ClickText       Verify
    END
    # Fill MFA
    

Home
    [Documentation]       Navigate to homepage, login if needed
    GoTo                  ${home_url}
    Sleep                 2
    ${login_status} =     IsText                      To access this page, you have to log in to Salesforce.    2
    Run Keyword If        ${login_status}             Login
    ClickText             Home
    VerifyTitle           Home | Salesforce
    Sleep                 2

Fill MFA
    ${isMFA}=  IsText     Verify Your Identity                            #Determines MFA is prompted
     IF   ${isMFA}                                                        #Conditional Statement for if MFA verification is required to proceed
          ${mfa_code}=    GetOTP    ${username}    ${MY_SECRET}    ${password}
          TypeSecret      Code      ${mfa_code}
          ClickText       Verify
    END

VerifyStage
    # Example of custom keyword with robot fw syntax
    [Documentation]       Verifies that stage given in ${text} is at ${selected} state; either selected (true) or not selected (false)
    [Arguments]           ${text}                     ${selected}=true
    VerifyElement         //a[@title\="${text}" and @aria-checked\="${selected}"]

Login As
    [Documentation]       Login As different persona. User needs to be logged into Salesforce with Admin rights
    ...                   before calling this keyword to change persona.
    ...                   Example:
    ...                   LoginAs    Chatter Expert
    [Arguments]           ${persona}
    ClickText             Setup
    ClickText             Setup for current app
    CloseWindow
    SwitchWindow          NEW
    TypeText              Search Setup                ${persona}             delay=2
    ClickText             User                        anchor=${persona}      delay=5    # wait for list to populate, then click
    VerifyText            Freeze                      timeout=45                        # this is slow, needs longer timeout          
    ClickText             Login                       anchor=Freeze          delay=1  

InsertRandomValue
    [Documentation]       This keyword accepts a character count, suffix, and prefix. It then types a random string into the given field.
    [Arguments]           ${field}                    ${charCount}=5              ${prefix}=                  ${suffix}=
    ${testRandom}=        Generate Random String      ${charCount}
    TypeText              ${field}                    ${prefix}${testRandom}${suffix}
    
NoData
    VerifyNoText          ${data}                     timeout=3                        delay=2

DeleteAccounts
    [Documentation]       RunBlock to remove all data until it doesn't exist anymore
    ClickText             ${data}
    ClickText             Show more actions
    ClickText             Delete
    VerifyText            Are you sure you want to delete this account?
    ClickText             Delete                      2
    VerifyText            Undo
    VerifyNoText          Undo
    ClickText             Accounts                    partial_match=False

DeleteLeads
    [Documentation]       RunBlock to remove all data until it doesn't exist anymore
    ClickText             ${data}
    ClickText             Show more actions
    ClickText             Delete
    VerifyText            Are you sure you want to delete this lead?
    ClickText             Delete                      2
    VerifyText            Undo
    VerifyNoText          Undo
    ClickText             Leads                    partial_match=False

    

Close All Salesforce Tabs
    HotKey                      shift                       w
    ${multiple_tabs}=           IsText                      Close all tabs?             5s
    IF                          ${multiple_tabs}
        ClickText               Close All
    END




Get Links
    [Documentation]      Gets all links from a page to a list.

    @{result}=           Create List
    ${link_elems}=       GetWebElement    //a

    FOR    ${link}    IN    @{link_elems}
        ${link_text}=       Evaluate      $link.text    
        Append To List      ${result}     ${link_text}
    END

    [return]    ${result}



Declare variables
    ${current_date}           Get Current Date          result_format=%m/%d/%Y-%H%M
    Set Suite Variable        ${account_Name}           Account ${current_date}
    Set Suite Variable        ${business_Name}          Business ${current_date} 
    Set Suite Variable        ${brand_Name}             Brand ${current_date}
    Set Suite Variable        ${opportunity_Name}       Opp ${current_date}

Get Record ID 
    ${url}=           GetUrl
    ${record_id}=     Evaluate    $url.split("/")[6]
    [Return]          ${record_id}


Pick Many
    [Documentation]         Opens the selector for provided label and selects multiple options
    ...                     Works with Purpose of Call multipicklist in the Intake page.
    ...                     Example usage:
    ...                     @{options}=                 Create List               General questions
    ...                     Pick Many                   Purpose of Call           @{options}
    [Arguments]             ${label}                    @{values}
    ${prev}=                SetConfig                   IsModalXPath              //label[text()\='${label}']/../div
    ClickElement            //span[@title\='Click to open the dropdown']/../input
    SetConfig               IsModalXPath                ${prev}
    FOR                     ${value}                    IN                        @{values}
        VerifyText          ${value}                    delay=1s
        ClickText           ${value}                    delay=1s
    END
    # Test steps
    #@{options}=                 Create List                 Seeking In Person Care      General questions
    #Pick Many                   Purpose of Call             @{options}

Calculate Day of Month
    [Arguments]        ${day}    ${months}
    ${current_date}=   Get Current Date    exclude_millis=true    result_format=%m/%d/%Y
    ${endDate}=        Nth Day of Month    ${current_date}     nth_day=${day}   months=${months}    date_format=%m/%d/%Y  result_format=%-m/%-d/%Y
    [Return]           ${endDate}