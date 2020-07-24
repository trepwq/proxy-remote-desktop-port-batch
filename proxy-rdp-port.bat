@echo off&PUSHD %~DP0 &TITLE VPN可访问远程桌面端口设置
mode con cols=90 lines=30&COLOR f0
fltmc>nul&&(goto :message)||(echo;请以管理员身份运行，按任意键退出 &&goto :end)

:message
cls
echo;本程序需在终端计算机上运行
echo;本程序会将VPN可访问端口映射到远程桌面的3389端口，并添加相应防火墙规则
echo;
echo;按任意键继续，或点击右上角X退出
pause>nul
goto :port3389check


:port3389check
set portnum=3389
for /f "tokens=3 delims=: " %%a in ('netstat -an') do (
if "%%a"=="%portnum%" (goto :input))
echo;&echo 未检测到3389端口，请检查远程桌面服务&echo 按任意键退出&goto :end


:input
cls
echo;请输入您的VPN可访问端口并按回车
set/p userinput=端口：
echo %userinput%|findstr /r /c:"^[0-9][0-9]*$">nul
if errorlevel 1 (echo 请检查您输入的端口，按任意键开始重新输入&pause>nul&goto :input) else (
if %userinput% leq 65535 (if %userinput% geq 10000 (goto :vpnportcheck) else (echo 请检查您输入的端口，按任意键开始重新输入&pause>nul&goto :input) ) else (echo 请检查您输入的端口，按任意键开始重新输入&pause>nul&goto :input))
goto :end

:vpnportcheck
set vpnportnum=%userinput%
for /f "tokens=3 delims=: " %%a in ('netstat -an') do (
if "%%a"=="%vpnportnum%" (echo 检测到您输入的端口已被占用，按任意键退出&goto :end))
goto :portproxy

:portproxy
cls
echo;***步骤1：添加端口映射***
echo;如果360天擎拦截，请选择“允许操作”
netsh interface portproxy add v4tov4  listenaddress=0.0.0.0 listenport=%userinput% connectaddress=127.0.0.1 connectport=3389
echo;
echo;***步骤2：添加防火墙规则***
echo;如果360天擎拦截，请选择“允许操作”
netsh advfirewall firewall add rule name="Allow VPN Remore Desktop" dir=in protocol=tcp localport=%userinput% action=allow >nul
echo;
echo;成功,按任意键退出...
goto :end

:end
pause>nul
