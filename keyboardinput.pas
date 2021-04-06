unit KeyboardInput;

{$mode fpc}{$H+}

interface

uses
  Keyboard;

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

(* 0 = titlescreen, 1 = game running, 2 = inventory screen, 3 = Quit menu, 4 = Game Over *)
procedure waitForInput;
var
  Keypress: TKeyEvent;
begin
  { Title menu }
  while gameState = 0 do
  begin
    Keypress := GetKeyEvent;
    Keypress := TranslateKeyEvent(Keypress);
    case GetKeyEventChar(Keypress) of
      'n': main.newGame;
      // 'l': continueGame;
      'q': main.exitApplication;
    end;
  end;
  { Gameplay controls }
  while gameState = 1 do
  begin
    Keypress := GetKeyEvent;
    Keypress := TranslateKeyEvent(Keypress);
    case GetKeyEventCode(Keypress) of
      kbdLeft:
      begin
        Dec(main.playerX);
        main.gameLoop;
      end;
      kbdRight:
      begin
        Inc(main.playerX);
        main.gameLoop;
      end;
      kbdUp:
      begin
        Dec(main.playerY);
        main.gameLoop;
      end;
      KbdDown:
      begin
        Inc(main.playerY);
        main.gameLoop;
      end;
    end;

  end;
end;

end.
