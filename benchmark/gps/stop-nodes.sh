#!/bin/bash

# Does the same thing as master-scripts/stop_gps_nodes.sh, but faster.
# Also removes the need for a separate scripts/stop_nodes.sh.

kill -9 $(ps aux | grep "[g]ps_node_runner" | awk '{print $2}')

# the "|| ..." is a workaround in case the file doesn't end with a newline
while read slave || [ -n "$slave" ]; do
    # must have -n, otherwise ssh consumes all of stdin (i.e., all of the input file)
    ssh -n $slave "kill -9 \$(ps aux | grep \"[g]ps_node_runner\" | awk '{print \$2}')" &
done < "$(dirname "${BASH_SOURCE[0]}")"/slaves
wait