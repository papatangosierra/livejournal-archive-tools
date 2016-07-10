#!/usr/bin/ruby

# Put your username and password here

lj_username = 'USERNAME' # replace USERNAME with your actual username
lj_password = 'PASSWORD' # replace PASSWORD with your actual password
firstyear = 2002 # Change this to the year your LJ starts

# You shouldn't have to change these, but here they are just in case!
lj_login_url = 'https://www.livejournal.com/login.bml' # LJ Login url
lj_archive_url = 'http://www.livejournal.com/export_do.bml' # XML download URL

# Build login string, then log into LJ and save the cookie.

loginstring = 'ret=1&user=' + lj_username + '&password=' + lj_password + '&action%3Alogin='

puts %x(curl --cookie-jar cookies.txt --data #{loginstring.dump} #{lj_login_url.dump})

# Iterate over years, starting with firstyear and running up to the current year
(firstyear..Time.now.year).each do |current_year|
	# In each month of each year, send POST data that will fetch the LJ XML for that month.
		(1..12).each do |current_month|
			poststring = 'what=journal&year=' + current_year.to_s + '&month=' + current_month.to_s + '&format=xml&header=on&encid=2&field_eventtime=on&field_subject=on&field_event=on'
			open(current_year.to_s + '-' + current_month.to_s + '.xml', 'w') do |f| # Open a file named e.g. "2006-4.xml"
				f.puts %x(curl --cookie cookies.txt --data #{poststring.dump}  #{lj_archive_url.dump}) # run CURL with the current month's POST info and dump the result into a file
				end
				puts "Waiting for 1 second so Livejournal doesn't have a fit..."
				sleep(1)
			end
end
