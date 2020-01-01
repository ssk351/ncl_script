;--------------------------------;
;   read and output wrf data 
;--------------------------------;
wrfout = addfile("/depot/dniyogi/data/tian/PRD_city_expansion_Jun2015/wrfout_d03_2015-06-10_01:00:00","r")

;-------- read data --------;

T = wrf_user_getvar(wrfout,"times",-1)
T_ind = ispan(5,215,6)
uv10 = wrf_user_getvar(wrfout,"uvmet10",-1)
u10 = uv10(0,:,:,:)
v10 = uv10(1,:,:,:)
u10_obsT = u10(T_ind,:,:)               ; 10m u wind at observation times
v10_obsT = v10(T_ind,:,:)               ; 10m v wind at observation times
wspd10_Jun2015_p2 = sqrt(u10_obsT ^2 + v10_obsT ^2)  ; 10m wind speed at observation times

;-------- output to .nc -------;

ncdf = addfile("PRD_city_expansion_on_10WSPD_Jun2015_p2.nc","c")
filedimdef(ncdf,"time",-1,True)

wspd10_Jun2015_p2@lat2d = wrf_user_getvar(wrfout,"XLAT",0)   ; latitude/longitude
wspd10_Jun2015_p2@lon2d = wrf_user_getvar(wrfout,"XLONG",0)  ; required for plotting
ncdf->city_expand_wspd10_Jun2015_p2 = wspd10_Jun2015_p2
