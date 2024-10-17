---
title: "Python 3.13 Free Threading Test"
description: ทดสอบการใช้งาน Free Threading ใน Python 3.13 แบบง่าย ๆ โดยใช้ uv 
date: 2024-10-17T11:38:56+07:00
featuredImage: posts/python-gil/python-gil.jpg
draft: false
---

หลังจาก Python 3.13 ได้ออกตัวจริงมาสักพัก และมีความสนใจที่จะลองใช้งาน Free Threading ที่เพิ่มมาใหม่ เท่าที่ทราบตัวติดตั้งบน Windows มีตัวเลือกให้เลือก แต่สำหรับ Linux และ macOS ต้องติดตั้งเอง เพราะ binary ที่มากับตัวติดตั้งไม่มีเปิดใช้งาน Free Threading มาให้ ก็มีทางเลือกสองทางคือ Build จาก source หรือใช้ตัวจัดการ package อื่น ๆ ที่มี Free Threading มาให้

## แนะนำ uv

ก่อนจะคุยเรื่อง Python 3.13 Free Threading มาทำความรู้จัก uv กันสักนิด เอาแบบคร่าว ๆ uv เป็นเครื่องมือจัดการ package และ project สำหรับ Python ที่ทรงพลังมาก ถ้ามองในแง่ความเร็วในการติดตั้ง package เทียบกับ pip ถ้าใครที่ยังไม่รู้จัก แต่เคยใช้เครื่องมือตัวอื่นเช่น Poetry, Hatch, PDM หรือ Rye ก็จะทำงานในลักษณะคล้าย ๆ กัน คือ 

- Package management
- Environment management
- Package development
- Python version management

