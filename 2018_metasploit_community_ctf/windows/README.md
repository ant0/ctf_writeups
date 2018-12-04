# Windows

## Port Scan

```
ec2-user@kali:~$ nmap 172.16.4.86 -p-
Starting Nmap 7.70 ( https://nmap.org ) at 2018-11-30 18:31 UTC
Nmap scan report for 172.16.4.86
Host is up (0.00090s latency).
Not shown: 65520 closed ports
PORT      STATE SERVICE
135/tcp   open  msrpc
139/tcp   open  netbios-ssn
445/tcp   open  microsoft-ds
3389/tcp  open  ms-wbt-server
4444/tcp  open  krb524
5985/tcp  open  wsman
5986/tcp  open  wsmans
47001/tcp open  winrm
49152/tcp open  unknown
49153/tcp open  unknown
49154/tcp open  unknown
49155/tcp open  unknown
49160/tcp open  unknown
49161/tcp open  unknown
49163/tcp open  unknown
```

I also have noted down:

    [+] 172.16.4.86:445       - Host is running Windows 2012 R2 Standard (build:9600) (name:WIN-F0RRKTD2VFF)

## Exploiting 4444

It was confirmed by Metasploit that 4444 was the (intended) entry point. It was buffer overflow on a vulnerable service, and you could grab the exe from the port and run it locally. That exe can be found attached in this Github directory.

Unfortunately I didn't exploit this service during the competition, but got help after it to get a shell from someone a lot more knowledgable than myself in this area (thanks @rangercha). The full code I used to get a shell can be found in `windows_exploit_4444.py`.

## Windows host

There was no docker stuff on this box, so all the flags could be found once getting a shell. I initially used a search from the meterpreter console to search for flags, something like `search -h *.png`.

A dump of info that I found from the box.

```
meterpreter > ls
Listing: C:\users\administrator\desktop
=======================================
Mode              Size    Type  Last modified              Name
----              ----    ----  -------------              ----
100666/rw-rw-rw-  263343  fil   2018-12-03 21:45:18 +0000  9_of_spades.png
100666/rw-rw-rw-  527     fil   2014-05-17 04:52:54 +0000  EC2 Feedback.website
100666/rw-rw-rw-  554     fil   2014-05-17 04:52:53 +0000  EC2 Microsoft Windows Guide.website
100666/rw-rw-rw-  146     fil   2018-11-28 19:24:03 +0000  README.txt
100666/rw-rw-rw-  460562  fil   2018-11-28 19:24:38 +0000  ace_of_hearts.png.gpg
100666/rw-rw-rw-  282     fil   2014-05-21 04:07:54 +0000  desktop.ini
100666/rw-rw-rw-  669879  fil   2018-11-28 19:24:52 +0000  queen_of_clubs.eml
```

```
C:\users\administrator\desktop>systeminfo
systeminfo

Host Name:                 WIN-F0RRKTD2VFF
OS Name:                   Microsoft Windows Server 2012 R2 Standard
OS Version:                6.3.9600 N/A Build 9600
OS Manufacturer:           Microsoft Corporation
OS Configuration:          Standalone Server
OS Build Type:             Multiprocessor Free
Registered Owner:          EC2
Registered Organization:   Amazon.com
Product ID:                00252-70000-00000-AA535
Original Install Date:     11/28/2018, 6:26:31 PM
System Boot Time:          12/1/2018, 10:26:34 AM
System Manufacturer:       Xen
System Model:              HVM domU
System Type:               x64-based PC
Processor(s):              1 Processor(s) Installed.
                           [01]: Intel64 Family 6 Model 63 Stepping 2 GenuineIntel ~2400 Mhz
BIOS Version:              Xen 4.2.amazon, 8/24/2006
Windows Directory:         C:\Windows
System Directory:          C:\Windows\system32
Boot Device:               \Device\HarddiskVolume1
System Locale:             en-us;English (United States)
Input Locale:              en-us;English (United States)
Time Zone:                 (UTC) Coordinated Universal Time
Total Physical Memory:     2,048 MB
Available Physical Memory: 1,290 MB
Virtual Memory: Max Size:  10,240 MB
Virtual Memory: Available: 9,478 MB
Virtual Memory: In Use:    762 MB
Page File Location(s):     C:\pagefile.sys
Domain:                    WORKGROUP
Logon Server:              N/A
```

