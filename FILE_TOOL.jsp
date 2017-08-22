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
           sLogText = "У вас нет прав на доступ по пути: " + patch + " " +ex2 ;
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
         sLogText = "Каталог успешно создан по пути: "+dir.getAbsolutePath() ;
         #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate, :sLogText, 0) };
         #sql { COMMIT };
        }
        else
        {
         sLogText = "Каталог " + dir.getAbsolutePath() + " не создан " ;
         #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate, :sLogText, 1) };
         #sql { COMMIT };
        }
      }
    }
    catch(Exception ex)
    {
       ex.printStackTrace();
       try {
       sLogText = "У вас нет прав на доступ по пути: " + patch + " " +ex ;
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
      sLogText = "Папка " + dir.getAbsolutePath()+ " не найдена.";
      #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate,:sLogText, 0) };
      #sql { COMMIT };
      return;
     }
    if(dir.delete())
     {
      sLogText = "Папка удалена по пути: " + dir.getAbsolutePath();
      #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate,:sLogText, 0) };
      #sql { COMMIT };
     }
     else
     {
      sLogText = "Папка " + dir.getAbsolutePath() + " не удалена.";
      #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate,:sLogText, 0) };
      #sql { COMMIT };
     }
    }
    catch(Exception ex)
    {
       ex.printStackTrace();
       try
       {
       sLogText = "У вас нет прав на доступ по пути: " + sPath ;
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
         sLogText = "У вас нет прав на доступ по пути: " + sFROM   ;
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
            sLogText = "Файл " + FROM.getAbsolutePath()+ " не найден "   ;
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
          sLogText = " У вас нет прав на доступ к файлу: " + sFROM +" "+SE   ;
          #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate,:sLogText,1) };
          #sql { COMMIT };
          return;
         }
       catch(Exception ex3)
         {
          try
           {
            sLogText = "Произошла ошибка:" + ex3  ;
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
              sLogText = "Каталог " + DirTo.getAbsolutePath()+ " не найден, будет создан новый "   ;
              #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate,:sLogText,0) };
              #sql { COMMIT };
              CREATE_FOLDER(sTO);
            }
           catch(Exception ex)
           {
            try
              {
               sLogText = "При создании нового каталога произошла ошибка:" + ex  ;
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
            sLogText = " У вас нет прав на доступ к папке: " + DirTo.getAbsolutePath()   ;
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
        sLogText = "Файл из " + FROM.getAbsolutePath()+ " успешно скопирован в " + DirTo.getAbsolutePath()   ;
        #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate,:sLogText,0) };
        #sql { COMMIT };
      }
    catch(Exception ex)
      {
       ex.printStackTrace();
       try
         {
          sLogText = "Ошибка при копировании файла: " + ex + " в папку " + DirTo.getAbsolutePath() ;
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
            sLogText = "Файл " + delFile.getAbsolutePath()+ " не найден "  ;
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
                sLogText = "Файл " + delFile.getAbsolutePath()+ " успешно удален. "   ;
                #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate,:sLogText,0) };
                #sql { COMMIT };
               }
               else
               {
                sLogText = "Файл " + delFile.getAbsolutePath()+ " не удален. "   ;
                #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate,:sLogText,1) };
                #sql { COMMIT };
               }
             }
             else
             {
              sLogText = "Вместо файла, указана папка " + delFile.getAbsolutePath()   ;
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
       sLogText = "У вас нет прав на доступ по пути: " + sPATH ;
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
      sLogText = "Папка " + dir.getAbsolutePath()+ " не найдена.";
      #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate,:sLogText, 1) };
      #sql { COMMIT };
      return;
     }
    try
    {
     recursiveDelete(dir);
     sLogText = "Папка " + dir.getAbsolutePath()+ " успешно удалено со всеми вложениями.";
      #sql{ INSERT INTO PARUSSV.DIAGNOSTIC_LOG(DATE_LOG, TEXT_LOG, ERROR) VALUES (sysdate,:sLogText, 0) };
      #sql { COMMIT };
    }
    catch(Exception ex1)
    {
     try
       {
       sLogText = "При удалении не пустого каталога произошла ошибка: " + ex1 ;
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
       sLogText = "У вас нет прав на доступ по пути: " + sPath ;
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
        // до конца рекурсивного цикла
        if (!file.exists())
            return;

        //если это папка, то идем внутрь этой папки и вызываем рекурсивное удаление всего, что там есть
        if (file.isDirectory()) {
            for (File f : file.listFiles()) {
                // рекурсивный вызов
                recursiveDelete(f);
            }
        }
        // вызываем метод delete() для удаления файлов и пустых(!) папок
        file.delete();
        System.out.println("Удаленный файл или папка: " + file.getAbsolutePath());
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
