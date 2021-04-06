(* User Interface - Unit responsible for displaying messages and screens *)

unit ui;

{$mode fpc}{$H+}

interface

uses
  SysUtils, video, keyboard, scrTitle,
  {$IFDEF WINDOWS}
  JwaWinCon {$ENDIF}  ;

var
  vid: TVideoMode;
  x, y: smallint;
  messageArray: array[1..7] of string = (' ', ' ', ' ', ' ', ' ', ' ', ' ');
  buffer: string;

(* Write to the screen *)
procedure TextOut(X, Y: word; textcol: shortstring; const S: string);
(* Blank the screen *)
procedure screenBlank;
(* Initialise the video unit *)
procedure setupScreen;
(* Shutdown the video unit *)
procedure shutdownScreen;
(* Write text to the message log *)
procedure displayMessage(message: string);
(* Store all messages from players turn *)
procedure bufferMessage(message: string);
(* Write buffered message to the message log *)
procedure writeBufferedMessages;

implementation

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
    'darkgrey': tint := $08;
    'brownBlock': tint := $66;
    'lightCyan': tint := LightCyan;
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
  for y := 1 to 67 do
  begin
    for x := 1 to 91 do
    begin
      TextOut(x, y, 'black', ' ');
    end;
  end;
end;

procedure setupScreen;
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
    TextOut(1, 22, 'lightCyan', messageArray[2]);
    TextOut(1, 23, 'cyan', messageArray[3]);
    TextOut(1, 24, 'cyan', messageArray[4]);
    TextOut(1, 25, 'blue', messageArray[5]);
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

end.
