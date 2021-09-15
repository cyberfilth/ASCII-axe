(* Unit responsible for NPC stat, initialising enemies and utility functions *)

unit entities;

{$mode objfpc}{$H+}
{$ModeSwitch advancedrecords}
{$RANGECHECKS OFF}

interface

uses
  SysUtils, ui, globalUtils,
  { List of creatures }
  cave_rat, giant_cave_rat, blood_bat, green_fungus, redcap_lesser, redcap_lesser_lobber;

type { NPC attitudes }
  Tattitudes = (stateNeutral, stateHostile, stateEscape);

type {NPC factions / groups }
  Tfactions = (redcapFaction, bluecapFaction, animalFaction, fungusFaction);

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
    currentHP, maxHP, attack, defence, posX, posY, targetX, targetY,
    xpReward, visionRange: smallint;
    (* Weapon stats *)
    weaponDice, weaponAdds: smallint;
    (* Character used to represent NPC on game map *)
    glyph: shortstring;
    (* Colour of the glyph *)
    glyphColour: shortstring;
    (* Count of turns the entity will keep tracking the player when they're out of sight *)
    moveCount: smallint;
    (* Is the NPC in the players FoV *)
    inView: boolean;
    (* First time the player discovers the NPC *)
    discovered: boolean;
    (* Some entities block movement, i.e. barrels *)
    blocks: boolean;
    (* NPC faction *)
    faction: Tfactions;
    (* NPC finite state *)
    state: Tattitudes;
    (* Is a weapon equipped *)
    weaponEquipped: boolean;
    (* Is Armour equipped *)
    armourEquipped: boolean;
    (* Has the NPC been killed, to be removed at end of game loop *)
    isDead: boolean;
    (* status effects *)
    stsDrunk, stsPoison: boolean;
    (* status timers *)
    tmrDrunk, tmrPoison: smallint;
    (* The procedure that allows each NPC to take a turn *)
    procedure entityTakeTurn(i: smallint);
  end;

var
  entityList: array of Creature;
  npcAmount, listLength: byte;

(* Add player to list of creatures on the map *)
procedure spawnPlayer;
(* Handle death of NPC's *)
procedure killEntity(id: smallint);
(* Update NPCs X, Y coordinates *)
procedure moveNPC(id, newX, newY: smallint);
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
(* Ensure all NPC's are correctly occupying tiles *)
procedure occupyUpdate;
(* Update the map display to show all NPC's *)
procedure redrawMapDisplay(id: byte);
(* Clear list of NPC's *)
procedure newFloorNPCs;
(* Count all living NPC's *)
function countLivingEntities: byte;
(* Call Creatures.takeTurn procedure *)
procedure NPCgameLoop;

implementation

uses
  player, map;

procedure spawnPlayer;
begin
  npcAmount := 1;
  (*  initialise array *)
  SetLength(entityList, 0);
  (* Add the player to Entity list *)
  player.createPlayer;
end;

procedure killEntity(id: smallint);

var
  i, amount, r, c: smallint;
begin
  entityList[id].isDead := True;
  entityList[id].glyph := '%';
  entityList[id].blocks := False;
  map.unoccupy(entityList[id].posX, entityList[id].posY);

  { Green Fungus }
  if (entityList[id].race = 'Green Fungus') then
    (* Attempt to spread spores *)
  begin
    (* Set a random number of spores *)
    amount := randomRange(0, 3);
    if (amount > 0) then
    begin
      for i := 1 to amount do
      begin
        (* Choose a space to place the fungus *)
        r := globalutils.randomRange(entityList[id].posY - 4,
          entityList[id].posY + 4);
        c := globalutils.randomRange(entityList[id].posX - 4,
          entityList[id].posX + 4);
        (* choose a location that is not a wall or occupied *)
        if (maparea[r][c].Blocks <> True) and (maparea[r][c].Occupied <> True) and
          (withinBounds(c, r) = True) then
        begin
          Inc(npcAmount);
          green_fungus.createGreenFungus(npcAmount, c, r);
        end;
      end;
      ui.writeBufferedMessages;
      ui.bufferMessage('The fungus releases spores into the air');
    end;
  end;
  { End of Green Fungus death }
end;


procedure moveNPC(id, newX, newY: smallint);
begin
  (* mark tile as unoccupied *)
  map.unoccupy(entityList[id].posX, entityList[id].posY);
  (* update new position *)
  if (map.isOccupied(newX, newY) = True) and (getCreatureID(newX, newY) <> id) then
  begin
    newX := entityList[id].posX;
    newY := entityList[id].posY;
  end;
  entityList[id].posX := newX;
  entityList[id].posY := newY;

  (* Check if NPC in players FoV *)
  if (map.canSee(newX, newY) = True) then
  begin
    entityList[id].inView := True;
    if (entityList[id].discovered = False) then
    begin
      ui.displayMessage('You see ' + entityList[id].description);
      entityList[id].discovered := True;
    end;
    (* Draw to map display *)
    map.mapDisplay[newY, newX].GlyphColour := entityList[id].glyphColour;
    map.mapDisplay[newY, newX].Glyph := entityList[id].glyph;
  end
  else
    entityList[id].inView := False;
  (* mark tile as occupied *)
  map.occupy(newX, newY);
end;

function getCreatureHP(x, y: smallint): smallint;

var
  i: smallint;
begin
  Result := 0;
  for i := 0 to npcAmount do
  begin
    if (entityList[i].posX = x) and (entityList[i].posY = y) then
      Result := entityList[i].currentHP;
  end;
end;

function getCreatureMaxHP(x, y: smallint): smallint;

var
  i: smallint;
begin
  Result := 0;
  for i := 0 to npcAmount do
  begin
    if (entityList[i].posX = x) and (entityList[i].posY = y) then
      Result := entityList[i].maxHP;
  end;
end;

function getCreatureID(x, y: smallint): smallint;

var
  i: smallint;
begin
  Result := 0;
  // initialise variable
  for i := 0 to npcAmount do
  begin
    if (entityList[i].posX = x) and (entityList[i].posY = y) then
      Result := i;
  end;
end;

function getCreatureName(x, y: smallint): shortstring;

var
  i: smallint;
begin
  Result := '';
  for i := 0 to npcAmount do
  begin
    if (entityList[i].posX = x) and (entityList[i].posY = y) then
      Result := entityList[i].race;
  end;
end;

function isCreatureVisible(x, y: smallint): boolean;

var
  i: smallint;
begin
  Result := False;
  for i := 0 to npcAmount do
    if (entityList[i].posX = x) and (entityList[i].posY = y) then
      if (entityList[i].inView = True) and (entityList[i].glyph <> '%') then
        Result := True;
end;

procedure occupyUpdate;

var
  i: smallint;
begin
  for i := 1 to npcAmount do
    if (entityList[i].isDead = False) then
      map.occupy(entityList[i].posX, entityList[i].posY);
end;

procedure redrawMapDisplay(id: byte);
begin
(* Redrawing NPC directly to map display as looping through
     entity list in the camera unit wasn't working *)
  if (entityList[id].isDead = False) and (entityList[id].inView = True) then
  begin
    map.mapDisplay[entityList[id].posY, entityList[id].posX].GlyphColour :=
      entityList[id].glyphColour;
    map.mapDisplay[entityList[id].posY, entityList[id].posX].Glyph :=
      entityList[id].glyph;
  end;
end;

procedure newFloorNPCs;
begin
  (* Clear the current NPC amount *)
  npcAmount := 1;
  SetLength(entityList, 1);
end;

function countLivingEntities: byte;

var
  i, Count: byte;
begin
  Count := 0;
  for i := 1 to npcAmount do
    if (entityList[i].isDead = False) then
      Inc(Count);
  Result := Count;
end;

procedure NPCgameLoop;
var
  i: smallint;
begin
  for i := 1 to npcAmount do
    if (entityList[i].glyph <> '%') then
      entityList[i].entityTakeTurn(i);
end;

{ Creature }

procedure Creature.entityTakeTurn(i: smallint);
begin
  if (entityList[i].race = 'Cave Rat') then
    cave_rat.takeTurn(i)
  else if (entityList[i].race = 'Giant Rat') then
    giant_cave_rat.takeTurn(i)
  else if (entityList[i].race = 'Blood Bat') then
    blood_bat.takeTurn(i)
  else if (entityList[i].race = 'Green Fungus') then
    green_fungus.takeTurn(i)
  else if (entityList[i].race = 'Hob') then
    redcap_lesser.takeTurn(i)
  else if (entityList[i].race = 'Hob lobber') then
    redcap_lesser_lobber.takeTurn(i);

  occupyUpdate;
end;

end.
