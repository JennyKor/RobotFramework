# -*- coding: utf-8 -*-
# ---
# jupyter:
#   jupytext:
#     text_representation:
#       extension: .robot
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.3.2
#   kernelspec:
#     display_name: Robot Framework
#     language: robotframework
#     name: robotkernel
# ---

*** Settings ***
Library   SeleniumLibrary
Library   String
#Jenny Korkeamäki

*** Variables ***
${departure}   Boston
${destination}   Cairo
${name}   Pate Postimies
${address}   123 Local St.
${city}   Yorkshire
${state}   Yorkington
${zip}   111555
${cccard}   Diner's Club
${ccnum}   3088 6666 5555 33
${ccmonth}   11
${ccyear}   2022

*** Test Cases ***
Open browser and go to blazedemo.com
    Open browser   http://blazedemo.com/
    Maximize browser window
    Page should contain   Welcome to the Simple Travel Agency!

*** Test Cases ***
Select departure and the destination
    Click element   xpath:/html/body/div[3]/form/select[1]
    Select from list by value   xpath:/html/body/div[3]/form/select[1]   ${departure}
    Click element   xpath:/html/body/div[3]/form/select[2]
    Select from list by value   xpath:/html/body/div[3]/form/select[2]   ${destination}
    Page should contain button   xpath:/html/body/div[3]/form/div/input
    Click button   xpath:/html/body/div[3]/form/div/input

*** Test Cases ***
Get flight count
    Page should contain   Flights from ${departure} to ${destination}
    ${hits} =   Get element count   xpath:/html/body/div[2]/table/tbody/tr[*]/td[1]/input
    Should be true   ${hits} >= 1

*** Test Cases ***
Get flight info and store it in variables
    ${flightnum} =   Get text   xpath:/html/body/div[2]/table/tbody/tr[1]/td[2]
    Set global variable   ${flightnum}
    ${airline} =   Get text   xpath:/html/body/div[2]/table/tbody/tr[1]/td[3]
    Set global variable   ${airline}
    ${price} =   Get text   xpath:/html/body/div[2]/table/tbody/tr[1]/td[6]
    ${price} =   Fetch from right   ${price}   $   #has to be removed otherwise sets value as the variable's name
    Set global variable   ${price}

*** Test Cases ***
Select flight, check if confirmation has the previous flight info and get the total cost
    Click button   xpath:/html/body/div[2]/table/tbody/tr[1]/td[1]/input
    ${flightnum} =   Catenate   Flight number:   ${flightnum}
    ${airline} =   Catenate   Airline:   ${airline}
    ${price} =   Catenate   Price:   ${price}
    Run keyword and continue on failure   Page should contain   ${flightnum}
    Run keyword and continue on failure   Page should contain   ${airline}
    Run keyword and continue on failure   Page should contain   ${price}
    ${totalcost} =   Get text   xpath:/html/body/div[2]/p[5]
    @{cost} =   Split string   ${totalcost}
    ${totalcost} =   Set variable   ${cost}[2]
    Set global variable   ${totalcost}

*** Test Cases ***
Fill in the passenger information and purchase the flight
    Click element   xpath://*[@id="inputName"]
    Input text   xpath://*[@id="inputName"]   ${name}
    Click element   xpath://*[@id="address"]
    Input text   xpath://*[@id="address"]   ${address}
    Click element   xpath://*[@id="city"]
    Input text   xpath://*[@id="city"]   ${city}
    Click element   xpath://*[@id="state"]
    Input text   xpath://*[@id="state"]   ${state}
    Click element   xpath://*[@id="zipCode"]
    Input text   xpath://*[@id="zipCode"]   ${zip}
    Click element   xpath://*[@id="cardType"]
    Select from list by label   xpath://*[@id="cardType"]   ${cccard}
    Click element   xpath://*[@id="creditCardNumber"]
    Input text   xpath://*[@id="creditCardNumber"]   ${ccnum}
    Click element   xpath://*[@id="creditCardMonth"]
    Input text   xpath://*[@id="creditCardMonth"]   ${ccmonth}
    Click element   xpath://*[@id="creditCardYear"]
    Input text   xpath://*[@id="creditCardYear"]   ${ccyear}
    Click element   xpath://*[@id="nameOnCard"]
    Input text   xpath://*[@id="nameOnCard"]   ${name}
    Click element   xpath://*[@id="rememberMe"]
    Click button   xpath:/html/body/div[2]/form/div[11]/div/input

*** Test Cases ***
Verify expiration date
    Page should contain   Thank you for your purchase today!
    ${expiration} =   Get text   xpath:/html/body/div[2]/div/table/tbody/tr[5]/td[2]
    ${month} =   Fetch from left   ${expiration}   /
    Convert to string   ${month}
    ${month} =   Strip string   ${month}
    ${year} =   Fetch from right   ${expiration}   /
    ${year} =   Convert to string   ${year}
    Run keyword and continue on failure   Should be equal   ${month}   ${ccmonth}
    Run keyword and continue on failure   Should be equal   ${year}   ${ccyear}

*** Test Cases ***
Verify total price and close browser
    ${totalamount}=   Get text   xpath:/html/body/div[2]/div/table/tbody/tr[3]/td[2]
    @{total} =   Split string   ${totalamount}
    ${totalamount} =   Set variable   ${total}[0]
    Run keyword and continue on failure   Should be equal   ${totalamount}   ${totalcost}
    Close browser
