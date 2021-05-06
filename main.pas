(* Axes, Armour & Ale - Roguelike for Linux and Windows.
   @author (Chris Hawkins)
*)

unit main;

{$mode objfpc}{$H+}
{$IFOPT D+} {$DEFINE DEBUG} {$ENDIF}

interface

uses
  Video, SysUtils, KeyboardInput, ui, camera, map, scrGame, globalUtils,
  universe, fov
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
  entities, items;

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
  killer := 'empty';
  (* Initialise the game world and create 1st cave *)
  universe.dlistLength := 0;
  (* first map type is always a cave *)
  map.mapType := tCave;
  (* map type is a cave with tunnels *)
  universe.createNewDungeon(map.mapType);
  (* Create the Player *)
  entities.spawnPlayer;
  (* Spawn game entities *)
  universe.spawnDenizens;
  (* Drop items *)
  items.initialiseItems;

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
var
  i: byte;
begin
  (* move NPC's *)
  entities.NPCgameLoop;
  (* Draw player and FOV *)
  fov.fieldOfView(entityList[0].posX, entityList[0].posY, entityList[0].visionRange, 1);
  (* Redraw all NPC'S *)
  for i := 1 to entities.npcAmount do
    entities.redrawMapDisplay(i);

  (* Redraw all items *)
  for i := 1 to items.itemAmount do
    if (map.canSee(items.itemList[i].posX, items.itemList[i].posY) = True) then
    begin
      items.itemList[i].inView := True;
      items.drawItemsOnMap(i);
      (* Display a message if this is the first time seeing this item *)
      if (items.itemList[i].discovered = False) then
      begin
        ui.displayMessage('You see a ' + items.itemList[i].itemName);
        items.itemList[i].discovered := True;
      end;
    end
    else
    begin
      items.itemList[i].inView := False;
      map.drawTile(itemList[i].posX, itemList[i].posY, 0);
    end;

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


  entities.occupyUpdate;
  (* Update health display to show damage *)
  ui.updateHealth;
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
end;

end.
