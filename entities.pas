(* Player / NPC stats and setup *)

unit entities;

{$mode objfpc}{$H+}
{$ModeSwitch advancedrecords}
{$RANGECHECKS OFF}

interface

uses
  SysUtils, map, globalutils, universe, ui;

type
  { Creature }

  Creature = record
    (* Unique ID *)
    npcID: smallint;
    (* Creature type *)
    race: shortstring;
    (* Description of creature *)
    description: string;
    (* health and position on game map *)
    currentHP, maxHP, attack, defense, posX, posY, targetX, targetY,
    xpReward, visionRange: smallint;
    (* Weapon stats *)
    weaponDice, weaponAdds: smallint;
    (* Character used to represent NPC on game map *)
    glyph: char;
    (* Colour of character, used in ASCII *)
    glyphColour: shortstring;
    (* Size of NPC *)
    NPCsize: smallint;
    (* Number of turns the entity will track the player when they're out of sight *)
    trackingTurns: smallint;
    (* Count of turns the entity will keep tracking the player when they're out of sight *)
    moveCount: smallint;
    (* Is the NPC in the players FoV *)
    inView: boolean;
    (* First time the player discovers the NPC *)
    discovered: boolean;
    (* Some entities block movement, i.e. barrels *)
    blocks: boolean;
    (* Is a weapon equipped *)
    weaponEquipped: boolean;
    (* Is Armour equipped *)
    armourEquipped: boolean;
    (* Has the NPC been killed, to be removed at end of game loop *)
    isDead: boolean;
    (* Whether a special ability has been activated *)
    abilityTriggered: boolean;
    (* status effects *)
    stsDrunk, stsPoison: boolean;
    (* status timers *)
    tmrDrunk, tmrPoison: smallint;
    (* The procedure that allows each NPC to take a turn *)
    procedure entityTakeTurn(i: smallint);
  end;

var
  entityList: array of Creature;
  npcAmount, listLength: smallint;

(* Generate list of creatures on the map *)
procedure spawnNPCs;
(* Handle death of NPC's *)
procedure killEntity(id: smallint);
(* Draw entity on screen *)
procedure drawEntity(c, r: smallint; glyph: char);
(* Update NPCs X, Y coordinates *)
procedure moveNPC(id, newX, newY: smallint);
(* Redraw all NPC's *)
procedure redrawNPC;
(* Get creature currentHP at coordinates *)
function getCreatureHP(x, y: smallint): smallint;
(* Get creature maxHP at coordinates *)
function getCreatureMaxHP(x, y: smallint): smallint;
(* Get creature ID at coordinates *)
function getCreatureID(x, y: smallint): smallint;
(* Get creature name at coordinates *)
function getCreatureName(x, y: smallint): shortstring;
(* Check if creature is visible at coordinates *)
function isCreatureVisible(x, y: smallint): boolean;
(* Call Creatures.takeTurn procedure *)
procedure NPCgameLoop;

implementation

procedure spawnNPCs;
var
  i, r, c, percentage: smallint;
begin
  npcAmount := (universe.dungeonList[0].totalRooms[1] + 2);
  (*  initialise array *)
  SetLength(entityList, 0);
  (* Add player to Entity list *)
  player.createPlayer;
  (* Create the NPCs *)
  for i := 1 to npcAmount do
  begin
    (* Choose random location on the map *)
    repeat
      r := globalutils.randomRange(1, MAXROWS);
      c := globalutils.randomRange(1, MAXCOLUMNS);
      (* choose a location that is not a wall or occupied *)
    until (maparea[r][c].Blocks = False) and (maparea[r][c].Occupied = False);
    (* Roll for chance of each enemy type appearing *)
    percentage := randomRange(1, 100);
    if (percentage < 20) then
      barrel.createBarrel(i, c, r)
    else if (percentage >= 20) and (percentage <= 50) then // Cave rat
      cave_rat.createCaveRat(i, c, r)
    else if (percentage > 50) and (percentage <= 75) then // Cave bear
      cave_bear.createCaveBear(i, c, r)
    else if (percentage > 75) and (percentage <= 90) then // Blood hyena
      hyena.createHyena(i, c, r)
    else // Green fungus
      green_fungus.createGreenFungus(i, c, r);
  end;
end;

procedure killEntity(id: smallint);
begin

end;

procedure drawEntity(c, r: smallint; glyph: char);
begin

end;

procedure moveNPC(id, newX, newY: smallint);
begin

end;

procedure redrawNPC;
begin

end;

function getCreatureHP(x, y: smallint): smallint;
begin

end;

function getCreatureMaxHP(x, y: smallint): smallint;
begin

end;

function getCreatureID(x, y: smallint): smallint;
begin

end;

function getCreatureName(x, y: smallint): shortstring;
begin

end;

function isCreatureVisible(x, y: smallint): boolean;
begin

end;

procedure NPCgameLoop;
begin

end;

end.

