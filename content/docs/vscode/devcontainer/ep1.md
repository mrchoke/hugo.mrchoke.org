---
title: เริ่มต้น
description: ก้าวแรกที่แสนง่าย
toc: true
authors: []
tags: [docker, devcontainer, vscode]
featuredImage: docs/vscode/devcontainer/docker-vscode.jpg
date: 2023-04-23T23:30:37+07:00
lastmod: 2023-04-26T17:45:37+07:00
draft: false
weight: 2
---

เมื่อเราเตรียมสิ่งที่ต้องการเรียบร้อยแล้วให้ทำการ start docker ให้พร้อมใช้งาน

## เปิด VSCode

เปิด VSCode แล้วทำตามขั้นตอนดังนี้

*__สำหรับคนที่ใช้ Windows แนะนำว่าให้ทำงานบน WLS2 จะเร็วกว่าและมีปัญหาน้อยกว่า__*

* สร้าง folder สำหรับเก็บ project นี้ชื่ออะไรก็ได้ ตัวอย่างชื่อ `ep1`
* สร้าง folder ขื่อ `.devcontainer`
* สร้าง file ชื่อ `devcontainer.json`

`.devcontainer` เป็นที่เก็บการตั้งค่าต่าง ๆ ของ Dev Container ใน Project นี้ ซึ่ง File หลักสำหรับการตั้งค่าคือ `devcontainer.json`

## ปฐมบทการสร้าง Dev Container

ง่ายที่สุดสำหรับสร้าง Dev Container คือ อยากใช้ Docker image ตัวไหนที่เล็งไว้ก็เอามาใช้ได้เลย เช่น จะเขียน Python ก็เลือก python:3.11 จะเขียน node ก็ใช้ node:16 เป็นต้น 

ตัวอย่างแรกนี้เรามาเริ่มกันด้วย `python:3.11` เมื่อ up ขึ้นมาแล้วเราก็สามารถเขียน python กันในนี้ได้เลย

### เขียน devcontainer.json

```json
{
  "name": "Dev Container EP1",
  "image": "python:3.11"
}

```

จากข้างบนก็มีแค่ `name` และ `image` ที่จะใช้

### Build Dev Container

เมื่อเราเขียน config เสร็จแล้วก็ทำการ Build ซึ่งการ Build มี 2 กรณีหลัก ๆ คือ

1. ถ้าเราเปิด VSCode ครั้งแรกและ VSCode ตรวจเจอว่ามี `.devcontainer` และ config มันจะถามว่าจะเปิดด้วย Dev Containers ไหม

[![](/docs/vscode/devcontainer/reopen_in_container.png)](/docs/vscode/devcontainer/reopen_in_container.png)
*<center>Reopen in Container</center>*

2. ถ้าเราไม่ได้เปิดตั้งแต่แรก หรือ เราเพิ่งสร้างและเขียน Config เสร็จเราก็สั่ง Build โดยเรียก `View` --> `Command Palette..` (อาจจะใช้ปุ่มลัดก็ได้ขึ้นกับ OS ที่ใช้ เช่น `Shift + Command + P`) ขึ้นมา แล้วค้นหาคำสั่ง `Rebuild and Reopen in Container`

[![](/docs/vscode/devcontainer/rebuild_and_reopen.png)](/docs/vscode/devcontainer/rebuild_and_reopen.png)
*<center>Rebuild and Reopen in Container</center>*

### Build Log

ไม่ว่าจะ Build ด้วยวิธีไหนเราสามารถเฝ้าดู Log ของการ Build ได้ ซึ่งปกติจะมี Dialog เล็กขึ้นตรงมุมขวาล่างให้เรา Click ดูได้เลย

[![](/docs/vscode/devcontainer/building_start.jpg)](/docs/vscode/devcontainer/building_start.jpg)
*<center>เริ่มทำการ Build</center>*

[![](/docs/vscode/devcontainer/building.jpg)](/docs/vscode/devcontainer/building.jpg)
*<center>Build log</center>*

หากไม่มีอะไรผิดพลาดก็จะ Build สำเร็จและพร้อมใช้งาน ถ้ามี Error ก็ไล่ดูจาก log นี่แหละครับแล้วแก้ไขให้ถูกต้อง

### ใช้งาน Dev Container

เมื่อกระบวนการ Build สำเร็จเสร็จสิ้นก็จะพาเข้าสู่ Container ที่ Build ซึ่งเราสามารถสังเกตตรง `Explorer` ด้านข้างถ้าเราเห็น file และ folder ข้างใน project ของเราแสดงว่าสำเร็จแล้วสามารถปิดหน้า log ได้เลยและเปิด terminal ใหม่ขึ้นมาใช้งานได้แล้ว

