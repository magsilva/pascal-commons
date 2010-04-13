unit Mouse;

Interface

Uses Dos;

Function IsMouseOn : Boolean;

Procedure ShowMouse;

Procedure HideMouse;

Function MouseX : Integer;

Function MouseY : Integer;

Function CoordWithinArea(x1, y1, x2, y2 : Integer; px, py : Integer) : Boolean;

Function IsMouseButtonActive(button : Integer) : Boolean;



Implementation

Var
	R : registers;

Function IsMouseOn : Boolean;
Begin
	IsMouseOn := false;
	R.ax := 0;
	intr($33, R);
	if R.ax <> 0 then
		IsMouseOn := True;
End;

Procedure ShowMouse;
begin
	R.ax := 1;
	intr($33, R);
End;


Procedure HideMouse;
Begin
	R.ax := 2;
	intr($33, R);
End;

Function MouseX : Integer;
Begin
	R.ax := 3;
	intr($33, R);
	MouseX := R.cx;
End;

Function MouseY : Integer;
Begin
	R.ax := 3;
	intr($33, R);
	MouseY := R.dx;
End;



Function CoordWithinArea(x1, y1, x2, y2 : Integer; px, py : Integer) : Boolean;
Begin
	if (px < x1) or (px > x2) or (py < y1) or (py > y2) then
		CoordWithinArea := false
	else
		CoordWithinArea := true;
End;


Function IsMouseButtonActive(button : Integer) : Boolean;
Begin
	R.ax := 3;
	intr($33, R);
	if (R.bx and button) = button then
		IsMouseButtonActive := true
	else
		IsMouseButtonActive := false;
End;

End.
