(* Unit responsible for NPC stat, initialising enemies and utility functions *)

Unit entities;

{$mode objfpc}{$H+}
{$ModeSwitch advancedrecords}
{$RANGECHECKS OFF}

Interface

Uses
ui, globalUtils, SysUtils,
  { List of creatures }
cave_rat, giant_cave_rat, blood_bat, green_fungus, redcap_lesser;

Type { NPC attitudes }
  Tattitudes = (stateNeutral, stateHostile, stateEscape);

Type {NPC factions / groups }
  Tfactions = (redcapFaction, bluecapFaction, animalFaction, fungusFaction);

Type
  (* Store information about NPC's *)
  { Creature }
  Creature = Record
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
    Procedure entityTakeTurn(i: smallint);
  End;

Var
  entityList: array Of Creature;
  npcAmount, listLength: byte;

(* Add player to list of creatures on the map *)
Procedure spawnPlayer;
(* Handle death of NPC's *)
Procedure killEntity(id: smallint);
(* Update NPCs X, Y coordinates *)
Procedure moveNPC(id, newX, newY: smallint);
(* Get creature currentHP at coordinates *)
Function getCreatureHP(x, y: smallint): smallint;
(* Get creature maxHP at coordinates *)
Function getCreatureMaxHP(x, y: smallint): smallint;
(* Get creature ID at coordinates *)
Function getCreatureID(x, y: smallint): smallint;
(* Get creature name at coordinates *)
Function getCreatureName(x, y: smallint): shortstring;
(* Check if creature is visible at coordinates *)
Function isCreatureVisible(x, y: smallint): boolean;
(* Ensure all NPC's are correctly occupying tiles *)
Procedure occupyUpdate;
(* Update the map display to show all NPC's *)
Procedure redrawMapDisplay(id: byte);
(* Clear list of NPC's *)
Procedure newFloorNPCs;
(* Count all living NPC's *)
Function countLivingEntities: byte;
(* Call Creatures.takeTurn procedure *)
Procedure NPCgameLoop;


Implementation

Uses
player, map;

Procedure spawnPlayer;
Begin
  npcAmount := 1;
  (*  initialise array *)
  SetLength(entityList, 0);
  (* Add the player to Entity list *)
  player.createPlayer;
End;

Procedure killEntity(id: smallint);

Var
  i, amount, r, c: smallint;
Begin
  entityList[id].isDead := True;
  entityList[id].glyph := '%';
  entityList[id].blocks := False;
  map.unoccupy(entityList[id].posX, entityList[id].posY);

  { Green Fungus }
  If (entityList[id].race = 'Green Fungus') Then
    (* Attempt to spread spores *)
    Begin
    (* Set a random number of spores *)
      amount := randomRange(0, 3);
      If (amount > 0) Then
        Begin
          For i := 1 To amount Do
            Begin
        (* Choose a space to place the fungus *)
              r := globalutils.randomRange(entityList[id].posY - 4, entityList[id].posY + 4);
              c := globalutils.randomRange(entityList[id].posX - 4, entityList[id].posX + 4);
        (* choose a location that is not a wall or occupied *)
              If (maparea[r][c].Blocks <> True) And (maparea[r][c].Occupied <> True) And
                 (withinBounds(c, r) = True) Then
                Begin
                  Inc(npcAmount);
                  green_fungus.createGreenFungus(npcAmount, c, r);
                End;
            End;
          ui.writeBufferedMessages;
          ui.bufferMessage('The fungus releases spores into the air');
        End;
    End;
  { End of Green Fungus death }
End;


Procedure moveNPC(id, newX, newY: smallint);
Begin
  (* mark tile as unoccupied *)
  map.unoccupy(entityList[id].posX, entityList[id].posY);
  (* update new position *)
  If (map.isOccupied(newX, newY) = True) And (getCreatureID(newX, newY) <> id) Then
    Begin
      newX := entityList[id].posX;
      newY := entityList[id].posY;
    End;
  entityList[id].posX := newX;
  entityList[id].posY := newY;

  (* Check if NPC in players FoV *)
  If (map.canSee(newX, newY) = True) Then
    Begin
      entityList[id].inView := True;
      If (entityList[id].discovered = False) Then
        Begin
          ui.displayMessage('You see ' + entityList[id].description);
          entityList[id].discovered := True;
        End;
    (* Draw to map display *)
      map.mapDisplay[newY, newX].GlyphColour := entityList[id].glyphColour;
      map.mapDisplay[newY, newX].Glyph := entityList[id].glyph;
    End
  Else
    entityList[id].inView := False;
  (* mark tile as occupied *)
  map.occupy(newX, newY);
End;

Function getCreatureHP(x, y: smallint): smallint;

Var
  i: smallint;
Begin
  Result := 0;
  For i := 0 To npcAmount Do
    Begin
      If (entityList[i].posX = x) And (entityList[i].posY = y) Then
        Result := entityList[i].currentHP;
    End;
End;

Function getCreatureMaxHP(x, y: smallint): smallint;

Var
  i: smallint;
Begin
  Result := 0;
  For i := 0 To npcAmount Do
    Begin
      If (entityList[i].posX = x) And (entityList[i].posY = y) Then
        Result := entityList[i].maxHP;
    End;
End;

Function getCreatureID(x, y: smallint): smallint;

Var
  i: smallint;
Begin
  Result := 0;
  // initialise variable
  For i := 0 To npcAmount Do
    Begin
      If (entityList[i].posX = x) And (entityList[i].posY = y) Then
        Result := i;
    End;
End;

Function getCreatureName(x, y: smallint): shortstring;

Var
  i: smallint;
Begin
  Result := '';
  For i := 0 To npcAmount Do
    Begin
      If (entityList[i].posX = x) And (entityList[i].posY = y) Then
        Result := entityList[i].race;
    End;
End;

Function isCreatureVisible(x, y: smallint): boolean;

Var
  i: smallint;
Begin
  Result := False;
  For i := 0 To npcAmount Do
    If (entityList[i].posX = x) And (entityList[i].posY = y) Then
      If (entityList[i].inView = True) And (entityList[i].glyph <> '%') Then
        Result := True;
End;

Procedure occupyUpdate;

Var
  i: smallint;
Begin
  For i := 1 To npcAmount Do
    If (entityList[i].isDead = False) Then
      map.occupy(entityList[i].posX, entityList[i].posY);
End;

Procedure redrawMapDisplay(id: byte);
Begin

(* Redrawing NPC directly to map display as looping through
     entity list in the camera unit wasn't working *)
  If (entityList[id].isDead = False) And (entityList[id].inView = True) Then
    Begin
      map.mapDisplay[entityList[id].posY, entityList[id].posX].GlyphColour := entityList[id].glyphColour;
      map.mapDisplay[entityList[id].posY, entityList[id].posX].Glyph := entityList[id].glyph;
    End;
End;

Procedure newFloorNPCs;
Begin
  (* Clear the current NPC amount *)
  npcAmount := 1;
  SetLength(entityList, 1);
End;

Function countLivingEntities: byte;

Var
  i, Count: byte;
Begin
  Count := 0;
  For i := 1 To npcAmount Do
    If (entityList[i].isDead = False) Then
      Inc(Count);
  Result := Count;
End;

Procedure NPCgameLoop;

Var
  i: smallint;
Begin
  For i := 1 To npcAmount Do
    If (entityList[i].glyph <> '%') Then
      entityList[i].entityTakeTurn(i);
End;

{ Creature }

Procedure Creature.entityTakeTurn(i: smallint);
Begin
  If (entityList[i].race = 'Cave Rat') Then
    cave_rat.takeTurn(i)
  Else If (entityList[i].race = 'Giant Rat') Then
         giant_cave_rat.takeTurn(i)
  Else If (entityList[i].race = 'Blood Bat') Then
         blood_bat.takeTurn(i)
  Else If (entityList[i].race = 'Green Fungus') Then
         green_fungus.takeTurn(i)
  Else If (entityList[i].race = 'Hob') Then
         redcap_lesser.takeTurn(i);

  occupyUpdate;
End;

End.
