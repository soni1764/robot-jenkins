*** Settings ***
Library    SeleniumLibrary

Variables    ${EXECDIR}/config.yaml

*** Variables ***
${url}    ${app.base_url}
${chrome_options}    --headless --no-sandbox --disable-dev-shm-usage --disable-gpu --window-size=1920,1080


*** Keywords ***
Launch Application
    Log    ${url}
    Open Browser    ${url}    chrome    options=${chrome_options}
    Maximize Browser Window
    Sleep    2
    Title Should Be    Google