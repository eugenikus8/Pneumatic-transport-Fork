![thumbnail144](https://github.com/user-attachments/assets/a9fa0ae7-8a3f-4f0b-8fe1-522f6beb6301)

Mod by Saienai<br>
https://mods.factorio.com/mod/pneumatic-transport

# Pneumatic Transport Factorio 2.0 {Fork}
#### Removes all belts and adds pneumatic in/out stations (with built in inserters) that convert any/all items into fluid-like states for transport through pipes. Alternative lore: LIQUIFY EVERYTHING!!!!

![76825a51b5a36f5e9959a69cc299f5a0b1187b22](https://github.com/user-attachments/assets/613b444c-4bc1-47fd-bc05-af2034ac571b)


![2024-11-23_002442](https://github.com/user-attachments/assets/c2c0e003-3706-4b04-bde4-0c109fb22fa7)

![2024-11-23_003502](https://github.com/user-attachments/assets/caa0f1a7-c662-4bd0-8f9d-712da7962931)
<br>Improvised 1 tube bus. Objects are liquefied and through Pneumatic outtake filtered are solidify in the appropriate industries.
<br><br>

### Alternate name:
Liquify Everything!

### Description:
Allows for sending most items through pipes instead of via belts by utilizing pneumatic in/out buildings (or liquidation / solidification buildings if that's the lore you want to follow).

Output (solidification) buildings are set as furnaces for ease of use - converting whatever is in the pipe back to solid form; Input (liquidation) however have both automatic (furnace) as well as filtered (assembler) versions to allow for both typical single-output recipes as well as mutli-output recipes.

All of these buildings will automatically transfer items to/from the attached building/chest/wagon on the opposite side to the pipe connection, and can also be interacted with via inserters if needed. See attached images for examples.

### Extra options:

    - Disable belts (on by default): removes belts from the game to force pipe-transfer for all items.
    - Disable item wagons (on by default): removes regular wagons from the game to force fluid-wagon use for all items.
    - Disable inserters (off by default): removes all inserters & loaders to force complete pipe-transfer for everything; prevents the use of direct-insertion.

### Mod compatibility:

Should work with most other mods (A&B tested).

NOTE: there seems to be some issue with K2SE, cause not yet found so for now it should be considered as incompatible.

Recommend not using any loader mods (mini-loaders, loader redux, AAI loaders, etc), especially if you decide to go full in and disable inserters.

### Extra controls:

Setting up the recipe for input / liquidation buildings can be done via the regular recipe selection window, however due to the massive number of recipes (one for each item) a simpler method of setting the recipe is provided via copying entity settings:

    - Use the copy-entity-settings shortcut (shift-right-click default) on the assembler/furnace/chest/wagon.
    - Use the paste-entity-settings shortcut (shift-left-click default) on the input/liquidation building.
    - Repeat step 2 to scroll through the list of items:

    - For assemblers/furnaces/chem-plants/etc: will scroll through all products (items only).
    - For chests: will scroll through all items in the chest.
    - For wagons: will scroll through all items and set filters in the wagon.

### Flow details:

Items are converted at a 1:10 ratio, giving pipes an average throughput of 100 items/sec for pipes of length under 200 (see factorio-pipe throughput for more details here). For most items the buildings provide a flow of 75 items/sec max, though if an item has a stack size smaller than 50 the flow may be less.

> [!WARNING]
> ### Known issues 2.0 (Space Age):
> - Quality does not support fluids. All items with quality when liquefied will be converted to normal quality
