CDF      
      time       bnds      lon       lat             CDI       ?Climate Data Interface version 1.9.6 (http://mpimet.mpg.de/cdi)    Conventions       CF-1.6     history      <Mon Sep 27 13:57:03 2021: cdo mergetime LHFL_5_02.nc LHFL_5_05.nc LHFL_5_08.nc LHFL_5_11.nc LHFL_5.nc
Mon Sep 27 13:57:00 2021: cdo -s fldmean -chname,mslhf,LHFL -sellonlatbox,-8,-3,-19,-14 ALHFL_S_avg02.nc LHFL_5_02.nc
Mon Sep 27 13:56:59 2021: cdo -s -timmean -seldate,2016-02-01,2016-02-50 /home/shucliu/ERA5//201602ERA5_ALHFL_S.nc ALHFL_S_avg02.nc
Fri Sep 24 12:37:13 2021: cdo selyear,2016 -selmon,02 adaptor.mars.internal-1628143430.2520404-8278-12-dcff2e91-a31b-4d67-836f-4447e433f566.nc 201602ERA5_ALHFL_S.nc
2021-08-05 06:05:07 GMT by grib_to_netcdf-2.20.0: /opt/ecmwf/mars-client/bin/grib_to_netcdf -S param -o /cache/data6/adaptor.mars.internal-1628143430.2520404-8278-12-dcff2e91-a31b-4d67-836f-4447e433f566.nc /cache/tmp/dcff2e91-a31b-4d67-836f-4447e433f566-adaptor.mars.internal-1628142303.5560653-8278-17-tmp.grib   CDO       ?Climate Data Operators version 1.9.6 (http://mpimet.mpg.de/cdo)          time                standard_name         time   	long_name         time   bounds        	time_bnds      units         !hours since 1900-01-01 00:00:00.0      calendar      	gregorian      axis      T               �   	time_bnds                                 �   lon                standard_name         	longitude      	long_name         	longitude      units         degrees_east   axis      X               �   lat                standard_name         latitude   	long_name         latitude   units         degrees_north      axis      Y               �   LHFL                      	long_name         Mean surface latent heat flux      units         W m**-2    
add_offset        �s�,���   scale_factor      ?�,��㔫   
_FillValue        �     missing_value         �              �                A/�    A/�    A/>    A  A/!�    A/�    A/$~    :�  A/2�    A//�    A/5�    >�  A/C�    A/A0    A/F�    M  