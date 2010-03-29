program Untitled;

(* This program is a demo of the Console Window Manager *)

uses CRT, DOS, Window;

var
   j : integer;

begin
     ClrScr;
     writeln;
     write('Ordinary cursor: ' );
     readln;

     write('Full cursor: ');
     FullCursor;
     readln;

     write('No cursor at all: ');
     NoCursor;
     readln;

     OrdinaryCursor;
     writeln('Window');
     OpenWindow(2, 2, 40, 20);
     for j := 1 to 300 do
         write('1A');
     readln;

     ScrollUp(5);
     readln;

     OpenWindow(10, 10, 50, 15);
     for j := 1 to 100 do
         write('1B');
     readln;

     ScrollUp(1);
     readln;

     OpenWindow(12, 12, 23, 23);
     for j := 1 to 100 do
         write('3C');
     readln;

     ScrollUp(4);
     readln;

     CloseWindow;
     readln;

     CloseWindow;
     readln;

     CloseWindow;
     readln;

     ScrollDown(3);
     readln;

     for j :=1 to 200 do
         write('Ok ');
     readln;

     CloseWindow;
     readln;
end.
