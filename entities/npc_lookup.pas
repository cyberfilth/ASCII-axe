(* Lookup table for NPC's, based on the environment *)

unit npc_lookup;

{$mode fpc}{$H+}

interface

uses
  globalUtils, universe, map,
  { List of creatures }
  cave_rat;

const
  (* Array of creatures found in a cave, ordered by cave level *)
  caveNPC1: array[1..4] of string = ('caveRat', 'caveRat', 'fungus', 'bloodHyena');
  caveNPC2: array[1..4] of string = ('caveRat', 'giantRat', 'fungus', 'caveBear');

procedure NPCpicker(i: byte; dungeon: dungeonTerrain);

implementation

procedure NPCpicker(i: byte; dungeon: dungeonTerrain);
var
  r, c: smallint;
begin
  { randomly choose a creature and call the generate code directly }
  (* Choose random location on the map *)
  repeat
    r := globalutils.randomRange(2, (MAXROWS - 1));
    c := globalutils.randomRange(2, (MAXCOLUMNS - 1));
    (* choose a location that is not a wall or occupied *)
  until (maparea[r][c].Blocks = False) and (maparea[r][c].Occupied = False);
  { Cave rat hard coded just for testing }
  cave_rat.createCaveRat(i, c, r);
end;

end.