```
Connection list
===============

    Proto  Local address                  Remote address       State        User  Inode  PID/Program name
    -----  -------------                  --------------       -----        ----  -----  ----------------
    tcp    0.0.0.0:135                    0.0.0.0:*            LISTEN       0     0      736/svchost.exe
    tcp    0.0.0.0:445                    0.0.0.0:*            LISTEN       0     0      4/System
    tcp    0.0.0.0:3389                   0.0.0.0:*            LISTEN       0     0      1604/svchost.exe
    tcp    0.0.0.0:4444                   0.0.0.0:*            LISTEN       0     0      6044/vulnerable_service.exe
    tcp    0.0.0.0:5985                   0.0.0.0:*            LISTEN       0     0      4/System
    tcp    0.0.0.0:5986                   0.0.0.0:*            LISTEN       0     0      4/System
    tcp    0.0.0.0:47001                  0.0.0.0:*            LISTEN       0     0      4/System
    tcp    0.0.0.0:49152                  0.0.0.0:*            LISTEN       0     0      560/wininit.exe
    tcp    0.0.0.0:49153                  0.0.0.0:*            LISTEN       0     0      848/svchost.exe
    tcp    0.0.0.0:49154                  0.0.0.0:*            LISTEN       0     0      880/svchost.exe
    tcp    0.0.0.0:49155                  0.0.0.0:*            LISTEN       0     0      1120/spoolsv.exe
    tcp    0.0.0.0:49160                  0.0.0.0:*            LISTEN       0     0      644/services.exe
    tcp    0.0.0.0:49161                  0.0.0.0:*            LISTEN       0     0      1692/svchost.exe
    tcp    0.0.0.0:49163                  0.0.0.0:*            LISTEN       0     0      652/lsass.exe
    tcp    127.0.0.1:49207                0.0.0.0:*            LISTEN       0     0      1128/ir_agent.exe
    tcp    127.0.0.1:49207                127.0.0.1:49215      ESTABLISHED  0     0      1128/ir_agent.exe
    tcp    127.0.0.1:49207                127.0.0.1:49218      ESTABLISHED  0     0      1128/ir_agent.exe
    tcp    127.0.0.1:49215                127.0.0.1:49207      ESTABLISHED  0     0      720/ir_agent.exe
    tcp    127.0.0.1:49218                127.0.0.1:49207      ESTABLISHED  0     0      2308/ir_agent.exe
    tcp    127.0.0.1:49220                0.0.0.0:*            LISTEN       0     0      2084/ir_agent.exe
    tcp    127.0.0.1:49220                127.0.0.1:49221      ESTABLISHED  0     0      2084/ir_agent.exe
    tcp    127.0.0.1:49221                127.0.0.1:49220      ESTABLISHED  0     0      720/ir_agent.exe
    tcp    172.16.4.86:139                0.0.0.0:*            LISTEN       0     0      4/System
    tcp    172.16.4.86:4444               172.16.4.84:50110    CLOSE_WAIT   0     0      6044/vulnerable_service.exe
    tcp    172.16.4.86:57816              172.16.4.84:7711     ESTABLISHED  0     0      6044/vulnerable_service.exe
    tcp    172.16.4.86:57843              172.16.254.254:5508  ESTABLISHED  0     0      1128/ir_agent.exe
    tcp    172.16.4.86:57856              169.254.169.254:80   CLOSE_WAIT   0     0      1388/Ec2Config.exe
    tcp    172.16.4.86:57858              172.16.254.254:8037  TIME_WAIT    0     0      0/[System Process]
    tcp6   :::135                         :::*                 LISTEN       0     0      736/svchost.exe
    tcp6   :::445                         :::*                 LISTEN       0     0      4/System
    tcp6   :::3389                        :::*                 LISTEN       0     0      1604/svchost.exe
    tcp6   :::5985                        :::*                 LISTEN       0     0      4/System
    tcp6   :::5986                        :::*                 LISTEN       0     0      4/System
    tcp6   :::47001                       :::*                 LISTEN       0     0      4/System
    tcp6   :::49152                       :::*                 LISTEN       0     0      560/wininit.exe
    tcp6   :::49153                       :::*                 LISTEN       0     0      848/svchost.exe
    tcp6   :::49154                       :::*                 LISTEN       0     0      880/svchost.exe
    tcp6   :::49155                       :::*                 LISTEN       0     0      1120/spoolsv.exe
    tcp6   :::49160                       :::*                 LISTEN       0     0      644/services.exe
    tcp6   :::49161                       :::*                 LISTEN       0     0      1692/svchost.exe
    tcp6   :::49163                       :::*                 LISTEN       0     0      652/lsass.exe
    udp    0.0.0.0:500                    0.0.0.0:*                         0     0      880/svchost.exe
    udp    0.0.0.0:3389                   0.0.0.0:*                         0     0      1604/svchost.exe
    udp    0.0.0.0:4500                   0.0.0.0:*                         0     0      880/svchost.exe
    udp    0.0.0.0:5355                   0.0.0.0:*                         0     0      1012/svchost.exe
    udp    172.16.4.86:137                0.0.0.0:*                         0     0      4/System
    udp    172.16.4.86:138                0.0.0.0:*                         0     0      4/System
    udp    172.16.4.86:53970              0.0.0.0:*                         0     0      2268/ir_agent.exe
    udp6   :::500                         :::*                              0     0      880/svchost.exe
    udp6   :::3389                        :::*                              0     0      1604/svchost.exe
    udp6   :::4500                        :::*                              0     0      880/svchost.exe
    udp6   :::5355                        :::*                              0     0      1012/svchost.exe
    udp6   fe80::ec8c:ecdd:a14d:52e4:546  :::*                              0     0      848/svchost.exe
```