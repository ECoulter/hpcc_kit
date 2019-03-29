#!/bin/bash

#These were originally two vars, but not all combinations are present
for toolchain in gnu-openmpi gnu-mpich gnu7-openmpi gnu7-openmpi3 gnu7-mpich
do
  compiler=$(echo $toolchain | cut -f 1 -d'-')
  mpi=$(echo $toolchain | cut -f 2 -d'-')
  jobfile=hpcc-$toolchain.job
  echo -e "#!/bin/bash
#SBATCH -n 4
#SBATCH -o %A-hpcc-$toolchain.txt

module purge
module load $compiler
module load $mpi
module load openblas

mkdir -p hpcc-$toolchain
cp /opt/ohpc/pub/apps/benchmarks/hpccinf.txt hpcc-$toolchain/hpccinf.txt
cd hpcc-$toolchain" > $jobfile

#leaving this in for posterity... TBDeleted if never used.
#  if [[ $mpi == "mpich" ]]; then
#   echo  -e "\nmpirun -np 4 /opt/ohpc/pub/apps/benchmarks/hpcc.xcbc-$toolchain" >> $jobfile
#  else
   echo  -e "\nmpirun -np 4 /opt/ohpc/pub/apps/benchmarks/hpcc.xcbc-$toolchain" >> $jobfile
#  fi

  sbatch $jobfile

done
