unit camera;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, globalUtils, ui;

const
  camHeight = 19;
  camWidth = 57;

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
  m := globalUtils.MAXCOLUMNS;

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
  m = globalUtils.MAXROWS;
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
      if (globalUtils.dungeonArray[r + getY(pY)][c + getX(pX)] = '#') then
        TextOut(c, r, 'brownBlock', Chr(178))
      else
        TextOut(c, r, 'darkgrey', globalUtils.dungeonArray[r + getY(pY)][c + getX(pX)]);
    end;
  end;

end;

end.