[![](/docs/vscode/devcontainer/build_finished.jpg)](/docs/vscode/devcontainer/build_finished.jpg)
*<center>Build เสร็จแล้ว</center>*

เปิด Terminal ใหม่ขึ้นมาแล้วสั่ง

```shell
# cat /etc/os-release
```

[![](/docs/vscode/devcontainer/show_linux_version.jpg)](/docs/vscode/devcontainer/show_linux_version.jpg)
*<center>เปิด Terminal ใหม่</center>*

รุ่นของ Linux จะขึ้นกับ image ที่เราใช้นะครับ python 3.11 ที่ใช้จะเป็น Debian Bullseye ตอนนี้เราก็สามารถใช้งานเหมือนมี Linux อีกตัวหนึ่งได้เลยโดยสภาพแวดล้อมการทำงานจะแยกอิสระออกไปเลย และ ถ้าเราตั้งค่าอะไรไว้ก็จะอยู่จนกว่าเราจะสั่งให้มัน Rebuild ใหม่ คือถ้ามีการ build ใหม่เมื่อไหร่ค่าต่าง ๆ ก็จะหายไป แต่ code ยังอยู่นะ

### Code แรก

คราวนี้ลองสร้าง file python ขึ้นมาสัก file หนึ่งตัวอย่างคือ `main.py`

[![](/docs/vscode/devcontainer/install_recomment_extension01.jpg)](/docs/vscode/devcontainer/install_recomment_extension01.jpg)
*<center>VSCode ถามว่าจะติดตั้ง Extension ที่เกี่ยวกับ Python หรือไม่</center>*

ความฉลาดของ VSCode ถ้าเราสร้าง file ขึ้นมามันจะวิเคราะห์จากนามสกุลแล้วก็แนะนำว่าจะใช้ extension อะไรในการจัดการในที่นี้เป็น `.py` ก็จะแนะนำ python extension มาให้ซึ่งเป็น meta extension นะครับมันจะดึงชุดของ extensions ที่จะใช้มาให้

[![](/docs/vscode/devcontainer/extensions_list.jpg)](/docs/vscode/devcontainer/extensions_list.jpg)
*<center>รายการ Extensions หลังจากติดตั้งเสร็จ</center>*

เมื่อได้ extensions มาแล้วคราวนี้ก็เริ่มเขียน code ง่าย ๆ ดังนี้

```python
import sys

print(sys.version)
```

แล้วลอง save ดู VSCode ก็จะเข้ามาสอดส่องให้อีกครั้งว่า code ยังขาดตัว format นะและแนะนำมาให้ว่าจะใช้ตัวไหนดี อันนี้ก็เลือกตามต้องการได้เลย

[![](/docs/vscode/devcontainer/install_formatter.jpg)](/docs/vscode/devcontainer/install_formatter.jpg)
*<center>แนะนำ Code Formatter</center>*

### Run Code

เมื่อติดตั้ง Formatter เสร็จแล้วคราวนี้ก็ลอง run code ดูซึ่ง Python สามารถ run ได้สองแบบหลัก ๆ คือกด `F5` หรือจะสั่ง run ใน `terminal` ได้เลย

[![](/docs/vscode/devcontainer/run_python.jpg)](/docs/vscode/devcontainer/run_python.jpg)
*<center>Run Code Python</center>*

### ติดตั้ง python modules เพิ่มเติม

หากเราต้องการติดตั้ง python module อื่น ๆ เพิ่มเติมก็สามารถสั่ง `pip` ได้เลยเพราะตัว image ที่ใช้เป็น python อยู่แล้ว ตัวอย่างก็ update pip ซะก่อนเลย

[![](/docs/vscode/devcontainer/pip_install.jpg)](/docs/vscode/devcontainer/pip_install.jpg)
*<center>pip install</center>*

## ส่งท้าย

หลักการทำงานกับ Dev Containers ที่กล่าวมาใน EP นี้เป็นภาคที่ง่ายที่สุดแล้วเป็นการเริ่มต้นให้เห็นภาพว่าเราสามารถ Build มันขึ้นมาได้อย่างไร ใน EP ต่อ ๆ ไปก็จะแนะนำการใช้งานที่สูงขึ้นเรื่อย ๆ เพราะว่าวิธีนี้มันไม่ยั่งยืนถ้ามีการ build ใหม่ก็ต้องมาเริ่ม set ค่าต่าง ๆ กันใหม่อีก แล้วไว้มาต่อกันครับ