(* Common functions / utilities *)

unit globalutils;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

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
  (* Name of entity or item that killed the player *)
  killer: shortstring;
  (* Turn counter *)
  playerTurn: integer;
  dungeonArray: array[1..MAXROWS, 1..MAXCOLUMNS] of shortstring;
  (* Number of rooms in the current dungeon *)
  currentDgnTotalRooms: smallint;
  (* list of coordinates of centre of each room *)
  currentDgncentreList: array of coordinates;

implementation

end.

