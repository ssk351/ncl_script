;------------------------------;
;   read and output wrf data   ;
;------------------------------;

wrfout = addfile("/depot/dniyogi/data/tian/run_with_LULC2015_Dec2015/wrfout_d03_2015-12-01_00:00:00","r")

;------ read data

T := wrf_user_getvar(wrfout,"times",-1)
T_ind = ispan(18,108,6)

uv10 = wrf_user_getvar(wrfout,"uvmet10",-1)
u10 = uv10(0,:,:,:)
v10 = uv10(1,:,:,:)
u10_obsT = u10(T_ind,:,:)               ; 10m u wind at observation times
v10_obsT = v10(T_ind,:,:)               ; 10m v wind at observation times
wspd10 = sqrt(u10_obsT ^2 + v10_obsT ^2)  ; 10m wind speed at observation times

t2 = wrf_user_getvar(wrfout,"T2", -1)   ; 2m temperature in K 
t2_obsT = t2(T_ind,:,:)                 ; 2m temperature at observation times
t2_obsT_cels = t2_obsT - 273.15          ; convert from K to C

;-------- output to .nc -------;

ncdf = addfile("10mWPSD_2mTemp_Dec2015.nc","c")
filedimdef(ncdf,"time",-1,True)

wspd10@lat2d = wrf_user_getvar(wrfout,"XLAT",0)   ; latitude/longitude
wspd10@lon2d = wrf_user_getvar(wrfout,"XLONG",0)  ; required for plotting
ncdf->wspd10_dec = wspd10

t2_obsT_cels@lat2d = wrf_user_getvar(wrfout,"XLAT",0)   ; latitude/longitude
t2_obsT_cels@lon2d = wrf_user_getvar(wrfout,"XLONG",0)  ; required for plotting
ncdf->t2_dec = t2_obsT_cels