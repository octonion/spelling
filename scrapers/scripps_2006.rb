#!/usr/bin/env ruby
# coding: utf-8

require 'csv'
require 'mechanize'

agent = Mechanize.new{ |agent| agent.history.max_size=0 }
agent.user_agent = 'Mozilla/5.0'

bad = " "

results = CSV.open("csv/scripps_competitions_2006.csv","w")

path = '/html/body/center/table/tr'

year = 2006

url = "https://web.archive.org/web/20060721121245/http://www.spellingbee.com/results.asp"

begin
  page = agent.get(url)
rescue
  print "  -> error, retrying\n"
  retry
end

page.parser.xpath(path).each_with_index do |tr,i|
  row = [year,i]
  tr.xpath("td").each_with_index do |td,j|
    case j
    when 0
      text = td.text.strip rescue nil
      text.gsub!(bad,"") rescue nil
      text.gsub!("Round ","") rescue nil
      text.gsub!(":","") rescue nil
      if (text=="")
        text = nil
      end
      row += [text]
    when 1
      td.search("a").each_with_index do |a,k|
        href = a.attributes["href"].value.strip rescue nil
        text = a.text.strip rescue nil
        text.gsub!(bad,"") rescue nil
        text.gsub!("  "," ") rescue nil
        href = URI.join(url, href)
        results << row + [k,text,href]
      end
    end
  end
  results.flush
end

results.close
