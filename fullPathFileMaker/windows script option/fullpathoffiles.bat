cd %1
for /F "tokens=*" %%A in ('dir /b/a-d') do @echo %%~dpnxA && @echo %%~dpnxA >> %~dp0myfile.txt
@echo File created.
cd %~dp0
