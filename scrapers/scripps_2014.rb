#!/usr/bin/env ruby
# coding: utf-8

require 'csv'
require 'mechanize'

agent = Mechanize.new{ |agent| agent.history.max_size=0 }
agent.user_agent = 'Mozilla/5.0'

bad = " "

results = CSV.open("csv/scripps_competitions_2014.csv","w")

base = "https://web.archive.org"

path = '//*[@id="copyBody"]/center/table/tr'

year = 2014

url = 'https://web.archive.org/web/20150401074618/http://spellingbee.com:80/public/results/2014/round_results'

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
      td.xpath("a").each_with_index do |a,k|
        href = a.attributes["href"].value.strip rescue nil
        text = a.text.strip rescue nil
        text.gsub!(bad,"") rescue nil
        text.gsub!("  "," ") rescue nil
        results << row + [k,text,base+href]
      end
    end
  end
  results.flush
end

results.close
