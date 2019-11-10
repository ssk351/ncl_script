;--------------------------------
;   read and process nc files
;--------------------------------

data_t1 = addfile("/home/tqun/city_expansion_on_10WSPD_t1.nc","r")
data_t3 = addfile("/home/tqun/city_expansion_on_10WSPD_t3.nc","r")
data_t4 = addfile("/home/tqun/city_expansion_on_10WSPD_t4.nc","r")
data_t5 = addfile("/home/tqun/city_expansion_on_10WSPD_t5.nc","r")

;------ compute diff vs mean ration for every case
wnd_diff_t1 = data_t1->wspd10_mean_diff_t1
wnd_mean_t1 = data_t1->wspd10_mean1980_t1
wnd_change_ratio_t1 = wnd_diff_t1 / wnd_mean_t1

wnd_diff_t3 = data_t3->wspd10_mean_diff_t3
wnd_mean_t3 = data_t3->wspd10_mean1980_t3
wnd_change_ratio_t3 = wnd_diff_t3 / wnd_mean_t3

wnd_diff_t4 = data_t4->wspd10_mean_diff_t4
wnd_mean_t4 = data_t4->wspd10_mean1980_t4
wnd_change_ratio_t4 = wnd_diff_t4 / wnd_mean_t4

wnd_diff_t5 = data_t5->wspd10_mean_diff_t5
wnd_mean_t5 = data_t5->wspd10_mean1980_t5
wnd_change_ratio_t5 = wnd_diff_t5 / wnd_mean_t5

;------ compute average ratio
dim = dimsizes(wnd_diff_t1)
wnd_change_ratio_t1tot5 = new((/dim(0),dim(1),4/),float,"No_FillValue")
wnd_change_ratio_t1tot5(:,:,0) = wnd_change_ratio_t1
wnd_change_ratio_t1tot5(:,:,1) = wnd_change_ratio_t3
wnd_change_ratio_t1tot5(:,:,2) = wnd_change_ratio_t4
wnd_change_ratio_t1tot5(:,:,3) = wnd_change_ratio_t5

wnd_change_ratio = dim_avg_n(wnd_change_ratio_t1tot5,2)

wrfout = addfile("/depot/dniyogi/data/tian/PRD_city_expansion_t3/wrfout_d03_2014-02-20_12:00:00","r")

wnd_change_ratio@lat2d = wrf_user_getvar(wrfout,"XLAT",0)
wnd_change_ratio@lon2d = wrf_user_getvar(wrfout,"XLONG",0) 


;----------------------------
; interpolation and output
;---------------------------

;------ interploate wspd to observation points

obs_loc = asciiread("/depot/dniyogi/data/tian/China_station_location.txt",(/826,3/),"float")

wnd_change_ratio_at_obs_points = new((/826,4/),float,"No_FillValue")

do i = 0, 825

cot = i
dims = dimsizes(wnd_change_ratio@lat2d)
opt=True
opt@returnInt=True

lon = obs_loc(cot,1)
lat = obs_loc(cot,2)
loc = wrf_user_ll_to_ij(wrfout,lon,lat, opt)

; -------- !!!notice!!! ---------
; loc(0) is lon grid index loc(1) is lat grid index, while wspd10_mean(0) is lat grid index, wspd10_mean(1) is lon grid index
;-------------------------------

wnd_change_ratio_at_obs_points(cot,0) = obs_loc(cot,0)  ; station ID
wnd_change_ratio_at_obs_points(cot,1) = obs_loc(cot,1)  ; lon
wnd_change_ratio_at_obs_points(cot,2) = obs_loc(cot,2)  ; lat

if loc(0) .lt. 0 .or. loc(1) .lt. 0 .or. loc(0) .ge. dims(1) .or. loc(1) .ge. dims(0) then
	wnd_change_ratio_at_obs_points(cot,3:34) = 0

else 
	wnd_change_ratio_at_obs_points(cot,3) = wspd10_2015(:,loc(1),loc(0))
end if

end do

fname = "WRF_wnd_change_ratio.txt"

do j = 0, 825

alist = [/wnd_change_ratio_at_obs_points(j,0),wnd_change_ratio_at_obs_points(j,1),wnd_change_ratio_at_obs_points(j,2),wnd_change_ratio_at_obs_points(j,3)/]
write_table(fname,"a",alist,"%.0f   %.4f   %.4f   %.4f")

end do


;---------------
;     plot
;---------------

;lat  = wrfout->XLAT(0,:,:)
;lon  = wrfout->XLONG(0,:,:)
;dims = dimsizes(lat)
;nlat = dims(0)
;nlon = dims(1)
;
;wks = gsn_open_wks("png","city_expansion_on_10mWSPD_t1tot5_ratio") 
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
;res@cnLevels    = (/-0.15, -0.1, -0.05, -0.03,-0.01, 0., 0.01, 0.03, 0.05, 0.1, 0.15/);
;res@cnFillColors = (/18, 27, 34, 41, 47, 50, 50, 53, 57, 60, 68, 80, 88/);
;
;res@cnLineLabelsOn = False                    ; turn the line labels off ;
;
;;res@cnFillPalette = "OceanLakeLandSnow"
;
;res@tiMainString    = "city expansion on 10m wspd changing ratio"   ; add titles
;res@tiMainFontHeightF  = 0.015                    ; change font heights
;
;contour = gsn_csm_contour_map(wks,wnd_change_ratio, res)