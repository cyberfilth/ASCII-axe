(* Axes, Armour & Ale - Roguelike for Linux and Windows.
   @author (Chris Hawkins)
*)

unit main;

{$mode fpc}{$H+}

interface

uses
  ui, Video, SysUtils, KeyboardInput, camera, map, scrGame, globalUtils;

var
  (* 0 = titlescreen, 1 = game running, 2 = inventory screen, 3 = Quit menu, 4 = Game Over *)
  gameState: byte;


procedure initialise;
procedure exitApplication;
procedure newGame;
procedure gameLoop;

implementation

uses
  entities;

procedure initialise;
begin
  gameState := 0;
  Randomize;
  { Check if seed set as command line parameter }
  if (ParamCount = 2) then
  begin
    if (ParamStr(1) = '--seed') then
      RandSeed := StrToDWord(ParamStr(2))
    else
    begin
      { Set random seed if not specified }
      {$IFDEF Linux}
      RandSeed := RandSeed shl 8;
      {$ENDIF}
      {$IFDEF Windows}
      RandSeed := ((RandSeed shl 8) or GetProcessID);
      {$ENDIF}
    end;
  end;
  { Initialise video unit and show title screen }
  ui.setupScreen;
  { Initialise keyboard unit }
  keyboardinput.setupKeyboard;
  { wait for keyboard input }
  keyboardinput.waitForInput;
end;

procedure exitApplication;
begin
  { Shutdown keyboard unit }
  keyboardinput.shutdownKeyboard;
  { Shutdown video unit }
  ui.shutdownScreen;
  (* Clear screen and display author message *)
  //ui.exitMessage;
  Halt;
end;

procedure newGame;
begin
  (* Game state = game running *)
  gameState := 1;
  playerTurn := 0;
  (* first map is number 2, a cave *)
  map.mapType := 2;
  map.setupMap;
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

  (* Redraw Field of View after entities move *)
  //fov.fieldOfView(entityList[0].posX, entityList[0].posY, entityList[0].visionRange, 1);

  (* draw map through the camera *)
  camera.drawMap;

  (* FINISH DRAWING TO THE BUFFER *)

  { Write those changes to the screen }
  UnlockScreenUpdate;
  { only redraws the parts that have been updated }
  UpdateScreen(False);
end;

end.

