(* totally random map *)

unit cave;

{$mode fpc}{$H+}

interface

uses
  SysUtils, globalUtils;

var
  myArray: array[1..MAXROWS, 1..MAXCOLUMNS] of shortstring;
  r, c: smallint;

procedure generateMap;

implementation

procedure generateMap;
begin
  for r := 1 to MAXROWS do
  begin
    for c := 1 to MAXCOLUMNS do
    begin
      myArray[r][c] := '#';
    end;
  end;
  for r := 2 to (MAXROWS - 1) do
  begin
    for c := 2 to (MAXCOLUMNS - 1) do
    begin
      if (random(3) <> 1) then
        myArray[r][c] := '.';
    end;
  end;

  // Update the original dungeon
  for r := 1 to globalutils.MAXROWS do
  begin
    for c := 1 to globalutils.MAXCOLUMNS do
    begin
      globalutils.dungeonArray[r][c] := myArray[r][c];
    end;
  end;
end;

end.

