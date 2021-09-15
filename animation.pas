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
        TextOut(flightPath[i - 1].X, flightPath[i - 1].Y, 'lightGrey',
          map.maparea[flightPath[i - 1].Y][flightPath[i - 1].X].Glyph);
      (* Draw rock *)
      TextOut(flightPath[i].X, flightPath[i].Y, 'white', '*');
      sleep(100);
    end;
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

end.
