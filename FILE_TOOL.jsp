create or replace and compile java source named file_tool as
import java.io.*;
import oracle.sql.BLOB;
import java.sql.SQLException;

public class FOLDER
{
  public static void CREATE_FOLDER( java.lang.String  patch )
  {
  String sLogText;
  boolean created = false;
    try
    {
      File dir = new File(patch);
      if (dir.exists() == false)
       {
        try
        {
         created = dir.mkdirs();
        }
        catch(Exception ex2)
        {
          ex2.printStackTrace();
          try
          {
           sLogText = "� ��� ��� ���� �� ������ �� ����: " + patch + " " +ex2 ;
           #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate,:sLogText, 1) };
           #sql { COMMIT };
           return;
          }
          catch(Exception ex1)
          {
           ex1.printStackTrace();
          }
        }
        if(created)
        {
         sLogText = "������� ������� ������ �� ����: "+dir.getAbsolutePath() ;
         #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate, :sLogText, 0) };
         #sql { COMMIT };
        }
        else
        {
         sLogText = "������� " + dir.getAbsolutePath() + " �� ������ " ;
         #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate, :sLogText, 1) };
         #sql { COMMIT };
        }
      }
    }
    catch(Exception ex)
    {
       ex.printStackTrace();
       try {
       sLogText = "� ��� ��� ���� �� ������ �� ����: " + patch + " " +ex ;
       #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate,:sLogText, 1) };
       #sql { COMMIT }; }
       catch(Exception ex1)
       {
       ex1.printStackTrace();
       }
     }
  }

  public static void DELETE_FOLDER_EMPTY(java.lang.String sPath)
  {
    String sLogText;
    try
    {
    File dir = new File(sPath);
    if (!dir.exists())
     {
      sLogText = "����� " + dir.getAbsolutePath()+ " �� �������.";
      #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate,:sLogText, 0) };
      #sql { COMMIT };
      return;
     }
    if(dir.delete())
     {
      sLogText = "����� ������� �� ����: " + dir.getAbsolutePath();
      #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate,:sLogText, 0) };
      #sql { COMMIT };
     }
     else
     {
      sLogText = "����� " + dir.getAbsolutePath() + " �� �������.";
      #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate,:sLogText, 0) };
      #sql { COMMIT };
     }
    }
    catch(Exception ex)
    {
       ex.printStackTrace();
       try
       {
       sLogText = "� ��� ��� ���� �� ������ �� ����: " + sPath ;
       #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate,:sLogText, 1) };
       #sql { COMMIT };
       }
       catch(Exception ex1)
       {
       ex1.printStackTrace();
       }
    }
  }

  public static void COPY_FILE(java.lang.String sFROM,java.lang.String sTO,java.lang.String sNewName) throws IOException
  {
   File FROM    = null;
   File DirTo   = null;
   File NewFile = null;
   InputStream is = null;
   OutputStream os = null;
   String sLogText;
   String sNameFile;
   try
     {
      FROM = new File(sFROM);
     }
   catch(Exception SE)
     {
       try
       {
         sLogText = "� ��� ��� ���� �� ������ �� ����: " + sFROM   ;
         #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate,:sLogText,1) };
         #sql { COMMIT };
         return;
       }
       catch(Exception ex)
       {
         ex.printStackTrace();
       }
     }
   try
     {
      if (!FROM.exists())
        {
         try
          {
            sLogText = "���� " + FROM.getAbsolutePath()+ " �� ������ "   ;
            #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate,:sLogText,1) };
            #sql { COMMIT };
            return;
          }
         catch(Exception ex)
          {
           ex.printStackTrace();
          }
        }
     }
     catch(Exception SE)
     {
       try
         {
          sLogText = " � ��� ��� ���� �� ������ � �����: " + sFROM +" "+SE   ;
          #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate,:sLogText,1) };
          #sql { COMMIT };
          return;
         }
       catch(Exception ex3)
         {
          try
           {
            sLogText = "��������� ������:" + ex3  ;
            #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate,:sLogText,0) };
            #sql { COMMIT };
           }
          catch(Exception ex4)
           {
            ex4.printStackTrace();
           }
         }
      }

      DirTo = new File(sTO);
      sNameFile = DirTo.getName();

      try
      {
        if (DirTo.exists() == false)
          {
           try
            {
              sLogText = "������� " + DirTo.getAbsolutePath()+ " �� ������, ����� ������ ����� "   ;
              #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate,:sLogText,0) };
              #sql { COMMIT };
              CREATE_FOLDER(sTO);
            }
           catch(Exception ex)
           {
            try
              {
               sLogText = "��� �������� ������ �������� ��������� ������:" + ex  ;
               #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate,:sLogText,1) };
               #sql { COMMIT };
               return;
              }
            catch(Exception ex4)
              {
               ex4.printStackTrace();
              }
           }
          }
          if (sNewName != null)
            {
             DirTo = new File(sTO+"\\"+sNewName);
            }
          else
            {
             sNameFile = FROM.getName();
             DirTo = new File(sTO+"\\"+sNameFile);
            }
     }
     catch(Exception SE)
     {
       try
          {
            sLogText = " � ��� ��� ���� �� ������ � �����: " + DirTo.getAbsolutePath()   ;
            #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate,:sLogText,1) };
            #sql { COMMIT };
            return;
          }
         catch(Exception ex)
         {
         ex.printStackTrace();
         }
     }
     try
       {
        is = new FileInputStream(FROM);
        os = new FileOutputStream(DirTo);
        byte[] buffer = new byte[1024];
        int length;
        while ((length = is.read(buffer)) > 0)
          {
           os.write(buffer, 0, length);
          }
        sLogText = "���� �� " + FROM.getAbsolutePath()+ " ������� ���������� � " + DirTo.getAbsolutePath()   ;
        #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate,:sLogText,0) };
        #sql { COMMIT };
      }
    catch(Exception ex)
      {
       ex.printStackTrace();
       try
         {
          sLogText = "������ ��� ����������� �����: " + ex + " � ����� " + DirTo.getAbsolutePath() ;
          #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate,:sLogText, 1) };
          #sql { COMMIT };
         }
       catch(Exception ex1)
         {
          ex1.printStackTrace();
         }
      }
    finally
      {
        is.close();
        os.close();
      }
  }

  public static void DELETE_FILE(java.lang.String sPATH)
  {
   File delFile = new File(sPATH);
   String sLogText;
   try
   {
     if (!delFile.exists())
        {
         try
          {
            sLogText = "���� " + delFile.getAbsolutePath()+ " �� ������ "  ;
            #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate,:sLogText,1) };
            #sql { COMMIT };
            return;
          }
         catch(Exception ex)
          {
           ex.printStackTrace();
          }
        }
        else
        {
           try
            {
             if (delFile.isFile())
             {
               if(delFile.delete())
               {
                sLogText = "���� " + delFile.getAbsolutePath()+ " ������� ������. "   ;
                #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate,:sLogText,0) };
                #sql { COMMIT };
               }
               else
               {
                sLogText = "���� " + delFile.getAbsolutePath()+ " �� ������. "   ;
                #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate,:sLogText,1) };
                #sql { COMMIT };
               }
             }
             else
             {
              sLogText = "������ �����, ������� ����� " + delFile.getAbsolutePath()   ;
              #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate,:sLogText,1) };
              #sql { COMMIT };
              return;
             }
            }
           catch(Exception ex)
            {
             ex.printStackTrace();
            }
        }
   }
   catch(Exception ex)
   {
     try
      {
       sLogText = "� ��� ��� ���� �� ������ �� ����: " + sPATH ;
       #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate,:sLogText, 1) };
       #sql { COMMIT }; }
     catch(Exception ex1)
       {
       ex1.printStackTrace();
       }
   }
  }

  public static void DELETE_FOLDER(java.lang.String sPath)
  {
    String sLogText;
    try
    {
    File dir = new File(sPath);
    if (!dir.exists())
     {
      sLogText = "����� " + dir.getAbsolutePath()+ " �� �������.";
      #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate,:sLogText, 1) };
      #sql { COMMIT };
      return;
     }
    try
    {
     recursiveDelete(dir);
     sLogText = "����� " + dir.getAbsolutePath()+ " ������� ������� �� ����� ����������.";
      #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate,:sLogText, 0) };
      #sql { COMMIT };
    }
    catch(Exception ex1)
    {
     try
       {
       sLogText = "��� �������� �� ������� �������� ��������� ������: " + ex1 ;
       #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate,:sLogText, 1) };
       #sql { COMMIT };
       }
       catch(Exception ex2)
       {
       ex2.printStackTrace();
       }
    }
    }
    catch(Exception ex)
    {
       ex.printStackTrace();
       try
       {
       sLogText = "� ��� ��� ���� �� ������ �� ����: " + sPath ;
       #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate,:sLogText, 1) };
       #sql { COMMIT };
       }
       catch(Exception ex1)
       {
       ex1.printStackTrace();
       }
    }
  }

  private static void recursiveDelete(File file) {
        // �� ����� ������������ �����
        if (!file.exists())
            return;

        //���� ��� �����, �� ���� ������ ���� ����� � �������� ����������� �������� �����, ��� ��� ����
        if (file.isDirectory()) {
            for (File f : file.listFiles()) {
                // ����������� �����
                recursiveDelete(f);
            }
        }
        // �������� ����� delete() ��� �������� ������ � ������(!) �����
        file.delete();
        System.out.println("��������� ���� ��� �����: " + file.getAbsolutePath());
    }

  public static void blob2file(BLOB blob, String fileName)
    throws SQLException, IOException {
    InputStream in = null;
    OutputStream out = null;
    try {
      out = new BufferedOutputStream(new FileOutputStream(new File(fileName)));
      in = blob.getBinaryStream();
      int length;
      byte[] buf = new byte[blob.getChunkSize()];
      while ((length = in.read(buf)) != -1) {
        out.write(buf, 0, length);
      }
    } finally {
      if (in != null) {in.close();}
      if (out != null) {out.close();}
    }
  }

}
/
