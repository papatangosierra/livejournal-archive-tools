#!/usr/bin/ruby

require "rexml/document"

# IMPORTANT: If you're using Day One Classic, comment out or delete the "YES" line, and uncomment the "NO" line. 
DAYONE2 = 'YES'
# DAYONE2 = 'NO'


# Function for creating a new Day One entry. Checks if the DAYONE2 constant
# has been set; if so, writes to a different store. Uses /tmp/ and a scratch
# file because echo can't be counted upon to deal with UTF-8 encoding.
def create_dayone_entry(subject, date, text)
	if DAYONE2 == 'YES'
		dayone_cmd = 'dayone2'		
		dayone_cmd_options = '-t LiveJournal'
# Uncomment this next line if you've already created a separate Day One journal named
# "Livejournal" and you want entries added to that one instead
#		dayone_cmd_options = '-journal=LiveJournal -t LiveJournal'
	else
		dayone_cmd = 'dayone'
		dayone_cmd_options = '-j="~/Library/Group Containers/5U8NS4GX82.dayoneapp/Data/Auto Import/Default Journal.dayone" new'
	end
# If there's no subject, don't try to use it
	#UGH Open scratch file
	f = File.new("/tmp/" + `uuidgen`.strip + ".txt", "w+")
	f.puts subject
	f.puts text
	f.close
#	cat the temp file and pipe it into the day one command line utility
	return `cat #{f.path.strip} | #{dayone_cmd} #{dayone_cmd_options} --date="#{date} EST" new`
	rm(f)
end

# It's very likely that we're going to be iterating over multiple files, so
# let's try to handle that intelligently!
(0..ARGV.length - 1).each do |j|
	ljdata = REXML::Document.new(File.new(ARGV[j]))

# Extract the relevant data from the ljdata xml object
	subjects = ljdata.elements.to_a('///subject')
	dates = ljdata.elements.to_a('///eventtime')
	entrytexts = ljdata.elements.to_a('///event')

# Iterate over the array; subjects[] is used to derive the index number, but
# that's an arbitrary choice; all three arrays should be the same length

	(0..subjects.length - 1).each do |i|
		# This gets rid of <lj-cut> garbage in a semi-intelligent way;
		# If the cut had a caption associated, we pull that out and
		# format it nicely, otherwise use an <hr />
		entrytexts[i].text.gsub!(/<lj-cut[[:blank:]]text="(?<cuttext>.*)">/, '<p><strong>Under the Fold: \k<cuttext></strong></p>')
		entrytexts[i].text.gsub!(/<lj-cut>/, "<hr />")
		entrytexts[i].text.gsub!(/<\/lj-cut>/, "\n")
		

		# Do some naive HTML-to-Markdown conversion
		entrytexts[i].text.gsub!(/<\/?[pP]>/, "\n")
		entrytexts[i].text.gsub!(/<\/[pP]>/, "")
		entrytexts[i].text.gsub!(/<\/?(strong)*(STRONG)*(b)*(B)*>/, '**')
		entrytexts[i].text.gsub!(/<\/?(em)*(EM)*(i)*(I)*>/, '**')
		entrytexts[i].text.gsub!(/<[aA] .*"(?<url>.*)">(?<linktext>.*)<\/[aA]>/, '[\k<linktext>](\k<url>)')

		# <lj-user> instances are converted to html links.
		entrytexts[i].text.gsub!(/<lj user="(?<username>.*)">/, '<a href="http://\k<username>.livejournal.com/">\k<username></a>')

		if subjects[i].text.to_s.empty?
				puts create_dayone_entry('', dates[i].text, entrytexts[i].text)
			else
				# When there's a subject, give it a top-level markdown header tag before passing it to Day One
				puts create_dayone_entry('# ' + subjects[i].text, dates[i].text, entrytexts[i].text)
			end
			puts "Entry from " + dates[i].text + " added."
		end
end
