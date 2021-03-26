unit main;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, ui, globalutils, Keyboard;

var
  (* 0 = titlescreen, 1 = game running, 2 = inventory screen, 3 = Quit menu, 4 = Game Over *)
  gameState: byte;
  saveGameExists: boolean;

procedure initialise;
procedure waitForInput;
procedure exitApplication;

implementation

procedure initialise;
begin
  gameState := 0;
  saveGameExists := False;
  Randomize;
  if (ParamCount = 2) then
  begin
    if (ParamStr(1) = '--seed') then
      RandSeed := StrToDWord(ParamStr(2))
    else
    begin
      (* Set random seed *)
      {$IFDEF Linux}
      RandSeed := RandSeed shl 8;
      {$ENDIF}
      {$IFDEF Windows}
      RandSeed := ((RandSeed shl 8) or GetProcessID);
      {$ENDIF}
    end;
  end;
  (* initialise display and show title screen *)
  ui.setupScreen;
  InitKeyboard;
  waitForInput;
end;

procedure waitForInput;
var
  Keypress: TKeyEvent;
begin
  Keypress := GetKeyEvent;
  Keypress := TranslateKeyEvent(K);
  if (gameState = 0) then
  begin // beginning of Title menu
    case GetKeyEventChar(Keypress) of
      'n': newGame;
      'l': continueGame;
      'q': exitApplication;
    end; // end of title menu screen
  end;
end;

procedure exitApplication;
begin
  DoneKeyBoard;
  { Shutdown video unit }
  ui.shutdownScreen;
  ui.exitMessage;
end;

end.

