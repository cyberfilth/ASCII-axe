(* User Interface - Unit responsible for displaying messages and screens *)

unit ui;

{$mode fpc}{$H+}

interface

uses
  SysUtils, video, keyboard, scrTitle, globalutils,
  {$IFDEF WINDOWS}
  JwaWinCon, {$ENDIF}
  (* CRT unit is just to clear the screen on exit *)
  Crt;

var
  vid: TVideoMode;
  x, y: smallint;
  messageArray: array[1..7] of string = (' ', ' ', ' ', ' ', ' ', ' ', ' ');
  buffer: string;

(* Write to the screen *)
procedure TextOut(X, Y: word; textcol: shortstring; const S: string);
(* Blank the screen *)
procedure screenBlank;
(* Clear the map when moving between floors *)
procedure clearMap;
(* Initialise the video unit *)
procedure setupScreen(yn: byte);
(* Shutdown the video unit *)
procedure shutdownScreen;
(* Write text to the message log *)
procedure displayMessage(message: string);
(* Store all messages from players turn *)
procedure bufferMessage(message: string);
(* Write buffered message to the message log *)
procedure writeBufferedMessages;
(* Update Experience points display *)
procedure updateXP;
(* Update player health display *)
procedure updateHealth;
(* Update player attack value *)
procedure updateAttack;
(* Update player defence value *)
procedure updateDefence;
(* Display Quit Game confirmation *)
procedure exitPrompt;
(* Clears the status bar message *)
procedure clearStatusBar;
(* Clear screen and write exit message *)
procedure exitMessage;

implementation

uses
  entities, KeyboardInput, map;

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
    'grey': tint := $07;
    'darkGrey': tint := $08;
    'brownBlock': tint := $66;
    'lightCyan': tint := LightCyan;
    'yellow': tint := Yellow;
    'lightGrey': tint := LightGray;
    'white': tint := White;
    'DgreyBGblack': tint := $80;
    'LgreyBGblack': tint := $70;
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

procedure screenBlank;
begin
  for y := 1 to 25 do
  begin
    for x := 1 to 80 do
    begin
      TextOut(x, y, 'black', ' ');
    end;
  end;
end;

procedure clearMap;
begin
  (* prepare changes to the screen *)
  LockScreenUpdate;
  (* set up the dungeon tiles *)
  for r := 1 to globalUtils.MAXROWS do
  begin
    for c := 1 to globalUtils.MAXCOLUMNS do
    begin
      with maparea[r][c] do
      begin
        Visible := False;
        Discovered := False;
      end;
      drawTile(c, r, 0);
    end;
  end;
  (* Write those changes to the screen *)
  UnlockScreenUpdate;
  (* only redraws the parts that have been updated *)
  UpdateScreen(False);
end;

procedure setupScreen(yn: byte);
begin
  {$IFDEF WINDOWS}
  SetConsoleTitle('Axes, Armour & Ale');
  {$ENDIF}
  { Initialise the video unit }
  InitVideo;
  InitKeyboard;
  vid.Col := 80;
  vid.Row := 25;
  vid.Color := True;
  SetVideoMode(vid);
  SetCursorType(crHidden);
  ClearScreen;
  (* prepare changes to the screen *)
  LockScreenUpdate;
  scrtitle.displayTitleScreen(yn);
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

procedure displayMessage(message: string);
begin
  (* Catch duplicate messages *)
  if (message = messageArray[1]) then
  begin
    (* Clear first line *)
    for x := 1 to 57 do
    begin
      TextOut(x, 21, 'black', ' ');
    end;
    messageArray[1] := messageArray[1] + ' x2';
    TextOut(1, 21, 'white', messageArray[1]);
  end
  else
  begin
    (* Clear the message window *)
    for y := 21 to 25 do
    begin
      for x := 1 to 57 do
      begin
        TextOut(x, y, 'black', ' ');
      end;
    end;
    (* Shift all messages down one in the array *)
    messageArray[7] := messageArray[6];
    messageArray[6] := messageArray[5];
    messageArray[5] := messageArray[4];
    messageArray[4] := messageArray[3];
    messageArray[3] := messageArray[2];
    messageArray[2] := messageArray[1];
    messageArray[1] := message;
    (* Display each line, gradually getting darker *)
    TextOut(1, 21, 'white', messageArray[1]);
    TextOut(1, 22, 'lightGrey', messageArray[2]);
    TextOut(1, 23, 'grey', messageArray[3]);
    TextOut(1, 24, 'darkGrey', messageArray[4]);
    TextOut(1, 25, 'darkGrey', messageArray[5]);
  end;
end;

{ TODO : If buffered message is longer than a certain length, flush the buffer with writeBuffer procedure }
procedure bufferMessage(message: string);
begin
  buffer := buffer + message + '. ';
end;

procedure writeBufferedMessages;
begin
  if (buffer <> '') then
    displayMessage(buffer);
  buffer := '';
end;

