$fa = 5;
$fs = 0.5;

nozzle_to_toolhead_clearance_z = 1.5;

nozzle_max_start_height = 0;

servo = [23, 12.6, 30];
servo_mounts = [
    [-2.5, 6.3, 16],
    [25.5, 6.3, 16]
];
servo_pivot_point = [6.3, 6.3];

reach = 15;

plate_width = 10;

extrusion_to_bed = 60;

height_above_strip = nozzle_to_toolhead_clearance_z + nozzle_max_start_height - 0.5;

bed_height = 38;

strip = [reach + 7, 10, 1.5];
lip = [10, 10, height_above_strip, 1.5];

block = [extrusion_to_bed + 20, strip.y + 10, bed_height + height_above_strip];

servo_pos = [20 + extrusion_to_bed - 26 - servo.y/2 - 2, 2, bed_height - servo.z - strip.z - 3 - 2];

jst_connector = [12.9, 7.5, 6.4];

// bucket_size = [39, 240, 23]; // V2 250mm
bucket_size = [64, 240, 23]; // V2 300mm
// bucket_size = [89, 240, 23]; //V2 350mm
bucket_wall = 2;

brush_size = [38.5, 13.8, 5];

shaker_arm_bucket_holes = [bucket_size.z - 18 + 4.5, bucket_size.z - 18 + 13.5];
shaker_arm_toolhead_holes = [4.5, 13.5];

bucket_pos_y = 100;

switch = [7.5, 13.2, 7.5];
switch_pos = [block.x - switch.x + 0.01, block.y/2 - switch.y/2, -0.01];

toolhead = "sb";

th = [[
        "sb", [
            ["size", [71, 40]],         // footprint
            ["pos", [-35.5, -34, 0.4]], // coordinates from nozzle
            ["extend", 15]              // how far extra the clamp extends for 1. extra force, 2. Maybe a filametrix, 3. te get around objects on the toolhead
        ]
    ], [
        "ab", [
            ["size", [60,34]],
            ["pos", [-30, -25, 0.4]],
            ["extend", 15]
        ]
    ],
];

sel_th = select(th, toolhead);

// =============================================== OBJECTS ==================================

base();

tray();

pivot_arm();

bucket();

%servo();

brush();

shaker_arm(select(sel_th, "size"), select(sel_th, "pos"), select(sel_th, "extend"));

shaker(select(sel_th, "size"), select(sel_th, "pos"), select(sel_th, "extend"));

poo(select(sel_th, "pos"));

// =============================================== MODULES ==================================

module shaker(size, pos, extend){
    // render()
    translate([block.x + pos.x, pos.y, block.z])
    union() {
        difference() {
            // clamp
            translate([-4, -4, -2])
            roundedCube([extend + 10 + 0, size.y + 8, 14], 6);
            
            // th cavity
            translate([0, 0, 0])
            roundedCube([extend + 10 + 0, size.y, 14], 2);

            // right cutoff
            difference() {
                translate([extend + 0, -4, -3])
                cube([10, size.y + 8, 16]);

                // leave the screw holes
                translate([0, -pos.y- 9, -2])
                cube([18, 9, 2]);
            }

            // bottom space for base
            translate([-4, -pos.y, -3])
            cube([100, 100, 6]);

            // chamfers
            translate([extend + 0, 0, 6])
            rotate([0, 0, -45])
            cube([10, 3, 12], center = true);
            
            translate([extend + 0, size.y, 6])
            rotate([0, 0, 45])
            cube([10, 3, 12], center = true);
            
            // screw holes
            for(x = shaker_arm_toolhead_holes)
            translate([x, -pos.y - 4.5, pos.z + 0.01])
            rotate([0, 180, 0]){
                cylinder(d1 = 7,, d2 = 3.4, h = 2);
                cylinder(d = 3.4, h = 8);
            }
        }

        // // left support
        // translate([-2, 0, pos.z])
        // cube([2, sb_size.y, 7]);

        // // front brace
        // translate([-2, -2, -2])
        // cube([extend + 15, 2, 9 + pos.z]);
        
        // // rear brace
        // translate([-2, size.y, pos.z])
        // cube([extend + 15, 2, 7]);
    }
}

