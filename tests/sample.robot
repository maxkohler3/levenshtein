*** Settings ***
Resource               ../resources/common.robot
#Resource               ../resources/locator.robot
# Library                ../resources/levenshtein_bridge.py
# Library                ../resources/dates.py
Library                QForce
Suite Setup            OpenBrowser  about:blank  chrome
Library                String
Library                DateTime
Suite Teardown         CloseAllBrowsers

 
*** Test Cases ***

Calculate diff using Levenshtein lib 
    [Tags]             TC02                        BEAU_Order_POC
    [Documentation]    BEAU Testing POC

    ${levi_result}=    Get Levenshtein Distance    Srijan  Vishisth


Days of Month Examples
    ${current_date}=        Get Current Date    exclude_millis=true    result_format=%m/%d/%Y

    ${first_day_of_month}=              Nth Day of Month    ${current_date}     nth_day=1                 date_format=%m/%d/%Y  result_format=%-m/%-d/%Y
    ${first-Day_of_last_month}=         Nth Day of Month    ${current_date}     nth_day=1    months=-1    date_format=%m/%d/%Y  result_format=%-m/%-d/%Y
    ${last_day_of_last_month}=          Nth Day of Month    ${current_date}     nth_day=-1   months=-1    date_format=%m/%d/%Y  result_format=%-m/%-d/%Y
    ${last_day_of_month_plus_2_years}=  Nth Day of Month    ${current_date}     nth_day=-1   months=23    date_format=%m/%d/%Y  result_format=%-m/%-d/%Y

Pendulum Examples
    ${now}           pendulum.now
    ${torontoDate}   Evaluate     $now.in_timezone("America/Toronto")
    ${formatDate}    Evaluate     $now.format('dddd DD MMMM YYYY')
    ${formatDate2}   Evaluate     $now.format('MM/DD/YYYY')
    ${year}          Evaluate     $now.year
    ${month}         Evaluate     $now.month 
    ${day}           Evaluate     $now.day 
    ${hour}          Evaluate     $now.hour 
    ${minute}        Evaluate     $now.minute 
    ${second}        Evaluate     $now.second
    ${convertDate}  Convert Date  ${torontoDate}  date_format=%m/%d/%Y   result_format=%-m/%-d/%Y