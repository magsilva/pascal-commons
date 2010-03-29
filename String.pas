(*
String related utils
Original code by Rafael Guimarães de Sá pushished at Micro Sistemas (year XIII,
number 140, july 1994, p. 42 - 44).
*)

Unit StringUtils;

Interface

(**
 * Add slash to the end of the pathname.
 *
 * @param Name Pathname to be added the slash (/)
 * @return Pathname with a slash in the end.
 *)
Function Slash(Name : String) : String;

(**
 * Return a string with the percentage of xPar in relation to xTot.
 *
 * @param xPar Sample selection count.
 * @param xTotal Sample size.
 * @return Percentage of selection into sample.
 *)
Function Percent(xPar, xTot : Real) : String;

(**
 * Remove the pathname for a filename.
 *
 * @param Filename Filename
 * @return The file's basename.
 *)
Function Basename(Filename : String) : String;

(**
 * Copy a file.
 *
 * @param InputFilename Name of the file to be copied.
 * @param OutputFilename Name of the destination file.
 *)
Procedure CopyFile(InputFilename, OutputFilename : String);

(**
 * Return the string in lowercase.
 *
 * @param S String
 * @return S in lowercase
 *)
Function Lower(S : String) : String;

(**
 * Return the string in uppercase.
 *
 * @param S String
 * @return S in uppercase
 *)
Function Upper(S : String) : String;

(**
 * Return the string capitalized.
 *
 * @param S String
 * @return S capitalized
 *)
Function Capitalize(Str1 : String) : String;

(**
 * Write a string to a given position in the screen.
 *
 * @param X Horizontal position (0 is the left of the screen)
 * @param Y Vertical position (0 is the top of the screen)
 * @param S String to be written
 *)
Procedure WriteXY(X, Y : Integer; Str : String);


Implementation

uses Crt;

Function StrEsp(Sz : Integer; Xz : Byte) : String;
Var
     Lz : String;
Begin
     Sz := Abs(sz);
     Str(Sz, Lz);
     While Length(Lz) < Xz do
           Insert(' ', Lz, 1);
     StrEsp := Lz;
End;

Function Slash(Name : String) : String;
Begin
     If Copy(Name, Length(Name), 1) <> '\' Then
        Name := Name + '\';
     Slash := Name;
End;

Function Percent(xPar, xTot : Real) : String;
Var
     xRet1 : Real;
     xRet2 : String;
Begin
     If xTot = 0 then
     Begin
          xRet1 := 0;
          xRet2 := '  0 %';
     End
     Else
     Begin
          xRet1 := (xPar / xTot) * 100;
          xRet2 := StrEsp(Round(xRet1), 3) + ' %';
     End;
     Percent := xRet2;
End;

Function Basename(Filename : String) : String;
Var
     Str1 : String;
     Count1 : Integer;
Begin
     Str1 := Filename;
     For Count1 := Length(Str1) DownTo (Length(Str1) - 12) Do
     Begin
          If Copy(Str1, Count1, 1) = '\' Then
          Begin
               Basename := Copy(Str1, Count1 + 1, 13);
               Count1 := Length(Str1) - 12;
          End;
     End;
End;

Procedure CopyFile(InputFilename, OutputFilename : String);
Var
     InputFile, OutputFile : File;
     NumRead, NumWritten : Word;
     Buffer : array[1..2048] of Char;
Begin
     Assign(InputFile, InputFilename);
     Reset(InputFile, 1);
     Assign(OutputFile, OutputFilename);
     Reset(OutputFile, 1);
     Repeat
          BlockRead(InputFIle, buffer, SizeOf(buffer), NumRead);
          BlockWrite(OutputFile, buffer, NumRead, NumWritten);
     until (NumRead = 0) or (NumWritten <> NumRead);
     Close(InputFile);
     Close(OutputFile);
End;

Function Lower(S : String) : String;
Var
     x : Byte;
Begin
     For x := 1 to Length(s) do
     Begin
          If Ord(s[x]) in [65..90] Then
             s[x] := Chr(Ord(s[x]) + 32);
     End;
     Lower := s;
End;


Function Upper(S : String) : String;
Var
     x : Byte;
Begin
     If s <> ' ' Then
        For x := 1 to Length(s) do
            s[x] := Upcase(s[x]);
     Upper := s;
End;

Function Capitalize(Str1 : String) : String;
Var
   Str : Array[1..201] of String[1];
   Cnt1 : Integer;
   Cp : String;
Begin
     Str1 := Lower(Str1);
     Cp := '';
     If Length(Str1) > 200 Then Halt;
     For Cnt1 := 1 to Length(Str1) do
     Begin
          Str[Cnt1] := Copy(Str1, Cnt1, 1);
     End;
     Str[1] := Upper(Str[1]);
     For Cnt1 := 2 to Length(Str1) + 1 do
     Begin
          If Str[Cnt1] = ' ' Then
             Str[cnt1 + 1] := Upper(Str[Cnt1 + 1]);
     End;
     For Cnt1 := 1 to Length(Str1) do
         Cp := Cp + Str[Cnt1];
     Capitalize := Cp;
End;

Procedure WriteXY(X, Y : Integer; Str : String);
Begin
     GotoXY(X, Y);
     Writeln(Str);
End;

Begin
End.
