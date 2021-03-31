(* User Interface - Unit responsible for displaying messages and stats *)

unit ui;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, video, keyboard, globalutils, scrtitle, scrgame,
  {$IFDEF WINDOWS}
  JwaWinCon, {$ENDIF}
  (* CRT unit is just to clear the screen on exit *)
  Crt;

var
  vid: TVideoMode;
  messageArray: array[1..7] of string = (' ', ' ', ' ', ' ', ' ', ' ', ' ');
  i: smallint;
  x, y: smallint;
  (* Status effects *)
  poisonStatusSet: boolean;

(* Write to the screen *)
procedure TextOut(X, Y: word; textcol: shortstring; const S: string);
(* Initialise the video unit *)
procedure setupScreen;
(* Shutdown the video unit *)
procedure shutdownScreen;
(* Blank the screen *)
procedure screenBlank;
(* Clear screen and write exit message *)
procedure exitMessage;
(* Display equipped weapon *)
procedure updateWeapon(weaponName: shortstring);
(* Display equipped armour *)
procedure updateArmour(armourName: shortstring);
(* Display status effects *)
procedure displayStatusEffect(onoff: byte; effectType: shortstring);
(* Display Experience level *)
procedure updateXP;
(* Display Health bar *)
procedure updateHealth;
(* Display Attack stat *)
procedure updateAttack;
(* Display Defence stat *)
procedure updateDefence;
(* Write text to the message log *)
procedure displayMessage(message: string);
(* Store all messages from players turn *)
procedure bufferMessage(message: string);
(* Write buffered message to the message log *)
procedure writeBufferedMessages;

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

procedure exitMessage;
begin
  ClrScr;
  {$IfDef DEBUG}
  writeln('Random seed: ' + IntToStr(RandSeed));
  {$EndIf}
  writeln('Axes, Armour & Ale - Chris Hawkins');
end;

procedure updateWeapon(weaponName: shortstring);
begin

end;

procedure updateArmour(armourName: shortstring);
begin

end;

procedure displayStatusEffect(onoff: byte; effectType: shortstring);
begin
  { TODO -cui : Insert status effect in sidebar }
end;

procedure updateXP;
begin
  (* Paint over previous stats *)
  TextOut(82, 5, 'black', '    ');
  (* Write Experience points *)
  TextOut(82, 5, 'red', '20');
end;

procedure updateHealth;
var
  healthPercentage: smallint;
begin
  (* Paint over previous stats *)
  TextOut(78, 6, 'black', '      ');
  TextOut(70, 7, 'black', '                ');
  (* Draw Health amount *)
  TextOut(78, 6, 'cyan', IntToStr(entities.entityList[0].currentHP) + ' / ' +
    IntToStr(entities.entityList[0].maxHP));
  (* Draw health bar *)

  (* Calculate percentage of total health *)
   { TODO -cui : calculate length of health bar }
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

procedure displayMessage(message: string);
begin
  { TODO -cui : All message handling routines need to be implemented }
end;

procedure bufferMessage(message: string);
begin

end;

procedure writeBufferedMessages;
begin

end;

end.
