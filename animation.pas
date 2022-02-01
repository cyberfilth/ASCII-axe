(* Unit responsible for projectile animation *)

unit animation;

{$mode fpc}{$H+}

interface

uses
  SysUtils, Classes, video, ui, entities, main, fov, map, camera;

type
  a = array[1..10] of TPoint;

(* Animate a rock being thrown *)
procedure throwRock(id: smallint; var flightPath: a);
(* Animate nearby enemies burning *)
procedure areaBurnEffect(x, y: smallint; NPCglyph: shortstring);

implementation

procedure throwRock(id: smallint; var flightPath: a);
var
  i, p: byte;
begin
  (* Change game state to stop receiving inputs *)
  main.gameState := stAnim;
  (* Draw player, FOV & NPC's *)
  LockScreenUpdate;
  (* Redraw all NPC'S *)
  for p := 1 to entities.npcAmount do
    entities.redrawMapDisplay(p);
  camera.drawMap;
  fov.fieldOfView(entityList[0].posX, entityList[0].posY, entityList[0].visionRange, 1);
  UnlockScreenUpdate;
  UpdateScreen(False);
  ui.displayMessage(entityList[id].race + ' throws a rock at you');
  for i := 2 to 10 do
  begin
    LockScreenUpdate;
    if (flightPath[i].X <> 0) and (flightPath[i].Y <> 0) then
    begin
      (* Paint over previous rock *)
      if (i > 2) then
      begin
        map.mapDisplay[flightPath[i - 1].Y, flightPath[i - 1].X].GlyphColour :=
          'lightGrey';
        map.mapDisplay[flightPath[i - 1].Y, flightPath[i - 1].X].Glyph := '.';
      end;
      (* Draw rock *)
      map.mapDisplay[flightPath[i].Y, flightPath[i].X].GlyphColour := 'white';
      map.mapDisplay[flightPath[i].Y, flightPath[i].X].Glyph := '*';
      sleep(100);
    end;
    (* Repaint map *)
    camera.drawMap;
    fov.fieldOfView(entityList[0].posX, entityList[0].posY,
      entityList[0].visionRange, 1);

    UnlockScreenUpdate;
    UpdateScreen(False);
  end;
  (* Restore game state *)
  main.gameState := stGame;
  (* Draw player and FOV *)
  LockScreenUpdate;
  (* Paint out NPC to fix a glitch with updating the display *)
  TextOut(flightPath[1].X, flightPath[1].Y, 'lightGrey', '.');
  fov.fieldOfView(entityList[0].posX, entityList[0].posY, entityList[0].visionRange, 1);
  UnlockScreenUpdate;
  UpdateScreen(False);
end;

procedure areaBurnEffect(x, y: smallint; NPCglyph: shortstring);
begin
  (* Change game state to stop receiving inputs *)
  main.gameState := stAnim;
  { prepare changes to the screen }
  LockScreenUpdate;
  map.mapDisplay[y, x].GlyphColour := 'red';
  map.mapDisplay[y, x].Glyph := NPCglyph;
   (* Repaint map *)
    camera.drawMap;
  //TextOut(x, y, 'yellow', 'X');
  { Write those changes to the screen }
  UnlockScreenUpdate;
  { only redraws the parts that have been updated }
  UpdateScreen(False);
  (* Restore game state *)
  main.gameState := stGame;
end;

end.
