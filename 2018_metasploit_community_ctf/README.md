# Metasploit Community CTF 2018 Writeup

## Overview

This is a brief writeup of the CTF since I originally didn't intend on doing a writeup! There was limited time to capture writeup notes after the competition ended, so this is more of a writeup/brain dump.

November 30th, 2018 - December 3rd, 2018

https://metasploitctf.com/

https://blog.rapid7.com/2018/12/03/congrats-to-the-2018-metasploit-community-ctf-winners/

### Players / Teams

Max capacity: 1,000 teams - with any number of players using team account

### Format

Each team is given a Kali instance to ssh into, and from there we could attack the two targets.

One target was an Ubuntu box which was running many docker containers. It was possible to eventually break out of a container and get onto the Ubuntu host as you can see below:

![docker containers][docker_containers]

The other target was a Windows box, where the only entry point was a Buffer Overflow exploit on port 4444. I did not get a shell here until after the competition was over, but captured as many files as I could in that time.

### Flags

Flags came in the form of PNGs showing an image of a card, and to submit the flag we had to subit the MD5 sum of the image.

There were 15 flags in total. 9 flags were in Ubuntu, 5 in Windows, and 1 flag required files that lived in both boxes.

![flags][solves]

### Scoreboard

No  | Team                   | Score
----|------------------------|------
1   | checksec 				 | 1500 
2   | rememberingAaronSwartz | 1500 
3   | Shad0wSynd1cate 		 | 1500 
4   | exit 					 | 1500 
5   | Snadoteam 			 | 1300 
6   | TheAvengers 			 | 1300 
7   | Arachnid 				 | 1300 
8   | Kasselhackt 			 | 1200 
9   | NCATS 				 | 1200 
10  | GirlsTakingOver 		 | 1200 
11  | BisonSquad 			 | 1100 
12  | alertot 				 | 1100 
13  | DH 					 | 1000 
14  | hackstreetboys 		 | 1000 
15  | Blackfoxs 			 | 1000 
16  | b0yd 					 | 900  
17  | USW 					 | 800  
18  | bc 					 | 800  
19  | SB18 					 | 800  
20  | wunder_brot 			 | 800  

My team came 19th.