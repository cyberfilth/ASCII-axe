unit map;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, globalutils, universe;

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
  r := 1;
  c := 1;
  (* set up the dungeon tiles *)
  for r := 1 to globalutils.MAXROWS do
  begin
    for c := 1 to globalutils.MAXCOLUMNS do
    begin
      with maparea[r][c] do
      begin
        id := universe.dungeonList[0].dlevel[1][r][c].id;
        Blocks := universe.dungeonList[0].dlevel[1][r][c].Blocks;
        Visible := universe.dungeonList[0].dlevel[1][r][c].Visible;
        Discovered := universe.dungeonList[0].dlevel[1][r][c].Discovered;
        Occupied := universe.dungeonList[0].dlevel[1][r][c].Occupied;
        Glyph := universe.dungeonList[0].dlevel[1][r][c].Glyph;
      end;
    end;
  end;
end;

end.

