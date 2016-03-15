library(ncdf)

# Copy this from trace_gases_all.nc
ncname = "trace_gases_zeroO3.nc"

nc    = open.ncdf(ncname,write=TRUE)
co2   = get.var.ncdf(nc,"co2")
o3    = get.var.ncdf(nc,"o3")

# Set desired concentrations
#co2[] = 0
o3[]  = 0

#put.var.ncdf(nc,"co2",co2)
put.var.ncdf(nc,"o3",o3)
close.ncdf(nc)