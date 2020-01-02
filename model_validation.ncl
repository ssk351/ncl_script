;------------------------------;
;   read and output wrf data   ;
;------------------------------;

wrfout = addfile("/depot/dniyogi/data/tian/run_with_LULC2015_Dec2015/wrfout_d03_2013-12-01_00:00:00","r")

;------ read data
T := wrf_user_getvar(wrfout,"times",-1)
T_ind = ispan(18,233,6)