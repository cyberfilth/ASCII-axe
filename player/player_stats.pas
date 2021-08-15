(* Additional player stats that are not shared with other entities are stored here *)

unit player_stats;

{$mode fpc}{$H+}

interface

uses
  SysUtils, video;

var
  playerLevel: smallint;

(* Check if the player has levelled up *)
procedure checkLevel;
(* Show level up dialog *)
procedure showLevelUpOptions;

implementation

uses
  ui, entities, main;

procedure checkLevel;
begin
  if (playerLevel = 1) and (entityList[0].xpReward >= 2) then
    showLevelUpOptions;
end;

procedure showLevelUpOptions;
begin
  main.gameState := stDialogLevel;
  { prepare changes to the screen }
  LockScreenUpdate;
  ui.displayDialog('level', IntToStr(playerLevel + 1));
  Inc(playerLevel);
  ui.updateLevel;
  { Write those changes to the screen }
  UnlockScreenUpdate;
  { only redraws the parts that have been updated }
  UpdateScreen(False);
end;

end.

