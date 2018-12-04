# 9 of Hearts - port 8777

Similar to 5 of Spades, there was a webservice here with seemingly nothing on it. I actually solved this one by finding it from the host box:

```
find / -name "*.png"
/win/var/lib/docker/aufs/diff/8ea58d85074e146d881c09cff5e2fa8adb4c4ca0cfb20f799d97de098ba30e04/usr/share/nginx/html/9_of_hearts.png
```

I would assume that the intended way might have been to build up a list of possible card names for all cards - 9_of_hearts.png, 9_of_hearts, 9ofhearts, aceofhearts etc. and do a bruteforce search.

However, after exfiltrating the image we find that it does not open.

Inspecting the file seems to show that all the bytes are swapped, so we simply need to reverse that. Below we know the PNG signatures start with `.PNG` and should end with (roughly) `IEND`.

```
$ cat 9_of_hearts_original.png | xxd
00000000: 5089 474e 0a0d 0a1a 0000 0d00 4849 5244  P.GN........HIRD
[..]
0003d100: 3bc7 d096 d71f 0000 0000 4945 4e44 ae42  ;.........IEND.B
```

Using a script we can fix the image:

```ruby
f = File.read('9_of_hearts_original.png').bytes

solution = []

f.each_with_index do |i, index|
	next if index.odd?
  
	solution << f[index+1] # remember nil
	solution << f[index]
end

File.open("wtf.png", "wb"){|fh|
  solution.compact.pack('C*').unpack('H*')[0].scan(/.{2}/) {|e| fh.putc(e.hex)}
}
```

![9 of hearts](9_of_hearts.png)