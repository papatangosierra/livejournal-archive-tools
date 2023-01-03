#!/usr/bin/env ruby
require 'cgi'
require 'io/console'  ##  For getpass

print("LiveJournal Username: ")
lj_username = $stdin.gets.strip
lj_password = $stdin.getpass("LiveJournal Password: ").strip

firstyear = 1999  ##  LiveJournal went online in 1999

# You shouldn't have to change these, but here they are just in case!
lj_login_url = 'http://www.livejournal.com/interface/flat' # LJ API url
lj_archive_url = 'http://www.livejournal.com/export_do.bml' # XML download URL

# Build login string, then log into LJ and save the cookie.

loginstring = 'mode=sessiongenerate&user=' + CGI.escape(lj_username) + '&password=' + CGI.escape(lj_password)

puts "Logging in..."
lj_session_cookie = %x(curl -# --data #{loginstring.dump} #{lj_login_url.dump}).lines

if lj_session_cookie[0] =~ /ljsession/ # if we logged in successfully, write out the cookie (We can detect a successful login if the first line of the response to our query includes the "ljsession" string
	open('cookies.txt', 'w') do |f|
		f.puts("#HttpOnly_.livejournal.com\tTRUE\t/\tFALSE\t0\tljsession\t" + lj_session_cookie[1])
	end
else
	abort('ERROR: Could not log in to LiveJournal.')
end

# Make sure we actually logged in
unless File.exists?('cookies.txt')
	abort('Error: Could not log in to LiveJournal')
end

# Iterate over years, starting with firstyear and running up to the current year
(firstyear..Time.now.year).each do |current_year|
	# In each month of each year, send POST data that will fetch the LJ XML for that month.
		(1..12).each do |current_month|
			poststring = 'what=journal&year=' + current_year.to_s + '&month=' + current_month.to_s + '&format=xml&header=on&encid=2&field_eventtime=on&field_subject=on&field_event=on'
			month_str = current_month.to_s.rjust 2, "0"  ##  2-digit month
			open "#{current_year}-#{month_str}.xml", "w" do |f|  ##  Open a file named e.g. "2006-04.xml"
				puts "Retrieving #{current_year}-#{month_str}..."
				f.puts %x(curl -L# --cookie cookies.txt --data #{poststring.dump}  #{lj_archive_url.dump}).encode("UTF-8") # run CURL with the current month's POST info and dump the result into a file
				end
				puts "Waiting for 1 second so Livejournal doesn't have a fit..."
				sleep(1)
			end
end

##  Don't leave stray files laying around
puts "Logging out"
File.delete 'cookies.txt' if File.exists?('cookies.txt')
