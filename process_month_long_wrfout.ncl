;--------------------------------;
;   read and output wrf data 
;--------------------------------;
;wrfout = addfile("/depot/dniyogi/data/tian/run_with_LULC1980_Jun2015/wrfout_d03_2015-06-21_01:00:00","r")
;
;;-------- read data --------;
;
;T := wrf_user_getvar(wrfout,"times",-1)
;T_ind = ispan(5,233,6)
;uv10 = wrf_user_getvar(wrfout,"uvmet10",-1)
;u10 = uv10(0,:,:,:)
;v10 = uv10(1,:,:,:)
;u10_obsT = u10(T_ind,:,:)               ; 10m u wind at observation times
;v10_obsT = v10(T_ind,:,:)               ; 10m v wind at observation times
;wspd10_Jun2015_p3 = sqrt(u10_obsT ^2 + v10_obsT ^2)  ; 10m wind speed at observation times
;
;;-------- output to .nc -------;
;
;ncdf = addfile("run_with_LULC1980_on_10WSPD_Jun2015_p3.nc","c")
;filedimdef(ncdf,"time",-1,True)
;
;wspd10_Jun2015_p3@lat2d = wrf_user_getvar(wrfout,"XLAT",0)   ; latitude/longitude
;wspd10_Jun2015_p3@lon2d = wrf_user_getvar(wrfout,"XLONG",0)  ; required for plotting
;ncdf->lulc1980_wspd10_Jun2015_p3 = wspd10_Jun2015_p3


;-----------------------------------;
; merge wrf sub-runs (restart runs)
;-----------------------------------;

;------ PRD city expansion Dec2015 

citexp_Dec_p1 = addfile("/home/tqun/PRD_city_expansion_on_10WSPD_Dec2015_p1.nc","r")
citexp_Dec_p2 = addfile("/home/tqun/PRD_city_expansion_on_10WSPD_Dec2015_p2.nc","r")
citexp_Dec_p3 = addfile("/home/tqun/PRD_city_expansion_on_10WSPD_Dec2015_p3.nc","r")
citexp_Dec_p4 = addfile("/home/tqun/PRD_city_expansion_on_10WSPD_Dec2015_p4.nc","r")

c_D_1 = citexp_Dec_p1->city_expand_wspd10_Dec2015_p1
c_D_2 = citexp_Dec_p2->city_expand_wspd10_Dec2015_p2
c_D_3 = citexp_Dec_p3->city_expand_wspd10_Dec2015_p3
c_D_4 = citexp_Dec_p4->city_expand_wspd10_Dec2015_p4

temp = array_append_record(c_D_1, c_D_2, 0)  ; merge array 
temp2 = array_append_record(c_D_3, c_D_4, 0)
citexp_Dec = array_append_record(temp, temp2, 0) ; PRD city expansion Dec2015 
delete(temp)
delete(temp2)

dim = dimsizes(citexp_Dec)
Citexp_Dec = citexp_Dec(ispan(0,dim(0)-2,1),:,:) ; remove the last element to make the number of days is integer 
delete(citexp_Dec)
delete(dim)

;------ PRD city expansion Jun2015 

citexp_Jun_p1 = addfile("/home/tqun/PRD_city_expansion_on_10WSPD_Jun2015_p1.nc","r")
citexp_Jun_p2 = addfile("/home/tqun/PRD_city_expansion_on_10WSPD_Jun2015_p2.nc","r")
citexp_Jun_p3 = addfile("/home/tqun/PRD_city_expansion_on_10WSPD_Jun2015_p3.nc","r")
citexp_Jun_p4 = addfile("/home/tqun/PRD_city_expansion_on_10WSPD_Jun2015_p4.nc","r")

c_J_1 = citexp_Jun_p1->city_expand_wspd10_Jun2015_p1
c_J_2 = citexp_Jun_p2->city_expand_wspd10_Jun2015_p2
c_J_3 = citexp_Jun_p3->city_expand_wspd10_Jun2015_p3
c_J_4 = citexp_Jun_p4->city_expand_wspd10_Jun2015_p4

temp = array_append_record(c_J_1, c_J_2, 0)  ; merge array 
temp2 = array_append_record(c_J_3, c_J_4, 0)
citexp_Jun = array_append_record(temp, temp2, 0)  ; PRD city expansion Jun2015 
delete(temp)
delete(temp2)

dim = dimsizes(citexp_Jun)
Citexp_Jun = citexp_Jun(ispan(0,dim(0)-2,1),:,:) ; remove the last element to make the number of days is integer 
delete(citexp_Jun)
delete(dim)

;------ run with LULC1980 Jun2015

lulc1980_Jun_p1 = addfile("/home/tqun/run_with_LULC1980_on_10WSPD_Jun2015_p1.nc","r")
lulc1980_Jun_p2 = addfile("/home/tqun/run_with_LULC1980_on_10WSPD_Jun2015_p2.nc","r")
lulc1980_Jun_p3 = addfile("/home/tqun/run_with_LULC1980_on_10WSPD_Jun2015_p3.nc","r")

l_J_1 = lulc1980_Jun_p1->lulc1980_wspd10_Jun2015_p1
l_J_2 = lulc1980_Jun_p2->lulc1980_wspd10_Jun2015_p2
l_J_3 = lulc1980_Jun_p3->lulc1980_wspd10_Jun2015_p3

