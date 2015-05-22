#!/usr/bin/env ruby
# coding: utf-8

require 'csv'
require 'mechanize'

agent = Mechanize.new{ |agent| agent.history.max_size=0 }
agent.user_agent = 'Mozilla/5.0'

bad = " "

results = CSV.open("csv/scripps_competitions_1999.csv","w")

path = '/html/body/table[1]/tr/td[2]/center/table/tr'

year = 1999

url = "https://web.archive.org/web/20000903063840/http://www.spellingbee.com/99bee/rounds99/results99.htm"

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
    when 0,1
      next
    when 2
      btext = td.text.strip rescue nil
      td.search("a").each_with_index do |a,k|
        href = a.attributes["href"].value.strip rescue nil
        text = a.text.strip rescue nil
        text.gsub!(bad,"") rescue nil
        text.gsub!("  "," ") rescue nil
        if (text =~ /^Round[\s]*[0-9]+$/)
          round_id = text.split[1]
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