module shaker_arm(size, pos, extend) {
    render()
    difference() {
        translate([block.x + pos.x, -9, 0])
        union() {
            difference(){
                // unit
                hull() {
                    translate([8, 0, bucket_size.z - 18])
                    cube([-pos.x - 8, 9, 18]);

                    translate([0, 0, bucket_size.z - 10])
                    cube([18, 9, block.z - bucket_size.z + 8]);
                }

                // bucket screws
                for(z = shaker_arm_bucket_holes)
                translate([-pos.x + 0.01, 4.5, z])
                rotate([0, -90, 0]){
                    cylinder(d = 4.6, h = 4);
                    cylinder(d = 3.4, h = 8);
                }
                
                // toolhead screws
                for(x = shaker_arm_toolhead_holes)
                translate([x, 4.5, block.z - 1.99])
                rotate([0, 180, 0]){
                    cylinder(d = 4.6, h = 4);
                    cylinder(d = 3.4, h = 8);
                }
                
            }
        }
        // translate([0, -1, 0])
        // scale([1, 2, 1])
        poo(pos);
    }
}

module brush(){
    render()
    translate([145, 0, 20])
    union() {
        //brush holder
        difference() {
            cube([brush_size.x + 4, brush_size.y + 2, brush_size.z + 4]);
            hull() {
                translate([2, -0.01, 2])
                cube(brush_size);

                translate([3, -0.01, 2])
                cube([brush_size.x - 2, brush_size.y, brush_size.z + 2.01]);
            }
        }

        translate([0, brush_size.y, 0])
        difference() {
            cube([20, 20, 5]);

            translate([10, 10, -1]){
                cylinder(d = 3.4, h = 7);

                translate([0, 0, 3])
                cylinder(d = 7, h = 4);
            }
        }

    }
}

module bucket(){
    render()
    translate([extrusion_to_bed + 20, -bucket_size.y + bucket_pos_y, 0])
    union() {
        difference() {
            roundedCube(bucket_size, 5);

            translate([bucket_wall, bucket_wall, bucket_wall])
            difference() {
                roundedCube([bucket_size.x - bucket_wall * 2, bucket_size.y - bucket_wall * 2, bucket_size.z], 5 - bucket_wall);
                for(x = [0 : 10 : bucket_size.x - bucket_wall*2])
                for(y = [0 : 10 : bucket_size.y - bucket_wall*2])
                translate([x, y, 0.2])
                rotate([0, 0, (x / 10) % 2 * 90 - 45])
                cube([1.2, 10, 0.4], center = true);
            }

            for(z = shaker_arm_bucket_holes)
            translate([bucket_wall + 0.01, bucket_size.y - bucket_pos_y - 4.5, z])
            rotate([0, -90, 0]){
                cylinder(d1 = 7, d2 = 3.4, h = 2.02);
            }
        }

        translate([-20, 20, 0])
        hull() {
            cube([20, 3, bucket_size.z - 5]);

            translate([5, 0, 0])
            cube([15, 3, bucket_size.z ]);

            translate([5, 0, bucket_size.z - 5])
            rotate([-90, 0, 0])
            cylinder(r = 5, h = 3);
            
        }
    }
}

module pivot_arm() {
    render()
    translate([servo_pos.x + servo.y/2, servo_pos.y + servo.y/2, servo_pos.z + servo.z])
    difference() {
        union() {
            translate([0, 0, -3])
            difference() {
                translate([0, 0, 0.4])
                cylinder(d = 7, h = 4.4);

                servo_head();
            }
            hull() {
                cylinder(d = 7, h = 1.8);

                translate([reach/2, 0, 0])
                cylinder(d = 6, h = 1.8);
            }
        }

        cylinder(d = 2.5, h = 3);
        
        translate([0, 0, 0.8])
        cylinder(d = 5, h = 3);
        
        translate([0, 0, 0.8])
        intersection() {
            cube([5, 2.5, 0.4], center = true);
            translate([0, 0, -0.2])
            cylinder(d = 5, h = 0.4);
        }

        translate([reach/2, 0, 0])
        cylinder(d = 1.5, h = 3);
    }
}

module tray(){
    render()
    translate([20 + extrusion_to_bed - 27, 1, bed_height - strip.z - 3])
    difference() {
        union() {
            cube([21, strip.y + 8, strip.z + 3]);

            translate([0, 3, 0])
            cube([strip.x + 21, strip.y + 2, strip.z + 3]);
        }

        translate([26, 4, 3])
        cube(strip);

        translate([reach/2, servo.y/2 + 1, -1]){
            hull() {
                cylinder(d = 2.4, h = 7);
                translate([0, 7.5, 0])
                cylinder(d = 2.4, h = 7);
            }
            
            translate([0, 0, 2])
            hull() {
                cylinder(d = 4, h = 7);
                translate([0, 7.5, 0])
                cylinder(d = 4, h = 7);
            }

        }
    }
}

module poo(pos) {
    render()
    color("BROWN")
    translate([block.x + pos.x/2 - 7, -8, block.z - 24])
    rotate([90, 0, 0])
    linear_extrude(height = 1)
    scale([0.08, 0.08])
    import("poo.svg");
}

