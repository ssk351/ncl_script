;----------------------------
;     read and process data
;----------------------------
 
wrfout = addfile("/depot/dniyogi/data/tian/pearl_river_delta_city_expansion/wrfout_d03_2013-08-04_12:00:00","r")
;wrfout = addfile("/depot/dniyogi/data/tian/run_with_casLULC_2015_d_t5/wrfout_d03_2013-10-04_12:00:00","r")


;------- read 10m wspd at obs times

T = wrf_user_getvar(wrfout,"times",-1)
T_ind = ispan(6,dimsizes(T)-1,6)
uv10 = wrf_user_getvar(wrfout,"uvmet10",-1)
u10 = uv10(0,:,:,:)
v10 = uv10(1,:,:,:)
u10_obsT = u10(T_ind,:,:)               ; 10m u wind at observation times
v10_obsT = v10(T_ind,:,:)               ; 10m v wind at observation times
wspd10_2015 = sqrt(u10_obsT ^2 + v10_obsT ^2)  ; 10m wind speed at observation times
wspd10_mean2015 = dim_avg_n(wspd10_2015,0)

;------- read 10m wspd at obs times 2 

wrfout2 = addfile("/depot/dniyogi/data/tian/run_with_casLULC_1980_d/wrfout_d03_2013-08-04_12:00:00","r")

uv10 = wrf_user_getvar(wrfout2,"uvmet10",-1)
u10 = uv10(0,:,:,:)
v10 = uv10(1,:,:,:)
u10_obsT = u10(T_ind,:,:)               ; 10m u wind at observation times
v10_obsT = v10(T_ind,:,:)               ; 10m v wind at observation times
wspd10_1980 = sqrt(u10_obsT ^2 + v10_obsT ^2)  ; 10m wind speed at observation times
wspd10_mean1980 = dim_avg_n(wspd10_1980,0)

wspd10_mean = wspd10_mean2015 - wspd10_mean1980

wspd10_mean@lat2d = wrf_user_getvar(wrfout,"XLAT",0)   ; latitude/longitude
wspd10_mean@lon2d = wrf_user_getvar(wrfout,"XLONG",0)  ; required for plotting

;------ read terrain height

;height = wrf_user_getvar(wrfout,"HGT",0) 
;height@lat2d = wrf_user_getvar(wrfout,"XLAT",0)   ; latitude/longitude
;height@lon2d = wrf_user_getvar(wrfout,"XLONG",0)  ; required for plotting

;-------- read free atmosphere wind 

;T = wrf_user_getvar(wrfout,"times",-1)
;T_ind = ispan(12,dimsizes(T)-1,12)
;
;uwnd850 = new((/180,201,16/),float,"No_FillValue")
;vwnd850 = new((/180,201,16/),float,"No_FillValue")
;
;do i = 0, dimsizes(T_ind) - 1
;
;uvwnd = wrf_user_getvar(wrfout,"uvmet",T_ind(1))
;uwnd = uvwnd(0,:,:,:)
;vwnd = uvwnd(1,:,:,:)
;
;p = wrf_user_getvar(wrfout,"pressure",1)
;;pf = wrf_user_getvar(wrfout,"pressure",1)
; 
;pressure = 850.
;
;uwnd850(:,:,i) = wrf_user_intrp3d(uwnd,p,"h",pressure,0.,False)
;vwnd850(:,:,i) = wrf_user_intrp3d(vwnd,p,"h",pressure,0.,False)
;;uwnd850(:,:,i) = wrf_interp_3d_z(uwnd,pf,pressure)
;;vwnd850(:,:,i) = wrf_interp_3d_z(vwnd,pf,pressure)
;
;end do
;
;u850 = dim_avg_n(uwnd850,2)
;v850 = dim_avg_n(vwnd850,2)
;
;u850@lat2d = wrf_user_getvar(wrfout,"XLAT",0)   ; latitude/longitude
;u850@lon2d = wrf_user_getvar(wrfout,"XLONG",0)  ; required for plotting
;
;v850@lat2d = wrf_user_getvar(wrfout,"XLAT",0)   ; latitude/longitude
;v850@lon2d = wrf_user_getvar(wrfout,"XLONG",0)  ; required for plotting
;
;
;lats      = wrf_user_getvar(wrfout,"XLAT",0)   ; latitude/longitude
;lons      = wrf_user_getvar(wrfout,"XLONG",0)  ; latitude/longitude
;dims = dimsizes(u850)
;nd = dimsizes(dims)
;dimU = dims(nd-1) 
;dimV = dims(nd-2) 
;lllat = lats(0,0) ;
;lllon = lons(0,0) ;
;urlat = lats(dimV-1,dimU-1) ;
;urlon = lons(dimV-1,dimU-1) ;


