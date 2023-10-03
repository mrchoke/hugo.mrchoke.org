---
title: Dockerfile
description: การใช้ Dockerfile ในการสร้าง Docker Image
toc: true
authors: []
date: 2023-05-01T00:51:41+07:00
lastmod: 2023-05-01T00:51:41+07:00
featuredImage: docs/vscode/devcontainer/docker-vscode.jpg
tags: [docker, devcontainer, vscode, dockerfile]
draft: false
weight: 4
---

ตามที่ได้เกริ่นไว้จากตอนที่แล้วว่าเราสามารถที่จะควบคุมและปรับแต่งตัว image ที่จะเอามาใช้ได้โดยการเขียน Dockerfile เองซึ่ง Dev Containers ได้สนับสนุนอยู่แล้ววิธีการก็ไม่ยุ่งยากอะไรขอแค่เลือก image ให้เหมาะสมการติดตั้งก็ง่ายและไม่ซับซ้อน อีกอย่างอย่าลืมว่าเรากำลังอยู่ระหว่าง Dev ดังนั้นเราอาจจะไม่ได้สนใจขนาดของ image มากนักขอให้มีเครื่องมือที่ต้องใช้ให้ครบไว้ก่อน ส่วนใครที่มีทรัพยากรจำกัดก็ค่อยหาทางออกสำหรับการลดขนาดอีกที

## Dockerfile

ตรงนี้เราต้องมีความรู้เรื่องการสร้าง docker image ด้วย Dockerfile มาบ้างเล็กน้อย ให้พอเข้าใจและศึกษาต่อยอดได้ ส่วนการเขียนนั้นเราอยากติดตั้งอะไร อยากจะใช้อะไรก็สั่งได้ใน Dockerfile นี่แหละเอาเท่าที่จำเป็นพอจะได้ไม่อ้วนมากนะครับ ตัวอย่าง

```dockerfile

FROM python:3.11

ENV TZ=Asia/Bangkok

# add fish repositories

RUN echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_11/ /' >/etc/apt/sources.list.d/shells:fish:release:3.list \
  && curl -fsSL 'https://download.opensuse.org/repositories/shells:fish:release:3/Debian_11/Release.key' | gpg --dearmor >/etc/apt/trusted.gpg.d/shells_fish_release_3.gpg

# install debian packages

RUN apt update \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt install -y \
  curl \
  fish \
  locales \
  tmux \
  && apt-get clean autoclean \
  && apt-get autoremove --yes \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

# change root shell

RUN chsh -s /usr/bin/fish root

# install locales

RUN sed --in-place '/en_US.UTF-8/s/^#//' /etc/locale.gen  \
  &&  sed --in-place '/th_TH.UTF-8/s/^#//' /etc/locale.gen \
  && locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# set timezone

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install python modules

RUN pip install --no-cache-dir -U pip \
  && pip install --no-cache-dir -U bandit autopep8 fastapi[all]

EXPOSE 8000


```

จาก Dockerfile ตัวอย่างจะคล้าย ๆ กับตัวอย่างจากตอนที่แล้วคือ มีการติดตั้ง fish และ tmux จริง ๆ แล้วสามารถตัดตรงนี้ออกได้แล้วไปใช้ features น่าจะง่ายกว่า แต่เพื่อเป็นตัวอย่างผมจะทำให้ดูวิธีเพื่อเป็นแนวทางประยุกต์ใช้ต่อไปด้วย นอกจากนั้นผมยังตั้ง timezone และ locale ด้วย และ ตบท้ายด้วยติดตั้ง packages ของ python นั่นคือ fastapi และ ตัวจัดการ format และ linter ด้วย ตรงนี้เราสามารถแยกเอาไปไว้ใน `requirement.txt` ก็ได้นะคือแยก packages ที่ต้องใช้จริงใน production ไปไว้ใน file ส่วนที่ใช้ในช่วง dev ก็ใส่ไว้ในนี้เป็นต้น

## devcontainer.json

ส่วนใน settings เราก็ให้เปลี่ยน `image` เป็น

```json
"build": {
    "dockerfile": "Dockerfile"
}

```

ซึ่ง file เต็ม ๆ มีดังนี้

```json

{
  "name": "Dev Container EP3",
  "build": {
    "dockerfile": "Dockerfile"
  },
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

การใช้ Dockerfile จะมีความยืดหยุ่นกว่า เราสามารถปรับแต่งและควบคุมตัว image ได้มากขึ้น ในตอนต่อไปจะเป็นตัวอย่างของ Docker Compose เบื้องต้น