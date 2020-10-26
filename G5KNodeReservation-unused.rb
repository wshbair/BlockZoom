#!/usr/bin/ruby -w
require 'cute'
g5k = Cute::G5K::API.new()
nodes_number=Integer(ARGV[0])
time=ARGV[1]
g5knodes=Array.new
jobs=Array.new
sites = g5k.site_uids
job = {}

sites.each do |site|
  job = g5k.reserve(:nodes => nodes_number, :site => site, :walltime => time, :wait => false, :type => :deploy)
  jobs.push(job)
  begin
    job = g5k.wait_for_job(job, :wait_time => 60)
    x=job['assigned_nodes']
    g5k.deploy(job, :env => 'ubuntu1404-x64-min', :wait => true)
    g5knodes=g5knodes+x
    rescue  Cute::G5K::EventTimeout
      puts "We waited too long in site #{site} let's release the job and try in another site"
      g5k.release(job)
    end
end

puts "All nodes are reserved"
puts g5knodes

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
puts "Installing Ethereurm Blockchain on all nodes"

ssh = Net::SSH::Multi::Session::new
g5knodes.each { |n| ssh.use "root@#{n}" }
 ssh.exec!("sudo apt-get update")
 ssh.exec!("sudo apt-get install -y git")
 ssh.exec!("git clone https://github.com/snt-sedan/Blockchain-Testbed.git") #Download needed software
 ssh.exec!("chmod u+x Blockchain-Testbed/Blockchain/ethereum/*.sh") #make the script executable
 ssh.exec!("Blockchain-Testbed/Blockchain/ethereum/install.sh")
 ssh.exec!("Blockchain-Testbed/Blockchain/ethereum/init.sh")#creat a user and run Gensis command

puts "Generating static-node address"
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
puts "Experiment preparation finished"
