unit camera;

{$mode objfpc}{$H+}

interface

uses
  map, SysUtils, ui;

const
  camHeight = 38;
  camWidth = 67;

var
  r, c: smallint;

function getX(Xcoord: smallint): smallint;
function getY(Ycoord: smallint): smallint;
procedure drawMap(playerX, playerY: smallint);

implementation

function getX(Xcoord: smallint): smallint;
var
  p, hs, s, m: smallint;
begin
  p := Xcoord;
  hs := camWidth div 2;
  s := camWidth;
  m := map.MAXCOLUMNS;

  if (p < hs) then
    Result := 0
  else if (p >= m - hs) then
    Result := m - s
  else
    Result := p - hs;
end;

function getY(Ycoord: smallint): smallint;
const
  s = camHeight;
  hs = camHeight div 2;
  m = map.MAXROWS;
var
  p: smallint;
begin
  p := Ycoord;
  if (p < hs) then
    Result := 0
  else if (p >= m - hs) then
    Result := m - s
  else
    Result := p - hs;
end;

procedure drawMap(playerX, playerY: smallint);
var
  pX, pY: smallint; // placeholder for player coordinates
begin
  pX := playerX;
  pY := playerY;


  for r := 1 to camHeight do
  begin
    for c := 1 to camWidth do
    begin
      if (map.myArray[r + getY(pY)][c + getX(pX)] = '#') then
        TextOut(c, r, 'white', Chr(178))
      else
        TextOut(c, r, 'grey', myArray[r + getY(pY)][c + getX(pX)]);
    end;
  end;

end;

end.

