unit scrRIP;

{$mode fpc}{$H+}

interface

uses
  video, ui, KeyboardInput;

(* Show the game over screen screen *)
procedure displayRIPscreen;

implementation

procedure displayRIPscreen;
begin
  (* prepare changes to the screen *)
  LockScreenUpdate;
  ui.screenBlank;

  TextOut(15, 3, 'cyan', 'You Died!');

  (* Write those changes to the screen *)
  UnlockScreenUpdate;
  (* only redraws the parts that have been updated *)
  UpdateScreen(False);
  KeyboardInput.waitForInput;
end;

end.

