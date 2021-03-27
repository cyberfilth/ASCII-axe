(* Store each dungeon, its levels and related info *)

unit universe;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, globalutils;

(* individual dungeon / cave *)
type
  dungeonLayout = record
    (* unique identifier *)
    uniqueID: smallint;
    (* human-readable name of dungeon *)
    title: string;
    (* Type of map: 0 = cave tunnels, 1 = blue grid-based dungeon, 2 = cavern, 3 = Bitmask dungeon *)
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

{ TODO 1 : Maintain a list of dungeon ID's and their coordinates on the world map }

procedure createNewDungeon(idNumber, mapType: byte);

implementation

uses
  cave;

procedure createNewDungeon(idNumber, mapType: byte);
var
  i: byte;
begin
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
    totalDepth := 3;
    currentDepth := 1;
    (* set each floor to unvisited *)
    for i := 1 to 10 do
    begin
      isVisited[i] := False;
    end;
    (* generate the dungeon *)
    for i := 1 to totalDepth do
    begin
      (* select which type of dungeon to generate *)
      case mapType of
        2: cave.generate(i, totalDepth);
       // 3: bitmask_dungeon.generate;
      end;
    end;
  end;
end;

end.

