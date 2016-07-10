#!/usr/bin/ruby

require "rexml/document"

# ljfile = File.new(ARGV[0])
#
# ljdata = REXML::Document.new ljfile

(0..ARGV.length - 1).each do |j|
	ljdata = REXML::Document.new(File.new(ARGV[j]))

# puts ljdata.to_s

# ljdata.elements.each('//entry') do |entry|
# 		entry.elements.each('//')
# 	end

	subjects = ljdata.elements.to_a('///subject')
	dates = ljdata.elements.to_a('///eventtime')
	entrytexts = ljdata.elements.to_a('///event')

	# Fix LJ-specific tags in entries

	# THIS WORKS, but mysteriously encloses subject lines in quotes

	(0..subjects.length - 1).each do |i|
		# This gets rid of <lj-cut> garbage in a semi-intelligent way;
		# If the cut had a caption associated, we pull that out and
		# format it nicely, otherwise use an <hr />
		entrytexts[i].text.gsub!(/<lj-cut[[:blank:]]text="(?<cuttext>.*)">/, '<strong>LJ Cut: \k<cuttext></strong>')
		entrytexts[i].text.gsub!(/<lj-cut>/, "<hr />")
		entrytexts[i].text.gsub!(/<\/lj-cut>/, "\n")

		# <lj-user> instances are converted to html links.
		entrytexts[i].text.gsub!(/<lj user="(?<username>.*)">/, '<a href="http://\k<username>.livejournal.com/">\k<username></a>')

		if subjects[i].text.to_s.empty?
			puts %x(echo <<'EOF' #{entrytexts[i].text.dump} EOF | dayone --date="#{dates[i].text} EST" new )
			else
				subjectline = '<h1>' + subjects[i].text.to_s + '</h1>'
				puts %x(echo <<'EOF' #{subjectline.dump} #{entrytexts[i].text.dump} | dayone --date="#{dates[i].text} EST" new )
			end
			puts "Entry from " + dates[i].text + " printed."
		end
end
