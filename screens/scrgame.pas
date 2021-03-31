unit scrgame;

{$mode objfpc}{$H+}

interface

uses
  video;

(* Draws the panel on side of screen *)
procedure drawSidepanel;
(* Clear screen and load various panels for game *)
procedure displayGameScreen;

implementation

uses
  ui;

procedure drawSidepanel;
begin
  (* Stats window *)
  { top line }
  TextOut(68, 1, 'cyan', Chr(218));
  for i := 69 to 90 do
  begin
    TextOut(i, 1, 'cyan', Chr(196));
  end;
  TextOut(91, 1, 'cyan', Chr(191));
  { edges }
  for i := 2 to 13 do
  begin
    TextOut(68, i, 'cyan', Chr(179) + '                      ' + Chr(179));
  end;
  { bottom }
  TextOut(68, 14, 'cyan', Chr(192));
  for i := 69 to 90 do
  begin
    TextOut(i, 14, 'cyan', Chr(196));
  end;
  TextOut(91, 14, 'cyan', Chr(217));

  (* Equipment window *)
  { top line }
  TextOut(68, 15, 'cyan', Chr(218));
  for i := 69 to 90 do
  begin
    TextOut(i, 15, 'cyan', Chr(196));
  end;
  TextOut(91, 15, 'cyan', Chr(191));
  TextOut(70, 15, 'cyan', 'Equipment');
  { edges }
  for i := 16 to 20 do
  begin
    TextOut(68, i, 'cyan', Chr(179) + '                      ' + Chr(179));
  end;
  { bottom }
  TextOut(68, 20, 'cyan', Chr(192));
  for i := 69 to 90 do
  begin
    TextOut(i, 20, 'cyan', Chr(196));
  end;
  TextOut(91, 20, 'cyan', Chr(217));

  (* Info window *)

  (* Write stats *)
  // test name
  TextOut(70, 2, 'cyan', 'Borodagz');
  TextOut(70, 3, 'cyan', 'the Worthless');
  TextOut(70, 5, 'cyan', 'Experience:');
  TextOut(70, 6, 'cyan', 'Health:');
  updateXP;
  updateHealth;
  updateAttack;
  updateDefense;
end;

procedure displayGameScreen;
begin
  drawSidepanel;
end;

end.