;----------------------------
; interpolation and output
;---------------------------

;------ interploate wspd to observation points
;
;obs_loc = asciiread("/depot/dniyogi/data/tian/China_station_location.txt",(/826,3/),"float")
;
;wspd_at_obs_points = new((/826,35/),float,"No_FillValue")
;
;wspd10_2015@lat2d = wrf_user_getvar(wrfout,"XLAT",0)
;wspd10_2015@lon2d = wrf_user_getvar(wrfout,"XLONG",0)
;
;do i = 0, 825
;
;cot = i
;dims = dimsizes(wspd10_2015@lat2d)
;opt=True
;opt@returnInt=True
;
;lon = obs_loc(cot,1)
;lat = obs_loc(cot,2)
;loc = wrf_user_ll_to_ij(wrfout,lon,lat, opt)
;
;; -------- !!!notice!!! ---------
;; loc(0) is lon grid index loc(1) is lat grid index, while wspd10_mean(0) is lat grid index, wspd10_mean(1) is lon grid index
;;-------------------------------
;
;wspd_at_obs_points(cot,0) = obs_loc(cot,0)  ; station ID
;wspd_at_obs_points(cot,1) = obs_loc(cot,1)  ; lon
;wspd_at_obs_points(cot,2) = obs_loc(cot,2)  ; lat
;
;if loc(0) .lt. 0 .or. loc(1) .lt. 0 .or. loc(0) .ge. dims(1) .or. loc(1) .ge. dims(0) then
;	wspd_at_obs_points(cot,3:34) = 0
;
;else 
;	wspd_at_obs_points(cot,3:34) = wspd10_2015(:,loc(1),loc(0))
;end if
;
;end do
;
;fname = "wspd10_casLULC_2015_t2_pratiman_config_EarthCord.txt"
;
;do j = 0, 825
;
;daily = reshape(wspd_at_obs_points(j,3:34),(/8,4/))
;daily_mean = dim_avg_n(daily,1)
;
;alist = [/wspd_at_obs_points(j,0),wspd_at_obs_points(j,1),wspd_at_obs_points(j,2),daily_mean(0),daily_mean(1),daily_mean(2),daily_mean(3),daily_mean(4),daily_mean(5),daily_mean(6),daily_mean(7)/]
;write_table(fname,"a",alist,"%.0f   %.4f   %.4f   %.3f   %.3f   %.3f   %.3f   %.3f    %.3f    %.3f    %.3f")
;
;end do
;
;print(wspd_at_obs_points(758,:))
;

;----------------------------
;            plot
;----------------------------

;----- shaded plot

