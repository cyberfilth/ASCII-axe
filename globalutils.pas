unit globalUtils;

{$mode fpc}{$H+}

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

implementation

end.

