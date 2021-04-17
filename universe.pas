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
  dlistLength: smallint;

procedure createNewDungeon(levelType: byte);

implementation

uses
  map;

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
  (* Add a dungeon to the dungeonList *)
   dlistLength := length(dungeonList);
   SetLength(dungeonList, dlistLength + 1);
  idNumber := Length(dungeonList);
  dlistLength := length(dungeonList);

  { Logging }
  logAction('----------------------------');
  logAction(' Dungeon added to list');
  logAction(' dlistLength: ' + IntToStr(dlistLength));
  logAction(' idNumber : ' +IntToStr(idNumber));
  logAction('----------------------------');

  (* Fill dungeon record with values *)
  with dungeonList[dlistLength - 1] do
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
      1: ;
      2:  // Cave
      begin
        { Logging }
        logAction(' universe.createNewDungeon procedure calls cave.generate(dlistLength - 1 '+
          IntToStr(dlistLength - 1) + ', totalDepth ' +
          IntToStr(totalDepth) + ')');
        cave.generate(dlistLength - 1, totalDepth);
      end;
      3: ;//bitmask_dungeon.generate;
    end;

    (* Copy the dungeon to the game map *)
    map.setupMap(dlistLength - 1);

  end;
end;

end.
