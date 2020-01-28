;------------------------------;
;   read and output wrf data   ;
;------------------------------;

wrfout = addfile("/depot/dniyogi/data/tian/run_with_LULC2015_Dec2015/wrfout_d03_2015-12-01_00:00:00","r")

;------ read srf data

;T := wrf_user_getvar(wrfout,"times",-1)
;T_ind = ispan(18,108,6)
;
;uv10 = wrf_user_getvar(wrfout,"uvmet10",-1)
;u10 = uv10(0,:,:,:)
;v10 = uv10(1,:,:,:)
;u10_obsT = u10(T_ind,:,:)               ; 10m u wind at observation times
;v10_obsT = v10(T_ind,:,:)               ; 10m v wind at observation times
;wspd10 = sqrt(u10_obsT ^2 + v10_obsT ^2)  ; 10m wind speed at observation times
;
;t2 = wrf_user_getvar(wrfout,"T2", -1)   ; 2m temperature in K 
;t2_obsT = t2(T_ind,:,:)                 ; 2m temperature at observation times
;t2_obsT_cels = t2_obsT - 273.15          ; convert from K to C

;------ read troposphere data

T := wrf_user_getvar(wrfout,"times",-1)
T_ind = ispan() 


;-------- output to .nc -------;

;ncdf = addfile("10mWPSD_2mTemp_Jun2015.nc","c")
;filedimdef(ncdf,"time",-1,True)
;
;wspd10@lat2d = wrf_user_getvar(wrfout,"XLAT",0)   ; latitude/longitude
;wspd10@lon2d = wrf_user_getvar(wrfout,"XLONG",0)  ; required for plotting
;ncdf->wspd10_jun = wspd10
;
;t2_obsT_cels@lat2d = wrf_user_getvar(wrfout,"XLAT",0)   ; latitude/longitude
;t2_obsT_cels@lon2d = wrf_user_getvar(wrfout,"XLONG",0)  ; required for plotting
;ncdf->t2_jun = t2_obsT_cels

;------ interploate wspd to srf observation points

obs_loc = asciiread("/depot/dniyogi/data/tian/China_station_location.txt",(/826,3/),"float")

wspd_at_obs_points = new((/826,19/),float,"No_FillValue")
t2_at_obs_points = new((/826,19/),float,"No_FillValue")

wspd10@lat2d = wrf_user_getvar(wrfout,"XLAT",0)
wspd10@lon2d = wrf_user_getvar(wrfout,"XLONG",0)
t2_obsT_cels@lat2d = wrf_user_getvar(wrfout,"XLAT",0) 
t2_obsT_cels@lon2d = wrf_user_getvar(wrfout,"XLONG",0) 

do i = 0, 825

cot = i
dims = dimsizes(wspd10@lat2d)
opt=True
opt@returnInt=True

lon = obs_loc(cot,1)
lat = obs_loc(cot,2)
loc = wrf_user_ll_to_ij(wrfout,lon,lat, opt)

; -------- !!!notice!!! ---------
; loc(0) is lon grid index loc(1) is lat grid index, while wspd10_mean(0) is lat grid index, wspd10_mean(1) is lon grid index
;-------------------------------

wspd_at_obs_points(cot,0) = obs_loc(cot,0)  ; station ID
wspd_at_obs_points(cot,1) = obs_loc(cot,1)  ; lon
wspd_at_obs_points(cot,2) = obs_loc(cot,2)  ; lat

;t2_at_obs_points(cot,0) = obs_loc(cot,0)  ; station ID
;t2_at_obs_points(cot,1) = obs_loc(cot,1)  ; lon
;t2_at_obs_points(cot,2) = obs_loc(cot,2)  ; lat

if loc(0) .lt. 0 .or. loc(1) .lt. 0 .or. loc(0) .ge. dims(1) .or. loc(1) .ge. dims(0) then
	wspd_at_obs_points(cot,3:18) = 0
    ;t2_at_obs_points(cot,3:18) = 0
else 
	wspd_at_obs_points(cot,3:18) = wspd10(:,loc(1),loc(0))
    ;t2_at_obs_points(cot,3:18) = t2_obsT_cels(:,loc(1),loc(0))
end if

end do

fname = "wspd10_Dec2015_model_validation.txt"
;fname = "t2_Dec2015_model_validation.txt"

do j = 0, 825

daily = reshape(wspd_at_obs_points(j,3:18),(/4,4/))
;daily = reshape(t2_at_obs_points(j,3:18),(/4,4/))
daily_mean = dim_avg_n(daily,1)

alist = [/wspd_at_obs_points(j,0),wspd_at_obs_points(j,1),wspd_at_obs_points(j,2),daily_mean(0),daily_mean(1),daily_mean(2),daily_mean(3)/]
;alist = [/t2_at_obs_points(j,0),t2_at_obs_points(j,1),t2_at_obs_points(j,2),daily_mean(0),daily_mean(1),daily_mean(2),daily_mean(3)/]
write_table(fname,"a",alist,"%.0f   %.4f   %.4f   %.3f   %.3f   %.3f   %.3f ")

end do

;------ interploate wspd to radiosonde observation points

