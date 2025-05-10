@REM Each all libraries into folder '/backend/libs'
@REM Iterate through all folders in '/backend/libs' and extract project names
for /d %%F in (backend/libs/*) do (
    set "projectName=%%~nF"
    echo Project Name: !projectName!
    
)

