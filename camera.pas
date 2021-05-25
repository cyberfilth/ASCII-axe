(* Camera unit follows the player around and displays the surrounding game map *)

Unit camera;

{$mode objfpc}{$H+}

Interface

Uses 
SysUtils, globalUtils, ui, map, entities;

Const 
  camHeight = 19;
  camWidth = 57;

Var 
  r, c: smallint;

Function getX(Xcoord: smallint): smallint;
Function getY(Ycoord: smallint): smallint;
Procedure drawMap;
Procedure drawPlayer;

Implementation

Function getX(Xcoord: smallint): smallint;

Var 
  p, hs, s, m: smallint;
Begin
  p := Xcoord;
  hs := camWidth Div 2;
  s := camWidth;
  m := globalUtils.MAXCOLUMNS;

  If (p < hs) Then
    Result := 0
  Else If (p >= m - hs) Then
         Result := m - s
  Else
    Result := p - hs;
End;

Function getY(Ycoord: smallint): smallint;

Const 
  s = camHeight;
  hs = camHeight div 2;
  m = globalUtils.MAXROWS;

Var 
  p: smallint;
Begin
  p := Ycoord;
  If (p < hs) Then
    Result := 0
  Else If (p >= m - hs) Then
         Result := m - s
  Else
    Result := p - hs;
End;

Procedure drawMap;

Var 
  (* Player coordinates *)
  pX, pY: smallint;
  (* Tile colour *)
  gCol: shortstring;
Begin
  pX := entities.entityList[0].posX;
  pY := entities.entityList[0].posY;
  For r := 1 To camHeight Do
    Begin
      For c := 1 To camWidth Do
        Begin
          gCol := map.mapDisplay[r + getY(pY)][c + getX(pX)].GlyphColour;
          TextOut(c, r, gCol, map.mapDisplay[r + getY(pY)][c + getX(pX)].Glyph);
        End;
    End;
  drawPlayer;
End;

Procedure drawPlayer;

Var 
  entX, entY: smallint;
  (* Glyph colour *)
  gCol: shortstring;
Begin
  gCol := entities.entityList[0].glyphColour;
  entX := entities.entityList[0].posX;
  entY := entities.entityList[0].posY;
  TextOut(entX - getX(entX), entY - getY(entY), gCol, entities.entityList[0].glyph);
End;

End.
