#!/usr/bin/env ruby
# coding: utf-8

require 'csv'
require 'mechanize'

agent = Mechanize.new{ |agent| agent.history.max_size=0 }
agent.user_agent = 'Mozilla/5.0'

bad = " "

competitions = CSV.open("csv/scripps_competitions_2007.csv","r")
results = CSV.open("csv/scripps_results_2007.csv","w")

path = "/html/body/center/table/tr[position()>2]"

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
      when 0
        text = td.text.strip rescue nil
        text.gsub!(bad,"") rescue nil
        text.gsub!("  "," ") rescue nil
        text.gsub!(".","") rescue nil
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
          
          href = URI.join(url, href).to_s
          
          row += [text,href]
        end
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
    if not(row[2]==nil or row[3]==nil)
      results << row
    end
  end
  results.flush
end

results.close
