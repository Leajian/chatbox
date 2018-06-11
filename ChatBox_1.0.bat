@echo off

title ChatBox [Chat for Dropbox folders] ver 1.0 --- Type /h for help
::mode 110
MODE CON COLS=110 LINES=37
::color 6
color F1
setlocal enableDelayedExpansion

::setting as name the first 3 letters of your username
set "name=!username:~0,3!"

::core folders
IF not exist ChatBox (
	mkdir ChatBox
)
cd ChatBox

IF not exist chat_logs (
	mkdir chat_logs
)

::statistics
IF not exist statistic_files (
	mkdir statistic_files
	cd statistic_files
)

cd statistic_files

set "file=[%username%]times_opened"

IF not exist %file% (
	>%file% echo 1
)

for /f %%G IN (%file%) do set /A uses=%%G+1
>%file% echo !uses!

cd ..


:loop
cls

::create our chatbox
IF not exist chatbox.txt (

	echo Type your message...

	goto read
)

:: max lines buffer
for /f %%C in ('Find /V /C "" ^< chatbox.txt') do set count=%%C

IF {%count%}=={35} (
	::archive chat
	goto archive
)

::print previous contents of chat
type chatbox.txt

:read
::dashes
echo ______________________________________________________________________________________________________________
::echo( acts like newline and it's the fastest way to do so
echo(

::our main read command
set /p input=%name% ^> 

::extra commands
IF /i !input!==/h (
	cls
	
	echo(
	echo /h ^(this help^)
	echo /r ^(refresh content^)
	echo /c ^(clear chatbox^)
	echo /a ^(archive chat.log^)
	echo /rename ^(change your name^)
	echo /x ^(exit program^)
	echo(
	
	pause
	
	goto loop
)

IF /i !input!==/r (
	goto loop
)

IF /i !input!==/c (
	del chatbox.txt
	
	goto loop
)

IF /i !input!==/a (
	:archive
	cls

	IF exist chat.log (
		set "dmy=%date:~4,2%.%date:~7,2%.%date:~10,4%"
		set "timer=%time:~0,2%.%time:~3,2%.%time:~6,2%"
		IF not exist chat_logs\!dmy! (
			mkdir chat_logs\!dmy!
		)
		
		move /Y "chat.log" "chat_logs\!dmy!\[!timer!]chat.log" >nul
		del chatbox.txt
		
		echo Previous chat log was archived, see the log at !timer! on !dmy!
		
		goto read
	)
	
	echo NO chat.log found! Aborted...
	ping -n 3 localhost>nul
	
	goto loop
)

IF /i !input!==/rename (
	cls
	set /p name=Give your new name : 
	
	goto loop
)

IF /i !input!==/x (
	exit
)

:output
echo %name%: !input!>>chatbox.txt
echo [%time:~0,8%] %username%: !input!>>chat.log
)

goto loop