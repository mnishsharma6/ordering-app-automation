*** Settings ***
Library           SeleniumLibrary
Library           Screenshot
Suite Setup       Open Browser    ${url}    ${browser}
Suite Teardown    Close Browser

*** Variables ***
${url}            https://d2yeesy3hd63ln.cloudfront.net
${browser}        chrome
${wait_time}      4s

*** Test Cases ***
Place Order Successfully
    [Documentation]    Test case to validate placing an order successfully
    [Tags]             Regression
    Open Home Page
    Select Product And Add To Cart
    Click Cart Icon
    Verify Item Is Added Successfully And Price Is Correct
    Click Checkout Button
    Verify Order Placed Successfully

*** Keywords ***
Open Home Page
    Maximize Browser Window
    Go To    ${url}
    Sleep   ${wait_time}
    Take Screenshot


Select Product And Add To Cart
    Click Element    xpath=/html/body/app-root/app-food-list/div/div/div[1]/div/div/button
    Sleep   ${wait_time}

Click Cart Icon
    Click Element    xpath=//*[@id="navbarNav"]/ul/li[2]/a
    Sleep   ${wait_time}

Verify Item Is Added Successfully And Price Is Correct
    ${item_name}=    Get Text    xpath=/html/body/app-root/app-shopping-cart/div/div/div/div[2]/table/tbody/tr/td[1]
    Should Not Be Empty    ${item_name}
    ${item_price}=    Get Text    xpath=/html/body/app-root/app-shopping-cart/div/div/div/div[2]/table/tbody/tr/td[2]
    Should Be Equal As Strings    ${item_price}    $23.99
    Sleep   2s
    Take Screenshot

Click Checkout Button
    Click Element    xpath=//*[text()='Checkout']
    Sleep   2s

Verify Order Placed Successfully
    Wait Until Page Contains    Your order has been placed successfully. Your order ID is
    Sleep   ${wait_time}
    Take Screenshot
