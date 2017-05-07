#!/usr/bin/env ruby
# coding: utf-8

require 'csv'
require 'mechanize'

require 'pg'

con = PG::Connection.open(:dbname => 'spelling')

words = con.exec_params("select distinct word from scripps.results order by word asc limit 10;")

agent = Mechanize.new{ |agent| agent.history.max_size=0 }

#Googlebot/2.1 (+http://www.google.com/bot.html)'
#'Mozilla/5.0'

agent.user_agent = 'Mozilla/5.0'

base = "http://www.google.com/search?q=define:+"

path='//*[@id="uid_0"]' #/div[1]/div/div[1]/div[3]/div[3]'

results = CSV.open("csv/words_google.csv","w")

words.each do |row|

  word = row["word"]
  print "#{word} - "
  
  url = "#{base}#{word}"
  p url

  begin
    page = agent.get(url, :referer => "http://www.google.com/")
  rescue
    #print "  -> error, retrying\n"
    print "  -> error\n"
    next
    #retry
  end

  #p page.body
  #next

  page.parser.xpath(path).each_with_index do |w,i|
    p w.text
    origin = w.text.split(",")[0].strip
    print "#{origin}\n"
    results << [word, origin]
  end
end

results.close
