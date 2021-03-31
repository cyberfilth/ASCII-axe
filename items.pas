(* Items and objects in the game world *)
unit items;

{$mode objfpc}{$H+}

interface

uses
  globalutils, map,
  (* Import the items *)
  ale_tankard, dagger, leather_armour1, cloth_armour1, basic_club, wine_flask;

type
  (* Item types = drink, weapon, armour, missile *)

  (* Store information about items *)
  Item = record
    (* Unique ID *)
    itemID: smallint;
    (* Item name & description *)
    itemName, itemDescription: shortstring;
    (* drink, weapon, armour, missile *)
    itemType: shortstring;
    (* Used for lookup table *)
    useID: smallint;
    (* Position on game map *)
    posX, posY: smallint;
    (* Character used to represent item on game map *)
    glyph: char;
    (* Colour of character, used in ASCII *)
    glyphColour: shortstring;
    (* Is the item in the players FoV *)
    inView: boolean;
    (* Is the item on the map *)
    onMap: boolean;
    (* Displays a message the first time item is seen *)
    discovered: boolean;
  end;

var
  itemList: array of Item;
  itemAmount, listLength: smallint;

  (* Generate list of items on the map *)
  procedure initialiseItems;
  (* Draw item on screen *)
  procedure drawItem(c, r: smallint; glyph: char; glyphColour: shortstring);
  (* Is there an item at coordinates *)
  function containsItem(x, y: smallint): boolean;
  (* Get name of item at coordinates *)
  function getItemName(x, y: smallint): shortstring;
  (* Get description of item at coordinates *)
  function getItemDescription(x, y: smallint): shortstring;
  (* Redraw all items *)
  procedure redrawItems;
  (* Execute useItem procedure *)
  procedure lookupUse(x: smallint; equipped: boolean);

implementation

procedure initialiseItems;
begin
  itemAmount := 0;
  // initialise array
  SetLength(itemList, 0);
end;

procedure drawItem(c, r: smallint; glyph: char; glyphColour: shortstring);
begin

end;

function containsItem(x, y: smallint): boolean;
begin

end;

function getItemName(x, y: smallint): shortstring;
begin

end;

function getItemDescription(x, y: smallint): shortstring;
begin

end;

procedure redrawItems;
begin

end;

procedure lookupUse(x: smallint; equipped: boolean);
begin

end;

end.

