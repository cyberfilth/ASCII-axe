(* Player input for game controls and menu selections, grouped in procedures *)

unit KeyboardInput;

{$mode fpc}{$H+}

interface

uses
  Keyboard, player, player_inventory, map;

(* Initialise keyboard unit *)
procedure setupKeyboard;
(* Shutdown keyboard unit *)
procedure shutdownKeyboard;
(* Input in TITLE Menu state *)
procedure titleInput(Keypress: TKeyEvent);
(* Input for QUIT Menu state *)
procedure quitInput(Keypress: TKeyEvent);
(* Input in INVENTORY Menu state *)
procedure inventoryInput(Keypress: TKeyEvent);
(* Input in the DROP Menu state *)
procedure dropInput(Keypress: TKeyEvent);
(* Input in the QUAFF Menu state *)
procedure quaffInput(Keypress: TKeyEvent);
(* Input in the WEAR / WIELD Menu state *)
procedure wearWieldInput(Keypress: TKeyEvent);
(* Input in the GAME OVER state *)
procedure RIPInput(Keypress: TKeyEvent);
(* Input in the LEVEL UP state *)
procedure LevelUpInput(Keypress: TKeyEvent);
(* Input in GAME state *)
procedure gameInput(Keypress: TKeyEvent);

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

procedure titleInput(Keypress: TKeyEvent);
begin
  case GetKeyEventChar(Keypress) of
    'n': main.newGame;
    'l': { Load previously saved game }
    begin
      if (main.saveExists = True) then
        main.continue;
    end;
    'q': main.exitApplication;
  end;
end;

procedure quitInput(Keypress: TKeyEvent);
begin
  case GetKeyEventChar(Keypress) of
    'q', 'Q': { Save and Quit }
    begin
      main.exitApplication;
    end;
    'x', 'X': { Exit to main menu, quit without saving }
    begin
      { TODO : Add pop-up window }
    end;
    #27: { Escape key - Cancel }
    begin
      gameState := stGame;
      main.returnToGameScreen;
    end;
  end;
end;

procedure inventoryInput(Keypress: TKeyEvent);
begin
  case GetKeyEventChar(Keypress) of
    'D': { Drop menu }
    begin
      gameState := stDropMenu;
      player_inventory.drop;
    end;
    'Q': { Quaff menu }
    begin
      gameState := stQuaffMenu;
      player_inventory.quaff;
    end;
    'W': { Wear / Wield menu }
    begin
      gameState := stWearWield;
      player_inventory.wield('n');
    end;
    'x', 'X': { Exit menu }
    begin
      gameState := stGame;
      main.returnToGameScreen;
    end;
    { List of inventory slots }
    'a': player_inventory.examineInventory(0);
    'b': player_inventory.examineInventory(1);
    'c': player_inventory.examineInventory(2);
    'd': player_inventory.examineInventory(3);
    'e': player_inventory.examineInventory(4);
    'f': player_inventory.examineInventory(5);
    'g': player_inventory.examineInventory(6);
    'h': player_inventory.examineInventory(7);
    'i': player_inventory.examineInventory(8);
    'j': player_inventory.examineInventory(9);
  end;
end;

procedure dropInput(Keypress: TKeyEvent);
begin
  case GetKeyEventChar(Keypress) of
    'x', 'X': { Exit menu }
    begin
      gameState := stGame;
      main.returnToGameScreen;
    end;
    'Q': { Quaff menu }
    begin
      gameState := stQuaffMenu;
      player_inventory.quaff;
    end;
    'W': { Wear / Wield menu }
    begin
      gameState := stWearWield;
      player_inventory.wield('n');
    end;
    { List of inventory slots }
    'a': player_inventory.dropSelection(0);
    'b': player_inventory.dropSelection(1);
    'c': player_inventory.dropSelection(2);
    'd': player_inventory.dropSelection(3);
    'e': player_inventory.dropSelection(4);
    'f': player_inventory.dropSelection(5);
    'g': player_inventory.dropSelection(6);
    'h': player_inventory.dropSelection(7);
    'i': player_inventory.dropSelection(8);
    'j': player_inventory.dropSelection(9);
  end;
end;

procedure quaffInput(Keypress: TKeyEvent);
begin
  case GetKeyEventChar(Keypress) of
    'x', 'X': { Exit menu }
    begin
      gameState := stGame;
      main.returnToGameScreen;
    end;
    'D': { Drop menu }
    begin
      gameState := stDropMenu;
      player_inventory.drop;
    end;
    'W': { Wear / Wield menu }
    begin
      gameState := stWearWield;
      player_inventory.wield('n');
    end;
    { List of inventory slots }
    'a': player_inventory.quaffSelection(0);
    'b': player_inventory.quaffSelection(1);
    'c': player_inventory.quaffSelection(2);
    'd': player_inventory.quaffSelection(3);
    'e': player_inventory.quaffSelection(4);
    'f': player_inventory.quaffSelection(5);
    'g': player_inventory.quaffSelection(6);
    'h': player_inventory.quaffSelection(7);
    'i': player_inventory.quaffSelection(8);
    'j': player_inventory.quaffSelection(9);
  end;
end;

procedure wearWieldInput(Keypress: TKeyEvent);
begin
  case GetKeyEventChar(Keypress) of
    'x', 'X': { Exit menu }
    begin
      gameState := stGame;
      main.returnToGameScreen;
    end;
    'D': { Drop menu }
    begin
      gameState := stDropMenu;
      player_inventory.drop;
    end;
    'Q': { Quaff menu }
    begin
      gameState := stQuaffMenu;
      player_inventory.quaff;
    end;
    { List of inventory slots }
    'a': player_inventory.wearWieldSelection(0);
    'b': player_inventory.wearWieldSelection(1);
    'c': player_inventory.wearWieldSelection(2);
    'd': player_inventory.wearWieldSelection(3);
    'e': player_inventory.wearWieldSelection(4);
    'f': player_inventory.wearWieldSelection(5);
    'g': player_inventory.wearWieldSelection(6);
    'h': player_inventory.wearWieldSelection(7);
    'i': player_inventory.wearWieldSelection(8);
    'j': player_inventory.wearWieldSelection(9);
  end;
end;

procedure RIPInput(Keypress: TKeyEvent);
begin
  case GetKeyEventChar(Keypress) of
    'x', 'X': { Exit menu }
    begin
      main.exitApplication;
    end;
  end;
end;

procedure LevelUpInput(Keypress: TKeyEvent);
begin

end;

procedure gameInput(Keypress: TKeyEvent);
begin
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
    'd', 'D': { Drop menu }
    begin
      main.gameState := stDropMenu;
      player_inventory.drop;
    end;
    'q', 'Q': { Quaff menu }
    begin
      main.gameState := stQuaffMenu;
      player_inventory.quaff;
    end;
    'w', 'W': { Wear / Wield menu }
    begin
      gameState := stWearWield;
      player_inventory.wield('n');
    end;
    ',', 'g', 'G': { Get item }
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

end.
