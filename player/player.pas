(* Player setup and stats *)

unit player;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, fov;

type
  (* Store information about the player *)
  Creature = record
    currentHP, maxHP, attack, defence, posX, posY, visionRange: smallint;
    experience: integer;
    playerName, title: string;
    (* status effects *)
    stsDrunk, stsPoison: boolean;
    (* status timers *)
    tmrDrunk, tmrPoison: smallint;
  end;

(* Create player character *)
procedure createPlayer;
(* Moves the player on the map *)
procedure movePlayer(dir: word);
(* Attack NPC *)
procedure combat(npcID: smallint);
(* Check if tile is occupied by an NPC *)
function combatCheck(x, y: smallint): boolean;

implementation

uses
  entities, globalUtils, map, ui, plot_gen;

procedure createPlayer;
begin
  plot_gen.generateName;
  (* Add Player to the list of creatures *)
  entities.listLength := length(entities.entityList);
  SetLength(entities.entityList, entities.listLength + 1);
  with entities.entityList[0] do
  begin
    npcID := 0;
    race := plot_gen.playerName;
    description := 'your character';
    glyph := '@';
    glyphColour := 'yellow';
    maxHP := 20;
    currentHP := 20;
    attack := 5;
    defence := 2;
    weaponDice := 0;
    weaponAdds := 0;
    xpReward := 0;
    visionRange := 4;
    NPCsize := 3;
    trackingTurns := 3;
    moveCount := 0;
    targetX := 0;
    targetY := 0;
    inView := True;
    discovered := True;
    weaponEquipped := False;
    armourEquipped := False;
    isDead := False;
    abilityTriggered := False;
    stsDrunk := False;
    stsPoison := False;
    tmrDrunk := 0;
    tmrPoison := 0;
    posX := map.startX;
    posY := map.startY;
  end;
  (* Occupy tile *)
  map.occupy(entityList[0].posX, entityList[0].posY);
  (* set up inventory *)

  (* Draw player and FOV *)
  fov.fieldOfView(entityList[0].posX, entityList[0].posY, entityList[0].visionRange, 1);
end;

(* Move the player within the confines of the game map *)
procedure movePlayer(dir: word);
var
  (* store original values in case player cannot move *)
  originalX, originalY: smallint;
begin
  (* Unoccupy tile *)
  map.unoccupy(entityList[0].posX, entityList[0].posY);
  (* Repaint visited tiles *)
  fov.fieldOfView(entities.entityList[0].posX, entities.entityList[0].posY,
    entities.entityList[0].visionRange, 0);
  originalX := entities.entityList[0].posX;
  originalY := entities.entityList[0].posY;
  case dir of
    1: Dec(entities.entityList[0].posY); // N
    2: Dec(entities.entityList[0].posX); // W
    3: Inc(entities.entityList[0].posY); // S
    4: Inc(entities.entityList[0].posX); // E
    5:                      // NE
    begin
      Inc(entities.entityList[0].posX);
      Dec(entities.entityList[0].posY);
    end;
    6:                      // SE
    begin
      Inc(entities.entityList[0].posX);
      Inc(entities.entityList[0].posY);
    end;
    7:                      // SW
    begin
      Dec(entities.entityList[0].posX);
      Inc(entities.entityList[0].posY);
    end;
    8:                      // NW
    begin
      Dec(entities.entityList[0].posX);
      Dec(entities.entityList[0].posY);
    end;
  end;
  (* check if tile is occupied *)
  if (map.isOccupied(entities.entityList[0].posX, entities.entityList[0].posY) =
    True) then
    (* check if tile is occupied by hostile NPC *)
    if (combatCheck(entities.entityList[0].posX, entities.entityList[0].posY) =
      True) then
    begin
      entities.entityList[0].posX := originalX;
      entities.entityList[0].posY := originalY;
    end;
  Inc(playerTurn);
  (* check if tile is walkable *)
  if (map.canMove(entities.entityList[0].posX, entities.entityList[0].posY) = False) then
  begin
    entities.entityList[0].posX := originalX;
    entities.entityList[0].posY := originalY;
    ui.displayMessage('You bump into a wall');
    Dec(playerTurn);
  end;
  (* Occupy tile *)
  map.occupy(entityList[0].posX, entityList[0].posY);
  fov.fieldOfView(entities.entityList[0].posX, entities.entityList[0].posY,
    entities.entityList[0].visionRange, 1);
  ui.writeBufferedMessages;
end;

procedure combat(npcID: smallint);
begin

end;

function combatCheck(x, y: smallint): boolean;
var
  i: smallint;
begin
  Result := False;
  for i := 1 to entities.npcAmount do
  begin
    if (x = entities.entityList[i].posX) then
    begin
      if (y = entities.entityList[i].posY) then
        player.combat(i);
      Result := True;
    end;
  end;
end;

end.