temp = array_append_record(l_J_1, l_J_2, 0)  ; merge array 
lulc1980_Jun = array_append_record(temp, l_J_3, 0)  ; run with LULC1980 Jun2015 
delete(temp)

dim = dimsizes(lulc1980_Jun)
Lulc1980_Jun = lulc1980_Jun(ispan(0,dim(0)-2,1),:,:) ; remove the last element to make the number of days is integer 
delete(lulc1980_Jun)
delete(dim)

;------ run with LULC1980 Dec2015

lulc1980_Dec_p1 = addfile("/home/tqun/run_with_LULC1980_on_10WSPD_Dec2015_p1.nc","r")
lulc1980_Dec_p2 = addfile("/home/tqun/run_with_LULC1980_on_10WSPD_Dec2015_p2.nc","r")
lulc1980_Dec_p3 = addfile("/home/tqun/run_with_LULC1980_on_10WSPD_Dec2015_p3.nc","r")
lulc1980_Dec_p4 = addfile("/home/tqun/run_with_LULC1980_on_10WSPD_Dec2015_p4.nc","r")

l_D_1 = lulc1980_Dec_p1->lulc1980_wspd10_Dec2015_p1
l_D_2 = lulc1980_Dec_p2->lulc1980_wspd10_Dec2015_p2
l_D_3 = lulc1980_Dec_p3->lulc1980_wspd10_Dec2015_p3
l_D_4 = lulc1980_Dec_p4->lulc1980_wspd10_Dec2015_p4

temp = array_append_record(l_D_1, l_D_2, 0)  ; merge array 
temp2 = array_append_record(l_D_3, l_D_4, 0)
lulc1980_Dec = array_append_record(temp, temp2, 0)  ; run with LULC1980 Dec2015 
delete(temp)
delete(temp2)

dim = dimsizes(lulc1980_Dec)
Lulc1980_Dec = lulc1980_Dec(ispan(0,dim(0)-2,1),:,:) ; remove the last element to make the number of days is integer 
delete(lulc1980_Dec)
delete(dim)

;----------------------------------;
;          computation             ;
;----------------------------------;
wrfout = addfile("/depot/dniyogi/data/tian/run_with_LULC1980_Jun2015/wrfout_d03_2015-06-21_01:00:00","r")

wspd10m_diff_Jun2015 = Lulc1980_Jun - Citexp_Jun
wspd10m_diff_Jun_mean = dim_avg_n(wspd10m_diff_Jun2015,0)
wspd10m_diff_Jun_mean@lat2d = wrf_user_getvar(wrfout,"XLAT",0)
wspd10m_diff_Jun_mean@lon2d = wrf_user_getvar(wrfout,"XLONG",0) 

wspd10_clim_Jun2015 = dim_avg_n(Lulc1980_Jun,0)  ; wndspd climatology 

;----------------------------------;
;              plot                ;
;----------------------------------;
wrfout = addfile("/depot/dniyogi/data/tian/run_with_LULC1980_Jun2015/wrfout_d03_2015-06-21_01:00:00","r")

lat  = wrfout->XLAT(0,:,:)
lon  = wrfout->XLONG(0,:,:)
dims = dimsizes(lat)
nlat = dims(0)
nlon = dims(1)

wks = gsn_open_wks("pdf","PRD_city_expand_on_10mWSPD_Jun2015") 

res = True
res@gsnMaximize = True
res@mpProjection          = "LambertConformal"
res@mpDataBaseVersion = "HighRes"
res@mpGeophysicalLineThicknessF = 3.0
res@pmTickMarkDisplayMode  = "Never"
res@cnFillOn = True
res@cnLinesOn           = False       ; Turn off contour lines
res@mpFillOn = False

;res@mpLimitMode           = "Corners"
;res@mpLeftCornerLatF      = lat(20,20)
;res@mpLeftCornerLonF      = lon(20,20)
;res@mpRightCornerLatF     = lat(nlat-21,nlon-21)
;res@mpRightCornerLonF     = lon(nlat-21,nlon-21)

res@mpLimitMode           = "LatLon"
res@mpMinLatF             = 21
res@mpMaxLatF             = 24
res@mpMinLonF             = 112
res@mpMaxLonF             = 115

res@mpLambertParallel1F   = wrfout@TRUELAT1
res@mpLambertParallel2F   = wrfout@TRUELAT2
res@mpLambertMeridianF    = wrfout@STAND_LON

res@cnLevelSelectionMode = "ExplicitLevels"	; manually set the contour levels
res@cnFillPalette = "BlWhRe"
res@cnLevels    = (/-2.0, -1.8, -1.6, -1.4, -1.2, -1.0, -0.8, -0.6, -0.4,-0.2, 0., 0.2, 0.4, 0.6, 0.8, 1.0, 1.2, 1.4, 1.6, 1.8, 2.0/);
res@cnFillColors = (/4, 10, 18, 23, 30, 34, 38, 41, 44, 47, 50, 50, 53, 55, 57, 60, 64, 68, 74, 80, 88, 94/);

res@cnLineLabelsOn = False                    ; turn the line labels off ;

;res@cnFillPalette = "OceanLakeLandSnow"

;res@tiMainString    = "city expansion on 10m wspd t3"   ; add titles
res@tiMainFontHeightF  = 0.015                    ; change font heights

contour = gsn_csm_contour_map(wks,wspd10m_diff_Jun_mean,res)
