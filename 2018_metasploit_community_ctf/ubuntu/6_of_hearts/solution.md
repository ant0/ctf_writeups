# 6 of Hearts - port 8443

Similar to 9 of Hearts, there was a webservice here with seemingly nothing on it. I actually solved this one by finding it from the host box (see King of Hearts for more info). This time I searched for a certain CTF keyword:

```
find / -name "*flag*"
/win/var/lib/docker/aufs/diff/<hash>/var/lib/postgresql/.msf4/loot/flag
```

![6 of hearts](6_of_hearts.png)