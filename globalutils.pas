(* Common functions / utilities *)

unit globalutils;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DOM, XMLWrite, XMLRead;

type
  coordinates = record
    x, y: smallint;
  end;

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
    Glyph: char;
  end;

const
  (* Version info - a = Alpha, d = Debug, r = Release *)
  VERSION = '30a';
  (* Save game file *)
  {$IFDEF Linux}
  saveFile = '.axes.data';
  {$ENDIF}
  {$IFDEF Windows}
  saveFile = 'axes.data';
  {$ENDIF}
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
  (* list of coordinates of centre of each room *)
  currentDgncentreList: array of coordinates;
  (* Name of entity or item that killed the player *)
  killer: shortstring;

(* Select random number from a range *)
function randomRange(fromNumber, toNumber: smallint): smallint;
(* Simulate dice rolls *)
function rollDice(numberOfDice: byte): smallint;

implementation

(* Random(Range End - Range Start) + Range Start *)
function randomRange(fromNumber, toNumber: smallint): smallint;
var
  p: smallint;
begin
  p := toNumber - fromNumber;
  Result := random(p + 1) + fromNumber;
end;

function rollDice(numberOfDice: byte): smallint;
var
  i: byte;
  x: smallint;
begin
  x := 0; // initialise variable
  if (numberOfDice = 0) then
    Result := 0
  else
  begin
    for i := 0 to numberOfDice do
    begin
      x := Random(6) + 1;
    end;
    Result := x;
  end;
end;

end.

