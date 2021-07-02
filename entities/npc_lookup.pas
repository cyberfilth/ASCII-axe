(* Lookup table for NPC's, based on the environment *)

Unit npc_lookup;

{$mode fpc}{$H+}

Interface

Uses
globalUtils, universe, map,
  { List of creatures }
cave_rat, giant_cave_rat, blood_bat, green_fungus, redcap_lesser;

Const
  (* Array of creatures found in a cave, ordered by cave level *)
  //caveNPC1: array[1..4] Of string = ('redcapLesser', 'redcapLesser', 'redcapLesser', 'redcapLesser');  REMOVED JUST FOR TESTING HOB NPC
  caveNPC1: array[1..4] of string = ('caveRat', 'caveRat', 'bloodBat', 'greenFungus');
  caveNPC2: array[1..4] Of string = ('caveRat', 'giantRat', 'giantRat', 'giantRat');
  caveNPC3: array[1..4] Of string = ('caveRat', 'giantRat', 'giantRat', 'giantRat');


(* randomly choose a creature and call the generate code directly *)
Procedure NPCpicker(i: byte; dungeon: dungeonTerrain);

Implementation

Procedure NPCpicker(i: byte; dungeon: dungeonTerrain);

Var
  r, c: smallint;
  randSelect: byte;
  monster: string;
Begin
  monster := '';
  (* Choose random location on the map *)
  Repeat
    r := globalutils.randomRange(2, (MAXROWS - 1));
    c := globalutils.randomRange(2, (MAXCOLUMNS - 1));
    (* choose a location that is not a wall or occupied *)
  Until (maparea[r][c].Blocks = False) And (maparea[r][c].Occupied = False);

  (* Randomly choose an NPC based on dungeon depth *)
  Case dungeon Of
    tCave:
           Begin { Level 1}
             If (universe.currentDepth = 1) Then
               Begin
                 randSelect := globalUtils.randomRange(1, 4);
                 monster := caveNPC1[randSelect];
               End { Level 2 }
             Else If (universe.currentDepth = 2) Then
                    Begin
                      randSelect := globalUtils.randomRange(1, 4);
                      monster := caveNPC2[randSelect];
                    End { Level 3 }
             Else If (universe.currentDepth = 3) Then
                    Begin
                      randSelect := globalUtils.randomRange(1, 4);
                      monster := caveNPC3[randSelect];
                    End;
           End;
    tDungeon:
              Begin
      { Placeholder }
              End;
  End;

  (* Create NPC *)
  Case monster Of
    'caveRat': cave_rat.createCaveRat(i, c, r);
    'bloodBat': blood_bat.createBloodBat(i, c, r);
    'greenFungus': green_fungus.createGreenFungus(i, c, r);
    'giantRat': giant_cave_rat.createGiantCaveRat(i, c, r);
    'redcapLesser': redcap_lesser.createRedcap(i, c, r);
  End;
End;

End.
