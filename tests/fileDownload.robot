*** Settings ***
Library         OperatingSystem
Library         Collections
Library         RequestsLibrary
Library         GitLibrary
Resource        ../resources/common.robot
Suite Setup     OpenBrowser  about:blank  chrome
Suite Teardown  CloseAllBrowsers
Test Teardown   Close All Excel Documents

*** Variables ***
${REPO_PATH}      /home/services/suite/files
${GIT_URL}        https://your-git-repo-url.git
${FILE_URL}       https://example.com/file-to-download.txt
${FILE_NAME}      file-to-download.txt
${COMMIT_MESSAGE} Added file during runtime

*** Test Cases ***
Download File And Commit To Git
    [Setup]    Clone Repository
    Download File
    Add File To Repository
    Commit Changes
    Push Changes
    [Teardown]    Cleanup Repository

*** Keywords ***
Clone Repository
    Run Process    git    clone    ${GIT_URL}    ${REPO_PATH}    shell=True
    Directory Should Exist    ${REPO_PATH}

Download File
    Create Directory    ${REPO_PATH}/downloads
    ${response}=    Get Request    ${FILE_URL}
    ${status_code}=    Get From Dictionary    ${response}    status_code
    Should Be Equal As Numbers    ${status_code}    200
    ${file_content}=    Get From Dictionary    ${response}    content
    Create File    ${REPO_PATH}/downloads/${FILE_NAME}    ${file_content}

Add File To Repository
    Run Process    git    add    ${REPO_PATH}/downloads/${FILE_NAME}    cwd=${REPO_PATH}    shell=True

Commit Changes
    Run Process    git    commit    -m "${COMMIT_MESSAGE}"    cwd=${REPO_PATH}    shell=True

Push Changes
    Run Process    git    push    origin    main    cwd=${REPO_PATH}    shell=True

Cleanup Repository
    Remove Directory    ${REPO_PATH}    recursive=True



*** Test Cases ***
Verify Products
    [Documentation]     Read product names from excel sheet and verify that those can be found from a webshop page
    [Tags]              excel    products    verify
    GoTo                ${webshop}
    VerifyText          Find your spirit animal

    # Open existing workbook
    ${document}=        Open Excel Document    ${excel_worksheet}    products

    # Start reading values from the second row, max number needs to be provided with offset
    ${product_names}=   Read Excel Column    col_num=1    max_num=6    row_offset=1    sheet_name=Fur

    # Check that we can find all the products from the web page
    FOR    ${item}    IN    @{product_names}
        VerifyText           ${item}
    END

Update Product Id
    [Documentation]     Update product id to an excel sheet and save changes
    [Tags]              excel    products    update
    GoTo                ${webshop}
    VerifyText          Find your spirit animal

    # Open existing workbook
    ${document}=        Open Excel Document    ${excel_worksheet}    products

    # Create new unique product id
    ${new_id}=          Generate Random String    length=6    chars=[NUMBERS]

    # Get the current product id
    ${current_id}=      Read Excel Cell    row_num=2    col_num=2    sheet_name=Fur

    # Write new product id to the excel
    Write Excel Cell    row_num=2    col_num=2    value=${new_id}    sheet_name=Fur

    # Check that new value was updated to excel
    ${updated_id}=      Read Excel Cell    row_num=2    col_num=2    sheet_name=Fur
    Should Be Equal As Strings    ${new_id}    ${updated_id}

    # Save changes to excel and commit to git
    Save Excel Document  ${excel_worksheet}
    Commit And Push     ${excel_worksheet}     ${git_branch}