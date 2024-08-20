# OEMC1 Firmware

This repository holds the latest Firmware for OEMC1 devices alongside the scripts and tools used to generate the output folder, designed to be used for Windows.

## Script

- Extract product.img into extracted\product
- Extract vendor.img into extracted\vendor
- Extract system_ext.img into extracted\system_ext
- Extract bluetooth.img into extracted\bluetooth
- Extract dsp.img into extracted\dsp
- Extract modem.img into extracted\modem
- Copy abl.img into extracted
- Copy aop.img into extracted
- Copy cpucp.img into extracted
- Copy featenabler.img into extracted
- Copy imagefv.img into extracted
- Copy keymaster.img into extracted
- Copy qupfw.img into extracted
- Copy sfsecapp.img into extracted
- Copy shrm.img into extracted
- Copy uefisecapp.img into extracted
- Copy xbl.img into extracted
- Run build.cmd

```
  _______        __  _____      _                  _
 |  ___\ \      / / | ____|_  _| |_ _ __ __ _  ___| |_ ___  _ __
 | |_   \ \ /\ / /  |  _| \ \/ / __| '__/ _` |/ __| __/ _ \| '__|
 |  _|   \ V  V /   | |___ >  <| |_| | | (_| | (__| || (_) | |
 |_|      \_/\_/    |_____/_/\_\\__|_|  \__,_|\___|\__\___/|_|


Target: OEMC1
SoC   : SM8350
RKH   : 34046EF5E08C14E01BE8883BFBE0E5C31A8E407B5B3B98C88F8A86C8D98C1235 (Microsoft Andromeda Attestation PCA 2017) (From: 11/1/2017 To: 11/1/2032)
```