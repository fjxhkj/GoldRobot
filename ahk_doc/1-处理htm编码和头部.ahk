#NoEnv
#Warn
#Warn, LocalSameAsGlobal, Off
#Warn, UseUnsetLocal, StdOut

global Gs_IsDebug := true
, gs_version := 0.1
, gs_author := "Fonny"
, gs_public := "2015"
, gs_setting_ini := SubStr(A_ScriptName, 1, -4) ".ini"

Include_CpTransform()
delHead()

ExitApp
return

delHead()
{
   ;~ ���� js �ļ�����
   ;~ ����Ŀ¼�� D, �ļ��� F, �ļ���Ŀ¼�� DF.
   loop, Files, %A_ScriptDir%\*.js, RF
   {      
      _fEncoding := File_GetEncoding(A_LoopFileLongPath)
      
      ;~ utf8+bom,��Ҫ��Ϊ utf8 no bom
      if (_fEncoding = 4)
      {
          File_CpTransform(A_LoopFileFullPath, "b", "u")
      }
      ;~ ansi,��Ҫ��Ϊutf8 no bom
      else if (_fEncoding = 1)
      {
         File_CpTransform(A_LoopFileFullPath, "a", "u")
      }
      ;~ utf8 no bom,��ΪANSI
      ;~ else if (_fEncoding = 6)
      ;~ {
         ;~ File_CpTransform(A_LoopFileFullPath, "u", "a")         
      ;~ }
      
      FileRead, content, % A_LoopFileFullPath
      FileDelete, % A_LoopFileFullPath      
      FileAppend, % content, % A_LoopFileFullPath
   }
      
   ;~ ���� htm �ļ������ͷ����������
   ;~ Loop, %A_ScriptDir%\*.htm, , 1
   ;~ ����Ŀ¼�� D, �ļ��� F, �ļ���Ŀ¼�� DF.
   loop, Files, %A_ScriptDir%\*.htm*, RF
   {
      _fEncoding := File_GetEncoding(A_LoopFileLongPath)
      
      ;~ Debug(A_LineFile "`nFunc `: " A_ThisFunc "`nLine : " A_LineNumber "`n`n"
      ;~ . "encoding " _fEncoding "`n" A_LoopFileLongPath)

      ;~ utf8+bom,��Ҫ��Ϊ utf8 no bom
      if (_fEncoding = 4)
      {
          File_CpTransform(A_LoopFileFullPath, "b", "u")
      }
      ;~ ansi,��Ҫ��Ϊutf8 no bom
      else if (_fEncoding = 1)
      {
         File_CpTransform(A_LoopFileFullPath, "a", "u")
      }
      ;~ utf8 no bom,��ΪANSI
      ;~ else if (_fEncoding = 6)
      ;~ {
         ;~ File_CpTransform(A_LoopFileFullPath, "u", "a")         
      ;~ }
      
      FileRead, content, % A_LoopFileFullPath
      FileDelete, % A_LoopFileFullPath
      
      _newContent := ""      
      _isLineOk := false
      
      ;~ ��������
      loop, Parse, % content, `n, `r
      {
         _line := A_LoopField
         
         if !(_isLineOk)
         {
            if (_line ~= "i)charset=iso-8859-1")
            {
               _line := RegExReplace(_line,"i)charset=iso-8859-1","charset=utf-8")            
            }            
            else if (_line ~= "i)GB2312")
            {
               _line := RegExReplace(_line,"i)GB2312","utf-8")               
            }
            
            if (_line ~= "i)<body>")
            {            
               _isLineOk := true
            }
         }
         _newContent .= _line "`n"
      }
      ;~ ɾ�����Ļ��з�
      _newContent := SubStr(_newContent, 1 , -1)
      FileAppend, % _newContent, % A_LoopFileFullPath
      ToolTip, %A_Index% %A_LoopFileLongPath% ���
   }
   Trace("�滻ͷ�����", 3)
   return
}