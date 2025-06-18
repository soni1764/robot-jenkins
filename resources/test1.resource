#*** Settings ***
#Library    SeleniumLibrary
#
#Variables    ${EXECDIR}/config.yaml
#
#*** Variables ***
#${url}    ${app.base_url}
#${chrome_options}    --headless --no-sandbox --disable-dev-shm-usage --remote-debugging-port=9222
#
#
#*** Keywords ***
#Launch Application
#    Log    ${url}
#    Open Browser    ${url}    chrome    options=${chrome_options}
#    Maximize Browser Window
#    Sleep    2
#    Title Should Be    Google

*** Settings ***
Library           SeleniumLibrary

Variables         ${EXECDIR}/config.yaml

*** Variables ***
${url}            ${app.base_url}
@{chrome_args}    --headless    --no-sandbox    --disable-dev-shm-usage    --remote-debugging-port=9222

*** Keywords ***
Launch Application
    &{options}=    Create Dictionary    args=${chrome_args}
    &{caps}=       Create Dictionary    goog:chromeOptions=${options}
    Open Browser    ${url}    chrome    desired_capabilities=${caps}
    Maximize Browser Window
    Sleep    2
    Title Should Be    Google
