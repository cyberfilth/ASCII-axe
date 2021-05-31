(* Handles player inventory and associated functions *)

unit player_inventory;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, StrUtils, video, entities, items, item_lookup, ui;

type
  (* Items in inventory *)
  Equipment = record
    id, useID: smallint;
    Name, description, glyph, glyphColour: shortstring;
    itemType: tItem;
    itemMaterial: tMaterial;
    (* Is the item still in the inventory *)
    inInventory: boolean;
    (* Is the item being worn or wielded *)
    equipped: boolean;
  end;

var
  inventory: array[0..9] of Equipment;

(* Initialise empty player inventory *)
procedure initialiseInventory;
(* Setup equipped items when loading a saved game *)
procedure loadEquippedItems;
(* Add to inventory *)
function addToInventory(itemNumber: smallint): boolean;
(* Remove from inventory *)
function removeFromInventory(itemNumber: smallint): boolean;
(* Display the inventory screen *)
procedure showInventory;
(* Display more information about an item *)
procedure examineInventory(selection: smallint);
(* Drop menu *)
procedure drop;
(* Drop selected item *)
procedure dropSelection(selection: smallint);
(* Quaff menu *)
procedure quaff;
(* Quaff selected item *)
procedure quaffSelection(selection: smallint);
(* Wear / Wield menu *)
procedure wield;
(* Wear / Wield selected item *)
procedure wearWieldSelection(selection: smallint);

implementation

uses
  KeyboardInput, scrInventory;

procedure initialiseInventory;

var
  i: byte;
begin
  for i := 0 to 9 do
  begin
    inventory[i].id := i;
    inventory[i].Name := 'Empty';
    inventory[i].equipped := False;
    inventory[i].description := 'x';
    inventory[i].itemType := itmEmptySlot;
    inventory[i].itemMaterial := matEmpty;
    inventory[i].glyph := 'x';
    inventory[i].glyphColour := 'x';
    inventory[i].inInventory := False;
    inventory[i].useID := 0;
  end;
end;

procedure loadEquippedItems;

var
  i: smallint;
begin
  for i := 0 to 9 do
  begin
    if (inventory[i].equipped = True) then
    begin
      (* Check for weapons *)
      //if (inventory[i].itemType = 'weapon') then
      //  ui.updateWeapon(inventory[i].Name)
      //(* Check for armour *)
      //else if (inventory[i].itemType = 'armour') then
      //  ui.updateArmour(inventory[i].Name);
    end;
  end;

end;

(* Returns TRUE if successfully added, FALSE if the inventory is full *)
function addToInventory(itemNumber: smallint): boolean;
var
  i: smallint;
begin
  Result := False;
  for i := 0 to 9 do
  begin
    if (inventory[i].Name = 'Empty') then
    begin
      itemList[itemNumber].onMap := False;
      (* Populate inventory with item description *)
      inventory[i].id := i;
      inventory[i].Name := itemList[itemNumber].itemname;
      inventory[i].description := itemList[itemNumber].itemDescription;
      inventory[i].itemType := itemList[itemNumber].itemType;
      inventory[i].itemMaterial := itemList[itemNumber].itemMaterial;
      inventory[i].useID := itemList[itemNumber].useID;
      inventory[i].glyph := itemList[itemNumber].glyph;
      inventory[i].glyphColour := itemList[itemNumber].glyphColour;
      inventory[i].inInventory := True;
      ui.displayMessage('You pick up the ' + inventory[i].Name);
      (* Set an empty flag for the item on the map, this
         gets deleted when saving the map *)
      with itemList[itemNumber] do
      begin
        itemID := itemNumber;
        itemName := 'empty';
        itemDescription := '';
        itemType := itmEmptySlot;
        itemMaterial := matEmpty;
        useID := 1;
        glyph := 'x';
        glyphColour := 'lightCyan';
        inView := False;
        posX := 1;
        posY := 1;
        onMap := False;
        discovered := False;
      end;
      Result := True;
      exit;
    end;
  end;
end;

function removeFromInventory(itemNumber: smallint): boolean;
var
  newItem: item;
  ss: shortstring;
