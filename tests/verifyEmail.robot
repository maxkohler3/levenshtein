*** Settings ***

Documentation          Test cases for verifying emails
Library                QWeb
Suite Setup            Open Browser                about:blank          chrome
Suite Teardown         Close All Browsers
Library                Collections
Library                ../resources/verifyEmail.py

*** Variables ***
${APPPASGMAIL}         #Stored in suite or robot varibale as hidden
${EMAIL}               maxrobotic2@gmail.com 

*** Test Cases ***
Get URL from Email
    [Tags]             url    email
    [Documentation]    Sample test to Open all URL available in an email
    ...                https://pypi.org/project/imap-tools/#search-criteria
    ${SUBJECT}=        Convert To String           something in the subject
    ${textInBody}=     Convert To String           something in the body
    @{links}=          Get Email Links Html        email=${EMAIL}       pwd=${APPPASSGMAIL}    subject=${SUBJECT}    inbody=${textInBody}
    FOR                ${link}                     IN                   @{links}
        Log To Console                             located a link: ${link}
        OpenWindow
        GoTo           ${link}
        # add steps here..
    END

Verify New Mail Exist
    [Tags]             url    email    verifyemail
    [Documentation]    Check if unread email exist based on something in the subject and body
    ${SUBJECT}=        Convert To String           something in the subject
    ${textInBody}=     Convert To String           something in the body
    ${test}=           Verify Email Exist          email=${EMAIL}       pwd=${APPPASSGMAIL}    subject=${SUBJECT}    inbody=${textInBody}