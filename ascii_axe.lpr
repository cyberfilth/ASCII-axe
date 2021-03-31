(*
Axes, Armour & Ale - The ASCII version
Copyright 2021 Chris Hawkins

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*)

program ascii_axe;

{$mode objfpc}{$H+}
{$IFDEF WINDOWS}
{$APPTYPE CONSOLE}
{$ENDIF}

uses                    // program doesn't use threads so remove after testing
 //
 //
 //...............
 {$IFDEF UseCThreads}cthreads,
 {$ENDIF} {$IFDEF WINDOWS}{$ENDIF}
  SysUtils,
  video,
  Keyboard,
  ui, main;


begin
  (* Initialise the display, keyboard and game variables *)
   main.initialise;


  (* UPDATE DISPLAY *)
  (* prepare changes to the screen *)
  LockScreenUpdate;

  (* draw the sidebar *)
  ui.drawSidepanel;

  (* Write those changes to the screen *)
  UnlockScreenUpdate;

  (* only redraws the parts that have been updated *)
  UpdateScreen(False);

  (* END OF UPDATE DISPLAY *)

  GetKeyEvent; (* so program doesnt exit straight away *)

end.
