unit scrRIP;

{$mode fpc}{$H+}

interface

uses
  video, SysUtils, ui, globalUtils, entities, file_handling;

(* Show the game over screen screen *)
procedure displayRIPscreen;

implementation

procedure displayRIPscreen;
begin
  { Closing screen update as in game loop }
  UnlockScreenUpdate;
  UpdateScreen(False);

  (* prepare changes to the screen *)
  LockScreenUpdate;
  ui.screenBlank;

  TextOut(15, 3, 'cyan', 'You Died!');

  (* Write those changes to the screen *)
  UnlockScreenUpdate;
  (* only redraws the parts that have been updated *)
  UpdateScreen(False);

  (* Delete all saved data from disk *)
  file_handling.deleteGameData;

  (* prepare changes to the screen *)
  LockScreenUpdate;

  TextOut(15, 5, 'cyan', 'Killed by a ' + globalUtils.killer +
    ', after ' + IntToStr(entityList[0].moveCount) + ' moves.');

  UnlockScreenUpdate;
  UpdateScreen(False);
end;

end.
