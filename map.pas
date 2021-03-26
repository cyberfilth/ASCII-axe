unit map;

{$mode objfpc}{$H+}

interface

uses
  SysUtils;

type
  (* Tiles that make up the game world *)
  tile = record
    (* Unique tile ID *)
    id: smallint;
    (* Does the tile block movement *)
    Blocks: boolean;
    (* Is the tile visible *)
    Visible: boolean;
    (* Is the tile occupied *)
    Occupied: boolean;
    (* Has the tile been discovered already *)
    Discovered: boolean;
    (* Character used to represent the tile *)
    Glyph: char;
  end;

var
  (* Type of map: 2 = cavern, 3 = Bitmask dungeon *)
  mapType: smallint;
  (* Game map array *)
  maparea: array[1..MAXROWS, 1..MAXCOLUMNS] of tile;
  (* ROWS and COLUMNS used in loops *)
  r, c: smallint;
  (* Player starting position *)
  startX, startY: smallint;

procedure setupMap;

implementation


procedure setupMap;
begin
  (* give each tile a unique ID number *)
  id_int: smallint;
  begin
  case mapType of
    2: cavern.generate;
    3: bitmask_dungeon.generate;
  end;

end;

end.

