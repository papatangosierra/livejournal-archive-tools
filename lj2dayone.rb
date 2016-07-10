#!/usr/bin/ruby

require "rexml/document"

# It's very likely that we're going to be iterating over multiple files, so
# let's try to handle that intelligently

# IMPORTANT: Uncomment the next line and delete the 'NO' line
# if you are using Day One 2
# DAYONE2 = 'YES'
DAYONE2 = 'NO'

dayone_cmd_options = '-j "~/Library/Group Containers/5U8NS4GX82.dayoneapp2/Data/Auto Import/Default Journal.dayone" new'

# Function for creating a new Day One entry. Checks if the DAYONE2 constant
# has been set; if so, writes to a different store.
def create_dayone_entry(subject, date, text)
	if DAYONE2 == 'YES'
		dayone_cmd_options = '-j "~/Library/Group Containers/5U8NS4GX82.dayoneapp2/Data/Auto Import/Default Journal.dayone" new'
	else
		dayone_cmd_options = ''
	end
# If there's no subject, don't try to use it
	if subject.empty?
		return %x(echo <<'EOF' #{text.dump} | dayone -j #{dayone_cmd_options} --date="#{date} EST" new )
	else
		return %x(echo <<'EOF' #{subject.dump} #{text.dump} | #{dayone_cmd_options} dayone --date="#{date} EST" new )
	end
end

(0..ARGV.length - 1).each do |j|
	ljdata = REXML::Document.new(File.new(ARGV[j]))

# Extract the relevant data from the ljdata xml object
	subjects = ljdata.elements.to_a('///subject')
	dates = ljdata.elements.to_a('///eventtime')
	entrytexts = ljdata.elements.to_a('///event')

# Iterate over the array; subjects[] is used as the count array, but
# that's an arbitrary choice; all three arrays should be the same length

	(0..subjects.length - 1).each do |i|
		# This gets rid of <lj-cut> garbage in a semi-intelligent way;
		# If the cut had a caption associated, we pull that out and
		# format it nicely, otherwise use an <hr />
		entrytexts[i].text.gsub!(/<lj-cut[[:blank:]]text="(?<cuttext>.*)">/, '<p><strong>Under the Fold: \k<cuttext></strong></p>')
		entrytexts[i].text.gsub!(/<lj-cut>/, "<hr />")
		entrytexts[i].text.gsub!(/<\/lj-cut>/, "\n")

		# <lj-user> instances are converted to html links.
		entrytexts[i].text.gsub!(/<lj user="(?<username>.*)">/, '<a href="http://\k<username>.livejournal.com/">\k<username></a>')

		if subjects[i].text.to_s.empty?
				puts create_dayone_entry('', dates[i].text, entrytexts[i].text)
			else
				# When there's a subject, give it H1 tags before passing it to
				puts create_dayone_entry('<h1>' + subjects[i].text + '</h1>', dates[i].text, entrytexts[i].text)
			end
			puts "Entry from " + dates[i].text + " added."
		end
end
