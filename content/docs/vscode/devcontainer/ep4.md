---
title: Docker Compose
description: การใช้ Docker Compose ในการควบคุมและสร้าง image
toc: true
authors: []
date: 2023-05-01T03:01:44+07:00
lastmod: 2023-05-01T03:01:44+07:00
draft: false
featuredImage: docs/vscode/devcontainer/docker-vscode.jpg
tags: [docker, devcontainer, vscode, docker-compose]
weight: 5
---

ตัวอย่างสำหรับตอนนี้เราสามารถ copy file จากตอนที่แล้วมาได้เลยคือสามารถ `Dockerfile` เดิมได้เลยแล้วสร้าง file `docker-compose.yml` เพิ่มขึ้นมาดังนี้

## docker-compose.yml

```yml

version: '3'

services:
  fastapi:
    build:
      context: ../.devcontainer
      dockerfile: Dockerfile
    volumes:
      - ../:/workspace/ep4:cached
    init: true
    command: [ 'sleep', 'infinity' ]

networks:
  default:
    name: ep4

```

### build
จากตัวอย่างด้านบนผมสร้าง service ขื่อ `fastapi` และกำหนดให้ build โดยชี้ `context` ไปยัง `../.devcontainer` และ `dockerfile` ชี้ไปยัง `Dockerfile` ตรงนี้ผมเขียนแบบเต็มเพื่อให้ดูเป็นตัวอย่างนะครับ ปกติถ้าใช้ dockerfile ขื่อ `Dockerfile` เรากำหนดแค่ build ได้เลย

```yml

fastapi:
    build: ../.devcontainer

```

ที่เขียนแบบเต็มให้ดูเพราะบางครั้งเราอาจจะเปลี่ยนชื่อ file เช่น `Dockerfile.dev` `Dockerfile.vscode` เป็นต้น และที่สังเกตเห็นอีกอย่างคือการอ้างอิง path Dev Container จะอ้างอิง path จาก `root directory` ของ project ดังนั้นมันถึงต้องถอยออกไปหนึ่งชั้นนั่นเอง ตรงนี้ต้องจำให้ดีนะเพราะพอสูงขึ้นไปอีกหน่อยจะมีการอ้างอิงแบบนี้อีก เช่นการ `Extend docker-compose` การ copy file ใน `Dockerfile` เป็นต้น ซึ่งจะกล่าวในตอนต่อ ๆ ไปอีกครั้ง

### volumes

ส่วน `volumes` เราต้องสั่งให้ขี้เองว่าจะ mount ไปไว้ที่ไหนกำหนดได้ตามชอบ จากตัวอย่างตอนก่อน ๆ ถ้าสังเกตจะพบว่ามันจะ mount อัตโนมัติให้ที่ `/workspace/projectname` ตอนนี้เราตั้งที่ไหนก็ได้ แต่ต้องให้สัมพันธ์กับ file `devcontainer.json` ที่จะกล่าวต่อไปด้วย

### command

ปกติเราจะตั้งให้เปิดคำสั่งที่ run แบบ background ทิ้งไว้เพื่อไม่ให้ container หยุดทำงานหลังจาก up ขึ้นที่นิยมก็จะเป็น sleep แบบ infinity 

### network

ตรงนี้ตั้งหรือไม่ก็ได้ถ้าตั้งไว้ก็จะสังเกตง่ายหน่อยเวลาเราไป list ดูว่ามี network อะไรบ้างในระบบจะได้ไม่สับสนด้วย

## devcontainer.json

สำหรับ settings ใน `devcontainer.json` ก็ให้เปลี่ยนจาก `build` เป็นดังนี้

```json

"dockerComposeFile": [
    "docker-compose.yml"
],
"service": "fastapi",
"workspaceFolder": "/workspace/ep4"

```
การอ้างอิง path ตรงนี้สามารถ ralative กับ `.devcontainer` ได้เลย และเพิ่มอีกสอง properties คือ 

- service ต้องระบุให้ตรงกับ `docker-compose.yml` 
- workspaceFolder คือจุด mount ของ volume ใน `docker-compose.yml` นั่นเองเมื่อ up ขึ้นมาก็จะทำงานที่นี่

