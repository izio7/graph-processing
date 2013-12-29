#!/bin/bash -e

if [ $# -ne 2 ]; then
    echo "usage: $0 [input graph] [ec2 nodes]"
    exit -1
fi

# place input in /user/ubuntu/gps-input/
# output is in /user/ubuntu/gps/output/
inputgraph=$(basename $1)

# nodes should be number of EC2 instances
nodes=$2

logname=mst_${inputgraph}_${nodes}_"$(date +%F-%H-%M-%S)"

cd ../master-scripts/

# NOTE: numMaxIterations can be set, but we do not set it
# this is to be fair with Giraph and Mizan (both do not max ss termination)
./start_gps_nodes.sh ${nodes} quick-start "-ifs /user/ubuntu/gps-input/${inputgraph} -hcf /home/ubuntu/hadoop-1.0.4/conf/core-site.xml -jc gps.examples.mst.MSTJobConfiguration -mcfg /user/ubuntu/gps-machine-config/cs848.cfg -log4jconfig /home/ubuntu/gps-rev-110/conf/log4j.config"

cd ../cs848/

echo "WARNING: NOT AUTOMATED. USE SCRIPT TO GET MACHINE STATS."
echo "hadoop dfs -get /user/ubuntu/gps/output/quick-start-machine-stats ./stats-${logname}" > ./${logname}.sh
echo "hadoop dfs -cp /user/ubuntu/gps/output/quick-start-machine-stats /user/ubuntu/gps/stats-${logname}" >> ./${logname}.sh
chmod +x ./${logname}.sh