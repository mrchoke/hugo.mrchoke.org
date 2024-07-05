---
title: "การ Compile Kernel 6.6 LTS สำหรับ WSL2"
description: เนื่องจาก WSL2 ได้ปล่อย kernel ใหม่ รุ่น 6.6 lts  แต่ยังไม่ปล่อยมาพร้อมกับตัว update หลักถ้าอยากใช้ตอนนี้ก็ต้อง build kernel เองซึ่งก็ไม่ยากเกินไปสามารถทำกันได้ตามขั้นตอนดังนี้
date: 2024-07-05T11:17:33+07:00
featuredImage: posts/wsl2/system-info.png
draft: false
---

เนื่องจาก WSL2 ได้ปล่อย kernel ใหม่ รุ่น 6.6 lts  แต่ยังไม่ปล่อยมาพร้อมกับตัว update หลักถ้าอยากใช้ตอนนี้ก็ต้อง build kernel เองซึ่งก็ไม่ยากเกินไปสามารถทำกันได้ตามขั้นตอนดังนี้

## เตรียมเครื่องมือ (ใน Linux ตัวอย่างเป็น Ubuntu 24.04)

```bash
sudo apt update
sudo apt install build-essential flex bison dwarves libssl-dev libelf-dev cpio
```
## Download kernel source

Download kernel source จาก https://github.com/microsoft/WSL2-Linux-Kernel/releases

```bash
 wget https://github.com/microsoft/WSL2-Linux-Kernel/archive/refs/tags/linux-msft-wsl-6.6.36.3.tar.gz

 tar vxfz linux-msft-wsl-6.6.36.3.tar.gz
 cd WSL2-Linux-Kernel-linux-msft-wsl-6.6.36.3
 ```

## Compile

```bash
make -j$(nproc)  KCONFIG_CONFIG=Microsoft/config-wsl 
```

*-j เป็นการระบุจำนวน CPU ที่จะใช้ $(nproc) คือใช้ทั้งหมดที่มี ถ้ารู้สึกว่าเครื่องอืดทำงานอย่างอื่นไม่ได้ก็ให้เปลี่ยนเป็นตัวเลขก็ได้*

## Install kernel modules and headers

```
sudo make modules_install headers_install
```
*ขั้นตอนนี้จะติดตั้งเฉพาะ module และ header เท่านั้นไม่ได้ติดตั้ง linux image ไปที่ /boot ด้วย*
## Copy kernel image to windows

```
mkdir /mnt/c/kernel
cp arch/x86/boot/bzImage /mnt/c/kernel
```

*คุณสามารถสร้าง directory เก็บไว้ที่ไหนก็ได้แต่ต้องเป็น Windows filesystem จะ C: หรือ D: หรือใด ๆ ก็ได้*

## Edit .wslconfig

powershell
```powershell
notepad $env:USERPROFILE\.wslconfig
```

cmd
```cmd
notepad %USERPROFILE%\.wslconfig
```

linux (เพื่ออะไร ฮา)
```bash
nano -w $(wslpath  "$(powershell.exe Write-Host -NoNewLine '$env:USERPROFILE')")/.wslconfig
```

สำหรับใน Linux จริง ๆ ถ้าเรารู้ path ก็เรียกตรง ๆ ได้เลย เช่น `/mnt/c/Users/mrchoke/.wslconfig`

เพิ่มบรรทัดต่อไปนี้ลงไปใน .wslconfig

```
kernel=C:\\kernel\\bzImage
```
*อย่าลืมใช้ \\\\ นะครับไม่ใช่ \\*

## Shutdown WSL

```powershell
wsl --shutdown
```

## เข้า WSL อีกครั้ง

```powershell
wsl
```

*ถ้า Error ก็ให้ Edit แก้ไขจนกว่าจะถูกต้อง หรือ ถ้ายอมแพ้ก็ให้ลบบรรทัดดังกล่าวออก*

## ตรวจสอบว่าใช้ kernel ใหม่หรือยัง

```

uname -a 
ีีuname -r

```

___
ขอให้มีความสุขกับ Linux ครับ

❤️🐧