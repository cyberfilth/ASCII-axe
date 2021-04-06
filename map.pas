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
  end;

type
  (* Tiles that make up the game world *)
  displayTile = record
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
  (* The map that the camera uses *)
  mapDisplay: array[1..MAXROWS, 1..MAXCOLUMNS] of displayTile;
  (* ROWS and COLUMNS used in loops *)
  r, c: smallint;
  (* Player starting position *)
  startX, startY: smallint;

(* Loop through tiles and set their ID, visibility etc *)
procedure setupMap;
(* Place a tile on the map *)
procedure drawTile(c, r: smallint; hiDef: byte);

implementation

procedure setupMap;
var
  // give each tile a unique ID number
  id_int: smallint;
begin
  case mapType of
    0: ;//cave.generate;
    1: ;//grid_dungeon.generate;
    2: cave.generate(1, 1);
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
        Visible := true;// False;
        Discovered := False;
        Occupied := False;
        Glyph := globalUtils.dungeonArray[r][c];
      end;
      drawTile(c, r, 1);
    end;
  end;
end;

procedure drawTile(c, r: smallint; hiDef: byte);
begin
  (* Draw black space if tile is not visible *)
  if (maparea[r][c].Visible = False) then
  begin
    mapDisplay[r][c].Glyph := ' ';
    mapDisplay[r][c].GlyphColour := 'black';
  end
  else
  (* Draw cave tiles *)
  if (mapType = 2) then
  begin
    case maparea[r][c].glyph of
      '.': // Cave Floor
      begin
        mapDisplay[r][c].Glyph := '.';
        if (hiDef = 1) then
          mapDisplay[r][c].GlyphColour := 'white'
        else
          mapDisplay[r][c].GlyphColour := 'darkgrey';
      end;
      '*': // Cave Wall
      begin
        mapDisplay[r][c].Glyph := Chr(177);
        if (hiDef = 1) then
          mapDisplay[r][c].GlyphColour := 'brown'
        else
          mapDisplay[r][c].GlyphColour := 'darkgrey';
      end;
    end;
  end;
end;

end.