module base() {
    render()
    union() {
        // extrusion mount
        difference() {
            union() {
                cube([block.x, block.y, 6]);

                translate([block.x - servo.x - 20, 0, 0])
                cube([servo.x + 20, block.y, block.z]);

                difference() {
                    hull() {
                        translate([0, -20, 0])
                        cube([20, block.y + 40, 6]);

                        cube([31, block.y, 6]);
                    }

                    for(y = [-10, block.y + 10])
                    translate([10, y, -1]){
                        cylinder(d = 3.5, h = 8);
                        translate([0, 0, 3])
                        cylinder(d = 7, h = 6);
                    }
                }

                hull(){
                    translate([20, 0, 0])
                    cube([40, block.y, 6]);

                    translate([40, 0, 0])
                    cube([1, block.y, 20]);
                }
            }
            

            // servo cavity
            servo();

            // servo insertion room
            translate([servo_pos.x - 5, 2, bed_height - servo.z + 10])
            cube([servo.x + 10, servo.y, 50]);

            // servo cables
            translate([servo_pos.x - 1.5, servo_pos.y + servo.y/2 - 3, -1])
            cube([5, 6, 100]);

            translate([servo_pos.x - jst_connector.x, servo.y/2 + servo_pos.y - 2, -0.01])
            cube([jst_connector.x, 4, 2]);

            translate([servo_pos.x + servo.x, block.y/2 - (switch.y - 1)/2, -0.01])
            cube([100, switch.y - 1, switch.z]);
            
            translate([servo_pos.x, servo_pos.y + 1, -0.01])
            cube([100, servo.y - 2, switch.z]);

            // jst connector
            translate([servo_pos.x - jst_connector.x - 2, block.y - jst_connector.y - 1.2, -0.01])
            cube(jst_connector);
            
            translate([servo_pos.x - jst_connector.x - 1.2, servo.y/2 + servo_pos.y - 2, -0.01])
            cube([jst_connector.x - 1.6, block.y, jst_connector.z]);

            // pivot room
            translate([servo_pos.x + servo.y/2, 2 + servo.y/2, bed_height - strip.z - 3 - 2 - 3])
            difference() {
                cylinder(r = 11, h = 5);

                translate([-15, -15, 0])
                cube([30, 15, 30]);
            }

            // tray room
            translate([0, 1 - 0.2, bed_height - strip.z - 3 - 0.2])
            hull() {
                cube([20 + extrusion_to_bed - 5, strip.y + 8.4, strip.z + 3.4]);
                
                translate([0, 1, 1])
                cube([20 + extrusion_to_bed - 5, strip.y + 6.4, strip.z + 3.4]);
            }

            // tray narrow part
            translate([0, 3.8, bed_height - strip.z - 3 - 0.2])
            cube([20 + extrusion_to_bed + 5, strip.y + 2.4, strip.z + 3.4]);


            // nozzle nudge
            translate([block.x - 1.5, block.y/2 - strip.y/2 - 1.2, block.z - height_above_strip])
            cube([2, strip.y + 2.4, 2]);

            // switch
            translate(switch_pos)
            cube(switch);

            // screw holes for switch
            translate(switch_pos)
            for(p = [[2, 3.3], [2, 9.9]])
            translate([p.x, p.y, switch.z + 0.2])
            cylinder(d = 1.5, h = 5);
            
        }
    }
}

module servo(){
    render()
    translate(servo_pos)
    union(){
        cube([servo.x, servo.y, 22.6]);

        translate([-5, 0, servo_mounts[0].z])
        cube([servo.x + 10, servo.y, 2.6]);

        translate([servo.y/2, servo.y/2, 22.6])
        cylinder(d = servo.y, h = 4.5);

        translate([servo.y/2, servo.y/2, servo.z - 4])
        cylinder(d = 5, h = 4);
    }
}

// =============================================== FUNCTIONS ================================
function select(dict, key) = dict[search([key], dict)[0]][1];


// ======================================= HELPERS MODULES ==================================

module roundedCube(size, r){
    
    // linear_extrude(height = size.z)
    hull() {
        for( p = [
            [r, r],
            [size.x - r, r],
            [size.x - r, size.y - r],
            [r, size.y - r]
        ]){
            translate(p)
            cylinder(r = r, h = size.z);
        }
    }
}

module servo_head() {
    union() {
        for(a = [0 : 360/21 : 359])
        rotate([0, 0, a])
        translate([2.35, 0, 0])
        cylinder(r = 0.35, h = 3, $fs = 0.2);

        cylinder(d = 4.7, h = 3);
    }
}