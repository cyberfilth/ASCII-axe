unit keyboardinput;

{$mode objfpc}{$H+}

interface

(* Initialise keyboard unit *)
procedure setupKeyboard;
(* Shutdown keyboard unit *)
procedure shutdownKeyboard;
(* Take input from player *)
procedure waitForInput;

implementation

uses
  main;

procedure setupKeyboard;
begin
  InitKeyboard;
end;

procedure shutdownKeyboard;
begin
  DoneKeyBoard;
end;

procedure waitForInput;
var
  Keypress: TKeyEvent;
begin
  Keypress := GetKeyEvent;
  Keypress := TranslateKeyEvent(Keypress);
  if (gameState = 0) then
  begin // beginning of Title menu
    case GetKeyEventChar(Keypress) of
      'n': ;//newGame;
      'l': ;//continueGame;
      'q': main.exitApplication;
    end; // end of title menu screen
  end;
end;

end.

