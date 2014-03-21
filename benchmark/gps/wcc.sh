#!/bin/bash -e

if [ $# -ne 2 ]; then
    echo "usage: $0 [input graph] [workers]"
    exit -1
fi

source ../common/get-dirs.sh

# place input in /user/${USER}/input/
# output is in /user/${USER}/gps/output/
inputgraph=$(basename $1)

# nodes should be number of EC2 instances
nodes=$2

logname=wcc_${inputgraph}_${nodes}_"$(date +%F-%H-%M-%S)"
logfile=${logname}_time.txt       # GPS statistics (incl running time)

## start logging memory + network usage
../common/bench-init.sh ${logname}

## start algorithm run
# NOTE: numMaxIterations can be set but we don't set it
# (to match Giraph and Mizan, neither of which use SS termination)
./start-nodes.sh ${nodes} quick-start \
    -ifs /user/${USER}/input/${inputgraph} \
    -hcf "$HADOOP_DIR"/conf/core-site.xml \
    -jc gps.examples.wcc.WeaklyConnectedComponentsVertex###JobConfiguration \
    -mcfg /user/${USER}/gps-machine-config/machine.cfg \
    -log4jconfig "$GPS_DIR"/conf/log4j.config

## finish logging memory + network usage
../common/bench-finish.sh ${logname}

## get stats (see debug_site.sh for debug naming convention)
hadoop dfs -get /user/${USER}/gps/output/quick-start-machine-stats ./logs/${logfile}
#hadoop dfs -mv /user/${USER}/gps/output/quick-start-machine-stats /user/${USER}/gps/stats-${logname}