#!/bin/bash

str=$(pwd)
rem="/simulation/rtl_sim"
export proj_root=${str%$rem}
echo $proj_root

echo "Removing xcelium temp files"
rm -rf *.err *.diag cov_work xcelium.d .simvision .shadow *.log *.key waves.shm *~

if [ "$2" == "" ]; then
    echo "Running simulation in batch mode"
    mode="batch" 
else
    echo "Running simulation in GUI mode"
    mode="gui"
fi

xrun -top $1 -$mode -f run.args
