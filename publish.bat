@echo off
setlocal enabledelayedexpansion

REM Change to the directory where the script is located
cd /d %~dp0

REM Iterate through each subdirectory in backend\libs that contains build.gradle or build.gradle.kts
for /d %%D in (backend\libs\*) do (
    echo Processing directory: %%D
    if exist "%%D\lib\build.gradle" (
        set "projectName=%%~nxD"
        echo Running Gradle tasks for project: !projectName!

        pushd %%D\lib
        call gradle clean build publish --refresh-dependencies --no-daemon
        popd
    ) else if exist "%%D\build.gradle.kts" (
        set "projectName=%%~nxD"
        echo Running Gradle tasks for project: !projectName!

        pushd %%D
        call gradle clean build publish --refresh-dependencies --no-daemon
        popd
    )
)

endlocal
