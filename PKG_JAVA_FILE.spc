create or replace package PKG_JAVA_FILE is

 procedure CREATE_FOLDER -- Создание каталога по указанному пути sPATH
   (
   sPATH   in varchar2
   )
  as language java name 'FOLDER.CREATE_FOLDER
              (
              java.lang.String
              )';


 procedure DELETE_FOLDER_EMPTY -- Удаление пустого каталога по указанному пути sPATH
   (
   sPATH   in varchar2
   )
  as language java name 'FOLDER.DELETE_FOLDER_EMPTY
              (
              java.lang.String
              )';

 procedure DELETE_FOLDER -- Удаление не пустого каталога по указанному пути sPATH
   (
   sPATH   in varchar2
   )
  as language java name 'FOLDER.DELETE_FOLDER
              (
              java.lang.String
              )';

 procedure DELETE_FILE -- Удаление файла по указанному пути sPATH
   (
   sPATH   in varchar2
   )
  as language java name 'FOLDER.DELETE_FILE
              (
              java.lang.String
              )';

 procedure COPY_FILE -- Удаление каталога по указанному пути sPATH
  (
  sFROM     in varchar2,
  sTO       in varchar2,
  sNEW_NAME in varchar2 -- не обязательное поле
  )
 as language java name 'FOLDER.COPY_FILE
             (
             java.lang.String,
             java.lang.String,
             java.lang.String
             )';
 
 procedure BLOB2FILE -- Выгрузка BLOB по указанному пути
   (
   p_blob blob,
   p_file_name varchar2 -- полный путь с расширением
   ) 
 as  language java name 'FOLDER.blob2file
             (
             oracle.sql.BLOB,
             java.lang.String
             )';

end PKG_JAVA_FILE;
/
