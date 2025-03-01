# A4T Shaker Arm Mod

A modified version of the shaker arm and shaker to fit the A4T toolhead.

![CAD](https://github.com/user-attachments/assets/4d77f904-fb7b-457a-a653-30385fbd3def)


## Variations Against the Stealth Burner Shaker Design

1. One M3x8 SHCS screw is needed to mount the shaker on the shaker arm.  
2. The shaker and shaker arm have indentations to align themselves to each other and prevent the shaker from twisting on the shaker arm, removing the need for the second M3 screw.  
3. The shaker and shaker arm have been made slimmer in the X direction to ease clearance between the front left Z belt and the shaker when inserting and removing the bucket from the printer.


## Bill of Materials (BOM)

### Printed Parts
- **Bucket_*.stl** (whichever suits your printer and print bed) – same as the Blobifier STL’s folder  
- **Shaker_A4T.stl**  
- **Shaker_Arm_A4T.stl**
Print using standard Voron part settings

### Hardware
- Same as the Blobifier. You won’t need the third M3x8 FHCS screw.

![1](https://github.com/user-attachments/assets/6f05a15d-af81-4ebc-8741-a852df8fd3d1)

## Assembly

1. **Insert 3x M3 heat set inserts** in the shaker arm. Use an exacto knife or metal object to “level” the heat sets with the part, ensuring the inserts are flush with the surface of the arm and no excess material is oozing out.  
2. **Mount the arm to the bucket** (with the poo logo upright) using 2x M3x8 FHCS screws.  
3. **Align the shaker notches** to the arm and secure with the M3x8 SHCS screw.

![2](https://github.com/user-attachments/assets/4f14a3d1-b457-458e-9b3d-aa61dbd4ec0d)

## Calibration

Install and calibrate your shaker Z height as per the Happy Hare instructions.

- In a Voron 350, you might set `variable_shaker_arm_z` to `2mm`.  
- If the A4T is rubbing against the bottom of the shaker, increase slightly to `2.5mm` or `3mm`.  

## Video

[![Watch the video](https://img.youtube.com/vi/eVDUzT1yRBc/0.jpg)](https://youtube.com/shorts/eVDUzT1yRBc)


Happy printing!
