(* Handles player inventory and associated functions *)

Unit player_inventory;

{$mode objfpc}{$H+}

Interface

Uses 
SysUtils, StrUtils, video, entities, items, item_lookup, ui;

Type 
  (* Items in inventory *)
  Equipment = Record
    id, useID: smallint;
    Name, description, glyph, glyphColour: shortstring;
    itemType: tItem;
    itemMaterial: tMaterial;
    (* Is the item still in the inventory *)
    inInventory: boolean;
    (* Is the item being worn or wielded *)
    equipped: boolean;
  End;

Var 
  inventory: array[0..9] Of Equipment;

(* Initialise empty player inventory *)
Procedure initialiseInventory;
(* Setup equipped items when loading a saved game *)
Procedure loadEquippedItems;
(* Add to inventory *)
Function addToInventory(itemNumber: smallint): boolean;
(* Remove from inventory *)
Function removeFromInventory(itemNumber: smallint): boolean;
(* Display the inventory screen *)
Procedure showInventory;
(* Display more information about an item *)
Procedure examineInventory(selection: byte);
(* Drop menu *)
Procedure drop;
(* Drop selected item *)
Procedure dropSelection(selection: byte);
(* Quaff menu *)
Procedure quaff;
(* Quaff selected item *)
Procedure quaffSelection(selection: byte);
(* Wear / Wield menu *)
Procedure wield;
(* Wear / Wield selected item *)
Procedure wearWieldSelection(selection: byte);

Implementation

Uses 
KeyboardInput, scrInventory;

Procedure initialiseInventory;

Var 
  i: byte;
Begin
  For i := 0 To 9 Do
    Begin
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
    End;
End;

Procedure loadEquippedItems;

Var 
  i: smallint;
Begin
  For i := 0 To 9 Do
    Begin
      If (inventory[i].equipped = True) Then
        Begin
      (* Check for weapons *)
          //if (inventory[i].itemType = 'weapon') then
          //  ui.updateWeapon(inventory[i].Name)
          //(* Check for armour *)
          //else if (inventory[i].itemType = 'armour') then
          //  ui.updateArmour(inventory[i].Name);
        End;
    End;

End;

(* Returns TRUE if successfully added, FALSE if the inventory is full *)
Function addToInventory(itemNumber: smallint): boolean;

Var 
  i: smallint;
Begin
  Result := False;
  For i := 0 To 9 Do
    Begin
      If (inventory[i].Name = 'Empty') Then
        Begin
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
      (* Remove the item from list of items on the map *)
      { Requires FPC3.2.0 or higher }
          Delete(itemList, 1, 1);
          Dec(itemAmount);
          Result := True;
          exit;
        End;
    End;
End;

(* Returns TRUE if successfully removed, FALSE if the inventory is full *)
Function removeFromInventory(itemNumber: smallint): boolean;

Var 
  newItem: item;
Begin
  Result := False;
  (* Check if there is already an item on the floor here *)
  If (items.containsItem(entityList[0].posX, entityList[0].posY) = False) Then
    { Create an item }
    Begin
      newItem.itemID := items.itemAmount;
      newItem.itemName := inventory[itemNumber].Name;
      newItem.itemDescription := inventory[itemNumber].description;
      newItem.itemType := inventory[itemNumber].itemType;
      newItem.itemMaterial := inventory[itemNumber].itemMaterial;
      newItem.useID := 1;
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
      ui.bufferMessage('You drop the ' + newItem.itemName);

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
    End
  Else
    ui.bufferMessage('There is no room here');
End;

Procedure showInventory;
Begin
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
End;

Procedure examineInventory(selection: byte);

Var 
  material: shortstring;
Begin
  (* Check that the slot is not empty *)
  If (inventory[selection].inInventory = True) Then
    Begin
    (* Get the item material *)
      material := '';
      If (inventory[selection].itemMaterial = matIron) Then
        material := ' [iron]';
      If (inventory[selection].itemMaterial = matSteel) Then
        material := ' [steel]';
      If (inventory[selection].itemMaterial = matWood) Then
        material := ' [wooden]';
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
      TextOut(8, 20, 'lightCyan', AnsiProperCase(inventory[selection].Name, StdWordDelims) +
      material);
    { description }
      TextOut(7, 21, 'cyan', chr(16) + ' ' + inventory[selection].description);
    { Write those changes to the screen }
      UnlockScreenUpdate;
    { only redraws the parts that have been updated }
      UpdateScreen(False);
      keyboardinput.waitForInput;
    End;
End;

Procedure drop;
Begin
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
End;

Procedure dropSelection(selection: byte);
Begin
  (* Check that the slot is not empty *)
  If (inventory[selection].inInventory = True) Then
    removeFromInventory(selection);
  { TODO : The 'if not' condition causes a stack trace. Will need to investigate. }
End;

Procedure quaff;
Begin
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
End;

Procedure quaffSelection(selection: byte);
Begin
  (* Check that the slot is not empty *)
  If (inventory[selection].inInventory = True) And
     (inventory[selection].itemType = itmDrink) Then
    Begin
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
    End;
End;

Procedure wield;
Begin
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
End;

Procedure wearWieldSelection(selection: byte);
Begin
  (* Check that the slot is not empty *)
  If (inventory[selection].inInventory = True) Then
    Begin
    (* Check that the selected item is armour or a weapon *)
      If (inventory[selection].itemType = itmWeapon) Or
         (inventory[selection].itemType = itmArmour) Then
        Begin

(* If the item is an unequipped weapon, and the player already has a weapon equipped
         prompt the player to unequip their weapon first *)
          If (inventory[selection].equipped = False) And
             (inventory[selection].itemType = itmWeapon) And
             (entityList[0].weaponEquipped = True) Then
            TextOut(6, 21, 'cyan', 'You must first unequip the weapon you already hold')


(* If the item is unworn armour, and the player is already wearing armour
         prompt the player to unequip their armour first *)
          Else If (inventory[selection].equipped = False) And
                  (inventory[selection].itemType = itmArmour) And
                  (entityList[0].armourEquipped = True) Then
                 TextOut(6, 21, 'cyan', 'You must first remove the armour you already wear')

      (* Check whether the item is already equipped or not *)
          Else If (inventory[selection].equipped = False) Then
                 Begin
        (* Equip *)
                   inventory[selection].equipped := True;
                   item_lookup.lookupUse(inventory[selection].useID, False);
                 End
          Else
            Begin
        (* Unequip *)
              inventory[selection].equipped := False;
              item_lookup.lookupUse(inventory[selection].useID, True);
            End;
      { Increment turn counter }
          Inc(entityList[0].moveCount);
          wield;
        End;
    End;
End;

End.
