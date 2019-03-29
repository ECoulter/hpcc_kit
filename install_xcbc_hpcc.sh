#!/bin/bash

wget http://icl.cs.utk.edu/projectsfiles/hpcc/download/hpcc-1.5.0.tar.gz

tar xfvz hpcc-1.5.0.tar.gz

patch -R -b ./hpcc-1.5.0/hpl/lib/arch/build/Makefile.hpcc -i Makefile-hpcc.patch

cp Make.xcbc-* ./hpcc-1.5.0/hpl/

#Install necessary compilers and mpi versions; assuming OpenHPC Repo is installed
echo "Installing OpenHPC compilers and mpi variants"
yum install -y gnu-compilers-ohpc gnu7-compilers-ohpc mpich-gnu-ohpc mpich-gnu7-ohpc openblas-gnu-ohpc openblas-gnu7-ohpc openmpi-gnu-ohpc openmpi-gnu7-ohpc openmpi3-gnu7-ohpc scalapack-gnu-mpich-ohpc scalapack-gnu-openmpi-ohpc scalapack-gnu7-mpich-ohpc scalapack-gnu7-openmpi-ohpc scalapack-gnu7-openmpi3-ohpc

cd ./hpcc-1.5.0/

module purge 
module load gnu
module load openblas
module load mpich
echo "Making hpcc for available toolchains:"
echo "gnu-mpich..."
make arch=xcbc-gnu-mpich &> gnu-mpich-build.log
make arch=xcbc-gnu-mpich clean &>> gnu-mpich-build.log
echo "gnu-openmpi..."
module swap mpich openmpi
make arch=xcbc-gnu-openmpi  &> gnu-openmpi-build.log
make arch=xcbc-gnu-openmpi clean
echo "gnu7-openmpi..."
module swap gnu gnu7
make arch=xcbc-gnu7-openmpi &> gnu7-openmpi-build.log
make arch=xcbc-gnu7-openmpi clean
echo "gnu7-mpich..."
module swap openmpi mpich
make arch=xcbc-gnu7-mpich &> gnu7-mpich-build.log
make arch=xcbc-gnu7-mpich clean
echo "gnu7-openmpi3..."
module swap mpich openmpi3
make arch=xcbc-gnu7-openmpi3 &> gnu7-openmpi3-build.log
make arch=xcbc-gnu7-openmpi3 clean

echo "Installing hpcc binaries in /opt/ohpc/pub/benchmarks/"
rm -rf /opt/ohpc/pub/apps/benchmarks/
mkdir -p /opt/ohpc/pub/apps/benchmarks/

cp hpcc.xcbc* /opt/ohpc/pub/apps/benchmarks
cp hpccinf.txt /opt/ohpc/pub/apps/benchmarks

