(* Axes, Armour & Ale - Roguelike for Linux and Windows.
   @author (Chris Hawkins)
*)

unit main;

{$mode objfpc}{$H+}
{$IFOPT D+} {$DEFINE DEBUG} {$ENDIF}

interface

uses
  Video, SysUtils, KeyboardInput, ui, camera, map, scrGame, globalUtils,
  universe
  {$IFDEF DEBUG}, logging
  {$ENDIF};

type
  gameStatus = (stTitle, stGame, stInventory, stQuitMenu, stGameOver);

var
  (* State machine for game menus / controls *)
  gameState: gameStatus;

procedure setSeed;
procedure initialise;
procedure exitApplication;
procedure newGame;
procedure gameLoop;

implementation

uses
  entities;

procedure setSeed;
begin
  {$IFDEF Linux}
  RandSeed := RandSeed shl 8;
  {$ENDIF}
  {$IFDEF Windows}
  RandSeed := ((RandSeed shl 8) or GetProcessID);
  {$ENDIF}
end;

procedure initialise;
begin
  gameState := stTitle;
  Randomize;
  { Check if seed set as command line parameter }
  if (ParamCount = 2) then
  begin
    if (ParamStr(1) = '--seed') then
      RandSeed := StrToDWord(ParamStr(2))
    else
    begin
      { Set random seed if not specified }
      setSeed;
    end;
  end
  else
    setSeed;

  (* Check for previous save file *)
  if (FileExists(globalUtils.saveDirectory + DirectorySeparator +
    globalutils.saveFile)) then
    { Initialise video unit and show title screen }
    ui.setupScreen(1)
  else
  begin
    try
      { create directory }
      CreateDir(globalUtils.saveDirectory);
    finally
      { Initialise video unit and show title screen }
      ui.setupScreen(0);
    end;
  end;
  { Initialise keyboard unit }
  keyboardinput.setupKeyboard;
  { Begin log file }
  {$IFDEF DEBUG}
  logging.beginLogging;
  {$ENDIF}
  { wait for keyboard input }
  keyboardinput.waitForInput;
end;

procedure exitApplication;
begin
  gameState := stGameOver;
  { Shutdown keyboard unit }
  keyboardinput.shutdownKeyboard;
  { Shutdown video unit }
  ui.shutdownScreen;
  (* Clear screen and display author message *)
  ui.exitMessage;
  Halt;
end;

procedure newGame;
begin
  (* Game state = game running *)
  gameState := stGame;
  playerTurn := 0;
  (* Initialise the game world and create 1st cave *)
  universe.dlistLength := 0;
  (* first map type is always a cave *)
  map.mapType := 2;
  {$IFDEF DEBUG}
  { Logging }
  logging.logAction('>reached main.NewGame');
  logging.logAction(' Creating new dungeon of type ' + IntToStr(map.mapType));
  {$ENDIF}
  (* map type is a cave with tunnels *)
  universe.createNewDungeon(map.mapType);
  (* Spawn game entities *)
  entities.spawnNPCs;

  { prepare changes to the screen }
  LockScreenUpdate;
  (* Clear the screen *)
  ui.screenBlank;
  (* Draw the game screen *)
  scrGame.displayGameScreen;

  (* draw map through the camera *)
  camera.drawMap;
  ui.displayMessage('Welcome message here...');
  { Write those changes to the screen }
  UnlockScreenUpdate;
  { only redraws the parts that have been updated }
  UpdateScreen(False);
end;

procedure gameLoop;
begin
  { prepare changes to the screen }
  LockScreenUpdate;

  (* BEGIN DRAWING TO THE BUFFER *)

  (* draw map through the camera *)
  camera.drawMap;

  (* FINISH DRAWING TO THE BUFFER *)

  { Write those changes to the screen }
  UnlockScreenUpdate;
  { only redraws the parts that have been updated }
  UpdateScreen(False);
  {$IFDEF DEBUG}
  logAction('- Player coordinates are, X: ' + IntToStr(entityList[0].posX) +
    ' Y:' + IntToStr(entityList[0].posY));
  {$ENDIF}
end;

end.
