(* Unit responsible for projectile animation *)

unit animation;

{$mode fpc}{$H+}

interface

uses
  SysUtils, Classes, video, ui, entities, logging;

type
  a = array[1..10] of TPoint;

(* Animate a rock being thrown *)
procedure throwRock(id: smallint; var flightPath: a);

implementation

procedure throwRock(id: smallint; var flightPath: a);
var
  i: byte;
begin
  logAction('Throw path');
  ui.displayMessage(entityList[id].race + ' throws a rock at you');
  for i := 2 to 10 do
  begin
    LockScreenUpdate;
    if (flightPath[i].X <> 0) and (flightPath[i].Y <> 0) then
    begin
      TextOut(flightPath[i].X, flightPath[i].Y, 'white', '*');
      sleep(125);
    end;
    UnlockScreenUpdate;
    UpdateScreen(False);
  end;
end;

end.
