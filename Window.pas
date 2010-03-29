(*
Window System
Original code by Alexandre de Azevedo Palmeira Filho and published at
Micro Sistemas Magazine (year XII, number 122, november 1992).
*)

Unit Window;

Interface

type
    (**
     * Represent the content of the screen and represents the phisical video
     * memory
     *)
    T = array[1..4000] of char;

(**
 * Make the cursor invisible.
 *)
Procedure NoCursor;

(**
 * Make the cursor visible (but just the bottom line).
 *)
Procedure OrdinaryCursor;

(**
 * Make the cursor visible (all the lines).
 *)
Procedure FullCursor;

(**
 * Shift up the last window content by n lines.
 *)
Procedure ScrollUp(n : byte);

(**
 * Shift down the last window content by n lines.
 *)
Procedure ScrollDown(n : byte);

(**
 * Save the current screen.
 *)
Procedure SaveScreen(x : T);

(**
 * Load a screen.
 *)
Procedure LoadScreen(x : T);

(**
 * Create a new window (with borders). The borders remove two pixels vertically
 * and two pixels horizontally of the area really available to write some
 * content to the window.
 *
 * @param x1, y1: Top left point.
 * @param x2, y2: Bottom right point.
 *)
Procedure OpenWindow(x1, y1, x2, y2 : byte);

(**
 * Close the last window created and restore the previous one.
 *)
Procedure CloseWindow;


Implementation

uses DOS, Crt;

type
    c = record
      WMin, Wmax : word;
    end;

var
   screen : T; (* absolute $b8000000; *)
   R : Registers;
   windows : array[1..16] of T;
   coord : array[1..16] of c;
   i, j : integer;
   focus : integer;

(**
 * The cursor (DOS) has 8 horizontal lines. This procedure let you choose
 * the lines to be highlighted.
 *
 * @param x First line to be highlighted.
 * @param y Last line to be highlighted.
 *)
Procedure Cursor(x, y : byte);
begin
     R.ah := 1;
     R.ch := x;
     R.cl := y;
     Intr(16, R);
end;

Procedure NoCursor;
begin
     Cursor(8, 0);
end;

Procedure OrdinaryCursor;
begin
     Cursor(6, 7);
end;

Procedure FullCursor;
begin
     Cursor(0, 7);
end;

Procedure Scroll(x, n : byte);
begin
     R.ah := x;
     R.al := n;
     R.cl := lo(WindMin);
     R.ch := hi(WindMin);
     R.dl := lo(WindMax);
     R.dh := hi(WindMax);
     R.bh := 15;
     Intr(16, R);
end;

Procedure ScrollUp(n : byte);
begin
     Scroll(6, n);
end;

Procedure ScrollDown(n : byte);
begin
     Scroll(7, n);
end;

Procedure SaveScreen(x : T);
begin
     x := screen;
end;

Procedure LoadScreen(x : T);
begin
     screen := x;
end;

Procedure OpenWindow(x1, y1, x2, y2 : byte);
var
   i, j : integer;
begin
     inc(focus);
     windows[focus] := screen;
     Window(x1, y1, x2, y2+1);
     write(chr(201));
     for j := x1 + 1 to x2 - 2 do
         write(char(205));
     write(char(187));
     for i := y1 + 1 to y2 - 1 do
     begin
         write(char(186));
         for j := x1 + 1 to x2 - 1 do
             write(' ');
         write(char(186));
     end;
     write(chr(200));
     for j := x1 + 1 to x2 - 1 do
         Write(char(205));
     Write(char(188));
     Window(x1 + 1, y1 + 1, x2 - 1, y2 - 1);
     coord[focus].WMax := WindMax;
     coord[focus].WMin := WindMin;
end;

Procedure CloseWindow;
begin
     screen := windows[focus];
     WindMax := coord[focus - 1].Wmax;
     WindMin := coord[focus - 1].Wmin;
     Window(lo(WindMin) + 1, hi(WindMin) + 1, lo(WindMax) + 1, hi(WindMax) + 1);
     dec(focus);
end;

Begin
     focus := 0;
End.
