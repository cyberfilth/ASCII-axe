unit KeyboardInput;

{$mode fpc}{$H+}

interface

uses
  Keyboard, player, player_inventory, map;

(* Initialise keyboard unit *)
procedure setupKeyboard;
(* Shutdown keyboard unit *)
procedure shutdownKeyboard;
(* Take input from player *)
procedure waitForInput;

implementation

uses
  main, ui;

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
  { ---------------------------------   Title menu }
  while gameState = stTitle do
  begin
    Keypress := GetKeyEvent;
    Keypress := TranslateKeyEvent(Keypress);
    case GetKeyEventChar(Keypress) of
      'n': main.newGame;
      // 'l': continueGame;
      'q': main.exitApplication;
    end;
  end;
  { Prompt to quit game }
  while gameState = stQuitMenu do
  begin
    Keypress := GetKeyEvent;
    Keypress := TranslateKeyEvent(Keypress);
    case GetKeyEventChar(Keypress) of
      'q', 'Q': { quit }
      begin
        main.exitApplication;
      end;
      'x', 'X':
      begin
        gameState := stGame;
      end;
      #27: { Escape key - Cancel }
      begin
        gameState := stGame;
        main.returnToGameScreen;
      end;
    end;
  end;

  { ---------------------------------    In the Inventory menu }
  while gameState = stInventory do
  begin
    Keypress := GetKeyEvent;
    Keypress := TranslateKeyEvent(Keypress);
    case GetKeyEventChar(Keypress) of
      'D': ;//main.newGame;
      'x', 'X': { Exit menu }
      begin
        gameState := stGame;
        main.returnToGameScreen;
      end;
    end;
  end;

  { ---------------------------------    Gameplay controls }
  while gameState = stGame do
  begin
    Keypress := GetKeyEvent;
    Keypress := TranslateKeyEvent(Keypress);
    { Arrow keys }
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
    { Numpad and VI keys }
    case GetKeyEventChar(Keypress) of
      '8', 'k', 'K': { N }
      begin
        player.movePlayer(1);
        main.gameLoop;
      end;
      '9', 'u', 'U': { NE }
      begin
        player.movePlayer(5);
        main.gameLoop;
      end;
      '6', 'l', 'L': { E }
      begin
        player.movePlayer(4);
        main.gameLoop;
      end;
      '3', 'n', 'N': { SE }
      begin
        player.movePlayer(6);
        main.gameLoop;
      end;
      '2', 'j', 'J': { S }
      begin
        player.movePlayer(3);
        main.gameLoop;
      end;
      '1', 'b', 'B': { SW }
      begin
        player.movePlayer(7);
        main.gameLoop;
      end;
      '4', 'h', 'H': { W }
      begin
        player.movePlayer(2);
        main.gameLoop;
      end;
      '7', 'y', 'Y': { NW }
      begin
        player.movePlayer(8);
        main.gameLoop;
      end;
      '<': { Go up the stairs }
      begin
        map.ascendStairs;
        main.gameLoop;
      end;
      '>': { Go down the stairs }
      begin
        map.descendStairs;
        main.gameLoop;
      end;
      'i', 'I': { Inventory }
      begin
        main.gameState := stInventory;
        player_inventory.showInventory;
      end;
      ',','g','G': { Get item }
      begin
        player.pickUp;
        main.gameLoop;
      end;
      #27: { Escape key - Quit }
      begin
        gameState := stQuitMenu;
        ui.exitPrompt;
      end;
    end;
  end;
end;

end.
