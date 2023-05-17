*** Settings ***
Documentation    Test Suite to validate the backend API endpoints
Library          RequestsLibrary
Library   OperatingSystem
Library    Collections
Library    ../../resources/customPythonMethods.py


*** Variables ***
${BASE_URL}      http://13.235.114.103:8443
&{HEADERS}       Content-Type=application/json
${orderDataFilePath}    ${EXECDIR}${/}data/placeOrderMenu.json
${expectdMenuPayloadPath}    ${EXECDIR}${/}data/expectdMenuPayload.json

*** Test Cases ***
S1: Get List Of Products
    [Documentation]  Retrieve the list of all available products
    [Tags]           backend
    ${response} =   Get Request    ${BASE_URL}/api/menu
    Should Be Equal As Strings    ${response.status_code}    200
    ${actual_product_list}=  Set Variable    ${response.json()}
    log    ${actual_product_list}
    Should Not Be Empty    ${actual_product_list}
    ${json} =  Get file    ${expectdMenuPayloadPath}
    ${expectdMenuPayload} =  evaluate    json.loads('''${json}''')  json
    Compare Json Payloads   ${expectdMenuPayload}   ${actual_product_list}

S2: Get Menu Item Details By ID
    [Documentation]  Retrieve a single Item details
    [Tags]           backend
    ${response}=     Get Request    ${BASE_URL}/api/menu/1
    Should Be Equal As Strings    ${response.status_code}    200
    ${actual_product_list}=  Set Variable    ${response.json()}
    log    ${actual_product_list}
    Should Not Be Empty    ${actual_product_list}
    Dictionary Should Contain Item    ${actual_product_list}   name   Grilled Salmon

S3: Place An Order
    [Documentation]  Placing an order and verify it's added successfully
    [Tags]           backend
    ${json} =  Get file    ${orderDataFilePath}
    ${payload} =  evaluate    json.loads('''${json}''')  json
    ${response} =    Post Request    ${BASE_URL}/orders    data=${payload}    headers=${HEADERS}
    Should Be Equal As Strings    ${response.status_code}    200
    ${cart_item}=     Set Variable    ${response.json()}
    Should Not Be Empty    ${cart_item}
    Dictionary Should Contain Item    ${cart_item}   message   Your Order has been placed
    Should Not Be Empty    ${cart_item}[message]
    Should Not Be Equal   ${cart_item}[id]   ${EMPTY}

#Add Product To Cart
#    [Documentation]  Add a product to cart and verify it's added successfully
#    [Tags]           backend
#    ${payload}=      Create Dictionary    product=1
#    ${response}=     Post Request    ${BASE_URL}/cart/    data=${payload}    headers=${HEADERS}
#    Should Be Equal As Strings    ${response.status_code}    201
#    ${cart_item}=     Set Variable    ${response.json()}
#    Should Not Be Empty    ${cart_item}
#    Should Be Equal As Strings    ${cart_item.product.name}    Product 1
#    Should Be Equal As Strings    ${cart_item.product.price}   9.99
#
#Update Cart Quantity
#    [Documentation]  Update the quantity of an item in the cart
#    [Tags]           backend
#    ${payload}=      Create Dictionary    quantity=2
#    ${response}=     Put Request    ${BASE_URL}/cart/1/    data=${payload}    headers=${HEADERS}
#    Should Be Equal As Strings    ${response.status_code}    200
#
#Retrieve Cart Item Information
#    [Documentation]  Retrieve information about an item in the cart
#    [Tags]           backend
#    ${response}=     Get Request    ${BASE_URL}/cart/1/    headers=${HEADERS}
#    Should Be Equal As Strings    ${response.status_code}    200
#    ${cart_item}=     Set Variable    ${response.json()}
#    Should Not Be Empty    ${cart_item}
#    Should Be Equal As Strings    ${cart_item.product.name}    Product 1
#    Should Be Equal As Strings    ${cart_item.product.price}   9.99

*** Keywords ***
Get Request
    [Documentation]  Send a GET request to the specified API endpoint
    [Arguments]      ${url}
    Create Session   api_session    ${BASE_URL}
    ${response}=     GET On Session    api_session    ${url}    headers=${HEADERS}
    Log              ${response.content}
    [Return]         ${response}

Post Request
    [Documentation]  Send a POST request to the specified API endpoint with the given payload
    [Arguments]      ${url}    ${data}    ${headers}
    Create Session   api_session    ${BASE_URL}
    ${response}=     POST On Session    api_session    ${url}    json=${data}    headers=${headers}
    Log              ${response.content}
    [Return]         ${response}

Put Request
    [Documentation]  Send a PUT request to the specified API endpoint with the given payload
    [Arguments]      ${url}    ${data}    ${headers}
    Create Session   api_session    ${BASE_URL}
    ${response}=     PUT On Session    api_session    ${url}    json=${data}    headers=${headers}
    Log              ${response.content}
    [Return]         ${response}
