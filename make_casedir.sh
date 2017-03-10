#!/bin/bash

#===========================#
# make_casedir              #
#                           #
# Script to construct dam   #
# case directory, scratch   #
# directory and link, and   #
# introduce correct path    #
#  name in submit script    #
#===========================#



# data, project, dam,  and case directories
case=$1
datadir=$CTMP/$USER
project=agg_co2
damdir=~/${project}/dam
casedir=${damdir}/${case}
rundir=$CPERM/$USER/${project}/${case}


# make run directory
if [ -d "$rundir" ]; then
  rm -rf $rundir
  printf "Removing old run directory \n"
fi 	
cp -r casedir_pre ${rundir} 
if [ -d "$rundir" ]; then
  printf "Created run directory\n"
else
  printf "Error in creating run directory\n"
  exit
fi

# make data directory and link 
if [ -d "${datadir}/${project}/${case}_data" ]; then
  printf "Data directory already exists\n"
else
  mkdir -p ${datadir}/${project}/${case}_data 
  if [ ! -d "${datadir}/${project}/${case}_data" ]; then
    printf "Error in creating data directory\n"
    exit
  fi
fi

# make case directory and link
if [ -d ${casedir} ]; then
   rm -rf ${casedir}
   printf "Removing old casedir and re-linking \n"
fi
ln -s  ${rundir} ${casedir}
ln -s ${datadir}/${project}/${case}_data ${casedir}/data

# modify submit file 
sed   -e "s|\#PBS -N [a-zA-Z0-9]*|\#PBS -N ${case}|" \
      -e "s|path=.*$|path=$case|" \
       < $casedir/submit_pre > $casedir/submit 


# modify nml
sed  -e "s|^! *nml_pre..*|!nml file for ${case}|" \
     < ${casedir}/nml_pre > ${casedir}/nml

printf "Submit and nml files modified\n"

# Clean up
#rm ${casedir}/*_pre*

# End of script