โดยตัว uv เองเป็นน้องใหม่ในวงการและถือว่าอยู่ในระหว่างการพัฒนา แต่ก็จี๊ดจ๊าดมาก ๆ ในเรื่องความเร็วและความสามารถ uv พัฒนาด้วยภาษา Rust การันตีได้ว่าเร็วถึงใจแน่นอน เอาเป็นว่าแนะนำคร่าว ๆ แค่นี้ก่อน ใครสนใจลองอ่านต่อได้ที่ [uv document](https://docs.astral.sh/uv/)

## การติดตั้ง uv

การติดตั้ง uv มีหลายวิธีด้วยกัน ขึ้นกับสถานการณ์การใช้งาน จะติดตั้งแบบ standalone หรือติดตั้งเป็น package ผ่าน pip ก็ได้ หรือจะใช้งานผ่าน Docker ก็ได้ แต่ในที่นี้จะใช้วิธีติดตั้งผ่าน script ติดตั้งของ uv โดยใช้คำสั่ง

สำหรับ Linux และ macOS

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

สำหรับ Windows

```bash
powershell -c "irm https://astral.sh/uv/install.ps1 | iex"
```

แค่นี้ก็เรียบร้อยแล้ว สามารถใช้งาน uv ได้เลย

## การใช้งาน uv เบื้องต้น

เราจะใช้ uv แทน pip หรือจะจัดการ environment ก็ได้ พิมพ์ยาวกว่าเดิมหน่อยแต่คุ้มค่ามาก ๆ และเร็วกว่าเดิมด้วย 

### การสร้าง environment ใหม่

ตัวอย่างการสร้าง environment ใหม่ เช่น สร้าง environment ชื่อ .uvenv ใหม่ โดยใช้คำสั่ง

```bash
uv venv .uvenv
```

เมื่อสร้าง environment แล้วเราสามารถเข้าไปใช้งานได้โดยใช้คำสั่งเหมือนกับการใช้งาน venv ของ Python คือ

```bash
source .uvenv/bin/activate
```

และเมื่อเราต้องการออกจาก environment ก็ใช้คำสั่ง

```bash
deactivate
```

และถ้าเราอยากจะระบุ Python version ที่เราต้องการใช้งานก็ใช้คำสั่ง

```bash
uv venv .uvenv --python=3.13

หรือ

uv venv .uvenv -p3.13t
```

หลังจากที่เรา source environment แล้วเราสามารถตรวจสอบ Python path และ Python version ที่เราใช้งานได้โดยใช้คำสั่ง

ตรวจสอบ Python path

```bash
which python
```

ตรวจสอบ Python version

```bash
python -V
```

หรือถ้าจะดูข้อมูลที่เยอะขึ้นก็ใช้คำสั่ง

```bash
python -VV
```

### การติดตั้ง package ใน environment

เมื่อเราสร้าง environment แล้วเราสามารถติดตั้ง package ได้โดยใช้คำสั่งที่คล้าย ๆ กับ pip หรือมันก็คือ pip แต่เป็นของ uv อาจจะมีคำสั่งไม่เท่ากันทั้งหมด แต่สามารถใช้งานได้เหมือนกัน โดยใช้คำสั่ง

```bash
uv pip install numpy
```

ถ้ามีข้อความ warning ขึ้นมาเกี่ยวกับการ link file เราสามารถลองใช้คำสั่งนี้เพื่อปิด warning ได้

```bash
uv pip install numpy --link-mode=copy
```

จบตัวอย่างการใช้งาน uv แบบทดแทน pip และ venv แบบง่าย ๆ แล้ว หากต้องการรู้เพิ่มเติมสามารถอ่านได้ที่ [uv document](https://docs.astral.sh/uv/)

## การใช้ uv จัดการ Project อย่างง่าย

ก่อนหน้านี้เราได้ทดลองใช้งาน uv ในการจัดการ environment และ package แล้ว แต่ถ้าเราต้องการจัดการ project อย่างง่าย ๆ ก็สามารถใช้ uv ได้เช่นกัน โดยเราสามารถสร้าง project ใหม่ได้โดยใช้คำสั่ง

```bash
uv init 
```

จะเป็นการสร้าง project ใหม่สำหรับ python application โดย uv จะสร้างไฟล์ `pyproject.toml`, `README.md` และ `hello.py` ให้

หรือถ้าเราต้องการปรับแต่ง project ตอน init เพิ่มเติม เช่น ชื่อ project หรือไม่ต้องสร้างไฟล์ `README.md` หรือกำหนด Python version ที่เราต้องการใช้งาน ก็สามารถใช้คำสั่ง

```bash
uv init --name=project_name --no-readme --python=3.13
```

### การเพิ่ม package ใน project

เมื่อเราสร้าง project แล้วเราสามารถเพิ่ม package ใน project ได้เหมือนกับเจ้าอื่น ๆ ซึ่งจะใช้คำสั่ง

```bash
uv add numpy
```

เช่นกันถ้ามี warning ขึ้นมาเกี่ยวกับการ link file เราสามารถลองใช้คำสั่งนี้เพื่อปิด warning ได้

```bash
uv add numpy --link-mode=copy
```

### การลบ package ใน project

เราสามารถลบ package ใน project ได้โดยใช้คำสั่ง

```bash
uv remove numpy
```

### การ sync package ใน project

ในกรณีที่เราสร้าง project และมีการ clone ไปยังเครื่องอื่น โดยไม่มี package ที่เราต้องการใน project นั้น โดยเราสามารถ sync package ที่เราต้องการใน project นั้น หรือการ sync เพื่อ update โดยใช้คำสั่ง

```bash
uv sync
```

หรือถ้ามี uv.lock ใน project แล้วเราสามารถ sync package ที่เราต้องการใน project นั้นโดยยังคง package ที่อยู่ใน uv.lock โดยใช้คำสั่ง

```bash
uv sync --frozen
```

หรือจะ update package ที่เราต้องการใน project ก็ใช้คำสั่ง

```bash
uv sync --upgrade
```

ข้างบนเป็นตัวอย่างการใช้งาน uv ในการจัดการ project อย่างง่าย ๆ และสามารถอ่านเพิ่มเติมได้ที่ [uv document](https://docs.astral.sh/uv/)

## Run script python ด้วย uv

โดยปกติเราสามารถใช้ uv สลับตัว Python version ต่าง ๆ โดยไม่ต้องติดตั้ง Python เองซึ่งมีความง่ายมาก ๆ เพราะ uv จะ download Python version ที่เราต้องการใช้งานให้เอง 

วิธี run script python โดยใช้ uv เช่น

```bash
uv run script.py
```

uv ก็จะเลือก Python version ที่เหมาะสมมา run script ให้เราโดยอัตโนมัติ แต่ถ้าเราต้องการเลือก Python version ที่เราต้องการใช้งานเองก็สามารถใช้คำสั่ง

```bash
uv run -p3.12 script.py
```

หรือเราจะเลือก python version ตั้งแต่ตอน init project ตามที่แนะนำไว้ข้างบนก็ได้ ส่วนวิธีระบุตอน run script uv ก็จะหา python version ที่เราต้องการใช้งานให้เอง ถ้ามีอยู่แล้วในระบบก็ใช้ได้เลย ถ้าไม่มีก็จะไป download มาให้เอง ถ้าเราอยากรู้ว่า uv มี python version อะไรให้เราใช้งานได้บ้างก็ใช้คำสั่ง

```bash
uv python list
```

แต่ทั้งนี้ถ้าเราใช้วิธี init project ไว้ต้องตรวจสอบข้อจำกัดของ python version ใน pyproject.toml และ .python-version ด้วย เช่นถ้าระบุไว้ในไฟล์ข้างต้นเป็น 3.13 เราจะใช้ -p3.12 ก็ไม่ได้นะ

## ลองใช้งาน Free Threading ใน Python 3.13

คราวนี้เรามาลองใช้ Free Threading ใน Python 3.13 กัน

ก่อนอื่นผมให้ ChatGPT สร้าง script สำหรับตรวจสอบ Python version, platform และ GIL status ให้ดังนี้

ไฟล์ `pyinfo.py`

```python
import sys
import platform

# Check Python version
python_version = sys.version

# Check platform
platform_info = platform.platform()

# Check GIL status
# ใน Python 3.13 สามารถตรวจสอบ GIL ได้ผ่าน sys.get_asyncgen_hooks()
def check_gil_status():
    try:
        return "Enabled" if sys.flags.gil else "Disabled"
    except AttributeError:
        return "Cannot determine - Python version may not support GIL status check"

print(f"Python Version: {python_version}")
print(f"Platform: {platform_info}")
print(f"GIL Status: {check_gil_status()}")
```

run โดยใช้ Python version 3.13 ปกติ

```bash
uv run -p3.13 pyinfo.py
```

เมื่อ run คำสั่งข้างต้นถ้าระบบยังไม่มี python 3.13 อยู่ uv จะ download มาให้เอง และ run script ให้เรา และผลลัพธ์ที่ได้ประมาณนี้

```bash
Python Version: 3.13.0 (main, Oct  8 2024, 01:04:00) [Clang 18.1.8 ]
Platform: Linux-5.15.0-122-generic-x86_64-with-glibc2.36
GIL Status: Enabled
```

เราสามารถเห็นได้ว่า GIL status ถูกเปิดใช้งานอย่างถูกต้อง

ถ้าเราลองสั่งปิด GIL ด้วยคำสั่ง

```bash
PYTHON_GIL=0 uv run -p3.13 pyinfo.py
```

ผลลัพธ์ที่ได้จะเป็น

```bash
Fatal Python error: config_read_gil: Disabling the GIL is not supported by this build
Python runtime state: preinitialized
```

เราจะเห็นได้ว่าเราไม่สามารถปิด GIL ได้เนื่องจากไม่ได้รองรับใน build นี้ซึ่งเป็นปกติสำหรับ official build ของ Python 3.13

แต่ถ้าเราจะใช้งาน Free Threading สามารถระบุ Python version เป็น 3.13t (มี t ต่อท้าย) ได้โดยใช้คำสั่ง

```bash
uv run -p3.13t pyinfo.py
```

ผลลัพธ์ที่ได้จะเป็น

```bash
Python Version: 3.13.0 experimental free-threading build (main, Oct  8 2024, 01:06:48) [Clang 18.1.8 ]
Platform: Linux-5.15.0-122-generic-x86_64-with-glibc2.36
GIL Status: Disabled
```

เราจะเห็นได้ว่า GIL status ถูกปิดใช้งาน และเราสามารถใช้งาน Free Threading ได้แล้ว 

ถ้าเราลองสั่งเปิด GIL จาก 3.13t สามารถทำได้โดยใช้คำสั่ง

```bash
PYTHON_GIL=1 uv run -p3.13t pyinfo.py
```

ผลลัพธ์ที่ได้จะเป็น

```bash
Python Version: 3.13.0 experimental free-threading build (main, Oct  8 2024, 01:06:48) [Clang 18.1.8 ]
Platform: Linux-5.15.0-122-generic-x86_64-with-glibc2.36
GIL Status: Enabled
```

### เปรียบเทียบผลลัพธ์ระหว่าง Python 3.13 และ Python 3.13t

ผมลองให้ ChatGPT สร้าง script สำหรับทดสอบการใช้งาน Free Threading ใน Python 3.13 และ Python 3.13t โดยการ run 3 แบบ คือ

1. Sequential
2. Thread
3. Multiprocessing

ไฟล์ `threading_test.py`

```python
import time
import multiprocessing
from concurrent.futures import ThreadPoolExecutor, ProcessPoolExecutor

# ฟังก์ชันสำหรับทดสอบ - คำนวณค่า fibonacci
def fibonacci(n):
    if n <= 1:
        return n
    return fibonacci(n-1) + fibonacci(n-2)

# ฟังก์ชันสำหรับทดสอบ CPU-intensive task
def heavy_computation(x):
    return sum(fibonacci(n) for n in range(x))

def run_sequential(numbers):
    start_time = time.time()
    results = [heavy_computation(n) for n in numbers]
    end_time = time.time()
    return end_time - start_time

def run_threaded(numbers):
    start_time = time.time()
    with ThreadPoolExecutor(max_workers=multiprocessing.cpu_count()) as executor:
        results = list(executor.map(heavy_computation, numbers))
    end_time = time.time()
    return end_time - start_time

def run_multiprocess(numbers):
    start_time = time.time()
    with ProcessPoolExecutor(max_workers=multiprocessing.cpu_count()) as executor:
        results = list(executor.map(heavy_computation, numbers))
    end_time = time.time()
    return end_time - start_time

def main():
    # จำนวน CPU cores
    num_cores = multiprocessing.cpu_count()
    print(f"\nRunning on system with {num_cores} CPU cores")

    # สร้างข้อมูลทดสอบ
    test_numbers = [25, 26, 27, 28]  # ปรับขนาดตามต้องการ

    print("\nStarting performance comparison...")
    print("Task: Computing Fibonacci sequences")
    print(f"Input numbers: {test_numbers}")

    # ทดสอบแบบ Sequential
    sequential_time = run_sequential(test_numbers)
    print(f"\n1. Sequential Execution Time: {sequential_time:.2f} seconds")

    # ทดสอบแบบ Threaded
    threaded_time = run_threaded(test_numbers)
    print(f"2. Threaded Execution Time: {threaded_time:.2f} seconds")
    print(f"   Thread Speedup: {sequential_time/threaded_time:.2f}x")

    # ทดสอบแบบ Multiprocess
    multiprocess_time = run_multiprocess(test_numbers)
    print(f"3. Multiprocess Execution Time: {multiprocess_time:.2f} seconds")
    print(f"   Multiprocess Speedup: {sequential_time/multiprocess_time:.2f}x")

    print("\nPerformance Summary:")
    print("-" * 50)
    print(f"Sequential:  100% (baseline)")
    print(f"Threaded:    {(threaded_time/sequential_time)*100:.1f}% of sequential time")
    print(f"Multiprocess: {(multiprocess_time/sequential_time)*100:.1f}% of sequential time")

if __name__ == '__main__':
    main()
```

เราสามารถ run script ด้วย Python version 3.13 ได้โดยใช้คำสั่ง

```bash
uv run -p3.13 threading_test.py
```

ผลลัพธ์ที่ได้จะประมาณนี้

```bash
Python Version: 3.13.0 (main, Oct  8 2024, 01:04:00) [Clang 18.1.8 ]
Platform: Linux-5.15.0-122-generic-x86_64-with-glibc2.36
GIL Status: Enabled

Running on system with 16 CPU cores

Starting performance comparison...
Task: Computing Fibonacci sequences
Input numbers: [25, 26, 27, 28]

1. Sequential Execution Time: 0.12 seconds
2. Threaded Execution Time: 0.12 seconds
   Thread Speedup: 0.97x
3. Multiprocess Execution Time: 0.06 seconds
   Multiprocess Speedup: 1.84x

Performance Summary:
--------------------------------------------------
Sequential:  100% (baseline)
Threaded:    103.2% of sequential time
Multiprocess: 54.2% of sequential time
```

เราจะเห็นได้ว่า Threaded ไม่ได้เพิ่มความเร็วในการทำงานเท่าไหร่ แต่ Multiprocess ได้เพิ่มความเร็วในการทำงานมากเกือบ 2 เท่า ซึ่งเป็นเรื่องปกติสำหรับ Python ที่มี GIL เปิดใช้งานอยู่

แต่ถ้าเรา run script ด้วย Python version 3.13t โดยใช้คำสั่ง

```bash
uv run -p3.13t threading_test.py
```

ผลลัพธ์ที่ได้จะประมาณนี้

```bash
Python Version: 3.13.0 experimental free-threading build (main, Oct  8 2024, 01:06:48) [Clang 18.1.8 ]
Platform: Linux-5.15.0-122-generic-x86_64-with-glibc2.36
GIL Status: Disabled

Running on system with 16 CPU cores

Starting performance comparison...
Task: Computing Fibonacci sequences
Input numbers: [25, 26, 27, 28]

1. Sequential Execution Time: 0.22 seconds
2. Threaded Execution Time: 0.09 seconds
   Thread Speedup: 2.46x
3. Multiprocess Execution Time: 0.10 seconds
   Multiprocess Speedup: 2.22x

Performance Summary:
--------------------------------------------------
Sequential:  100% (baseline)
Threaded:    40.6% of sequential time
Multiprocess: 44.9% of sequential time
```

เราจะเห็นได้ว่า Threaded ได้เพิ่มความเร็วในการทำงานขึ้นมามากกว่า 2 เท่า แต่ถ้าเทียบกับ Multiprocess ก็ยังไม่ได้เร็วเท่าไหร่ แต่เบื้องหลังการงานของ Free Threading จะใช้งานได้เต็มที่บน CPU cores ทั้งหมดโดย overhead จะน้อยกว่า Multiprocess 

## สรุป

ผมได้นำเสนอการใช้งาน uv ฉบับย่อ ๆ เพื่อเป็นแนวทางสำหรับใครที่หาตัวจัดการ project python ที่ง่ายและรวดเร็ว และได้ทดลองใช้งาน Free Threading ใน Python 3.13 ซึ่งเป็น feature ใหม่แต่ยังไม่ถูกเปิดใช้งานอย่างเป็นทางการ ส่วนข้อมูลที่ผมให้อาจจะมีข้อผิดพลาดไม่ตรงตามหลักวิชาการบ้างก็ต้องขออภัยไว้ ณ ที่นี้ และยินดีน้อมรับคำแนะนำจากทุก ๆ ท่าน`