unit scrRIP;

{$mode fpc}{$H+}

interface

uses
  SysUtils, video, ui, globalUtils, entities, file_handling;

(* Show the game over screen screen *)
procedure displayRIPscreen;
(* Draw a skull on screen *)
procedure drawSkull;
(* Draw a bat on the screen *)
procedure drawBat;

implementation

procedure displayRIPscreen;
var
  epitaph, deathMessage: shortstring;
  prefix: smallint;
begin
  (* Create a farewell message *)
  epitaph := entityList[0].race + ' the ' + entityList[0].description;
  prefix := randomRange(1, 3);
  if (prefix = 1) then
    epitaph := 'Fare thee well, ' + epitaph
  else if (prefix = 2) then
    epitaph := 'So long, ' + epitaph
  else
    epitaph := 'In Memoriam, ' + epitaph;

  (* Show which creature killed the player *)
  deathMessage := 'Killed by a ' + globalUtils.killer + ', after ' +
    IntToStr(entityList[0].moveCount) + ' moves.';


  { Closing screen update as in game loop }
  UnlockScreenUpdate;
  UpdateScreen(False);

  (* prepare changes to the screen *)
  LockScreenUpdate;

  ui.screenBlank;
  TextOut(36, 3, 'cyan', 'You Died!');
  TextOut(ui.centreX(epitaph), 4, 'cyan', epitaph);

  (* Write those changes to the screen *)
  UnlockScreenUpdate;
  (* only redraws the parts that have been updated *)
  UpdateScreen(False);
  (* Delete all saved data from disk *)
  file_handling.deleteGameData;

  (* prepare changes to the screen *)
  LockScreenUpdate;

  (* Randomly choose an image *)
  if (randomRange(1, 3) = 2) then
    drawBat
  else
    drawSkull;

  TextOut(centreX(deathMessage), 18, 'cyan', deathMessage);
  UnlockScreenUpdate;
  UpdateScreen(False);
end;

procedure drawSkull;
var
  col: shortstring;
  x: byte;
begin
  col := 'darkGrey';
  x := 32;
  TextOut(x, 5, col, '     ______');
  TextOut(x, 6, col, '  .-"      "-.');
  TextOut(x, 7, col, ' /            \');
  TextOut(x, 8, col, '|              |');
  TextOut(x, 9, col, '|,  .-.  .-.  ,|');
  TextOut(x, 10, col, '| )(__/  \__)( |');
  TextOut(x, 11, col, '|/     /\     \|');
  TextOut(x, 12, col, '(_     ^^     _)');
  TextOut(x, 13, col, ' \__|IIIIII|__/');
  TextOut(x, 14, col, '  | \IIIIII/ |');
  TextOut(x, 15, col, '  \          /');
  TextOut(x, 16, col, '   `--------`');

end;

procedure drawBat;
var
  col: shortstring;
  x: byte;
begin
  col := 'darkGrey';
  x := 32;
  TextOut(x, 10, col, '  _   ,_,   _');
  TextOut(x, 11, col, ' / `''=) (=''` \');
  TextOut(x, 12, col, '/.-.-.\ /.-.-.\');
  TextOut(x, 13, col, '`      "      `');
end;

end.
