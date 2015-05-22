#!/usr/bin/env ruby
# coding: utf-8

require 'csv'
require 'mechanize'

agent = Mechanize.new{ |agent| agent.history.max_size=0 }
agent.user_agent = 'Mozilla/5.0'

bad = " "

results = CSV.open("csv/scripps_competitions_2004.csv","w")

path = '/html/body/table/tr/td/div/center/table/tr[position()>2]'

year = 2004

url = "https://web.archive.org/web/20040811133841/http://spellingbee.com/04bee/rounds/resultsindex.html"

begin
  page = agent.get(url)
rescue
  print "  -> error, retrying\n"
  retry
end

page.parser.xpath(path).each_with_index do |tr,i|
  row = [year,i]
  round_id = 1
  tr.xpath("td").each_with_index do |td,j|
    case j
    when 0
      next
    when 1
      btext = td.text.strip rescue nil
      td.search("a").each_with_index do |a,k|
        href = a.attributes["href"].value.strip rescue nil
        text = a.text.strip rescue nil
        text.gsub!(bad,"") rescue nil
        text.gsub!("  "," ") rescue nil
        if (text =~ /^Round\s[0-9]+$/)
          round_id = text.split(" ")[1]
        end
        if (btext =~ /Status/)
          type = "Status"
        elsif (btext =~ /Written/)
          type = "Written"
        elsif (btext =~ /Qualifiers/)
          type = "Qualifiers"
        elsif (text =~ /Round/)
          type = "Spelling"
        else
          type = text
        end
        href = URI.join(url, href)
        results << row + [round_id,k,type,href]
      end
    end
  end
  results.flush
end

results.close
