-- 1.A
INSERT INTO USER_SDO_GEOM_METADATA
VALUES (
    'FIGURY',
    'KSZTALT',
    MDSYS.SDO_DIM_ARRAY(
        MDSYS.SDO_DIM_ELEMENT('X', 0, 0, 0.01),
        MDSYS.SDO_DIM_ELEMENT('Y', 20, 20, 0.01) 
    ),
    NULL
);

-- 1.B
SELECT SDO_TUNE.ESTIMATE_RTREE_INDEX_SIZE(3000000,8192,10,2,0) FROM DUAL;

-- 1.C
CREATE INDEX FIGURY_IDX
ON FIGURY(KSZTALT)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2; 

-- 1.D
SELECT ID FROM FIGURY
WHERE SDO_FILTER(KSZTALT, SDO_GEOMETRY(
    2001, NULL, SDO_POINT_TYPE(3,3,NULL), NULL, NULL)) = 'TRUE';
    
-- Wynik nie jest poprawny ponieważ SDO_FILTER korzysta tylko z filtra podstawowego, który wykorzystuje aproksymację

-- 1.E
SELECT ID FROM FIGURY
WHERE SDO_RELATE(KSZTALT, SDO_GEOMETRY(
    2001, NULL, SDO_POINT_TYPE(3,3,NULL), NULL, NULL),
    'mask=ANYINTERACT') = 'TRUE';
-- Teraz wynik jest poprawny
-- SDO_RELATE korzysta z filtra podstawowego i dokładnego

-- 2.A
SELECT A.CITY_NAME MIASTO, SDO_NN_DISTANCE(1) ODL
FROM MAJOR_CITIES A
WHERE SDO_NN(
    GEOM, 
    (SELECT GEOM FROM MAJOR_CITIES WHERE CITY_NAME = 'Warsaw'),
    'sdo_num_res=10 unit=km',
    1
) = 'TRUE' AND A.CITY_NAME <> 'Warsaw';

-- 2.B
SELECT C.CITY_NAME MIASTO FROM MAJOR_CITIES C
WHERE SDO_WITHIN_DISTANCE(
    C.GEOM,
    (SELECT GEOM FROM MAJOR_CITIES WHERE CITY_NAME = 'Warsaw'),
    'distance=100 unit=km'
) = 'TRUE' AND C.CITY_NAME <> 'Warsaw';

-- 2.C
SELECT B.CNTRY_NAME Kraj, C.CITY_NAME Miasto
FROM COUNTRY_BOUNDARIES B, MAJOR_CITIES C
WHERE B.CNTRY_NAME = 'Slovakia' AND SDO_RELATE(C.GEOM, B.GEOM,
 'mask=INSIDE') = 'TRUE';
 
-- 2.D
SELECT B.CNTRY_NAME PANSTWO, SDO_GEOM.SDO_DISTANCE(B.GEOM, Poland.GEOM, 1, 'unit=km') ODL
FROM COUNTRY_BOUNDARIES B, (SELECT * FROM COUNTRY_BOUNDARIES WHERE CNTRY_NAME = 'Poland') Poland
WHERE SDO_RELATE(Poland.GEOM, B.GEOM,'mask=TOUCH+EQUAL') <> 'TRUE';

-- 3.A
SELECT B.CNTRY_NAME PANSTWO, SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(Poland.GEOM, B.GEOM, 1), 1, 'unit=km') ODL
FROM COUNTRY_BOUNDARIES B, (SELECT * FROM COUNTRY_BOUNDARIES WHERE CNTRY_NAME = 'Poland') Poland
WHERE SDO_RELATE(Poland.GEOM, B.GEOM,'mask=TOUCH') = 'TRUE';

-- 3.B
SELECT A.CNTRY_NAME
FROM COUNTRY_BOUNDARIES A
ORDER BY SDO_GEOM.sdo_area(A.GEOM, 1, 'unit=SQ_KM') DESC
FETCH NEXT 1 ROWS ONLY;

-- 3.C
SELECT (SDO_GEOM.sdo_area(SDO_GEOM.SDO_MBR(SDO_GEOM.SDO_UNION(A.GEOM, B.GEOM, 1)), 1, 'unit=SQ_KM')) SQ_KM
FROM MAJOR_CITIES A, MAJOR_CITIES B
WHERE A.CITY_NAME = 'Lodz'
AND B.CITY_NAME = 'Warsaw';

-- 3.D
SELECT SDO_GEOM.SDO_UNION(COUNTRIES.GEOM, CITIES.GEOM, 1).GET_GTYPE()
FROM COUNTRY_BOUNDARIES COUNTRIES, MAJOR_CITIES CITIES
WHERE COUNTRIES.CNTRY_NAME = 'Poland'
AND CITIES.CITY_NAME = 'Prague';

-- 3.E
SELECT CITIES.CITY_NAME, COUNTRIES.CNTRY_NAME
FROM COUNTRY_BOUNDARIES COUNTRIES JOIN MAJOR_CITIES CITIES ON COUNTRIES.FIPS_CNTRY = CITIES.FIPS_CNTRY
ORDER BY SDO_GEOM.SDO_DISTANCE(SDO_GEOM.SDO_CENTROID(COUNTRIES.GEOM,1), CITIES.GEOM, 1, 'unit=km')
FETCH NEXT 1 ROWS ONLY;

-- 3.F
SELECT RIVERS.NAME, SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(POLAND.GEOM, RIVERS.GEOM, 1),  1, 'unit=km') DLUGOSC
FROM 
    (SELECT * FROM COUNTRY_BOUNDARIES WHERE CNTRY_NAME = 'Poland') POLAND, 
    (SELECT NAME, SDO_AGGR_UNION(MDSYS.SDOAGGRTYPE(GEOM,1)) GEOM FROM RIVERS GROUP BY NAME) RIVERS
WHERE SDO_RELATE(POLAND.GEOM, RIVERS.GEOM, 'mask=ANYINTERACT') = 'TRUE';
