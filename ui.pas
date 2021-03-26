(* User Interface - Unit responsible for displaying messages and stats *)

unit ui;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, video, keyboard, globalutils, scrtitle, main,
  {$IFDEF WINDOWS}
  JwaWinCon, {$ENDIF}
  (* CRT unit is just to clear the screen on exit *)
  Crt;

var
  vid: TVideoMode;
  i: smallint;
  x, y: smallint;

(* Write to the screen *)
procedure TextOut(X, Y: word; textcol: shortstring; const S: string);
(* Initialise the video unit *)
procedure setupScreen;
(* Shutdown the video unit *)
procedure shutdownScreen;
(* Blank the screen *)
procedure screenBlank;
(* Update Experience level *)
procedure updateXP;
(* Update player health display *)
procedure updateHealth;
(* Update player attack value *)
procedure updateAttack;
(* Update player defence value *)
procedure updateDefence;
(* Draws the panel on side of screen *)
procedure drawSidepanel;
(* Clear screen and write exit message *)
procedure exitMessage;

implementation

uses
  main;

procedure TextOut(X, Y: word; textcol: shortstring; const S: string);
var
  P, I, M: smallint;
  tint: byte;
begin
  tint := $07;
  case textcol of
    'black': tint := $00;
    'blue': tint := $01;
    'green': tint := $02;
    'cyan': tint := $03;
    'red': tint := $04;
    'magenta': tint := $05;
    'brown': tint := $06;
    'white': tint := $07;
    'grey': tint := $08;
    'lblue': tint := $09;
    'blueBGblackTXT': tint := $10;
    'blueBlock': tint := $11;
    'blueBGgreenTXT': tint := $12;
    'blueBGlblueTXT': tint := $13;
    'blueBGredTXT': tint := $14;
    'blueBGbrownTXT': tint := $15;
    'blueBGyellowTXT': tint := $16;
    'blueBGgreyTXT': tint := $17;
    'greenBGblackTXT': tint := $20;
    'brownBlock': tint := $66;
    'yellow': tint := Yellow;
    else
      tint := $07;
  end;
  P := ((X - 1) + (Y - 1) * ScreenWidth);
  M := Length(S);
  if P + M > longint(ScreenWidth) * ScreenHeight then
    M := longint(ScreenWidth) * ScreenHeight - P;
  for I := 1 to M do
    VideoBuf^[longint(P + I) - 1] := Ord(S[i]) + (tint shl 8);
end;

procedure setupScreen;
begin
  {$IFDEF WINDOWS}
  SetConsoleTitle('Axes, Armour & Ale');
  {$ENDIF}
  { Initialise the video unit }
  InitVideo;
  InitKeyboard;
  vid.Col := 67;
  vid.Row := 91;
  vid.Color := True;
  SetVideoMode(vid);
  SetCursorType(crHidden);
  ClearScreen;
  (* prepare changes to the screen *)
  LockScreenUpdate;
  (* Check for previous save file *)
  if FileExists(GetUserDir + globalutils.saveFile) then
  begin
    scrtitle.displayTitleScreen(1);
    main.saveGameExists := True;
  end
  else
    scrtitle.displayTitleScreen(0);
  (* Write those changes to the screen *)
  UnlockScreenUpdate;
  (* only redraws the parts that have been updated *)
  UpdateScreen(False);
end;

procedure shutdownScreen;
begin
  SetCursorType(crBlock);
  ClearScreen;
  DoneVideo;
  DoneKeyboard;
end;

procedure screenBlank;
begin
  for y := 1 to 67 do
  begin
    for x := 1 to 91 do
    begin
      TextOut(x, y, 'black', ' ');
    end;
  end;
end;


procedure updateXP;
begin

end;

procedure updateHealth;
begin
  TextOut(70, 7, 'green', Chr(223) + Chr(223) + Chr(223) + Chr(223) +
    Chr(223) + Chr(223) + Chr(223) + Chr(223) + Chr(223) + Chr(223) +
    Chr(223) + Chr(223) + Chr(223) + Chr(223) + Chr(223) + Chr(223));
end;

procedure updateAttack;
begin
  TextOut(70, 8, 'cyan', 'Attack:');
end;

procedure updateDefence;
begin
  TextOut(70, 9, 'cyan', 'Defence:');
end;

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
  updateHealth;
  updateAttack;
  updateDefence;
end;

procedure exitMessage;
begin
  ClrScr;
  writeln('Axes, Armour & Ale - Chris Hawkins');
end;

end.
