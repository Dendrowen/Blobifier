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

height_above_strip = nozzle_to_toolhead_clearance_z + nozzle_max_start_height - 0.7;

bed_height = 38;

strip = [reach + 7, 10, 1.5];
lip = [10, 10, height_above_strip, 1.5];

block = [extrusion_to_bed + 20, strip.y + 10, bed_height + height_above_strip];

servo_pos = [20 + extrusion_to_bed - 26 - servo.y/2 - 2, 2, bed_height - servo.z - strip.z - 1 - 2];

jst_connector = [10.4, 7.5, 6.4];

bucket_size = [64, 240, 23];
bucket_wall = 2;

!base();

translate([20 + extrusion_to_bed - 27, 1, bed_height - strip.z - 1])
tray();

translate([servo_pos.x + servo.y/2, servo_pos.y + servo.y/2, servo_pos.z + servo.z])
pivot_arm();

translate([extrusion_to_bed + 20, -bucket_size.y + 120, 0])
bucket();

// %translate(servo_pos)
// servo();


module bucket(){
    union() {
        difference() {
            roundedCube(bucket_size, 5);

            translate([bucket_wall, bucket_wall, bucket_wall])
            roundedCube([bucket_size.x - bucket_wall * 2, bucket_size.y - bucket_wall * 2, bucket_size.z], 5 - bucket_wall);

            // translate([-1, -1, bucket_size[3]])
            // cube([bucket_size.x + 2, bucket_size.y - 41, bucket_size.z]);
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

module roundedCube(size, r){
    
    linear_extrude(height = size.z)
    hull() {
        for( p = [
            [r, r],
            [size.x - r, r],
            [size.x - r, size.y - r],
            [r, size.y - r]
        ]){
            translate(p)
            circle(r = r);
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

module pivot_arm() {
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
    difference() {
        union() {
            cube([21, strip.y + 8, strip.z + 1]);

            translate([0, 3, 0])
            cube([strip.x + 21, strip.y + 2, strip.z + 1]);
        }

        translate([26, 4, 1])
        cube(strip);

        translate([reach/2, servo.y/2 + 1, -1])
        hull() {
            cylinder(d = 4, h = 5);
            translate([0, 7.5, 0])
            cylinder(d = 4, h = 5);
        }
    }
}

module base() {
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

                        cube([33, block.y, 6]);
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
            translate(servo_pos)
            servo();

            // servo insertion room
            translate([servo_pos.x - 5, 2, bed_height - 16])
            cube([servo.x + 10, servo.y, 50]);

            // servo cables
            translate([servo_pos.x - 1.5, servo_pos.y + servo.y/2 - 3, -1])
            cube([5, 6, 100]);

            translate([servo_pos.x - jst_connector.x, servo.y/2 + servo_pos.y - 2, -0.01])
            cube([jst_connector.x, 4, 2]);

            // servo plug hole
            // translate([servo_pos.x, servo_pos.y + servo.y/2 - 4.5, -1])
            // cube([5, 9, 10]);

            // jst connector
            translate([servo_pos.x - jst_connector.x - 2, block.y - jst_connector.y - 1.2, -0.01])
            cube(jst_connector);
            
            translate([servo_pos.x - jst_connector.x - 1.2, servo.y/2 + servo_pos.y - 2, -0.01])
            cube([jst_connector.x - 1.6, block.y, jst_connector.z]);

            // servo mounting screws
            // translate(servo_pos)
            // for(p = servo_mounts)
            // translate([p.x, p.y, p.z - 10])
            // cylinder(d = 1, h = 11);


            // pivot room
            translate([servo_pos.x + servo.y/2, 2 + servo.y/2, bed_height - strip.z - 1 - 2 - 3])
            difference() {
                cylinder(r = 11, h = 5);

                translate([-15, -15, 0])
                cube([30, 15, 30]);
            }

            // tray room
            translate([0, 1 - 0.2, bed_height - strip.z - 1 - 0.2])
            hull() {
                cube([20 + extrusion_to_bed - 5, strip.y + 8.4, strip.z + 1.4]);
                
                translate([0, 1, 1])
                cube([20 + extrusion_to_bed - 5, strip.y + 6.4, strip.z + 1.4]);
            }
            
            translate([0, 1.8, bed_height - strip.z - 1 - 0.2])
            cube([20 + extrusion_to_bed - 5, strip.y + 6.4, 20]);

            // tray narrow part
            translate([0, 3.8, bed_height - strip.z - 1 - 0.2])
            cube([20 + extrusion_to_bed + 5, strip.y + 2.4, strip.z + 1.4]);


            // nozzle nudge
            translate([block.x, block.y/2, block.z - height_above_strip/2])
            rotate([0, 0, 45])
            cylinder(r = 1.5, h = 2);
        }
    }
}

module servo(){
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