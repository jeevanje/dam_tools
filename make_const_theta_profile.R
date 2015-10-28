library(ncdf)
source('make_1D_netcdf.R')

# Constants
rgasa <- 287.04
cva <- 719
cpa = rgasa + cva
g = 9.81
gamma = g/cpa

# Make z grd, set surface tabs and p
dz  = 25
nz  = 128
z   = 0.5*dz+dz*(0:(nz-1))
sst = 300
p0  = 1e5                            # surface pressure, Pa
tabs= sst - gamma*z
p   = p0*(tabs/sst)^(cpa/rgasa)
rho = gamma*rgasa/g/sst/cpa*p0*(tabs/sst)^(cpa/rgasa -1)
qv  = z-z                            # i.e. 0

vars <- list()

vars[['tabs']] <- list()
vars[['tabs']]$longname <- 'Absolute temperature'
vars[['tabs']]$units <- 'K'
vars[['tabs']]$data <- tabs

vars[['rho']] <- list()
vars[['rho']]$longname <- 'Density'
vars[['rho']]$units <- 'kg/m^3'
vars[['rho']]$data <- rho

vars[['p']] <- list()
vars[['p']]$longname <- 'pressure'
vars[['p']]$units <- 'Pa'
vars[['p']]$data <- p

vars[['qv']] <- list()
vars[['qv']]$longname <- 'specific humidity'
vars[['qv']]$units <- 'kg/kg'
vars[['qv']]$data <- qv

make_1D_netcdf('const_theta_profile.nc',z,vars)

