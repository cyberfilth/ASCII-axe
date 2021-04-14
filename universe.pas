(* Store each dungeon, its levels and related info *)

unit universe;

{$mode fpc}{$H+}

interface

uses
  SysUtils, globalutils, map, cave;

(* individual dungeon / cave *)
type
  dungeonLayout = record
    (* unique identifier *)
    uniqueID: smallint;
    (* human-readable name of dungeon *)
    title: string;
    (* Type of map: 0 = cave *)
    dungeonType: smallint;
    (* total number of floors *)
    totalDepth: byte;
    (* current floor the player is on *)
    currentDepth: byte;
    (* array of dungeon floor maps *)
    dlevel: array[0..10, 1..MAXROWS, 1..MAXCOLUMNS] of tile;
    (* stores which parts of each floor is discovered *)
    discoveredTiles: array[1..10, 1..MAXROWS, 1..MAXCOLUMNS] of boolean;
    (* stores whether each floor has been visited *)
    isVisited: array[1..10] of boolean;
    totalRooms: array[1..10] of byte;
  end;

var
  dungeonList: array of dungeonLayout;
  dungeonAmount: smallint;

procedure createNewDungeon(idNumber, mapType: byte);

implementation

procedure createNewDungeon(idNumber, mapType: byte);
var
  i: byte;
  r, c: smallint;
begin
  r := 1;
  c := 1;
  (* Add a dungeon to the list of dungeonList *)
  dungeonAmount := length(dungeonList);
  Inc(dungeonAmount);
  SetLength(dungeonList, dungeonAmount);

  (* Fill dungeon record with values *)
  with dungeonList[0] do
  begin
    uniqueID := idNumber;
    // hardcoded values for testing
    title := 'First cave';
    dungeonType := mapType;
    totalDepth := 1;
    { TODO : First dungeon has 3 levels, others are random depth based on difficulty }
    currentDepth := 1;
    (* set each floor to unvisited *)
    for i := 1 to 10 do
    begin
      isVisited[i] := False;
    end;

    (* generate the dungeon *)
    case mapType of
      0: cave.generate(0, totalDepth);
      1: ;//grid_dungeon.generate;
      2: ;//cavern.generate(i, totalDepth);
      3: ;//bitmask_dungeon.generate;
    end;

    (* Copy the dungeon to the game map *)
    for r := 1 to globalUtils.MAXROWS do
    begin
      for c := 1 to globalUtils.MAXCOLUMNS do
      begin
        with map.maparea[r][c] do
        begin
          id := dungeonList[0].dlevel[0][r][c].id;
          Blocks := True;
          Visible := False;
          Discovered := False;
          Occupied := False;
          Glyph := dungeonList[0].dlevel[0][r][c].Glyph;

        end;
        if (dungeonList[0].dlevel[0][r][c].Glyph = '.') or  { floor tile }
          (dungeonList[0].dlevel[0][r][c].Glyph = '<') or   {Up stair tile }
          (dungeonList[0].dlevel[0][r][c].Glyph = '>') then { Down stair tile }
          maparea[r][c].Blocks := False;
        //drawTile(c, r, 1);
      end;
    end;
  end;
end;

end.
