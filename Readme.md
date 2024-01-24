![Blobifier Render](https://raw.githubusercontent.com/Dendrowen/Blobifier/conversion_to_step/Pictures/Render_Full.png)
Do you like the Blobifier? Consider [buying me a coffee](https://www.buymeacoffee.com/dendrowen)

# 1. What is it?
The Blobifier is a small device that eliminates the need for a purgeblock, making filament swaps more quick. It does this by extruding filament onto a tray creating a blob that will get ejected into a purge-bucket.
## 1.1 Features
- Turn your filament purge waste into blobs for fewer waste and quicker purging.
- Store the blobs in a bucket then can hold up to **700 blobs!** (for the V2 350mm version)
- Automatically pause the printer once the bucket is full.
- Detect when the bucket is installed or missing.
- Shake the bucket for better dispersion of the blobs in the bucket.
- Clean your nozzle on a brass brush before resuming to print.


![Blobifier Render](https://raw.githubusercontent.com/Dendrowen/Blobifier/conversion_to_step/Pictures/Render_Base.png)

# 2. Credit where credit is due
The Macro and Nozzle Scrubber are based on a version madde by by Hernsl (hernsl#8860 on Discord). 

# 3. Who is it for?
The device is designed around a Voron V2.4 300mm, but should work for 250mm and 350mm too. This version only supports the assembly on the rear-left of the bed. If you decide to change all this, please consider contributing to the project by creating a pull request with the needed changes.

# 4. BOM
- 3 x M3x8 shsc (Mounting on the 2020 extrusion).
- 4 x M3x8 fhcs.
- 3 x M3 t-nut.
- 1 x M2x4 shsc (For the servo pivot arm).
- 2 x M2x10 self tapping screws.
- 4 x heat set inserts.
- 1 x 10x15 aluminum strip.
    - max 1.5mm thick.
    - Make sure it's thick enough to dissipate the heat from the nozzle.
- 1 x SG90 servo (and the included screws).
- 1 x omron D2F-5L sized micro switch.
- 1 x brass brush.
- 1 x 4-pin jst connector set (male + female).
- other connectors to wire it to the board.

# 5. Build instructions
## 5.1 Bucket
### 5.1.1 Printed Parts
- **Bucket_*.stl** (whichever suits your printer)
- **Shaker_*.stl** (whichever suits your toolhead)
- **Shaker_Arm_*.stl** (whichever suits your toolhead)
    - The included **Poo.stl** can be used for a multimaterial print.
### 5.1.2 Assembly
1. Insert 4 heatset inserts in the arm.
2. Screw the arm to the bucket with the *poo* being upright using 2 M3x8 fhcs screws.
3. Screw the shaker to the arm with the opening facing the bucket using 2 M3x8 fhcs screws.

## 5.2 Brush
### 5.2.1 Printed Parts
- **Brush.stl**
### 5.2.2 Assembly
1. Cut off the handle from the brass brush and insert it into the printed part. If it doesn't fit smootly, file down the brush further until it does.
2. Screw the brush down on the left bed extrusion with the brush against the rear of the bed using an M3x8 shcs and t-nut.

## 5.3 Base
### 5.3.1 Printed Parts 
- **Base.stl**
- **Tray.stl**
- **Servo_arm_*.stl** (Check which arm fits properly on your servo)
### 5.3.2 Assembly
1. Glue a piece of aluminum inside the tray. Make sure the piece of aluminum is thick enough to dissipate heat from the nozzle without melting the plastic.
2. Sand down the tray untill the top and bottom are smooth. If the aluminum pertrudes the top a bit, sand that down with it.
3. Clean up the base where the tray slides. Depending on your printers bridging capabilities you might have to file or cut some plastic away.
4. Test fit the tray in the base. Slide it in from the back. It should stick out 15mm if fully inserted. If operation isn't smooth, go back to step 2.
5. Remove the tray from the base
6. Insert the servo from above making sure the wires face the cavity meant for them and are inserted first so they come out from the bottom. It could be a tight fit, but if your printer is properly tuned you shouldn't have any trouble. Make sure you inserted it fully, you can check from the bottom.
7. Insert the microswitch in the bottom. Check if the lever is correctly oriented. Screw it down with 2 M2x10 self tapping screws. The screw holes might be hard to see, because there is an extra layer for printability.
8. Insert the 4-pin female JST connector iside the slot. If the fit is very loose, use some glue. 
9. Solder the wires from the servo and the switch to this connector. The order is less important, just keep in mind that you'll have to connect the wire to the board in the same order.
    - pin 1: VCC (Red, usually)
    - pin 2: 
        - GND from the servo (Brown, usually)
        - C from the switch (pins are marked C, NC and NO)
    - pin 3: Signal wire from servo (Orange, usually)
    - pin 4: NC from the switch
10. Connect the base to your printer with a cable of your own making. You can drill a hole in the bottom plate of your printer to feed the wire through. **Be careful not to hit any components in your electronics compartment and ALWAYS unplug your printer from the wall if you're working on the electronics!** You'll have to pick empty pins on your board. Refer to your boards documentation on which pins to use.
    - pin 1: 5V (any 5V on your board should work)
    - pin 2: GND (any GND on your board should work)
    - pin 3: An output capable pin. Most of them are.
    - pin 4: A pin with an internal pullup resistor. Most of them have.
11. Screw the base into place with 2 x M3x8 shcs and T-nuts onto the left 2020 extrusion. The tray should just slide behind your bed. You can temporarily insert the tray to verify the position.
12. Turn on your printer and include the config file found in the github. Then restart the klipper firmware.
13. run `BLOBIFIER_SERVO POS=out` in the console. You should hear your servo move.
14. Screw the servo arm onto the servo with the arm pointing towards the brush. Make sure you don't turn the servo while doing this. If you accidentally turn it, run `BLOBIFIER_SERVO POS=out` again and continue.
15. Insert the tray from the back until the hole in the servo arm becomes visible through the tray. Then screw it down with an M2x4 screw, then go back half a turn so the screw can rotate freely in the tray.
16. Test the servo a couple of times with `BLOBIFIER_SERVO POS=in` and `BLOBIFIER_SERVO POS=out`. The tray should be fully inside or outside the base. If not, try to determine why.
    - There may be too much resistance in the sliding mechanism.
    - You might have screwed the m2 screw too tight.
    - The values in the config might need adjustment (unlikely)
17. Push the switch on the base. A message that the bucket is placed should be on the screen. Then let go of the switch. A message that the bucket was removed should be on the screen.
18. Place the bucket and see if it still works. If not, the base might need slight adjustment towards the center.

# 6. Configuration
Refer to the config files comments to configure the macro to your desires.

# 7. Release notes
## version 0.3
- Add the poo icon for multicolored prints.
- Add a shaker arm to the bucket which the SB can slide into.
    - Other toolheads may be added in future releases.
- Move the brush to the right.
- Increase bucket height to 23mm.
- Add ridges to the bucket floor to help spread the blobs.
- Add a micro switch to the base bottom to detect the bucket.
- Updated BOM to include hardware for the brush
- Increased the hight of the base by 0.2mm for more support to for the tray
## version 0.2 & 0.1
- I... started making release notes with version 0.3