create or replace package PKG_JAVA_FILE is

 procedure CREATE_FOLDER -- �������� �������� �� ���������� ���� sPATH
   (
   sPATH   in varchar2
   )
  as language java name 'FOLDER.CREATE_FOLDER
              (
              java.lang.String
              )';


 procedure DELETE_FOLDER_EMPTY -- �������� ������� �������� �� ���������� ���� sPATH
   (
   sPATH   in varchar2
   )
  as language java name 'FOLDER.DELETE_FOLDER_EMPTY
              (
              java.lang.String
              )';

 procedure DELETE_FOLDER -- �������� �� ������� �������� �� ���������� ���� sPATH
   (
   sPATH   in varchar2
   )
  as language java name 'FOLDER.DELETE_FOLDER
              (
              java.lang.String
              )';

 procedure DELETE_FILE -- �������� ����� �� ���������� ���� sPATH
   (
   sPATH   in varchar2
   )
  as language java name 'FOLDER.DELETE_FILE
              (
              java.lang.String
              )';

 procedure COPY_FILE -- �������� �������� �� ���������� ���� sPATH
  (
  sFROM     in varchar2,
  sTO       in varchar2,
  sNEW_NAME in varchar2 -- �� ������������ ����
  )
 as language java name 'FOLDER.COPY_FILE
             (
             java.lang.String,
             java.lang.String,
             java.lang.String
             )';
 
 procedure BLOB2FILE -- �������� BLOB �� ���������� ����
   (
   p_blob blob,
   p_file_name varchar2 -- ������ ���� � �����������
   ) 
 as  language java name 'FOLDER.blob2file
             (
             oracle.sql.BLOB,
             java.lang.String
             )';

end PKG_JAVA_FILE;
/
