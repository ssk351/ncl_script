;--------------------------------
;   read and process nc files
;--------------------

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

;---------------
;     plot
;---------------

lat  = wrfout->XLAT(0,:,:)
lon  = wrfout->XLONG(0,:,:)
dims = dimsizes(lat)
nlat = dims(0)
nlon = dims(1)

wks = gsn_open_wks("png","city_expansion_on_10mWSPD_t1tot5_ratio") 

res = True
res@gsnMaximize = True
res@mpProjection          = "LambertConformal"
res@mpDataBaseVersion = "HighRes"
res@mpGeophysicalLineThicknessF = 3.0
res@pmTickMarkDisplayMode  = "Never"
res@cnFillOn = True
res@cnLinesOn           = False       ; Turn off contour lines
res@mpFillOn = False
res@mpLimitMode           = "Corners"
res@mpLeftCornerLatF      = lat(0,0)
res@mpLeftCornerLonF      = lon(0,0)
res@mpRightCornerLatF     = lat(nlat-1,nlon-1)
res@mpRightCornerLonF     = lon(nlat-1,nlon-1)
res@mpLambertParallel1F   = wrfout@TRUELAT1
res@mpLambertParallel2F   = wrfout@TRUELAT2
res@mpLambertMeridianF    = wrfout@STAND_LON

res@cnLevelSelectionMode = "ExplicitLevels"	; manually set the contour levels
res@cnFillPalette = "BlWhRe"
res@cnLevels    = (/-0.15, -0.1, -0.05, -0.03,-0.01, 0., 0.01, 0.03, 0.05, 0.1, 0.15/);
res@cnFillColors = (/18, 23, 34, 41, 44, 50, 50, 55, 57, 60, 68, 80, 88/);

res@cnLineLabelsOn = False                    ; turn the line labels off ;

;res@cnFillPalette = "OceanLakeLandSnow"

res@tiMainString    = "city expansion on 10m wspd changing ratio"   ; add titles
res@tiMainFontHeightF  = 0.015                    ; change font heights

contour = gsn_csm_contour_map(wks,wspd10_mean, res)