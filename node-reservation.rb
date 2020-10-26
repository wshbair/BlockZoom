#!/usr/bin/ruby -w
require 'cute'


def colorize(text, color = "default", bgColor = "default")
    colors = {"default" => "38","black" => "30","red" => "31","green" => "32","brown" => "33", "blue" => "34", "purple" => "35",
     "cyan" => "36", "gray" => "37", "dark gray" => "1;30", "light red" => "1;31", "light green" => "1;32", "yellow" => "1;33",
      "light blue" => "1;34", "light purple" => "1;35", "light cyan" => "1;36", "white" => "1;37"}
    bgColors = {"default" => "0", "black" => "40", "red" => "41", "green" => "42", "brown" => "43", "blue" => "44",
     "purple" => "45", "cyan" => "46", "gray" => "47", "dark gray" => "100", "light red" => "101", "light green" => "102",
     "yellow" => "103", "light blue" => "104", "light purple" => "105", "light cyan" => "106", "white" => "107"}
    color_code = colors[color]
    bgColor_code = bgColors[bgColor]
    return "\033[#{bgColor_code};#{color_code}m#{text}\033[0m"
end
#----------------------------------------------------------------------------------------


g5k = Cute::G5K::API.new()
nodes_number=Integer(ARGV[0])
time=ARGV[1]
g5knodes=Array.new
jobs=Array.new
#sites = g5k.site_uids
sites=['luxembourg','grenoble','nantes','nancy','lyon','rennes', 'sophia']

job = {}

#should be less than 8
sites_number=Integer(ARGV[2])-1

i=0 
while i<=sites_number do
job = g5k.reserve(:nodes => nodes_number, :site => sites[i], :walltime => time, :wait => false, :type => :deploy)
jobs.push(job)

begin 
   job = g5k.wait_for_job(job, :wait_time => 60)  
   x=job['assigned_nodes']  
   g5k.deploy(job, :env => 'ubuntu1404-x64-min', :wait => true)  
   g5knodes=g5knodes+x  
   rescue  Cute::G5K::EventTimeout  
   #puts "We waited too long in site #{sites[i]} let's release the job and try in another site"   
   puts "#{colorize("We waited too long in site #{sites[i]} let's release the job and try in another site",'yellow')}"
   g5k.release(job)  
end

i=i+1
end 


if g5knodes.length > 0 
puts "All nodes are reserved"
#puts g5knodes

# Save Nodes names
File.open("nodes.txt", "w+") do |f|
  f.puts(g5knodes)
end
#save jobs id
File.open("jobs.txt", "w+") do |x|   
x.puts(jobs) 
end

output = File.open( "static-nodes.json","w" )
nodeslink=[]
puts "Install and init Ethereum blockchain "

Net::SSH::Multi.start do |ssh|

g5knodes.each { |n| ssh.use "root@#{n}" }
 ssh.exec!("sudo apt-get update")
 ssh.exec!("sudo apt-get install -y git")
 ssh.exec!("git clone https://github.com/snt-sedan/Blockchain-Testbed.git") #Download needed software
 ssh.exec!("chmod u+x Blockchain-Testbed/Blockchain/ethereum/*.sh") #make the script executable
 ssh.exec!("Blockchain-Testbed/Blockchain/ethereum/install.sh")
 ssh.exec!("Blockchain-Testbed/Blockchain/ethereum/init.sh")#creat a user and run Gensis command
 ssh.exec!("Blockchain-Testbed/Blockchain/ethereum/workloads.sh")#compile the workload generator
# ssh.exec!("chmod u+x Blockchain-Testbed/*.sh")
# ssh.exec!("Blockchain-Testbed/run-monitor.sh") # start MGEN in Listening mode

end

puts "Generate static node address"
# We needd to get the address of the static node
output = File.open( "static-nodes.json","w" )
nodeslink=[]
for @hostname in g5knodes
  @username = "root"
  @password = ""
  @cmd = "Blockchain-Testbed/Blockchain/ethereum/GenerateStaticNode.sh"
  ssh = Net::SSH.start(@hostname, @username, :password => @password)
  res = ssh.exec!(@cmd)
  nodeslink.push(res)
  ssh.close
end
output<<'[ '+nodeslink.join(',')+' ]'
output.close
puts "Experiment preparation finished."
return 0
else
#puts "No nodes have been reserved"
puts "#{colorize("No nodes have been reserved",'red')}"
return 0
end
