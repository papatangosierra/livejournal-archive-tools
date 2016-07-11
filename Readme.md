# Hello!

If you're still using [Livejournal][lj], odds are you've got a _lot_ of stuff there. LJ does let you download your archives, but their tool only lets you do it one month at a time.

My personal archives on LJ go back to 2002, and the idea of individually downloading well in excess of a hundred files by hand seems absurd. So here's a way to get your whole LJ archive without doing that.

First of all, you need to be able to run ruby scripts. If you're on a Mac or Linux machine, you already can. If you're running Windows, I assume there's some way to do this, but hell if I know what it is.

## How to use getljxml.rb on a Mac

First, download the file. Then put it in the directory where you want your LJ archives to be downloaded.

Then open up `getljxml.rb` in a text editor. DO NOT PANIC at this point. Replace USERNAME with your username, and PASSWORD with your password. (This script does not steal your password. It sends it to Livejournal the same way your browser does.) Also, change 2002 to the first year your own journal started.

**NOTE:** Make sure that your username and password are surrounded with single straight quotes, like this one: '. If the text editor you're using smartens them, the script will not work. 

You're almost done.

Now, open up a Terminal window. Don't worry, you can do this. I believe in you.

If you're on a Mac, type `cd `, put a space after it, and then drag the folder containing `getljxml.rb` into the terminal window. Then hit `return`.

**You're almost done.**

Now, type two things.

> `chmod u+x getljxml.rb` (Then hit return!)

> `./getljxml.rb` (Hit return again!)

Now you should see a bunch of stuff happening. When stuff stops happening, look at your folder again. You should have a bunch of .xml files in there, each one corresponding to a month of entries from your Livejournal. Huzzah!

## How to use getljxml on a Linux machine

If you're running Linux, I sincerely hope you know how to run a script at the shell. If you can't, you're beyond my help.

## How to use getljxml on a Windows machine

Hell if I know.

## How to use lj2dayone.rb

Put the `lj2dayone.rb` file in the same folder as all your LJ XML files. If you're using Day One Classic, you don't need to edit the script at all. You can skip to the terminal commands below. However, if you're running the beautiful new Day One 2 app, open `lj2dayone.rb` in a text editor. Find the lines that look like this:

	# DAYONE2 = 'YES'
	DAYONE2 = 'NO'

And change them to look like this:

	DAYONE2 = 'YES'
	# DAYONE2 = 'NO'

This makes sure the script adds your entries in the right place.

Next open up a terminal window (I know, I know) and type

> `chmod u+x lj2dayone.rb` (Hit return.)

> `./lj2dayone.rb *.xml` (And hit return again)

Depending on how many LJ entries you have to import, this could take a few minutes. Once's it's finished, you can open up Day One and gaze upon your beautiful new archive.


[lj]: http://www.livejournal.com
