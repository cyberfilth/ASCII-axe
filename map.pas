unit map;

{$mode objfpc}{$H+}

interface

uses
  SysUtils;

const
  MAXROWS = 100;
  MAXCOLUMNS = 100;

var
  myArray: array[1..MAXROWS, 1..MAXCOLUMNS] of string;
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
end;

end.