### file เต็ม

```json

{
  "name": "Dev Container EP4",
  "dockerComposeFile": [
    "docker-compose.yml"
  ],
  "service": "fastapi",
  "workspaceFolder": "/workspace/ep4",
  "init": true,
  "customizations": {
    "vscode": {
      "settings": {
        "editor.autoClosingBrackets": "always",
        "editor.bracketPairColorization.enabled": true,
        "editor.formatOnPaste": true,
        "editor.formatOnSave": true,
        "editor.formatOnSaveMode": "file",
        "editor.guides.bracketPairs": true,
        "editor.guides.highlightActiveIndentation": false,
        "editor.guides.indentation": false,
        "editor.inlineSuggest.enabled": true,
        "editor.minimap.enabled": false,
        "editor.tabSize": 2,
        "indentRainbow.indicatorStyle": "light",
        "python.formatting.provider": "none",
        "remote.autoForwardPorts": true,
        "remote.localPortHost": "allInterfaces",
        "terminal.integrated.cursorBlinking": true,
        "terminal.integrated.defaultProfile.linux": "fish",
        "vsintellicode.features.python.deepLearning": "enabled",
        "workbench.colorCustomizations": {
          "editorUnnecessaryCode.border": "#fbbd52",
          "editorUnnecessaryCode.opacity": "#ffffff8b",
          "editorIndentGuide.background": "#2a2a2a"
        },
        "editor.showUnused": true,
        "editor.renderLineHighlight": "gutter",
        "terminal.integrated.gpuAcceleration": "on",
        "terminal.integrated.copyOnSelection": true,
        "terminal.integrated.cursorStyle": "line",
        "terminal.integrated.fontSize": 15,
        "editor.quickSuggestions": {
          "other": "on",
          "comments": "on",
          "strings": "on"
        },
        "isort.check": true,
        "indentRainbow.lightIndicatorStyleLineWidth": 2,
        "python.languageServer": "Pylance",
        "python.linting.banditEnabled": true,
        "python.linting.lintOnSave": true,
        "python.linting.enabled": true,
        "python.linting.pylintEnabled": false,
        "[python]": {
          "editor.defaultFormatter": "ms-python.autopep8",
          "editor.formatOnSave": true,
          "editor.formatOnType": true,
          "editor.tabSize": 4,
          "editor.codeActionsOnSave": {
            "source.organizeImports": true
          }
        },
        "isort.args": [
          "--profile",
          "black"
        ],
        "python.analysis.autoImportCompletions": true,
        "python.analysis.autoImportUserSymbols": true,
        "python.analysis.indexing": true,
        "python.analysis.diagnosticSeverityOverrides": {
          "reportUnboundVariable": "information",
          "reportImplicitStringConcatenation": "warning",
          "reportImportCycles": "error",
          "reportUnusedCoroutine": "error"
        },
        "python.formatting.autopep8Args": [
          "--max-line-length",
          "150",
          "--experimental"
        ]
      },
      "extensions": [
        "kevinrose.vsc-python-indent",
        "ms-python.autopep8",
        "ms-python.isort",
        "njpwerner.autodocstring",
        "oderwat.indent-rainbow",
        "VisualStudioExptTeam.vscodeintellicode"
      ]
    }
  }
}

```

## ส่งท้าย

หลัก ๆ Docker Compose ก็จะคล้าย ๆ กับ Dockefile ตอนเลือกใช้ก็ต้องดูว่า Project ของเราเป็นแค่เดี่ยว ๆ หรือ เป็นชุด ถ้าเป็นขุดปกติเราก็ทำ docker-compose.yml ไว้อยู่แล้วตอน dev อาจจะ extend ออกมาก็ได้ หรือ จะทำ Docker Compose ของแต่ละ Project ไว้แล้วเชื่อมด้วยกันกับ `COMPOSE_PROJECT_NAME` ก็ได้ไว้มีโอกาสจะแนะนำให้อีกที

ตอนต่อไปถ้าไม่มีอะไรผิดพลาดจะมาแนะนำเรื่องการจัดการ user และ sudo กัน