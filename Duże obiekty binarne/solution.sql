-- 1.
CREATE TABLE MOVIES AS SELECT * FROM ZTPD.MOVIES;

-- 2.
DESC MOVIES;

-- 3.
SELECT ID, TITLE
FROM MOVIES
WHERE COVER IS NULL;

-- 4
SELECT ID, TITLE, dbms_lob.GETLENGTH(COVER) AS FILESIZE 
FROM MOVIES
WHERE COVER IS NOT NULL;

-- 5.
SELECT ID, TITLE, dbms_lob.GETLENGTH(COVER) AS FILESIZE
FROM MOVIES
WHERE COVER IS NULL;

-- 6.
SELECT DIRECTORY_NAME, DIRECTORY_PATH FROM ALL_DIRECTORIES;
-- /u01/app/oracle/oradata/DBLAB03/directories/tpd_dir

-- 7.
UPDATE MOVIES
SET COVER =  EMPTY_BLOB(), MIME_TYPE = 'image/jpeg'
WHERE ID = 66;
COMMIT;

-- 8.
SELECT ID, TITLE, dbms_lob.GETLENGTH(COVER) AS FILESIZE
FROM MOVIES
WHERE ID IN (65, 66);

-- 9.
DECLARE
    lobd blob;
    fils BFILE := BFILENAME('TPD_DIR','escape.jpg');
BEGIN
    SELECT COVER INTO lobd
    FROM MOVIES
    WHERE DBMS_LOB.GETLENGTH(COVER) = 0
    FOR UPDATE;
    DBMS_LOB.FILEOPEN(fils, DBMS_LOB.file_readonly);
    DBMS_LOB.LOADFROMFILE(lobd,fils,DBMS_LOB.GETLENGTH(fils));
    DBMS_LOB.FILECLOSE(fils);
    COMMIT;
END;

-- 10.
CREATE TABLE TEMP_COVERS (
    movie_id NUMBER(12),
    image BFILE,
    mime_type VARCHAR2(50)
);

-- 11.
INSERT INTO TEMP_COVERS VALUES(65, BFILENAME('TPD_DIR','eagles.jpg'), ' image/jpeg');
COMMIT;

-- 12.
SELECT MOVIE_ID, dbms_lob.GETLENGTH(IMAGE) AS FILESIZE 
FROM TEMP_COVERS;

-- 13.
DECLARE
    temp_blob BLOB;
    target_image_file BFILE;
    target_mime_type VARCHAR2(50);
    target_movie_id NUMERIC := 65;
BEGIN
    SELECT image, mime_type INTO target_image_file, target_mime_type
    FROM TEMP_COVERS
    WHERE movie_id = target_movie_id;
    DBMS_LOB.CREATETEMPORARY(temp_blob, TRUE);
    DBMS_LOB.FILEOPEN(target_image_file, DBMS_LOB.file_readonly);
    DBMS_LOB.LOADFROMFILE(temp_blob, target_image_file, DBMS_LOB.GETLENGTH(target_image_file));
    DBMS_LOB.FILECLOSE(target_image_file);
    UPDATE MOVIES SET 
        COVER = temp_blob,
        MIME_TYPE = target_mime_type
    WHERE ID = target_movie_id;
    DBMS_LOB.FREETEMPORARY(temp_blob);
    COMMIT;
END;

-- 14.
SELECT ID, TITLE, dbms_lob.GETLENGTH(COVER) AS FILESIZE
FROM MOVIES
WHERE ID IN (65, 66);

-- 15.
DROP TABLE MOVIES;
