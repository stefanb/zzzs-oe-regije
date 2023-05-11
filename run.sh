#!/bin/bash

# curl -R https://raw.githubusercontent.com/stefanb/gurs-rpe/master/data/OB.geojson -o OB.geojson

rm ZZZS_OE.geojson
# http://gis.stackexchange.com/questions/85028/dissolve-aggregate-polygons-with-ogr2ogr-or-gpc
ogr2ogr ZZZS_OE.geojson OB.geojson -dialect sqlite \
 -sql "SELECT ST_Union(geometry),
		sif.ZZZS_OE as ZZZS_OE,
        GROUP_CONCAT(src.OB_UIME, ', ') as OBCINE,
        SUM(src.POV_KM2) as POV_KM2
	FROM 'OB' AS src
		LEFT JOIN 'obcina_zzzsoe_sif.csv'.obcina_zzzsoe_sif AS sif ON src.OB_UIME=sif.OB_UIME
	GROUP BY sif.ZZZS_OE" \
 -explodecollections \
 -lco RFC7946=YES -lco WRITE_BBOX=YES \
 -nln ZZZS_OE
