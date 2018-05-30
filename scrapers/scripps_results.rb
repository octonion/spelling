#!/usr/bin/env ruby
# coding: utf-8

require 'csv'
require 'mechanize'

agent = Mechanize.new{ |agent| agent.history.max_size=0 }
agent.user_agent = 'Mozilla/5.0'

bad = " "



base = "http://spellingbee.com"

path = '//*[@id="copyBody"]/table//tr' #[position()>1]'

first_year = ARGV[0].to_i
last_year = ARGV[1].to_i

(first_year..last_year).each do |year|

  competitions = CSV.open("csv/scripps_competitions_#{year}.csv","r")
  results = CSV.open("csv/scripps_results_#{year}.csv","w")

  competitions.each do |c|

    if not(c[4]=='Spelling')
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
            absolute_href = URI.join(url,href) rescue href
            text = a.text.strip rescue nil
            text.gsub!(bad,"") rescue nil
            text.gsub!("  "," ") rescue nil
            row += [text,absolute_href]
          end

        when 3
          td.xpath("a").each_with_index do |a,k|
            href = a.attributes["href"].value.strip rescue nil
            absolute_href = URI.join(url,href) rescue href
            text = a.text.strip rescue nil
            text.gsub!(bad,"") rescue nil
            text.gsub!("  "," ") rescue nil
            title = a.attributes["title"].value.strip rescue nil
            row += [text,title,absolute_href]
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
      if (row.size > 4)
        results << row
      end
    end
    results.flush
  end

  results.close
  competitions.close

end
