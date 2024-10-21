*** Settings ***
Library                QForce
Library                DateTime
Library                Collections
Library                ../resources/smtp.py
Library                ../resources/verifyEmail.py
Library                OperatingSystem
Suite Setup            OpenBrowser                 About:blank               Chrome
Suite Teardown         CloseAllBrowsers


*** Variables ***
${user}      maxrobotic2@gmail.com            
${APPPASSGMAIL}
${sender}     maxrobotic2@gmail.com             
${subject}    
${recipients}  mkohler@copado.com           
${replyTo}           
${EMAIL}       maxrobotic2@gmail.com 


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
    ${SUBJECT}=        Convert To String           crt testing
    ${textInBody}=     Convert To String           Account \# abcd1234
    ${test}=           Verify Email Exist          email=${EMAIL}       pwd=${APPPASSGMAIL}    subject=${SUBJECT}    inbody=${textInBody}
    

Send Email
    [Documentation]    Uses environent variables from CRT cloud container.
    ${timestamp}=      Get Current Date
    ${body}=           Set Variable                Test email${timestamp}
    ${subject}=        Set Variable                Test email${timestamp}
    Send Email         ${subject}                  ${body}                   ${sender}              ${recipients}         ${user}           ${APPPASSGMAIL}

Send Reply Email
    ${timestamp}=      Get Current Date
    ${body}=           Set Variable                Test email${timestamp}
    ${subject}=        Set Variable                Test email${timestamp}
    
    #for example so email exist in inbox
    Send Email         ${subject}                  ${body}                   ${sender}              ${recipients}         ${user}           ${APPPASSGMAIL}
    Sleep              10s
    #Check if expected email exist in inbox
    ${test1}=          Verify Email Exist    email=${user}             pwd=${APPPASSGMAIL}    subject=${subject}    inbody=${body}
   
    #Fake reply email message with same subject and body and reply to address
    Reply Email        ${subject}                  ${body}                   ${sender}              ${replyTo}         ${user}           ${APPPASSGMAIL}

this is a testcase with attachment
    [Documentation]    dfdfdf
    ${timestamp}=      Get Current Date
    ${body}=           Set Variable                Test email${timestamp}
    ${subject}=        Set Variable                Test email${timestamp}
    
    #Filepath needs to be given as from the .py file
    @{files}=             Create List    ../tests/attachment.txt     
    send email Attachments     
    ...                ${subject}                  
    ...                ${body}                   
    ...                ${sender}              
    ...                ${recipients}         
    ...                ${user}           
    ...                ${APPPASSGMAIL}
    ...                ${files}


# and as last every python function is using this
# bodies = [msg.txt for msg in mailbox.fetch(AND(subject=subject, text=inbody, seen=False), reverse = True)]
# so it need to contain some text in the subject and contain some text in the body to find the email
# seen=false means it needs to be an unread email after reading it even with the api it will be marked as read so if you want to test it again just mark the email by hand to unread