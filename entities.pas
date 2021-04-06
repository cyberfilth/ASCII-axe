(* NPC stats and setup *)

unit entities;

{$mode fpc}{$H+}
{$ModeSwitch advancedrecords}
{$RANGECHECKS OFF}

interface

uses
  SysUtils, map, globalUtils, ui;

type
  (* Store information about NPC's *)

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
    (* Colour of the glyph *)
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


implementation

uses
  player;

procedure spawnNPCs;
var
  i, r, c, percentage: smallint;
begin
   npcAmount := 1; //(universe.dungeonList[0].totalRooms[1] + 2);
  (*  initialise array *)
  SetLength(entityList, 0);
  (* Add the player to Entity list *)
  player.createPlayer;

end;

{ Creature }

procedure Creature.entityTakeTurn(i: smallint);
begin

end;

end.

