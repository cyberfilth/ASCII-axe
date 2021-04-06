(* Organises the current level into an array *)

unit map;

{$mode fpc}{$H+}
{$RANGECHECKS OFF}

interface

uses
  SysUtils, globalUtils, cave;

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
    Glyph: shortstring;
    (* Colour of the tile *)
    GlyphColour: shortstring;
  end;

var
  (* Type of map: 2 = cavern, 3 = Bitmask dungeon *)
  mapType: smallint;
  (* Game map array *)
  maparea: array[1..MAXROWS, 1..MAXCOLUMNS] of tile;
  (* ROWS and COLUMNS used in loops *)
  r, c: smallint;

(* Loop through tiles and set their ID, visibility etc *)
procedure setupMap;

implementation

procedure setupMap;
var
  // give each tile a unique ID number
  id_int: smallint;
begin
  case mapType of
    0: ;//cave.generate;
    1: ;//grid_dungeon.generate;
    2: cave.generateMap;
    3: ;//bitmask_dungeon.generate;
  end;
  r := 1;
  c := 1;
  id_int := 0;
  (* set up the dungeon tiles *)
  for r := 1 to globalUtils.MAXROWS do
  begin
    for c := 1 to globalUtils.MAXCOLUMNS do
    begin
      Inc(id_int);
      with maparea[r][c] do
      begin
        id := id_int;
        Blocks := True;
        Visible := False;
        Discovered := False;
        Occupied := False;
        Glyph := globalUtils.dungeonArray[r][c];
        // testing code
        GlyphColour := 'white';
      end;
    end;
  end;
end;

end.

