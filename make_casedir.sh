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
datadir=${SCRATCH}
project=rad_cooling
damdir=~/edison/${project}/dam
case=$1


# make case directory
if [ ! -d "$case" ]; then  
  cp -r casedir_pre ${case} # Copy casedir_pre to new dir
  if [ -d "$case" ]; then
     printf "Created case directory\n"
  else
     printf "Error in creating case directory\n"
     exit
  fi
else
  printf "Case directory already exists\n"
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
  ln -s ${datadir}/${project}/${case}_data ${damdir}/${case}/data
fi


# modify submit file 
sed   -e "s|\#SBATCH -J [a-zA-Z0-9]*|\#SBATCH -J ${case}|" \
      -e "s|path=.*$|path=$case|" \
       < $case/submit_pre > $case/submit 


# modify nml
sed  -e "s|^! *nml_pre..*|!nml file for ${case}|" \
     < ${damdir}/${case}/nml_pre > ${damdir}/${case}/nml

printf "Submit and nml files modified\n"

# Clean up
rm ${damdir}/${case}/*_pre*

# End of script
