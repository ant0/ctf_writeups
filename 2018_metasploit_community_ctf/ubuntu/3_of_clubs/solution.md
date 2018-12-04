# 3 of Clubs - port 31063

First check what's there `curl 172.16.4.85:31063`

```html

<HTML>
  <HEAD>
    <TITLE>3 of Clubs</TITLE>
    <SCRIPT>
      function flagme() {
        window.location.pathname = document.getElementById('flag').value + '.png';
      }
    </SCRIPT>
  </HEAD>
  <BODY>
  <P>In one word, how would you describe the reward which you seek?</P>

  <P><INPUT ID="flag"><INPUT TYPE="BUTTON" VALUE="SUBMIT" ONCLICK="flagme()"></P>
  </BODY>
</HTML>
```

Looks like we simply need to figure out the word used, then the flag can be found at `/<solution>.png`.

I first wrote a quick and dirty script to bruteforce this based on dictionary words, but using a dirbuster type tool would work too. The problem is that you'd need a comprehensive dictionary, so it would take a while.

```ruby
File.open("words.txt") do |file|
	file.each_with_index do |line, index|
		word = line.strip.downcase.delete("'")
		#next if index < 90600 # used if the box was reset/crashed
		url = "172.16.4.85:31063/" + word + ".png"
		res = `curl -s #{url}`

		if !res.include? "404"
			puts "********************************************"
			puts word
			puts "********************************************"
			break
		end

		if index % 300 == 0
			puts "#{index}: #{word}"
		end
	end
end
```

While waiting for that to run, taking a look at the CTF rules showed something interesting on the last page.

https://information.rapid7.com/rs/411-NAK-970/images/Metasploit-Community-CTF-2018-Official-Rules.pdf

	13. CONTACT.
	For more information, please see the contest website here:
	https://metasploit.com/communityctf2018.
	Thanks for actually reading our terms of service. As a show of our gratitude, please find your
	splendiferous reward by pointing a web browser to your Linux host on port 31063.

And there was the solution all along - **splendiferous**

Get the flag from 172.16.4.85:31063/splendiferous.png

![3 of clubs](3_of_clubs.png)