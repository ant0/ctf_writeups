# 5 of Spades - port 9021

I was doing some enum and found it by searching by file extension.

```
dirb http://172.16.4.85:9021 /usr/share/wordlists/dirb/big.txt -X .png
+ http://172.16.4.85:9021/0.png (CODE:200|SIZE:395196)
```

![5 of spades](5_of_spades.png)