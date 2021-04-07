(* Organises the current level into an array together with helper functions *)

unit map;

{$mode objfpc}{$H+}
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
  (* Type of map: 2 = cave, 3 = Bitmask dungeon *)
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
(* Occupy tile *)
procedure occupy(x, y: smallint);
(* Unoccupy tile *)
procedure unoccupy(x, y: smallint);
(* Check if a map tile is occupied *)
function isOccupied(checkX, checkY: smallint): boolean;
(* Check if the coordinates are within the bounds of the gamemap *)
function withinBounds(x, y: smallint): boolean;
(* Check if the direction to move to is valid *)
function canMove(checkX, checkY: smallint): boolean;
(* Check if an object is in players FoV *)
function canSee(checkX, checkY: smallint): boolean;
(* Check if player is on a tile *)
function hasPlayer(checkX, checkY: smallint): boolean;
(* Place a tile on the map *)
procedure drawTile(c, r: smallint; hiDef: byte);

implementation

uses
  entities;

procedure setupMap;
var
  (* give each tile a unique ID number *)
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
        Visible := False;
        Discovered := False;
        Occupied := False;
        Glyph := globalUtils.dungeonArray[r][c];
      end;
      if (globalutils.dungeonArray[r][c] = '.') then
        maparea[r][c].Blocks := False;
      drawTile(c, r, 1);
    end;
  end;
end;

procedure occupy(x, y: smallint);
begin
  maparea[y][x].Occupied := True;
end;

procedure unoccupy(x, y: smallint);
begin
  maparea[y][x].Occupied := False;
end;

function isOccupied(checkX, checkY: smallint): boolean;
begin
  Result := False;
  if (maparea[checkY][checkX].Occupied = True) then
    Result := True;
end;

function withinBounds(x, y: smallint): boolean;
begin
  Result := False;
  if (x >= 1) and (x <= globalutils.MAXCOLUMNS) and (y >= 1) and
    (y <= globalutils.MAXROWS) then
    Result := True;
end;

function canMove(checkX, checkY: smallint): boolean;
begin
  Result := False;
  if (checkX >= 1) and (checkX <= MAXCOLUMNS) and (checkY >= 1) and
    (checkY <= MAXROWS) then
  begin
    if (maparea[checkY][checkX].Blocks = False) then
      Result := True;
  end;
end;

function canSee(checkX, checkY: smallint): boolean;
begin
  Result := False;
  if (maparea[checkY][checkX].Visible = True) then
    Result := True;
end;

function hasPlayer(checkX, checkY: smallint): boolean;
begin
  Result := False;
  if (entities.entityList[0].posX = checkX) and
    (entities.entityList[0].posY = checkY) then
    Result := True;
end;

procedure drawTile(c, r: smallint; hiDef: byte);
begin
  (* Draw black space if tile is not visible *)
  if (maparea[r][c].Visible = False) and (maparea[r][c].Discovered = False) then
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
        if (hiDef = 1) then
        begin
          mapDisplay[r][c].GlyphColour := 'lightGrey';
          mapDisplay[r][c].Glyph := '.';
        end
        else
        begin
          mapDisplay[r][c].GlyphColour := 'darkGrey';
          mapDisplay[r][c].Glyph := '.';
        end;
      end;
      '*': // Cave Wall
      begin
        if (hiDef = 1) then
        begin
          mapDisplay[r][c].GlyphColour := 'brown';
          mapDisplay[r][c].Glyph := Chr(219);
        end
        else
        begin
          mapDisplay[r][c].GlyphColour := 'brown';
          mapDisplay[r][c].Glyph := Chr(177);
        end;
      end;
    end;
  end;
end;

end.
