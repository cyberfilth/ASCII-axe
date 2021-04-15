(* Store each dungeon, its levels and related info *)

unit universe;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, logging, globalutils, cave;

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
    dlevel: array[1..10, 1..MAXROWS, 1..MAXCOLUMNS] of shortstring;
    (* stores which parts of each floor is discovered *)
    discoveredTiles: array[1..10, 1..MAXROWS, 1..MAXCOLUMNS] of boolean;
    (* stores whether each floor has been visited *)
    isVisited: array[1..10] of boolean;
    totalRooms: array[1..10] of byte;
  end;

var
  dungeonList: array of dungeonLayout;
  dungeonAmount: smallint;

procedure createNewDungeon(levelType: byte);

implementation

uses
  main;

procedure createNewDungeon(levelType: byte);
var
  i: byte;
  idNumber: smallint;
begin
  { Logging }
  logAction('>reached universe.createNewDungeon(levelType ' +
    IntToStr(levelType) + ')');

  r := 1;
  c := 1;
  (* Add a dungeon to the list of dungeonList *)
  dungeonAmount := length(dungeonList);
  Inc(dungeonAmount);
  SetLength(dungeonList, dungeonAmount);
  idNumber := dungeonAmount;

  { Logging }
  logAction(' Dungeon added to list');
  logAction(' Total number of dungeons: ' + IntToStr(dungeonAmount));

  (* Fill dungeon record with values *)
  with dungeonList[0] do
  begin
    uniqueID := idNumber;
    // hardcoded values for testing
    title := 'First cave';
    dungeonType := levelType;
    totalDepth := 3;
    currentDepth := 1;
    (* set each floor to unvisited *)
    for i := 1 to 10 do
    begin
      isVisited[i] := False;
    end;


    (* generate the dungeon *)
    case levelType of
      0: ;
      1: ;//grid_dungeon.generate;
      2:
      begin
        { Logging }
        logAction(' universe.createNewDungeon procedure calls cave.generate(1, ' +
          IntToStr(totalDepth) + ')');
        cave.generate(1, totalDepth);
      end;
      3: ;//bitmask_dungeon.generate;
    end;

    (* Copy the dungeon to the game map *)


  end;
end;

end.
