#!/usr/bin/env ruby
# coding: utf-8

require 'csv'
require 'mechanize'

require 'pg'

con = PG::Connection.open(:dbname => 'spelling')

words = con.exec_params("select word from scripps.results where year=2016 and word not in (select distinct word from scripps.results where year<=2015) order by word asc;")

agent = Mechanize.new{ |agent| agent.history.max_size=0 }

#'Mozilla/5.0'

agent.user_agent = 'Googlebot/2.1 (+http://www.google.com/bot.html)'

base = "http://www.merriam-webster.com/dictionary" #/feuilleton"

results = CSV.open("csv/words_2016.csv","w")

words.each do |row|

  word = row["word"]
  print "#{word} - "
  
  url = "#{base}/#{word}"

  begin
    page = agent.get(url, :referer => "http://www.google.com/")
  rescue
    #print "  -> error, retrying\n"
    print "  -> error\n"
    next
    #retry
  end

  #'//*[@id="mwEntryData"]/div[2]/div[9]/div'
  path='//div[@class="etymology"]/div/text()[1]'

  page.parser.xpath(path).each_with_index do |w,i|
    origin = w.text.split(",")[0].strip
    print "#{origin}\n"
    results << [word, origin]
  end
end

results.close
