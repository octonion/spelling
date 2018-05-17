#!/usr/bin/env ruby
# coding: utf-8

require 'csv'
require 'mechanize'

agent = Mechanize.new{ |agent| agent.history.max_size=0 }
agent.user_agent = 'Mozilla/5.0'

bad = " "

competitions = CSV.open("csv/scripps_competitions_2014.csv","r")
results = CSV.open("csv/scripps_results_2014.csv","w")

base = "https://web.archive.org"

path = '//*[@id="copyBody"]/table/tr[position()>1]'

competitions.each do |c|

  if not(["Spelling","HTML"].include?(c[4]))
    next
  end

  year = c[0]
  round = c[2]
  url = c[5]

  print "#{year} - #{round}\n"

  begin
    page = agent.get(url)
  rescue
    print "  -> error, retrying\n"
    retry
  end

  page.parser.xpath(path).each_with_index do |tr,i|
    row = [year,round]
    tr.xpath("td").each_with_index do |td,j|
      case j
      when 1
        td.xpath("a").each_with_index do |a,k|
          href = a.attributes["href"].value.strip rescue nil
          text = a.text.strip rescue nil
          text.gsub!(bad,"") rescue nil
          text.gsub!("  "," ") rescue nil
          href = base+href
          row += [text,href]
        end
#      when 3
#        td.xpath("a").each_with_index do |a,k|
#          href = a.attributes["href"].value.strip rescue nil
#          text = a.text.strip rescue nil
#          text.gsub!(bad,"") rescue nil
#          text.gsub!("  "," ") rescue nil
#          title = a.attributes["title"].value.strip rescue nil
#          row += [text,title,href]
#        end
      else
        text = td.text.strip rescue nil
        text.gsub!(bad,"") rescue nil
        text.gsub!("  "," ") rescue nil
        if (text=="")
          text = nil
        end
        row += [text]
      end
    end
    results << row
  end
  results.flush
end

results.close
