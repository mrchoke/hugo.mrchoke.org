---
title: "Docker Remote"
date: 2024-12-22T03:27:32+07:00
description: การ Remote ไปยัง Docker Container ที่ไม่ได้ Publish port ออกมา
featuredImage: posts/docker-remote/docker-remote-binding3.png
draft: false
---
ปกติเราจะสื่อสารกับ Container ผ่าน Port ที่เรา Publish ออกมา แต่ถ้า Container ไม่ได้ Publish port ออกมาเราจะทำยังไง ? เป็นโจทย์ที่เกิดขึ้นในระหว่างที่ผมต้องการเชื่อมต่อไปยัง Database ที่อยู่ใน Container ที่ไม่ได้ Publish port ออกมา และ ผ่านทาง ssh อีกทอดหนึ่งด้วย ตอนแรกก็คิดว่าต้องยากแน่ ๆ แต่ก็ลองคิดแบบง่าย ๆ ไม่ซับซ้อนก็นึกถึงสิ่งที่เคยทำมาก่อน ๆ ไม่ว่าจะเป็นการมุดเข้า Container ด้วย IP ของ Container ตรง ๆ และ การใช้ ssh มุดไปยังเครื่องเป้าหมายผ่านทาง port ที่ต้องการ เลยลองทดสอบสมมติฐานนี้ดู และพบว่าสามารถทำได้จริง ๆ เลยเขียนบันทึกไว้สักหน่อย

## Docker Port

ก่อนอื่นเราต้องเข้าใจการเชื่อมต่อกับ Container เพื่อใช้งานกันก่อน ปกติเราจะ run หลัก ๆ 2 แบบ คือ 

1. แบบไม่ Publish port ออกมา

    - run เพื่อทำงานอย่างใดอย่างหนึ่ง โดยไม่ต้องติดต่อสื่อสารกับ Container ผ่าน port เช่น สั่ง train model เมื่อเสร็จงานก็ได้ผลลัพธ์ออกมาเป็น file แล้วก็จบกัน
    ```bash
    docker run -it --rm -v $(pwd):/app tensorflow/tensorflow python /app/train.py
    ```

    - run แล้วไม่ต้อง Publish port ออกมาแต่ให้ Container อื่นใน project เดียวกันเข้าถึงกันภายใน เช่น run database แล้วให้ api ใน project เชื่อมต่อกันภายใน

    ```bash
    docker run -itd --name db --network my-network -e POSTGRES_PASSWORD=123456 postgres:alpine
    docker run -itd --name api --network my-network -p 8000:8000 my-api
    ```

2. แบบ Publish port ออกมา

เราจะคุ้นเคยกับการ run แบบนี้เพื่อจะได้สื่อสารกับ Container ได้ซึ่งที่ใช้งานบ่อย ๆ 2 แบบคือ (ที่ใช้บ่อยส่วนตัว)

  1. run แล้ว Publish port binding แบบ public ที่ 0.0.0.0 การใช้งานแบบนี้จะสะดวกแต่ไม่แนะนำใน production ถ้า Server เราไม่มี firewall ที่ดี

  ```bash
  docker run -itd --name my-api -p 8000:8000 my-api
  ```

  2. run แล้ว Publish port binding แบบ private ที่ IP ของ interface ที่เราต้องการ

  ```bash
  docker run -itd --name my-api -p 127.0.0.1:8000:8000 my-api
  ```

## SSH Tunneling

เรามารู้จักกับ SSH Tunneling กันก่อน โดย SSH Tunneling คือการสร้าง tunnel ทางเครือข่าย ที่เราสามารถสื่อสารหรือส่งข้อมูลผ่านไปยังเครื่องอื่นได้ โดยใช้ SSH ในการเชื่อมต่อ โดยหลัก ๆ มี 2 แบบ คือ

1. Local Port Forwarding

    สร้าง tunnel จากเครื่องเราไปยังเครื่องอื่น โดยเราสามารถเข้าถึงเครื่องอื่นผ่าน port ของเครื่องเรา

    ```bash
    ssh -L 8000:localhost:8000 user@remote
    ```
  
2. Remote Port Forwarding


    สร้าง tunnel จากเครื่องอื่นไปยังเครื่องเรา โดยเราสามารถเข้าถึงเครื่องเราผ่าน port ของเครื่องอื่น

    ```bash
    ssh -R 8000:localhost:8000 user@remote
    ```

โดยในบทความนี้เราจะใช้ Local Port Forwarding ในการเชื่อมต่อไปยัง Container ที่ไม่ได้ Publish port ออกมาบนเครื่อง Server

## การ Remote ไปยัง Docker Container ที่ไม่ได้ Publish port ออกมา

เมื่อเราเข้าใจการทำงานของ Docker Port และ SSH Tunneling แล้ว เรามาดูกันว่าจะ Remote ไปยัง Container ที่ไม่ได้ Publish port ออกมาได้ด้วยการใช้ SSH Tunneling แบบ Local Port Forwarding ได้อย่างไร

### Get Container IP

ก่อนที่เราจะเริ่มต้นทำการ Remote เราต้องหา IP ของ Container ที่เราต้องการ Remote ก่อน โดยเราสามารถใช้คำสั่ง `docker inspect` ในการดู IP ของ Container ทำได้สองแบบหลัก ๆ คือ

