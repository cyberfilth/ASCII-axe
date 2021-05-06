(* Lookup table for items, based on the environment *)

unit item_lookup;

{$mode fpc}{$H+}

interface

uses
  globalUtils, universe, map, entities,
  { List of items }
  ale_tankard;

(* Choose an item and call the generate code directly *)
procedure dispenseItem;
(* Execute useItem procedure *)
procedure lookupUse(x: smallint; equipped: boolean);

implementation

uses
  items;

procedure dispenseItem;
var
  r, c: smallint;
begin
  (* Choose random location on the map *)
//  repeat
  //  r := globalutils.randomRange(3, (MAXROWS - 3));
    //c := globalutils.randomRange(3, (MAXCOLUMNS - 3));
    (* choose a location that is not a wall or occupied *)
 // until (maparea[r][c].Blocks = False) and (maparea[r][c].Occupied = False);

  Inc(items.itemAmount);
  SetLength(items.itemList, items.itemAmount);

  ale_tankard.createAleTankard(itemAmount, entities.entityList[0].posX + 1, entities.entityList[0].posY);

end;

procedure lookupUse(x: smallint; equipped: boolean);
begin

end;

end.

