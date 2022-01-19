set service[0]=dmwappushservice
set service[1]=diagnosticshub.standardcollector.service
REM Disabling DiagTrack can prevent Xbox achievements
set service[2]=DiagTrack

set "x=0"

:SymLoop
if defined service[%x%] (
    call sc config "%%service[%x%]%%" start= disabled >nul 2>&1
    call sc stop "%%service[%x%]%%" >nul 2>&1
    call echo Service stopped and disabled: %%service[%x%]%%
    set /a "x+=1"
    GOTO :SymLoop
)
set service[1]=dmwappushservice
set service[2]=diagnosticshub.standardcollector.service

set "x=0"

:SymLoop
if defined service[%x%] (
    call sc config "%%service[%x%]%%" start= disabled >nul 2>&1
    call sc stop "%%service[%x%]%%" >nul 2>&1
    call echo Service stopped and disabled: %%service[%x%]%%
    set /a "x+=1"
    GOTO :SymLoop
)
