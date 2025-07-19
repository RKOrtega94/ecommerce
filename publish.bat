@echo off
setlocal enabledelayedexpansion

REM Change to the directory where the script is located
cd /d %~dp0

REM Iterate through each subdirectory in backend\libs
for /d %%D in (backend\libs\*) do (
    echo Processing directory: %%D

    REM Check for build.gradle or build.gradle.kts and run Gradle tasks
    if exist "%%D\lib\build.gradle" (
        echo Running Gradle tasks for project: %%~nxD
        pushd %%D
        call gradle lib:clean lib:build lib:publish --refresh-dependencies --no-daemon -x test
        popd
    ) else if exist "%%D\lib\build.gradle.kts" (
        echo Running Gradle tasks for project: %%~nxD
        pushd %%D
        call gradle lib:clean lib:build lib:publish --refresh-dependencies --no-daemon -x test
        popd
    )
)

endlocal
