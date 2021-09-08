(* Unit responsible for projectile animation *)

unit animation;

{$mode fpc}{$H+}

interface

uses
  SysUtils, Classes, video, ui, entities, main;

type
  a = array[1..10] of TPoint;

(* Animate a rock being thrown *)
procedure throwRock(id: smallint; var flightPath: a);

implementation

procedure throwRock(id: smallint; var flightPath: a);
var
  i: byte;
begin
  (* Change game state to stop receiving inputs *)
  main.gameState := stAnim;
  ui.displayMessage(entityList[id].race + ' throws a rock at you');
  for i := 2 to 10 do
  begin
    LockScreenUpdate;
    if (flightPath[i].X <> 0) and (flightPath[i].Y <> 0) then
    begin
      (* Paint over previous rock *)
      if (i > 2) then
        TextOut(flightPath[i - 1].X, flightPath[i - 1].Y, 'lightGrey', '.');

      (* Draw rock *)
      TextOut(flightPath[i].X, flightPath[i].Y, 'white', '*');
      sleep(125);
    end;
    UnlockScreenUpdate;
    UpdateScreen(False);
  end;
  (* Restore game state *)
  main.gameState := stGame;
end;

end.
