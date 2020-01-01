;--------------------------------;
;   read and output wrf data 
;--------------------------------;
wrfout = addfile("/depot/dniyogi/data/tian/run_with_LULC1980_Dec2015/wrfout_d03_2015-12-01_00:00:00","r")

;-------- read data --------;

T = wrf_user_getvar(wrfout,"times",-1)
T_ind = ispan(5,137,6)
uv10 = wrf_user_getvar(wrfout,"uvmet10",-1)
u10 = uv10(0,:,:,:)
v10 = uv10(1,:,:,:)
u10_obsT = u10(T_ind,:,:)               ; 10m u wind at observation times
v10_obsT = v10(T_ind,:,:)               ; 10m v wind at observation times
wspd10_Dec2015_p1 = sqrt(u10_obsT ^2 + v10_obsT ^2)  ; 10m wind speed at observation times

;-------- output to .nc -------;

ncdf = addfile("run_with_LULC1980_on_10WSPD_Dec2015_p1.nc","c")
filedimdef(ncdf,"time",-1,True)

wspd10_Dec2015_p1@lat2d = wrf_user_getvar(wrfout,"XLAT",0)   ; latitude/longitude
wspd10_Dec2015_p1@lon2d = wrf_user_getvar(wrfout,"XLONG",0)  ; required for plotting
ncdf->lulc1980_wspd10_Dec2015_p1 = wspd10_Dec2015_p1