1. Inspect แบบปกติ

```bash
docker inspect container_name
```

วิธีนี้เราต้องดู IP โดยไล่ในส่วนของ "NetworkSettings" -> "Networks" -> "{Network Name}" -> "IPAddress" ถ้า Container มีหลาย Network ก็จะมีหลาย IP ด้วย

2. Inspect แบบใช้ format

```bash
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_name
```

วิธีนี้เราจะได้ IP ของ Container ที่เราต้องการเลย แต่เราต้องจำคำสั่งยาวหน่อย

### Remote ไปยัง Container จาก Client

เมื่อเราได้ IP ของ Container ที่เราต้องการ Remote แล้ว เราสามารถใช้คำสั่ง `ssh` ในการสร้าง tunnel ไปยัง Container ได้ โดยสมมติว่าเราจะเชื่อมต่อเพื่อใช้งานไปยัง Postgres Database ที่อยู่ใน Container ที่ไม่ได้ Publish port ออกมา โดย IP ของ Container คือ `172.23.0.2` และ Port ของ Postgres คือ `5432` และ Server IP คือ `10.244.4.35` เราสามารถใช้คำสั่ง

```bash
ssh -L 5432:172.23.0.2:5432 mrchoke@10.244.4.35
```

เมื่อเราใช้คำสั่งนี้เราจะสร้าง tunnel จากเครื่อง Client ไปยัง Container ได้แล้วเราสามารถเชื่อมต่อไปยัง Postgres Database ได้ผ่าน port 5432 ของเครื่อง Client ได้เลย โดยเราอาจจะใช้ Application ที่สามารถเชื่อมต่อ Postgres Database ได้เช่น DBeaver หรือ pgAdmin หรือจะเขียนโปรแกรมเพื่อเชื่อมต่อก็ได้

```bash
docker run --rm -it -p 5050:80 -e PGADMIN_DEFAULT_EMAIL=myemail@domain -e PGADMIN_DEFAULT_PASSWORD=password dpage/pgadmin4
```

ตัวอย่างผมใช้ PGAdmin ที่ run ด้วย Docker บนเครื่อง macOS และเชื่อมต่อไปยัง Postgres Database ที่อยู่ใน Container ที่ได้สร้าง tunnel ไว้ข้างต้น โดยสามารถตั้งค่าได้ดังรูป

![การตั้งค่า PGAdmin](/posts/docker-remote/pgadmin1.jpg "การตั้งค่า PGAdmin")
<center><em>การตั้งค่า PGAdmin</em></center>

เนื่องจาก PGAdmin run ใน Container ดังนั้นตรงช่อง Host name/address เราจะใส่ `localhost` ตรง ๆ ไม่ได้ เราต้องใช้ IP ของเครื่อง Client แทน 

มาถึงจุดนี้ผมคิดว่าหลายท่านคงพอจะมองภาพได้ว่าเราจะนำไปประยุกต์ใช้งานได้ยังไงบ้าง ซึ่งก็ไมไ่ด้ใช้ได้เฉพาะ Database เท่านั้น แต่ยังสามารถใช้งานได้กับ Application อื่น ๆ ที่ไม่ได้ Publish port ออกมาด้วย เช่น API ลับที่ หรือ อื่น ๆ อีกมากมาย

## ของแถม

สำหรับ PGAdmin เราสามารถเชื่อมต่อผ่าน SSH Tunnel ได้เลยโดยที่เราไม่ต้องสร้าง tunnel ด้วยตัวเอง คือสามารถข้ามขั้นตอนทำ tunnel ด้านบนได้เลย แล้วตั้งค่าดังรูป

![การตั้งค่า PGAdmin](/posts/docker-remote/pgadmin2.jpg "การตั้งค่า PGAdmin")
<center><em>การตั้งค่า Connection PGAdmin</em></center>

วิธีนี้ตรงช่อง Host name/address ให้เราใส่ IP ของ Container บน Server ได้เลย

![การตั้งค่า PGAdmin](/posts/docker-remote/pgadmin3.jpg "การตั้งค่า PGAdmin")
<center><em>การตั้งค่า SSH Tunnel PGAdmin</em></center>

ในช่อง Tunnel host ให้ใส่ IP ของ Server ที่เราจะใช้งาน และ ใส่ username และ password ของ Server ด้วย หรือถ้าใช้ key ให้ใส่ path ของ key ด้วย

วิธีนี้ดูแล้วจะง่ายสำหรับการใช้งาน PGAdmin กว่าการสร้าง tunnel ด้วยตัวเอง แต่ถ้าเราต้องการใช้งานกับ Application อื่น ๆ ที่ไม่มีการสนับสนุน SSH Tunnel ก็สามารถใช้วิธีที่ผมเขียนไว้ด้านบนได้เลย คราวนี้เราก็ใช้ PGAdmin บนเครื่องของเราเพื่อควบคุม Postgres Database ที่อยู่ใน Container บนเครื่อง Server ต่าง ๆ พร้อม ๆ กันได้โดยที่ไม่ต้องมี PGAdmin Container ของแต่ละ Project run อยู่บน Server แยกกัน ซึ่งเป็นการประหยัดทรัพยากรของ Server ได้ด้วย