(* Lookup table for items, based on the environment *)

unit item_lookup;

{$mode fpc}{$H+}

interface

uses
  entities, universe, globalUtils,
  { List of drinks }
  ale_tankard,
  { List of weapons }
  crude_dagger,
  { List of armour }
  leather_armour1;

const
  (* Array of items found in a cave, ordered by cave level *)
  caveItems1: array[1..4] of string =
    ('aleTankard', 'crudeDagger', 'aleTankard', 'leatherArmour1');
  caveItems2: array[1..4] of string =
    ('aleTankard', 'aleTankard', 'aleTankard', 'leatherArmour1');
  caveItems3: array[1..2] of string = ('aleTankard', 'crudeDagger');

(* Choose an item and call the generate code directly *)
procedure dispenseItem(i: byte; dungeon: dungeonTerrain);
(* Execute useItem procedure *)
procedure lookupUse(x: smallint; equipped: boolean);
(* Used to drop a specific special item on each level *)
procedure dropFirstItem;

implementation

uses
  items, map;

procedure dispenseItem(i: byte; dungeon: dungeonTerrain);
var
  r, c: smallint;
  randSelect: byte;
  thing: string;
begin
  (* Choose random location on the map *)
  repeat
    r := globalutils.randomRange(3, (MAXROWS - 3));
    c := globalutils.randomRange(3, (MAXCOLUMNS - 3));
    (* choose a location that is not a wall or occupied *)
  until (maparea[r][c].Blocks = False) and (maparea[r][c].Occupied = False);

  (* Randomly choose an item based on dungeon depth *)
  case dungeon of
    tCave:
    begin { Level 1}
      if (universe.currentDepth = 1) then
      begin
        randSelect := globalUtils.randomRange(1, 4);
        thing := caveItems1[randSelect];
      end { Level 2 }
      else if (universe.currentDepth = 2) then
      begin
        randSelect := globalUtils.randomRange(1, 4);
        thing := caveItems2[randSelect];
      end;
    end;
    tDungeon:
    begin
      { Placeholder }
    end;
  end;


  (* Create Item *)
  case thing of
    'aleTankard': ale_tankard.createAleTankard(i, c, r);
    'crudeDagger': crude_dagger.createDagger(i, c, r);
    'leatherArmour1': leather_armour1.createLeatherArmour(i, c, r);
  end;
end;

procedure lookupUse(x: smallint; equipped: boolean);
begin
  case x of
    1: ale_tankard.useItem;
    2: crude_dagger.useItem(equipped);
    3: leather_armour1.useItem(equipped);
  end;
end;

procedure dropFirstItem;
var
  r, c: smallint;
begin
  (* Choose random location on the map *)
  repeat
    r := globalutils.randomRange(3, (MAXROWS - 3));
    c := globalutils.randomRange(3, (MAXCOLUMNS - 3));
    (* choose a location that is not a wall or occupied *)
  until (maparea[r][c].Blocks = False) and (maparea[r][c].Occupied = False);

  items.listLength:=Length(items.itemList);
  SetLength(items.itemList, items.itemAmount + 1);
  leather_armour1.createLeatherArmour(itemAmount, c, r);
end;

end.
