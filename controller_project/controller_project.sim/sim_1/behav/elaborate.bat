@echo off
set xv_path=C:\\.Xilinx\\Vivado\\2016.4\\bin
call %xv_path%/xelab  -wto 63ba737099844c3a93b798f0ab6fe3c4 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip -L xpm --snapshot testvalues_behav xil_defaultlib.testvalues -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
