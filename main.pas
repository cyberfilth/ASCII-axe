unit main;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, ui, globalutils, Keyboard, keyboardinput, map;

var
  (* 0 = titlescreen, 1 = game running, 2 = inventory screen, 3 = Quit menu, 4 = Game Over *)
  gameState: byte;
  saveGameExists: boolean;

procedure initialise;
procedure newGame;
procedure exitApplication;

implementation

procedure initialise;
begin
  gameState := 0;
  saveGameExists := False;
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
  keyboardinput.waitForInput;
end;


procedure newGame;
begin
  (* Title menu *)
  gameState := 1;
  (* No player-kiler set *)
  globalutils.killer := 'empty';
  (* Number of player turns set to zero *)
  globalutils.playerTurn := 0;
  (* first map is number 2, a cave *)
  map.mapType := 2;
  universe.createNewDungeon(2, map.mapType);
  (* Copy first dungeon to game map *)
  map.setupMap;

 // no items created yet

 (* Spawn game entities *)
  entities.spawnNPCs;
end;

procedure exitApplication;
begin
  { Shutdown keyboard unit }
  keyboardinput.shutdownKeyboard;
  { Shutdown video unit }
  ui.shutdownScreen;
  (* Clear screen and display author message *)
  ui.exitMessage;
  Halt;
end;

end.

