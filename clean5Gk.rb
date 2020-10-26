#!/usr/bin/ruby -w 
require 'cute' 
require 'json'
g5k = Cute::G5K::API.new()
jobs = File.open("jobs.txt").read.split("}\n").join("},")+"}"
data =JSON.parse([jobs].to_s)
puts data
data.each do |job|
g5k.release(job)
puts job
end
