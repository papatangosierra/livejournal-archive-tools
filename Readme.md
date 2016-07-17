# Get LJ Archives Pashua script

This script relies on Carsten Blüm's [Pashua](http://www.bluem.net/en/mac/pashua/) app to give it a GUI interface. It's meant to put up a window asking for a download location, start year, and LJ credentials, then run a modified version of getljxml.rb in the background. It uses osascript to display Notification Center messages upon each year of archives successfully downloaded, and throws up a dialog box upon completion of the script.

(A progress bar would be more obvious, but that's beyond the scope of what Pashua can do.)

Pashua.rb is the very simple ruby binding.

The script invokes Pashua with the parameters for the interface, then gets the user input. This all seems to work fine. Currently I'm trying to print some "useful" interaction notes to the console.

The script works perfectly when invoked from the terminal. When packaged as an app, per the zip file, and launched via doubleclick, it fails. It _seems_ to be failing on the invocation of curl. I though this might be a path problem, so I've made sure to use the full path of both curl and osascript. It still seems to fail in the same way.

Good luck, I guess.
