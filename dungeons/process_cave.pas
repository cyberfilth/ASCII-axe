(* Processes cave map to add features *)

unit process_cave;

{$mode objfpc}{$H+}
{$RANGECHECKS OFF}

interface

uses
  SysUtils, globalutils, universe;

var
  processed_cave: array[1..globalutils.MAXROWS, 1..globalutils.MAXCOLUMNS] of char;

(* Process generated cave to add shaped walls *)
procedure prettify(floorNumber, rmtotal: byte);

implementation

uses
  cave;

procedure prettify(floorNumber, rmtotal: byte);
var
  tileCounter, id_int: smallint;
begin
  id_int := 0;
  (* First pass for adding walls *)
  for r := 1 to globalutils.MAXROWS do
  begin
    for c := 1 to globalutils.MAXCOLUMNS do
      if (cave.terrainArray[r][c] = '*') then
      begin
        tileCounter := 0;
        if (cave.terrainArray[r - 1][c] <> '.') then // NORTH
          tileCounter := tileCounter + 1;
        if (cave.terrainArray[r - 1][c + 1] <> '.') then // NORTH EAST
          tileCounter := tileCounter + 2;
        if (cave.terrainArray[r][c + 1] <> '.') then // EAST
          tileCounter := tileCounter + 4;
        if (cave.terrainArray[r + 1][c + 1] <> '.') then // SOUTH EAST
          tileCounter := tileCounter + 8;
        if (cave.terrainArray[r + 1][c] <> '.') then // SOUTH
          tileCounter := tileCounter + 16;
        if (cave.terrainArray[r + 1][c - 1] <> '.') then // SOUTH WEST
          tileCounter := tileCounter + 32;
        if (cave.terrainArray[r][c - 1] <> '.') then // WEST
          tileCounter := tileCounter + 64;
        if (cave.terrainArray[r - 1][c - 1] <> '.') then // NORTH WEST
          tileCounter := tileCounter + 128;
        case tileCounter of
          0: processed_cave[r][c] := 'A';
          1: processed_cave[r][c] := 'B';
          4: processed_cave[r][c] := 'C';
          5: processed_cave[r][c] := 'D';
          7: processed_cave[r][c] := 'E';
          16: processed_cave[r][c] := 'F';
          17: processed_cave[r][c] := 'G';
          20: processed_cave[r][c] := 'H';
          21: processed_cave[r][c] := 'I';
          23: processed_cave[r][c] := 'J';
          28: processed_cave[r][c] := 'K';
          29: processed_cave[r][c] := 'L';
          31: processed_cave[r][c] := 'M';
          64: processed_cave[r][c] := 'N';
          65: processed_cave[r][c] := 'O';
          68: processed_cave[r][c] := 'P';
          69: processed_cave[r][c] := 'Q';
          71: processed_cave[r][c] := 'R';
          80: processed_cave[r][c] := 'S';
          81: processed_cave[r][c] := 'T';
          84: processed_cave[r][c] := 'U';
          85: processed_cave[r][c] := 'V';
          87: processed_cave[r][c] := 'W';
          92: processed_cave[r][c] := 'X';
          93: processed_cave[r][c] := 'Y';
          95: processed_cave[r][c] := 'Z';
          112: processed_cave[r][c] := 'a';
          113: processed_cave[r][c] := 'b';
          116: processed_cave[r][c] := 'c';
          117: processed_cave[r][c] := 'd';
          119: processed_cave[r][c] := 'e';
          124: processed_cave[r][c] := 'f';
          125: processed_cave[r][c] := 'g';
          127: processed_cave[r][c] := 'h';
          193: processed_cave[r][c] := 'i';
          197: processed_cave[r][c] := 'j';
          199: processed_cave[r][c] := 'k';
          209: processed_cave[r][c] := 'l';
          213: processed_cave[r][c] := 'm';
          215: processed_cave[r][c] := 'n';
          221: processed_cave[r][c] := 'o';
          223: processed_cave[r][c] := 'p';
          241: processed_cave[r][c] := 'q';
          245: processed_cave[r][c] := 'r';
          247: processed_cave[r][c] := 's';
          253: processed_cave[r][c] := 't';
          255: processed_cave[r][c] := 'u';
          else
            processed_cave[r][c] := 'u';
        end;
      end
      else if (cave.terrainArray[r][c] = '<') then
        processed_cave[r][c] := '<'
      else if (cave.terrainArray[r][c] = '>') then
        processed_cave[r][c] := '>'
      else
        processed_cave[r][c] := '.';
  end;
  (* set up the dungeon tiles *)
  for r := 1 to globalutils.MAXROWS do
  begin
    for c := 1 to globalutils.MAXCOLUMNS do
    begin
      Inc(id_int);
      with universe.dungeonList[0].dlevel[floorNumber][r][c] do
      begin
        id := id_int;
        Blocks := True;
        Visible := False;
        Discovered := False;
        Occupied := False;
        Glyph := processed_cave[r][c];
      end;
      if (processed_cave[r][c] = '.') or (processed_cave[r][c] = '<') or
        (processed_cave[r][c] = '>') then
        universe.dungeonList[0].dlevel[floorNumber][r][c].Blocks := False;
    end;
  end;

  (* Store total number of rooms in this level *)
  universe.dungeonList[0].totalRooms[floorNumber] := rmtotal;
end;

end.
