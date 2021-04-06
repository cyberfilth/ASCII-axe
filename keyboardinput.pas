unit KeyboardInput;

{$mode fpc}{$H+}

interface

uses
  Keyboard, player;

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
        player.movePlayer(2);
        main.gameLoop;
      end;
      kbdRight:
      begin
        player.movePlayer(4);
        main.gameLoop;
      end;
      kbdUp:
      begin
        player.movePlayer(1);
        main.gameLoop;
      end;
      KbdDown:
      begin
        player.movePlayer(3);
        main.gameLoop;
      end;
    end;

  end;
end;

end.
