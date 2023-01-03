# Hello!

If you're still using [Livejournal][lj], odds are you've got a _lot_ of stuff there. LJ does let you download your archives, but their tool only lets you do it one month at a time.

My personal archives on LJ go back to 2002, and the idea of individually downloading well in excess of a hundred files by hand seems absurd. So here's a way to get your whole LJ archive without doing that.

First of all, you need to be able to run ruby scripts. If you're on a Mac or Linux machine, you already can. If you're running Windows, it takes a little bit of doing, but you can still do it!

## How to use getljxml.rb on a Mac

First, download and unzip the files. ([Here's a link for doing that](https://github.com/papatangosierra/livejournal-archive-tools/archive/refs/heads/master.zip)). Then move the file `getljxml.rb` to the directory where you want your LJ archives to be downloaded.

Now, open up a Terminal window. Don't worry, you can do this. I believe in you.

If you're on a Mac, type `cd `, put a space after it, and then drag the folder containing `getljxml.rb` into the terminal window. Then hit `return`.

**You're almost done.**

Now, type two things.

> `chmod u+x getljxml.rb` (Then hit return!)

> `./getljxml.rb` (Hit return again!)

When it prompts you, enter you LiveJournal username and password.  Nothing will appear on the screen as you type your password, so anyone looking over your shoulder will not see it.

Now you should see each month's posts retrieved one at a time.  When the retrievals stop (at the end of the current year), look at your folder again.  You should have a bunch of .xml files in there, each one corresponding to a month of entries from your Livejournal.  Huzzah!

## How to use getljxml on a Linux machine

It's the same as doing it on a Mac! 

## How to use getljxml on a Windows machine

This takes a little work. You'll need to install a couple of things that don't come with Windows by default. 

### Installing Ruby on Windows
First, you'll need to install Ruby. 

1. Go to https://rubyinstaller.org/downloads/
2. Click on one of the Ruby installers to download and run. 
	If you're not sure which one of the installers to choose, read the text on the right-hand side of the page under 'Which Versions to Download?'. This is a fairly simple script, and will probably run with any version of Ruby, so don't stress too much over what to pick. 
3. Run the installer. 

### Installing cURL on Windows
Next you'll need to install cURL, which is basically a web browser that your script can use from the command line. Unfortunately, this can be a bit fiddly. The simplest set of instructions that I've found are available here: https://help.zendesk.com/hc/en-us/articles/229136847-Installing-and-using-cURL#install

If you follow them step by step, you should get it working. 

### Running the getljxml script
Okay, now that you've done that, you're almost home free. 
First, download the getljxml.rb file:

1. From https://github.com/papatangosierra/livejournal-archive-tools, click the **Clone or download** button. 
2. Click **Download ZIP**
3. Extract the contents of the zip file and copy the getljxml.rb script to a folder where you want your files to be backed up. 

Then, edit the getljxml.rb file with a text editor like Notepad. Replace USERNAME with your username, and PASSWORD with your password. (This script does not steal your password. It sends it to Livejournal the same way your browser does.) Also, change 2002 to the first year your own journal started. (If you don't know what year your journal started, go to your profile page and look for the date your account was created near the top.) 

**NOTE:** Make sure that your username and password are surrounded with single straight quotes, like this one: '. If the text editor you're using smartens them, the script will not work. 

Now you're ready to run the script. 

1. Click **Start** and type `cmd` to open a command-line window. 
2. Type `cd` followed by the path to the folder where the getljxml.rb script is located. 
	To find the path, browse to the folder in Windows Explorer. Click in an empty part of the address bar of the window to show  and select the path. Press Ctrl+C to copy the path. Right-click in the command-line window and select paste to paste the path you have copied. 
3. Type `ruby getljxml.rb` to run the script. 

Now you should see a bunch of stuff happening. When stuff stops happening, look at your folder again. You should have a bunch of .xml files in there, each one corresponding to a month of entries from your Livejournal. Huzzah!

## How to use lj2dayone.rb

Put the `lj2dayone.rb` file in the same folder as all your LJ XML files. If you're running Day One 2 or 3, you can use the script as-is, so skip to the terminal commands below. However, if you're using Day One Classic, you'll need to edit the `lj2dayone.rb` script slightly. 

Open `lj2dayone.rb` in a text editor. Find the lines that look like this:

	DAYONE2 = 'YES'
	# DAYONE2 = 'NO'

And change them to look like this:

	# DAYONE2 = 'YES'
	DAYONE2 = 'NO'

This makes sure the script adds your entries in the right place.

Next open up a terminal window (I know, I know) and type

> `chmod u+x lj2dayone.rb` (Hit return.)

> `./lj2dayone.rb *.xml` (And hit return again)

Depending on how many LJ entries you have to import, this could take a few minutes. Once's it's finished, you can open up Day One and gaze upon your beautiful new archive.


[lj]: http://www.livejournal.com
