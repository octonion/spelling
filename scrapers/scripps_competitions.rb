#!/usr/bin/env ruby
# coding: utf-8

require 'csv'
require 'mechanize'

agent = Mechanize.new{ |agent| agent.history.max_size=0 }
agent.user_agent = 'Mozilla/5.0'

bad = " "

base = "http://spellingbee.com"

path = '//*[@id="copyBody"]/table/tr'

first_year = ARGV[0].to_i
last_year = ARGV[1].to_i

(first_year..last_year).each do |year|

  results = CSV.open("csv/scripps_competitions_#{year}.csv","w")

  url = "http://spellingbee.com/public/results/#{year}/round_results"

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
          if (["Spelling","Vocabulary"].include?(text))
            href = base+href
          end
          results << row + [k,text,href]
        end
      end
    end
  end
  results.close
end