procedure updateXP;
begin
  (* Paint over previous stats *)
  TextOut(72, 5, 'black', Chr(219) + Chr(219) + Chr(219) + Chr(219) +
    Chr(219) + Chr(219) + Chr(219));
  (* Write out XP amount *)
  TextOut(72, 5, 'cyan', IntToStr(entities.entityList[0].xpReward));
end;

procedure updateHealth;
var
  healthPercentage, bars, i: byte;
begin
  (* Paint over previous stats *)
  TextOut(68, 6, 'black', Chr(219) + Chr(219) + Chr(219) + Chr(219) +
    Chr(219) + Chr(219) + Chr(219) + Chr(219) + Chr(219) + Chr(219) +
    Chr(219) + Chr(219));
  (* Write stats *)
  TextOut(68, 6, 'cyan', IntToStr(entities.entityList[0].currentHP) +
    '/' + IntToStr(entities.entityList[0].maxHP));
  (* Paint over health bar *)
  TextOut(60, 7, 'black', Chr(223) + Chr(223) + Chr(223) + Chr(223) +
    Chr(223) + Chr(223) + Chr(223) + Chr(223) + Chr(223) + Chr(223) +
    Chr(223) + Chr(223) + Chr(223) + Chr(223) + Chr(223) + Chr(223));
  (* Length of health bar *)
  bars := 0;
  (* Calculate percentage of total health *)
  healthPercentage :=
    (entities.entityList[0].currentHP * 100) div entities.entityList[0].maxHP;
  (* Calculate the length of the health bar *)
  if (healthPercentage <= 6) then
    bars := 1
  else if (healthPercentage > 6) and (healthPercentage <= 12) then
    bars := 2
  else if (healthPercentage > 12) and (healthPercentage <= 18) then
    bars := 3
  else if (healthPercentage > 18) and (healthPercentage < 25) then
    bars := 4
  else if (healthPercentage >= 25) and (healthPercentage <= 31) then
    bars := 5
  else if (healthPercentage > 31) and (healthPercentage <= 37) then
    bars := 6
  else if (healthPercentage > 37) and (healthPercentage <= 43) then
    bars := 7
  else if (healthPercentage > 43) and (healthPercentage < 50) then
    bars := 8
  else if (healthPercentage >= 50) and (healthPercentage <= 56) then
    bars := 9
  else if (healthPercentage > 56) and (healthPercentage <= 62) then
    bars := 10
  else if (healthPercentage > 62) and (healthPercentage <= 68) then
    bars := 11
  else if (healthPercentage > 68) and (healthPercentage < 75) then
    bars := 12
  else if (healthPercentage >= 75) and (healthPercentage <= 81) then
    bars := 13
  else if (healthPercentage > 81) and (healthPercentage <= 87) then
    bars := 14
  else if (healthPercentage > 87) and (healthPercentage <= 94) then
    bars := 15
  else if (healthPercentage > 94) then
    bars := 16;
  (* Draw health bar *)
  for i := 1 to bars do
    TextOut(59 + i, 7, 'green', Chr(223));
end;

procedure updateAttack;
begin
  (* Paint over previous stats *)
  TextOut(68, 8, 'black', Chr(219) + Chr(219) + Chr(219) + Chr(219) +
    Chr(219) + Chr(219) + Chr(219) + Chr(219) + Chr(219) + Chr(219) +
    Chr(219) + Chr(219));
  (* Write out XP amount *)
  TextOut(68, 8, 'cyan', IntToStr(entities.entityList[0].attack));
end;

procedure updateDefence;
begin
  (* Paint over previous stats *)
  TextOut(69, 9, 'black', Chr(219) + Chr(219) + Chr(219) + Chr(219) +
    Chr(219) + Chr(219) + Chr(219) + Chr(219) + Chr(219) + Chr(219) + Chr(219));
  (* Write out XP amount *)
  TextOut(69, 9, 'cyan', IntToStr(entities.entityList[0].defence));
end;

procedure exitPrompt;
begin
  (* prepare changes to the screen *)
  LockScreenUpdate;
  TextOut(1, 20, 'LgreyBGblack',
    ' [Q]-Quit game  [X]-Exit to menu  [ESC]-Return to game  ');
  (* Write those changes to the screen *)
  UnlockScreenUpdate;
  (* only redraws the parts that have been updated *)
  UpdateScreen(False);
  KeyboardInput.waitForInput;
end;

procedure clearStatusBar;
begin
  (* prepare changes to the screen *)
  LockScreenUpdate;
  TextOut(1, 20, 'black', '                                                        ');
  (* Write those changes to the screen *)
  UnlockScreenUpdate;
  (* only redraws the parts that have been updated *)
  UpdateScreen(False);
  KeyboardInput.waitForInput;
end;

procedure exitMessage;
begin
  ClrScr;
  writeln('Random seed: ' + IntToStr(RandSeed));
  writeln('Axes, Armour & Ale - Chris Hawkins');
end;

end.
