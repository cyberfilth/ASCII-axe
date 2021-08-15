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
  if (playerLevel = 1) and (entityList[0].xpReward >= 100) then
    showLevelUpOptions
  else if (playerLevel = 2) and (entityList[0].xpReward >= 250) then
    showLevelUpOptions
  else if (playerLevel = 3) and (entityList[0].xpReward >= 450) then
    showLevelUpOptions
  else if (playerLevel = 4) and (entityList[0].xpReward >= 700) then
    showLevelUpOptions
  else if (playerLevel = 5) and (entityList[0].xpReward >= 1000) then
    showLevelUpOptions
  else if (playerLevel = 6) and (entityList[0].xpReward >= 1350) then
    showLevelUpOptions
  else if (playerLevel = 7) and (entityList[0].xpReward >= 1750) then
    showLevelUpOptions
  else if (playerLevel = 8) and (entityList[0].xpReward >= 2200) then
    showLevelUpOptions
  else if (playerLevel = 9) and (entityList[0].xpReward >= 2700) then
    showLevelUpOptions
  else if (playerLevel = 10) and (entityList[0].xpReward >= 3250) then
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

