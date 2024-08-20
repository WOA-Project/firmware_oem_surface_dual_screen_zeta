@echo off

echo.
echo.  _______        __  _____      _                  _             
echo. ^|  ___\ \      / / ^| ____^|_  _^| ^|_ _ __ __ _  ___^| ^|_ ___  _ __ 
echo. ^| ^|_   \ \ /\ / /  ^|  _^| \ \/ / __^| '__/ _` ^|/ __^| __/ _ \^| '__^|
echo. ^|  _^|   \ V  V /   ^| ^|___ ^>  ^<^| ^|_^| ^| ^| ^(_^| ^| ^(__^| ^|^| ^(_^) ^| ^|   
echo. ^|_^|      \_/\_/    ^|_____/_/\_\\__^|_^|  \__,_^|\___^|\__\___/^|_^|   
echo.                                                                 

REM OEMC1 Root Key Hash
set RKH=34046EF5E08C14E01BE8883BFBE0E5C31A8E407B5B3B98C88F8A86C8D98C1235

echo.
echo Target: OEMC1
echo SoC   : SM8350
echo RKH   : %RKH% (Microsoft Andromeda Attestation PCA 2017) (From: 11/1/2017 To: 11/1/2032)
echo.

echo Checking MBN files validity... (This may take a while!)

for /f %%f in ('dir /b /s extracted\*.mbn') do (
    call :checkRKH %%f
)

echo Checking ELF files validity... (This may take a while!)

for /f %%f in ('dir /b /s extracted\*.elf') do (
    call :checkRKH %%f
)

echo Checking BIN files validity... (This may take a while!)

for /f %%f in ('dir /b /s extracted\*.bin') do (
    call :checkRKH %%f
)

echo Checking IMG files validity... (This may take a while!)

for /f %%f in ('dir /b /s extracted\*.img') do (
    call :checkRKH %%f
)

echo Cleaning up Output Directory...
rmdir /Q /S output

echo Cleaning up PIL Squasher Directory...
rmdir /Q /S pil-squasher

echo Cloning PIL Squasher...

git clone https://github.com/linux-msm/pil-squasher

echo Building PIL Squasher...

cd pil-squasher
bash.exe -c make
cd ..

mkdir output
mkdir output\Subsystems

mkdir output\Subsystems\ADSP
mkdir output\Subsystems\ADSP\ADSP

echo Converting Analog DSP Image...
bash.exe -c "./pil-squasher/pil-squasher ./output/Subsystems/ADSP/qcadsp8350.mbn ./extracted/modem/image/adsp.mdt"

echo Copying ADSP Protection Domain Registry Config files...
xcopy /qchky /-i extracted\modem\image\adspr.jsn output\Subsystems\ADSP\adspr.jsn
xcopy /qchky /-i extracted\modem\image\adspua.jsn output\Subsystems\ADSP\adspua.jsn

echo Copying ADSP lib files...
xcopy /qcheriky extracted\vendor\lib\rfsa\adsp output\Subsystems\ADSP\ADSP
xcopy /qcheriky extracted\vendor\lib64\rfsa\adsp output\Subsystems\ADSP\ADSP
xcopy /qcheriky extracted\dsp\adsp output\Subsystems\ADSP\ADSP

echo Generating ADSP FASTRPC INF Configuration...
tools\SuBExtInfUpdater-ADSP.exe output\Subsystems\ADSP\ADSP > output\Subsystems\ADSP\inf_configuration.txt

mkdir output\Subsystems\CDSP
mkdir output\Subsystems\CDSP\CDSP

echo Converting Compute DSP Image...
bash.exe -c "./pil-squasher/pil-squasher ./output/Subsystems/CDSP/qccdsp8350.mbn ./extracted/modem/image/cdsp.mdt"

echo Copying CDSP Protection Domain Registry Config files...
xcopy /qchky /-i extracted\modem\image\cdspr.jsn output\Subsystems\CDSP\cdspr.jsn

echo Copying CDSP lib files...
xcopy /qcheriky extracted\dsp\cdsp output\Subsystems\CDSP\CDSP

echo Generating CDSP FASTRPC INF Configuration...
tools\SuBExtInfUpdater-CDSP.exe output\Subsystems\CDSP\CDSP > output\Subsystems\CDSP\inf_configuration.txt

mkdir output\Subsystems\SLPI
mkdir output\Subsystems\SLPI\SDSP

echo Converting Sensor Low Power Interface DSP Image...
bash.exe -c "./pil-squasher/pil-squasher ./output/Subsystems/SLPI/qcslpi8350.mbn ./extracted/modem/image/slpi.mdt"

echo Copying SDSP Protection Domain Registry Config files...
xcopy /qchky /-i extracted\modem\image\slpir.jsn output\Subsystems\SLPI\slpir.jsn
xcopy /qchky /-i extracted\modem\image\slpius.jsn output\Subsystems\SLPI\slpius.jsn

echo Copying SDSP lib files...
xcopy /qcheriky extracted\dsp\sdsp output\Subsystems\SLPI\SDSP

echo Generating SDSP FASTRPC INF Configuration...
tools\SuBExtInfUpdater-SDSP.exe output\Subsystems\SLPI\SDSP > output\Subsystems\SLPI\inf_configuration.txt

mkdir output\Subsystems\EVASS

xcopy /qchky /-i extracted\vendor\firmware\evass.mbn output\Subsystems\EVASS\evass.mbn

mkdir output\Subsystems\ICP

xcopy /qchky /-i extracted\vendor\firmware\CAMERA_ICP.elf output\Subsystems\ICP\CAMERA_ICP_AAAAAA.elf

mkdir output\Subsystems\IPA

xcopy /qchky /-i extracted\vendor\firmware\ipa_fws.elf output\Subsystems\IPA\ipa_fws.elf

mkdir output\Subsystems\MCFG
mkdir output\Subsystems\MCFG\MCFG

echo Generating MCFG TFTP INF Configuration...
tools\SuBExtInfUpdater-MCFG.exe extracted\modem\image\modem_pr output\Subsystems\MCFG\MCFG > output\Subsystems\MCFG\inf_configuration.txt

xcopy /qchky /-i extracted\modem\image\lahaina\qdsp6m.qdb output\Subsystems\MCFG\qdsp6m.qdb

mkdir output\Subsystems\MPSS

echo Copying MPSS Protection Domain Registry Config files...
xcopy /qchky /-i extracted\modem\image\modemr.jsn output\Subsystems\MPSS\modemr.jsn

echo Converting Modem Processor Subsystem DSP Image...
bash.exe -c "./pil-squasher/pil-squasher ./output/Subsystems/MPSS/qcmpss8350.mbn ./extracted/modem/image/modem.mdt"

mkdir output\Subsystems\SPSS

xcopy /qchky /-i extracted\modem\image\spss1p.mbn output\Subsystems\SPSS\spss8350v1p.mbn
xcopy /qchky /-i extracted\modem\image\spss1t.mbn output\Subsystems\SPSS\spss8350v1t.mbn

xcopy /qchky /-i extracted\modem\image\asym1p.sig output\Subsystems\SPSS\asym1p.sig
xcopy /qchky /-i extracted\modem\image\asym1t.sig output\Subsystems\SPSS\asym1t.sig
xcopy /qchky /-i extracted\modem\image\crypt1p.sig output\Subsystems\SPSS\crypt1p.sig
xcopy /qchky /-i extracted\modem\image\crypt1t.sig output\Subsystems\SPSS\crypt1t.sig
xcopy /qchky /-i extracted\modem\image\keym1p.sig output\Subsystems\SPSS\keym1p.sig
xcopy /qchky /-i extracted\modem\image\keym1t.sig output\Subsystems\SPSS\keym1t.sig
xcopy /qchky /-i extracted\modem\image\macch1p.sig output\Subsystems\SPSS\macch1p.sig
xcopy /qchky /-i extracted\modem\image\macch1t.sig output\Subsystems\SPSS\macch1t.sig

mkdir output\Subsystems\VENUS

xcopy /qchky /-i extracted\vendor\firmware\vpu20_4v.mbn output\Subsystems\VENUS\qcvss8350.mbn

mkdir output\Subsystems\ZAP

xcopy /qchky /-i extracted\vendor\firmware\a660_zap.elf output\Subsystems\ZAP\qcdxkmsuc8350.mbn

mkdir output\Camera

mkdir output\Camera\Front

xcopy /qchky /-i extracted\vendor\lib64\camera\com.qti.sensormodule.sony_front_imx481.bin output\Camera\Front\com.qti.sensormodule.sony_front_imx481.bin
xcopy /qchky /-i extracted\vendor\lib64\camera\com.qti.tuned.sony_front_imx481.bin output\Camera\Front\com.qti.tuned.sony_front_imx481.bin

mkdir output\Camera\Rear

xcopy /qchky /-i extracted\vendor\lib64\camera\com.qti.sensormodule.sony_imx563.bin output\Camera\Rear\com.qti.sensormodule.sony_imx563.bin
xcopy /qchky /-i extracted\vendor\lib64\camera\com.qti.tuned.sony_imx563.bin output\Camera\Rear\com.qti.tuned.sony_imx563.bin

mkdir output\Camera\Tele

xcopy /qchky /-i extracted\vendor\lib64\camera\com.qti.sensormodule.sony_tele_imx481.bin output\Camera\Tele\com.qti.sensormodule.sony_tele_imx481.bin
xcopy /qchky /-i extracted\vendor\lib64\camera\com.qti.tuned.sony_tele_imx481.bin output\Camera\Tele\com.qti.tuned.sony_tele_imx481.bin

mkdir output\Camera\UW

xcopy /qchky /-i extracted\vendor\lib64\camera\com.qti.sensormodule.sony_uw_imx481.bin output\Camera\UW\com.qti.sensormodule.sony_uw_imx481.bin
xcopy /qchky /-i extracted\vendor\lib64\camera\com.qti.tuned.sony_uw_imx481.bin output\Camera\UW\com.qti.tuned.sony_uw_imx481.bin

mkdir output\Camera\ToF

xcopy /qchky /-i extracted\vendor\firmware\tof8801_firmware.bin output\Camera\ToF\tof8801_firmware.bin

mkdir output\Touch
mkdir output\Touch\Config

echo Extracting N-Trig Digitizer Project Configuration Databases...
tools\PSCFGDataReader.exe output\Touch\Config extracted\vendor\lib64\c1\libsurfacetouch_c1.so

mkdir output\Touch\FW

xcopy /qcheriky extracted\vendor\firmware\cfu\hid\touch\0C1D output\Touch\FW

mkdir output\Pen
mkdir output\Pen\FW

xcopy /qcheriky extracted\vendor\firmware\cfu\hid\pen\0C0F output\Pen\FW

mkdir output\BT

echo Copying Blueooth Firmware Files...
xcopy /qcheriky extracted\bluetooth\image output\BT

mkdir output\Sensors
mkdir output\Sensors\Config

xcopy /qchky /-i extracted\vendor\etc\sensors\sns_reg_config output\Sensors\Config\sns_reg_config
xcopy /qcheriky extracted\vendor\etc\sensors\config output\Sensors\Config

echo Generating SLPI FASTRPC INF Configuration...
tools\SuBExtInfUpdater-SLPI.exe output\Sensors\Config > output\Sensors\inf_configuration.txt
move output\Sensors\inf_configuration.txt output\Sensors\Config\inf_configuration.txt

mkdir output\Sensors\Proto

xcopy /qcheriky extracted\vendor\etc\sensors\proto output\Sensors\Proto

mkdir output\Audio
mkdir output\Audio\Cal

xcopy /qchky /-i extracted\vendor\etc\acdbdata\adsp_avs_config.acdb output\Audio\Cal\adsp_avs_config.acdb
xcopy /qcheriky extracted\vendor\etc\acdbdata\nn_ns_models output\Audio\Cal
xcopy /qcheriky extracted\vendor\etc\acdbdata\nn_vad_models output\Audio\Cal
xcopy /qcheriky extracted\vendor\etc\acdbdata\Surface\region\a output\Audio\Cal
xcopy /qcheriky extracted\vendor\etc\acdbdata\Surface\region\b output\Audio\Cal

mkdir output\Regulatory

REM TODO: Remember where this is stored again

mkdir output\TrEE

xcopy /qchky /-i extracted\modem\image\rtic.mbn output\TrEE\rtic.mbn
xcopy /qchky /-i extracted\modem\image\mdcompress.mbn output\TrEE\mdcompress.mbn
xcopy /qchky /-i extracted\modem\image\widevine.mbn output\TrEE\widevine.mbn
xcopy /qchky /-i extracted\modem\image\haventkn.mbn output\TrEE\haventkn.mbn

echo Converting voiceprint (n=voiceprint;p=8:c47728cf3e4089,61,82:6004,b4) QSEE Applet...
bash.exe -c "./pil-squasher/pil-squasher ./output/TrEE/voicepri.mbn ./extracted/modem/image/voicepri.mdt"
echo Converting smplap32 (f=2000;m=x;n=smplap32;p=8:cc7738cf7fe7891,60:3,82:6004,b4,12d,400,ff0001;u=706D6153656C70417000000000000032) QSEE Applet...
bash.exe -c "./pil-squasher/pil-squasher ./output/TrEE/smplap64.mbn ./extracted/modem/image/smplap64.mdt"
echo Converting smplap64 (f=2000;n=smplap64;p=8:cc7738cf7fe7891,60:3,82:6004,b4,12d,400,ff0001;u=706D6153656C70417000000000000064) QSEE Applet...
bash.exe -c "./pil-squasher/pil-squasher ./output/TrEE/smplap32.mbn ./extracted/modem/image/smplap32.mdt"
echo Converting hdcpsrm (n=hdcpsrm;p=8:c47728cf3e4089,5d:8,82:6004,b4;s=5e) QSEE Applet...
bash.exe -c "./pil-squasher/pil-squasher ./output/TrEE/hdcpsrm.mbn ./extracted/modem/image/hdcpsrm.mdt"
echo Converting qcom.tz.hdcp2p2 (n=qcom.tz.hdcp2p2;p=8:c47728cf3e408911,5a:94,82:6004,b4;s=43,56) QSEE Applet...
bash.exe -c "./pil-squasher/pil-squasher ./output/TrEE/hdcp2p2.mbn ./extracted/modem/image/hdcp2p2.mdt"
echo Converting hdcp1 (n=hdcp1;p=8:c477a8cf3e40893,61,82:6004,b4;s=55) QSEE Applet...
bash.exe -c "./pil-squasher/pil-squasher ./output/TrEE/hdcp1.mbn ./extracted/modem/image/hdcp1.mdt"
echo Converting featenabler (n=featenabler;p=8:c47728cf3e4089,61:6,77,82:6004,b4;u=7e1903bb7c17ff47b6d862337ca7db85) QSEE Applet...
bash.exe -c "./pil-squasher/pil-squasher ./output/TrEE/featenabler.mbn ./extracted/modem/image/featenabler.mdt"
echo Converting fingerprint (m=x;n=fingerprint;p=8:cc7728cf3f4089,61,84:1001,b4) QSEE Applet...
bash.exe -c "./pil-squasher/pil-squasher ./output/TrEE/fpcrel.mbn ./extracted/modem/image/fpcrel.mdt"


REM START: Do we need those? They should already be loaded in UEFI.

REM TODO: Trim
echo Copying sfsecapp (n=sfsecapp;p=8:c47728cf3f6089,61,82:6004,b4) QSEE Applet...
xcopy /qchky /-i extracted\sfsecapp.img output\TrEE\sfsecapp.mbn

REM TODO: Trim
echo Copying qcom.tz.uefisecapp (n=qcom.tz.uefisecapp;p=8:c47728cf3e4089,61,82:6004,b4) QSEE Applet...
xcopy /qchky /-i extracted\uefisecapp.img output\TrEE\uefisecapp.mbn

REM TODO: Trim
echo keymaster64 (n=keymaster64;o=100;p=8:c47728cf3e4489,61,82:6024,b4,12d:1;s=96) QSEE Applet...
xcopy /qchky /-i extracted\keymaster.img output\TrEE\keymaster.mbn

REM END: Do we need those? They should already be loaded in UEFI.


mkdir output\UEFI

echo Extracting XBL Image...
tools\UEFIReader.exe extracted\XBL.img output\UEFI

mkdir output\UEFI\ImageFV

echo Extracting ImageFV Image...
tools\UEFIReader.exe extracted\imagefv.img output\UEFI\ImageFV

mkdir output\UEFI\ABL

echo Extracting ABL Image...
tools\UEFIReader.exe extracted\abl.img output\UEFI\ABL

echo Cleaning up PIL Squasher Directory...
rmdir /Q /S pil-squasher

REM TODO: Get list of supported PM resources from AOP directly
REM TODO: Extract QUP FW individual files
REM TODO: devcfg parser?

:eof
exit /b 0

:checkRKH
set x=INVALID
for /F "eol=; tokens=1-2 delims=" %%a in ('tools\RKHReader.exe %1 2^>^&1') do (set x=%%a)

echo.
echo File: %1
echo RKH : %x%
echo.
set directory=%~dp1
call set directory=%%directory:%cd%=%%

if %x%==%RKH% (
    exit /b 1
)

if %x%==FAIL! (
    exit /b 2
)

if %x%==EXCEPTION! (
    exit /b 2
)

echo %1 is a valid MBN file and is not production signed (%x%). Moving...
mkdir unsigned\%directory%
move %1 unsigned\%directory%
exit /b 0