begin
  Result := False;
  (* Check if there is already an item on the floor here *)
  if (items.containsItem(entityList[0].posX, entityList[0].posY) = False) then
    { Create an item }
  begin
    newItem.itemID := items.itemAmount;
    newItem.itemName := inventory[itemNumber].Name;
    newItem.itemDescription := inventory[itemNumber].description;
    newItem.itemType := inventory[itemNumber].itemType;
    newItem.itemMaterial := inventory[itemNumber].itemMaterial;
    newItem.useID := inventory[itemNumber].useID;
    newItem.glyph := inventory[itemNumber].glyph;
    newItem.glyphColour := inventory[itemNumber].glyphColour;
    newItem.inView := True;
    newItem.posX := entities.entityList[0].posX;
    newItem.posY := entities.entityList[0].posY;
    newItem.onMap := True;
    newItem.discovered := True;

    { Place item on the game map }
    Inc(items.itemAmount);
    Insert(newitem, itemList, itemAmount);
    WriteStr(ss, 'You drop the ', newItem.itemName);
    ui.bufferMessage(ss);

    (* Remove from inventory *)
    inventory[itemNumber].Name := 'Empty';
    inventory[itemNumber].equipped := False;
    inventory[itemNumber].description := 'x';
    inventory[itemNumber].itemType := itmEmptySlot;
    inventory[itemNumber].itemMaterial := matEmpty;
    inventory[itemNumber].glyph := 'x';
    inventory[itemNumber].glyphColour := 'x';
    inventory[itemNumber].inInventory := False;
    inventory[itemNumber].useID := 0;
    Result := True;
    (* Redraw the Drop menu *)
    drop;
  end
  else
    ui.bufferMessage('There is no room here');
end;

procedure showInventory;
begin
  { prepare changes to the screen }
  LockScreenUpdate;
  (* Clear the screen *)
  ui.screenBlank;
  (* Draw the game screen *)
  scrInventory.displayInventoryScreen;
  { Write those changes to the screen }
  UnlockScreenUpdate;
  { only redraws the parts that have been updated }
  UpdateScreen(False);
  keyboardinput.waitForInput;
end;

procedure examineInventory(selection: smallint);
var
  material: shortstring;
begin
  (* Check that the slot is not empty *)
  if (inventory[selection].inInventory = True) then
  begin
    (* Get the item material *)
    material := '';
    if (inventory[selection].itemType <> itmDrink) then
    begin
      if (inventory[selection].itemMaterial = matIron) then
        material := ' [iron]';
      if (inventory[selection].itemMaterial = matSteel) then
        material := ' [steel]';
      if (inventory[selection].itemMaterial = matWood) then
        material := ' [wooden]';
      if (inventory[selection].itemMaterial = matLeather) then
        material := ' [leather]';
    end;
    { prepare changes to the screen }
    LockScreenUpdate;
    (* Clear the name & description lines *)
    TextOut(6, 20, 'black',
      '                                                                 ');
    TextOut(6, 21, 'black',
      '                                                                 ');
    { glyph }
    TextOut(6, 20, inventory[selection].glyphColour, inventory[selection].glyph);
    { name }
    TextOut(8, 20, 'lightCyan', AnsiProperCase(inventory[selection].Name,
      StdWordDelims) + material);
    { description }
    TextOut(7, 21, 'cyan', chr(16) + ' ' + inventory[selection].description);
    { Write those changes to the screen }
    UnlockScreenUpdate;
    { only redraws the parts that have been updated }
    UpdateScreen(False);
    keyboardinput.waitForInput;
  end;
end;

procedure drop;
begin
  { prepare changes to the screen }
  LockScreenUpdate;
  (* Clear the screen *)
  ui.screenBlank;
  (* Draw the game screen *)
  scrInventory.displayDropMenu;
  { Write those changes to the screen }
  UnlockScreenUpdate;
  { only redraws the parts that have been updated }
  UpdateScreen(False);
  keyboardinput.waitForInput;
end;

