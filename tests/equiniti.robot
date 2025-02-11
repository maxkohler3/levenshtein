*** Settings ***

Documentation          Test cases 
Library                QWeb
Suite Setup            Open Browser                about:blank          chrome
Suite Teardown         Close All Browsers

*** Variables ***


*** Test Cases ***
TC1
    GoTo            https://equiniti--qarel.sandbox.my.salesforce.com
    TypeText        Username    mkohler@copado.com
    TypeText        Password    Copado123$
    ClickText       Log In to Sandbox
    GoTo            https://equiniti--qarel.sandbox.lightning.force.com/lightning/r/Apttus_Config2__Order__c/a3tS8000000n36PIAQ/view
    ClickItem       Configure Products    

    UseTable        1

    VerifyText            Product Catalog             timeout=90s
    ClickText             ${productCategory1}
    Verifytext            ${productName1}     timeout=30s
    ClickElement          //label[@for\='#product-${productID1}']
    VerifyText            ${productName2}
    ClickElement          //label[@for\='#product-${productID2}']
    ClickText             Add to Cart                 anchor=Product Catalog
    clickelement          //md-icon[text()\='shopping_cart']
    ClickText             View Cart
    ClickElement          //md-icon[@class\='custom_dimension cart-grid-action-indication-icon']
    VerifyText            ${productOptionName2}         timeout=30s
    ClickElement          //label[contains(@for,'option-component--${productOptionID2}--')]
    sleep                 2s
    ClickText             Go to Pricing
    sleep                 5s

    ${date}               Get Current Date
    ${startdate}          Add Time To Date            ${date}                     0 days                      result_format=%m/%d/%Y
    Log To Console        ${startdate}
    Set Suite Variable    ${startdate}
    ${enddate}            Add Time To Date            ${date}                     364 days                    result_format=%m/%d/%Y
    Log To Console        ${enddate}

    #Validate Data

    Verifytext            ${productName1}                   anchor=Product
    Verifytext            USD 250.00000                 anchor=Net Price
    Verifytext            USD 250.00000                 anchor=List Price
    VerifyElement         //input[@title\='${startdate}']                         index=1
    VerifyElement         //input[@title\='${enddate}']                           index=1
    Verifytext            1.00000                     anchor=Selling Term
    VerifyElement         //dynamic-field[@title\='One Time']                     index=1

    Verifytext            ${productName2}        anchor=${productName1}
    Verifytext            USD 150.00000              anchor=Net Price
    Verifytext            USD 0.00000                 anchor=List Price
    VerifyElement         //input[@title\='${startdate}']                         index=2
    VerifyElement         //input[@title\='${enddate}']                           index=2
    Verifytext            1.00000                    anchor=Selling Term
    VerifyElement         //dynamic-field[@title\='One Time']                     index=2

    Verifytext            ${productOptionName2}         anchor=Admin & maintencance
    Verifytext            USD 150.00000             anchor=${productOptionName2}
    Verifytext            USD 150.00000             anchor=USD 0.00000
    VerifyElement         //input[@title\='${startdate}']                         index=3
    VerifyElement         //input[@title\='${enddate}']                           index=3
    Verifytext            1.00000                     anchor=One Time
    VerifyElement         //dynamic-field[@title\='One Time']                     index=3

    ClickText             Finalize
    VerifyField           Status                      Draft                       partial_match=True          timeout=90s
    Clickelement          //img[@alt\='Accept']
    VerifyField           Status                      Pending                     partial_match=True          timeout=90s
    ClickElement          //li[@title\='Order Line Items']
    VerifyText            ${productName1}
    VerifyText            ${productName2}
    VerifyText            ${productOptionName2}
    ClickText             Details                     anchor=Order Line Items
    ClickText             Edit Ready For Activation Date

    #TypeText              Date                        ${startdate}