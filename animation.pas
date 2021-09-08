(* Unit responsible for projectile animation *)

unit animation;

{$mode fpc}{$H+}

interface

uses
  SysUtils, Classes, video, ui, entities;

type
  a = array[1..10] of TPoint;

(* Animate a rock being thrown *)
procedure throwRock(id: smallint; var flightPath: a);

implementation

procedure throwRock(id: smallint; var flightPath: a);
var
  i: byte;
begin
  ui.displayMessage(entityList[id].race + ' throws a rock at you');
  for i := 2 to 10 do
  begin
    LockScreenUpdate;

    TextOut(flightPath[i].X, flightPath[i].Y, 'white', '*');

    UnlockScreenUpdate;
    UpdateScreen(False);
    sleep(150);
  end;
end;

end.