procedure dropSelection(selection: smallint);
begin
  (* Check that the slot is not empty *)
  if (inventory[selection].inInventory = True) then
    removeFromInventory(selection);
end;

procedure quaff;
begin
  { prepare changes to the screen }
  LockScreenUpdate;
  (* Clear the screen *)
  ui.screenBlank;
  (* Draw the game screen *)
  scrInventory.displayQuaffMenu;
  { Write those changes to the screen }
  UnlockScreenUpdate;
  { only redraws the parts that have been updated }
  UpdateScreen(False);
  keyboardinput.waitForInput;
end;

procedure quaffSelection(selection: smallint);
begin
  (* Check that the slot is not empty *)
  if (inventory[selection].inInventory = True) and
    (inventory[selection].itemType = itmDrink) then
  begin
    item_lookup.lookupUse(inventory[selection].useID, False);
    (* Increase turn counter for this action *)
    Inc(entityList[0].moveCount);
    (* Remove from inventory *)
    inventory[selection].Name := 'Empty';
    inventory[selection].equipped := False;
    inventory[selection].description := 'x';
    inventory[selection].itemType := itmEmptySlot;
    inventory[selection].itemMaterial := matEmpty;
    inventory[selection].glyph := 'x';
    inventory[selection].glyphColour := 'x';
    inventory[selection].inInventory := False;
    inventory[selection].useID := 0;
    (* Redraw the Quaff menu *)
    quaff;
  end;
end;

procedure wield;
begin
  { prepare changes to the screen }
  LockScreenUpdate;
  (* Clear the screen *)
  ui.screenBlank;
  (* Draw the game screen *)
  scrInventory.displayWieldMenu;
  { Write those changes to the screen }
  UnlockScreenUpdate;
  { only redraws the parts that have been updated }
  UpdateScreen(False);
  keyboardinput.waitForInput;
end;

procedure wearWieldSelection(selection: smallint);
begin
  (* Check that the slot is not empty *)
  if (inventory[selection].inInventory = True) then
  begin
    (* Check that the selected item is armour or a weapon *)
    if (inventory[selection].itemType = itmWeapon) or
      (inventory[selection].itemType = itmArmour) then
    begin

(* If the item is an unequipped weapon, and the player already has a weapon equipped
         prompt the player to unequip their weapon first *)
      if (inventory[selection].equipped = False) and
        (inventory[selection].itemType = itmWeapon) and
        (entityList[0].weaponEquipped = True) then
      begin
        { prepare changes to the screen }
        LockScreenUpdate;
        (* Clear the message line *)
        TextOut(6, 20, 'black', '                                                  ');
        { Display message }
        TextOut(6, 20, 'cyan', 'You must first unequip the weapon you already hold');
        { Write those changes to the screen }
        UnlockScreenUpdate;
        { only redraws the parts that have been updated }
        UpdateScreen(False);
        KeyboardInput.waitForInput;
      end

(* If the item is unworn armour, and the player is already wearing armour
         prompt the player to unequip their armour first *)
      else if (inventory[selection].equipped = False) and
        (inventory[selection].itemType = itmArmour) and
        (entityList[0].armourEquipped = True) then
      begin
        { prepare changes to the screen }
        LockScreenUpdate;
        (* Clear the message line *)
        TextOut(6, 20, 'black', '                                                  ');
        { Display message }
        TextOut(6, 20, 'cyan', 'You must first remove the armour you already wear');
        { Write those changes to the screen }
        UnlockScreenUpdate;
        { only redraws the parts that have been updated }
        UpdateScreen(False);
        KeyboardInput.waitForInput;
      end

      (* Check whether the item is already equipped or not *)
      else if (inventory[selection].equipped = False) then
      begin
        (* Equip *)
        inventory[selection].equipped := True;
        item_lookup.lookupUse(inventory[selection].useID, False);
      end
      else
      begin
        (* Unequip *)
        inventory[selection].equipped := False;
        item_lookup.lookupUse(inventory[selection].useID, True);
      end;
      { Increment turn counter }
      Inc(entityList[0].moveCount);
      wield;
    end;
  end;
end;

end.
