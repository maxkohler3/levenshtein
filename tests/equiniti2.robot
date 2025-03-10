*** Settings ***
Library                QWeb
Library                String 
Library                QForce
Suite Setup            Open Browser                about:blank          chrome
Suite Teardown         Close All Browsers

*** Keywords ***
GetHeaderIndex
    [Documentation]
    [Arguments]                 ${header}
    ${header_index_full}=       GetAttribute                //div[@role\="columnheader" and contains(@title,"${header}")]//span[@id] | //div[@role\="columnheader"]//span[@title\="${header}"]    id
    RETURN                      ${header_index_full}

GetRowIndexByProduct
    [Documentation]    Returns the row index for a given product name
    [Arguments]        ${product_name}
    ${header_index_full}    GetHeaderIndex    Product
    ${header_index}=    Split String    ${header_index_full}    -
    ${rows}=    GetElementCount    //*[contains(@id,"${header_index}[0]-") and contains(@id,"-uiGrid-${header_index}[2]-cell")]
    FOR    ${index}    IN RANGE    ${rows}
        ${cell_text}=    GetText    //*[@id\="${header_index}[0]-${index}-uiGrid-${header_index}[2]-cell"]
        IF    '${cell_text}' == '${product_name}'    RETURN    ${index}
    END
    Fail    Product '${product_name}' not found in the grid

ClickCongaCell
    [Documentation]    Clicks a cell in the grid based on column header and product name
    [Arguments]        ${header}    ${product_name}
    ${header_index_full}    GetHeaderIndex    ${header}
    ${header_index}=    Split String    ${header_index_full}    -
    ${row}=    GetRowIndexByProduct    ${product_name}
    ClickElement    //*[@id\="${header_index}[0]-${row}-uiGrid-${header_index}[2]-cell"]   

GetCongaText
    [Documentation]    Gets text from a cell based on column header and product name
    [Arguments]        ${header}    ${product_name}
    ${header_index_full}    GetHeaderIndex    ${header}
    ${header_index}=    Split String    ${header_index_full}    -
    ${row}=    GetRowIndexByProduct    ${product_name}
    ${input}    IsElement    //*[@id\="${header_index}[0]-${row}-uiGrid-${header_index}[2]-cell"]//input
    IF    ${input}
        ${text}=    GetAttribute    //*[@id\="${header_index}[0]-${row}-uiGrid-${header_index}[2]-cell"]//input    title
    ELSE
        ${text}=    GetText    //*[@id\="${header_index}[0]-${row}-uiGrid-${header_index}[2]-cell"]
    END
    RETURN    ${text}

TypeCongaCell
    [Documentation]    Types text into a cell based on column header and product name
    [Arguments]        ${header}    ${product_name}    ${input_text}
    ${header_index_full}    GetHeaderIndex    ${header}
    ${header_index}=    Split String    ${header_index_full}    -
    ${row}=    GetRowIndexByProduct    ${product_name}
    TypeText    //*[@id\="${header_index}[0]-${row}-uiGrid-${header_index}[2]-cell"]//input    ${input_text}    click=True


*** Test Cases ***

TC1
    GoTo            https://equiniti--qarel.sandbox.my.salesforce.com
    TypeText        Username    mkohler@copado.com
    TypeText        Password    Copado123$
    ClickText       Log In to Sandbox
    GoTo            https://equiniti--qarel.sandbox.lightning.force.com/lightning/r/Apttus_Config2__Order__c/a3tS8000000n36PIAQ/view
    VerifyText      Dates & Billing Information
    ScrollTo        Configure Products   
    ClickItem       Configure Products    
    VerifyText      Payment Term   delay=3

    ${productName}=     GetCongaText       Product       Court Meeting Poll scrutiny
    ${productName2}=    GetCongaText       Product       Court Meeting Printing Fee
    ${startDate1}=      GetCongaText       Start Date    Court Meeting Poll scrutiny

    ClickCongaCell       Payment Term       ${productName}
    ClickText            Net 60 Days

    TypeCongaCell        Quantity           ${productName}    10
    TypeCongaCell        Quantity           ${productName2}   5

    ClickElement         //span[@class\="fa fa-search"]    parent=//*[@id\="${header_index}[0]-${row}-uiGrid-${header_index}[2]-cell"] 

# *** Keywords ***

# GetHeaderIndex
#     [Documentation]
#     [Arguments]                 ${header}
    # ${header_index_full}=       GetAttribute                //div[@role\="columnheader" and contains(@title,"${header}")]//span[@id] | //div[@role\="columnheader"]//span[@title\="${header}"]    id
#     RETURN                      ${header_index_full}

# ClickCongaCell
#     [Documentation]
#     [Arguments]                 ${header}                   ${row}
#     ${header_index_full}        GetHeaderIndex              ${header}
#     ${header_index}=            Split String                ${header_index_full}        -
#     ${row}=                     Evaluate                    int($row)-1
#     ClickElement                //*[@id\="${header_index}[0]-${row}-uiGrid-${header_index}[2]-cell"]

# GetCongaText
#     [Documentation]
#     [Arguments]                 ${header}                   ${row}
#     ${header_index_full}        GetHeaderIndex              ${header}
#     ${header_index}=            Split String                ${header_index_full}        -
#     ${row}=                     Evaluate                    int($row)-1
#     ${input}                    IsElement                   //*[@id\="${header_index}[0]-${row}-uiGrid-${header_index}[2]-cell"]//input
#     IF                          ${input}
#         ${text}=                GetAttribute                //*[@id\="${header_index}[0]-${row}-uiGrid-${header_index}[2]-cell"]//input                   title
#     ELSE
#         ${text}=                GetText                     //*[@id\="${header_index}[0]-${row}-uiGrid-${header_index}[2]-cell"]
#     END
#     RETURN                      ${text}

