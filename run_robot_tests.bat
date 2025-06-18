@echo off
REM Change directory to the workspace or project root
REM cd C:\Users\User\Downloads\Gourav\repos\robot-jenkins

REM Run Robot Framework tests with output in 'results' folder
robot --outputdir results tests\test1.robot

REM Optional: pause so you can see output when running manually
REM pause
