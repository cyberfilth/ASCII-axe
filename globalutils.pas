unit globalUtils;

{$mode objfpc}{$H+}

interface

type
  coordinates = record
    x, y: smallint;
  end;

const
  (* Version info - a = Alpha, d = Debug, r = Release *)
  VERSION = '30a';
  (* Columns of the game map *)
  MAXCOLUMNS = 67;
  (* Rows of the game map *)
  MAXROWS = 38;

var
  (* Turn counter *)
  playerTurn: integer;
  dungeonArray: array[1..MAXROWS, 1..MAXCOLUMNS] of shortstring;
  (* Number of rooms in the current dungeon *)
  currentDgnTotalRooms: smallint;

(* Select random number from a range *)
function randomRange(fromNumber, toNumber: smallint): smallint;

implementation

function randomRange(fromNumber, toNumber: smallint): smallint;
var
  p: smallint;
begin
  p := toNumber - fromNumber;
  Result := random(p + 1) + fromNumber;
end;

end.