# TypeCongaCell
#     [Documentation]
#     [Arguments]                 ${header}                   ${row}        ${input_text}
#     ${header_index_full}        GetHeaderIndex              ${header}
#     ${header_index}=            Split String                ${header_index_full}        -
#     ${row}=                     Evaluate                    int($row)-1
#     TypeText                    //*[@id\="${header_index}[0]-${row}-uiGrid-${header_index}[2]-cell"]//input    ${input_text}   click=True


# *** Test Cases ***
#     GoTo            https://equiniti--qarel.sandbox.my.salesforce.com
#     TypeText        Username    mkohler@copado.com
#     TypeText        Password    Copado123$
#     ClickText       Log In to Sandbox
#     GoTo            https://equiniti--qarel.sandbox.lightning.force.com/lightning/r/Apttus_Config2__Order__c/a3tS8000000n36PIAQ/view
#     VerifyText      Dates & Billing Information
#     ScrollTo        Configure Products   
#     ClickItem       Configure Products    
#     VerifyText      Payment Term

#     ${example_text}=     GetCongaText                Product       2
#     ${example_text2}=    GetCongaText                Start Date    4
#     ClickCongaCell       Product                     3
#     TypeCongaCell        Quantity                    7             5
#     ClickCongaCell       Location                    

# Conga case
#     [tags]               conga
#     Appstate             Home
#     GoTo                 https://equiniti--qarel.sandbox.lightning.force.com/lightning/r/Apttus_Config2__Order__c/a3tS8000000n36PIAQ/view
#     VerifyText           Dates & Billing Information
#     ScrollTo             Configure Products
#     ClickItem            Configure Products
#     VerifyText           Payment Term

#     ${example_text}=     GetCongaText                Product       2
#     ${example_text2}=    GetCongaText                Start Date    4
#     ClickCongaCell       Product                     3
#     TypeCongaCell        Quantity                    7             5

#     VerifyText            Product Catalog             timeout=90s
#     ClickText             ${productCategory1}
#     Verifytext            ${productName1}     timeout=30s
#     ClickElement          //label[@for\='#product-${productID1}']
#     VerifyText            ${productName2}
#     ClickElement          //label[@for\='#product-${productID2}']
#     ClickText             Add to Cart                 anchor=Product Catalog
#     clickelement          //md-icon[text()\='shopping_cart']
#     ClickText             View Cart
#     ClickElement          //md-icon[@class\='custom_dimension cart-grid-action-indication-icon']
#     VerifyText            ${productOptionName2}         timeout=30s
#     ClickElement          //label[contains(@for,'option-component--${productOptionID2}--')]
#     sleep                 2s
#     ClickText             Go to Pricing
#     sleep                 5s

#     ${date}               Get Current Date
#     ${startdate}          Add Time To Date            ${date}                     0 days                      result_format=%m/%d/%Y
#     Log To Console        ${startdate}
#     Set Suite Variable    ${startdate}
#     ${enddate}            Add Time To Date            ${date}                     364 days                    result_format=%m/%d/%Y
#     Log To Console        ${enddate}

#     #Validate Data

#     Verifytext            ${productName1}                   anchor=Product
#     Verifytext            USD 250.00000                 anchor=Net Price
#     Verifytext            USD 250.00000                 anchor=List Price
#     VerifyElement         //input[@title\='${startdate}']                         index=1
#     VerifyElement         //input[@title\='${enddate}']                           index=1
#     Verifytext            1.00000                     anchor=Selling Term
#     VerifyElement         //dynamic-field[@title\='One Time']                     index=1

#     Verifytext            ${productName2}        anchor=${productName1}
#     Verifytext            USD 150.00000              anchor=Net Price
#     Verifytext            USD 0.00000                 anchor=List Price
#     VerifyElement         //input[@title\='${startdate}']                         index=2
#     VerifyElement         //input[@title\='${enddate}']                           index=2
#     Verifytext            1.00000                    anchor=Selling Term
#     VerifyElement         //dynamic-field[@title\='One Time']                     index=2

#     Verifytext            ${productOptionName2}         anchor=Admin & maintencance
#     Verifytext            USD 150.00000             anchor=${productOptionName2}
#     Verifytext            USD 150.00000             anchor=USD 0.00000
#     VerifyElement         //input[@title\='${startdate}']                         index=3
#     VerifyElement         //input[@title\='${enddate}']                           index=3
#     Verifytext            1.00000                     anchor=One Time
#     VerifyElement         //dynamic-field[@title\='One Time']                     index=3

#     ClickText             Finalize
#     VerifyField           Status                      Draft                       partial_match=True          timeout=90s
#     Clickelement          //img[@alt\='Accept']
#     VerifyField           Status                      Pending                     partial_match=True          timeout=90s
#     ClickElement          //li[@title\='Order Line Items']
#     VerifyText            ${productName1}
#     VerifyText            ${productName2}
#     VerifyText            ${productOptionName2}
#     ClickText             Details                     anchor=Order Line Items
#     ClickText             Edit Ready For Activation Date

#     #TypeText              Date                        ${startdate}