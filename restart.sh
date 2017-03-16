#!/bin/bash

#=============================#
# Script to restart DAM runs  #
#=============================#

project=agg_co2
damdir=~/$project/dam
casedir=$1

cd $casedir
declare -i nprev=$( ls log* | cut -c4,5 | sort -n | tail -n1 )+1
printf "nprev = ${nprev}"

# Change filenames so data doesn't get overwritten
for f in data/*[st].nc; do
    mv $f ${f%.nc}${nprev}.nc
done

#rename log, copy nml
mv log log${nprev}
cp nml nml${nprev}

# Change ivdata_path in nml file
sed -e "s|ivdata_path = .*|ivdata_path = \'${casedir}/data/snapshot${nprev}.nc\'|" \
   < ${damdir}/${casedir}/nml > ${damdir}/${casedir}/nml_post
mv nml_post nml

# Submit job
msub submit 
cd ..