;lat  = wrfout->XLAT(0,:,:)
;lon  = wrfout->XLONG(0,:,:)
;dims = dimsizes(lat)
;nlat = dims(0)
;nlon = dims(1)
;
;wks = gsn_open_wks("png","city_expansion_on_10mWSPD_t3") 
;
;res = True
;res@gsnMaximize = True
;res@mpProjection          = "LambertConformal"
;res@mpDataBaseVersion = "HighRes"
;res@mpGeophysicalLineThicknessF = 3.0
;res@pmTickMarkDisplayMode  = "Never"
;res@cnFillOn = True
;res@cnLinesOn           = False       ; Turn off contour lines
;res@mpFillOn = False
;res@mpLimitMode           = "Corners"
;res@mpLeftCornerLatF      = lat(0,0)
;res@mpLeftCornerLonF      = lon(0,0)
;res@mpRightCornerLatF     = lat(nlat-1,nlon-1)
;res@mpRightCornerLonF     = lon(nlat-1,nlon-1)
;res@mpLambertParallel1F   = wrfout@TRUELAT1
;res@mpLambertParallel2F   = wrfout@TRUELAT2
;res@mpLambertMeridianF    = wrfout@STAND_LON
;
;res@cnLevelSelectionMode = "ExplicitLevels"	; manually set the contour levels
;res@cnFillPalette = "BlWhRe"
;res@cnLevels    = (/-2.0, -1.8, -1.6, -1.4, -1.2, -1.0, -0.8, -0.6, -0.4,-0.2, 0., 0.2, 0.4, 0.6, 0.8, 1.0, 1.;2, 1.4, 1.6, 1.8, 2.0/);
;res@cnFillColors = (/4,; 10, 18, 23, 30, 34, 38, 41, 44, 47, 50, 50, 53, 55, 57, 60, 64, 68, 74, 80, 88, 94/);

;res@cnLineLabelsOn = Fa;lse                    ; turn the line labels off ;
;
;;res@cnFillPalette = "OceanLakeLandSnow"
;
;res@tiMainString    = "city expansion on 10m wspd t3"   ; add titles
;res@tiMainFontHeightF  = 0.015                    ; change font heights
;
;contour = gsn_csm_contour_map(wks,wspd10_mean, res)

;------ vector plot
 
;wks = gsn_open_wks("png","850mb_wind_vector_t2")
;
;res = True
;
;res@gsnMaximize   = True   ; maximize plot in frame
;res@gsnDraw       = False  ; don't draw
;res@gsnFrame      = False  ; don't advance frame
;res@gsnMaximize   = True   ; use full page
;
;;---Zoom in on plot
;  res@mpMinLatF     = urlat - 4
;  res@mpMaxLatF     = urlat + 0.5
;  res@mpMinLonF     = urlon - 7
;  res@mpMaxLonF     = urlon -0.5
;
;
;res@gsnDraw = True
;res@gsnFrame      = True  ;  advance frame
;res@pmTickMarkDisplayMode = "Always" 
;res@gsnMajorLatSpacing = 20              ; change maj lat tm spacing
;res@gsnMajorLonSpacing = 50              ; change maj lon tm spacing 
;res@vcGlyphStyle     = "CurlyVector"   ; curly vectors
;res@vcRefMagnitudeF  = 5              ; define vector ref mag
;res@vcRefLengthF     = 0.04           ; define length of vec ref
;;res@vcRefAnnoOrthogonalPosF = -.15    ; move ref vector into plot
;res@vcMinDistanceF           = 0.03
;res@mpProjection  = "CylindricalEquidistant"    ; The default
;res@tfDoNDCOverlay           = False
;
;plot = gsn_csm_vector_map(wks,u850,v850,res)

;-----------------------
;     output to .nc
;-----------------------
ncdf = addfile("city_expansion_on_10WSPD_t1.nc","c")
filedimdef(ncdf,"time",-1,True)

ncdf->wspd10_mean_diff_t1 = wspd10_mean

wspd10_mean1980@lat2d = wrf_user_getvar(wrfout,"XLAT",0)   ; latitude/longitude
wspd10_mean1980@lon2d = wrf_user_getvar(wrfout,"XLONG",0)  ; required for plotting
ncdf->wspd10_mean1980_t1 = wspd10_mean1980  
