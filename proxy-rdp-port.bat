@echo off&PUSHD %~DP0 &TITLE 映射远程桌面端口设置
mode con cols=120 lines=30
fltmc>nul&&(goto :input)||(echo;请以管理员身份运行，按任意键退出 &&goto :end)

:input
cls
echo;本程序需在终端计算机上运行，本程序会将VPN可访问端口映射到远程桌面的3389端口，并添加相应防火墙规则
echo;
echo;请输入您的VPN端口并按回车
set/p userinput=端口：
if %userinput% leq 65535 (if %userinput% geq 10000 (goto :portproxy) else (echo 您输入的端口：%userinput% 不正确，按任意键开始重新输入&pause>nul&goto :input) ) else (echo 您输入的端口：%userinput% 不正确，按任意键开始重新输入&pause>nul&goto :input)
goto :end

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
