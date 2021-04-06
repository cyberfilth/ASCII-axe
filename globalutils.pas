unit globalUtils;

{$mode fpc}{$H+}

interface

uses
  SysUtils;

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
  dungeonArray: array[1..MAXROWS, 1..MAXCOLUMNS] of shortstring;

implementation

end.

