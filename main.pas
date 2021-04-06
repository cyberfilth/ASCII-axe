(* Axes, Armour & Ale - Roguelike for Linux and Windows.
   @author (Chris Hawkins)
*)

unit main;

{$mode fpc}{$H+}

interface

uses
  ui, SysUtils, KeyboardInput;

var
  (* 0 = titlescreen, 1 = game running, 2 = inventory screen, 3 = Quit menu, 4 = Game Over *)
  gameState: byte;

procedure initialise;
procedure exitApplication;

implementation

procedure initialise;
begin
  gameState := 0;
  Randomize;
  { Check if seed set as command line parameter }
  if (ParamCount = 2) then
  begin
    if (ParamStr(1) = '--seed') then
      RandSeed := StrToDWord(ParamStr(2))
    else
    begin
      { Set random seed if not specified }
      {$IFDEF Linux}
      RandSeed := RandSeed shl 8;
      {$ENDIF}
      {$IFDEF Windows}
      RandSeed := ((RandSeed shl 8) or GetProcessID);
      {$ENDIF}
    end;
  end;
  { Initialise video unit and show title screen }
  ui.setupScreen;
  { Initialise keyboard unit }
  keyboardinput.setupKeyboard;
  { wait for keyboard input }
  keyboardinput.waitForInput;
end;

procedure exitApplication;
begin
  { Shutdown keyboard unit }
  keyboardinput.shutdownKeyboard;
  { Shutdown video unit }
  ui.shutdownScreen;
  (* Clear screen and display author message *)
  //ui.exitMessage;
  Halt;
end;

end.

