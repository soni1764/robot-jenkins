*** Settings ***
Library    SeleniumLibrary

Variables    ${EXECDIR}/config.yaml

*** Variables ***
${url}    ${app.base_url}


*** Keywords ***
Launch Application
    Log    ${url}
    Open Browser    ${url}    chrome
    Maximize Browser Window
    Sleep    2
    Title Should Be    Google