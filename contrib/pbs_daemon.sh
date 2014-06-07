#!/bin/bash
#PBS -P  v10
#PBS -q  normal
#PBS -l ncpus=1,walltime=1:10:00
#PBS -e /home/547/lpgs/PBS_OE
#PBS -o /home/547/lpgs/PBS_OE

# PBS -m e
# PBS -M fei.zhang@ga.gov.au


TotalTime=3600  # make this 10 minutes less than the PBS wall time limit to avoid being killed by PBS
SleepTime=300

MaxRepeat=10  # maximal number of times this job repeat itself-runs. Avoid infinite daemon.

#if REP is undefined RepeatCount=1 else RepeatCount=$REP+1

if [ -z $REP ]; then
    RepeatCount=1
else
    let "RepeatCount= $REP +1"
fi

if [[ $RepeatCount -gt $MaxRepeat ]]
then
    echo "exit now, it reached maximal number of runs $MaxRepeat "
    exit 0  # finished this runs
else
    echo "Doing the $RepeatCount run"
fi

let "N=  $TotalTime/$SleepTime"

echo "number of iteration is $N"

# loop

for  ((n=1; n<=$N; n++))
do
    echo "$n  submit_pbsjobs()" #qsub -V -v... script.sh
    sleep $SleepTime
done


# qsub self this daemon job.

echo "qsub this script"

cd $PBS_O_WORKDIR
qsub -v REP=$RepeatCount $PBS_JOBNAME
