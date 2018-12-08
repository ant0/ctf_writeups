# 2 of Clubs

Hints by Metasploit:

> "SEE MOM, I'm Hiding!"
> little 2 of Clubs Cried
> When we gazed at the yard
> Meeting no-one outside
> I said "he's hid good"
> now what else have we tried?

> The strangest places are the best. Still in doubt? Try wbemtest.

This hint's at using `wbemtest`. I had no idea what it meant, so a quick search shows that it's related to [WMI](https://docs.microsoft.com/en-us/sccm/develop/core/understand/introduction-to-wbemtest).

> Windows Management Instrumentation, WMI is an API designed by Microsoft that allows the control of systems and devices in a network.

I found a decent explation on it [here](http://hackingandsecurity.blogspot.com/2016/08/using-credentials-to-own-windows-boxes_99.html).

`wbemtest` is a GUI tool, but I didn't have a RDP session at this stage (it was possible to use Remote Desktop with some extra effort), so the alternative is `wmic` to make remote queries.

I used the following to list out all the classes:

```
powershell -command "Get-WmiObject -List"
```

Over a thousand results are returned, and browsing through it we see that one stands out:

	Win32_RoamingProfileBackgroundUp... {}                   {Interval, Scheduli...
	CIM_ToDirectoryAction               {}                   {DestinationDirecto...
	CIM_ActsAsSpare                     {}                   {Group, HotStandby,...
	Win32_RoamingProfileSlowLinkParams  {}                   {ConnectionTransfer...
	MSFlag                              {}                   {FileName, FileStor...
	Win32_SecuritySettingAccess         {}                   {AccessMask, GuidIn...
	Win32_LogicalFileAccess             {}                   {AccessMask, GuidIn...
	Win32_LogicalShareAccess            {}                   {AccessMask, GuidIn...
	Win32_OfflineFilesHealth            {}                   {LastSuccessfulSync...
	CIM_StorageDefect                   {}                   {Error, Extent}
	Win32_PerfFormattedData_AFDCount... {}                   {Caption, Descripti...

Now we want to inspect the class more, so use the command:

```
powershell -command "Get-WmiObject -Class MSFlag"
```

This returns a whole lot of data, but importantly we can see we're in the right place with `MSFlag.FileName="2_of_clubs"`.

From manually inspecting the data, we can see there are many blocks of base64 and also index numbers - `"<base64>",Index="<int>"`. Starting at index 0, we manually decode the block and see it outputs a string of integers. Converting each integer to ascii shows the start as `PNG`! Checking the last block shows `IEND`.

Now we just need to write a script to grab all the base64 blocks and write it to file by order of index. Also note that there seem to be duplicate blocks of base64 and index blocks, so you'll have to handle this. Regexp would be a good way but I only used a little regexp so far:

```ruby
require 'base64'

# join all lines together to process data easier
data = File.read('2_of_clubs.txt').delete(' ').delete "\n"

output = ""

# iterate based on number of indexes found from manual scanning
(0..467).each do |i|
	# there's actually two matches with "scan", but only need one since they're the same so use "match"
	index_position = data.enum_for(:match, /,Index=\"#{i}\"/).map { Regexp.last_match.begin(0) }.join.to_i
	b64_start = (i == 467) ? index_position - 2 - 4567 : index_position - 2 - 7999
	b64_end = index_position - 2
	output << (b64_start..b64_end).map { |x| data[x] }.join
end

# output gets decoded to a string of ints - convert ints to hex to write to file
decoded = Base64.decode64(output).delete("\x00").split.map(&:to_i).map { |x| x.to_s(16).rjust(2,'0') }.join

File.open("2_of_clubs.png", "wb"){|fh|
  decoded.scan(/.{2}/) { |e| fh.putc(e.hex) }
}
```

![2 of clubs](2_of_clubs.png)