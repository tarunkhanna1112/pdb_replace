proc lipid_remove {} {

	package require math::linearalgebra

	# REMOVE AND THEN REPLACE

	package require math::linearalgebra

	set inp [open "input" "r"]
	set mn [read $inp]
	close $inp

	set pdb [lindex $mn 4 1]

	set f [open "$pdb" "r"]
	set data1 [read $f]
	close $f

	set h [open "lipids_replace.pdb" "w"]

	# space variables

	set old_res -99
	set new_res 99

	set p(1) "   "
	set p(2) "  "
	set p(3) " "
	set p(4) ""
	
	set p1(1) "    "
	set p1(2) "   "
	set p1(3) "  "
	set p1(4) " "
	set p1(5) ""

	set c(4) "    "
	set c(5) "   "
	set c(6) "  "
	set c(7) " "
	set c(8) ""

	set sat(1) "  "
	set sat(2) " "
	set sat(3) ""
	set sat(4) ""

	set ic(1) " "
	set ic(2) " "
	set ic(3) " "
	set ic(4) ""
	
	set satn(1) "   "
	set satn(2) "  "
	set satn(3) " "
	set satn(4) " "

	set k 0

	set next 0
	

	while { $k < [llength $data1] } {
		set term [lindex $data1 $k]
		set t1 [string range $term 0 5]
		if { [lindex $data1 $k] == "ATOM" || $t1 == "HETATM" } {
			if { $t1 == "HETATM" } {
				set sterm [string length $term]
				if { $sterm > 6 } {
					set shift 1
					set rn1 $term 
					set srn1 [string length $rn1]
					set rnum [string range $rn1 6 $srn1]
					set srn1 5
					set ft ""
				} else {
						set shift 0
						set rn1 [lindex $data1 [expr { $k + 1 }]]
						set rnum $rn1
						set srn1 [string length $rn1]
						set ft "HETATM"
				}
			} else { 
					set shift 0
					set rn1 [lindex $data1 [expr { $k + 1 }]]
					set srn1 [string length $rn1]
					set ft "ATOM  "
			}
		
			set atype [lindex $data1 [expr { $k + 2 - $shift}]]
			set satype [string length $atype]

			if { $satype > 5} {
				set shift2 1
				set at1 [lindex $data1 [expr { $k + 2 - $shift }]]		
				set sat1 4
				set resn ""
				set sresn 4
			} else {
				set shift2 0
				set at1 [lindex $data1 [expr { $k + 2 - $shift }]]		
				set sat1 [string length $at1]
				set resn [lindex $data1 [expr { $k + 3 - $shift}]]
			}
				set chain_id [lindex $data1 [expr { $k + 4 - $shift - $shift2}]]
				set schain_id [string length $chain_id]
					if { $schain_id > 1 } {
						set shift1 1
						set an1 [lindex $data1 [expr { $k + 4 - $shift - $shift2 }]]
						set san1 4
						set cn ""
					} else { 
						set cn [lindex $data1 [expr { $k + 4 - $shift - $shift2  }]]
						set an1 [lindex $data1 [expr { $k + 5 -$shift - $shift2 }]]
						set san1 [string length $an1]
						set shift1 0
					}

				set new_res $an1

				set x1 [lindex $data1 [expr { $k + 6 - $shift - $shift1 -$shift2}]]
				set sx1 [string length $x1]SQD
				if { $sx1 > 8 } {
					set shift3 1
					set t 0
					while { [string range $x1 $t $t] != "." } {
							incr t
					}
					set corx [string range $x1 0 [expr { $t + 3 }]]
					set cory [string range $x1 [expr { $t + 3 }] end]
					set sx1 [string length [string range $x1 0 [expr { $t + 3 }]]]
					set y1 ""
					set sy1 8
					set z1 [lindex $data1 [expr { $k + 8 - $shift -$shift1 - $shift2 - $shift3}]] 
					set z1 [format "%.3f" [expr { $z1 - 0.0 }]]
					set sz1 [string length $z1]
				} else { 
					set shift3 0
					set x1 [format "%.3f" [expr { $x1 - 0.0 }]]
					set corx $x1
					set sx1 [string length $x1]
					set y1 [lindex $data1 [expr { $k + 7 - $shift -$shift1 - $shift2 - $shift3}]]
					set cory $y1 
					set sy1 [string length $y1]
					if { $sy1 > 8 } {
						set shift4 1
						set t 0
						while { [string range $y1 $t $t] != "." } {
							incr t
						}
						set cory [string range $y1 0 [expr { $t + 3 }]]
						set corz [string range $y1 [expr { $t + 3 }] end]
						set sy1 [string length [string range $y1 0 [expr { $t + 3 }]]]
						set z1 ""
						set sz1 8
					} else {
						set shift4 0
						set y1 [format "%.3f" [expr { $y1 - 0.0 }]]
						set cory $y1
						set sy1 [string length $y1]
						set z1 [lindex $data1 [expr { $k + 8 - $shift -$shift1 - $shift2 - $shift3 - $shift4}]] 
						set corz $z1
						set z1 [format "%.3f" [expr { $z1 - 0.0 }]]
						
						set sz1 [string length $z1]
					}
				}

				set t 0
				set count 0
				set countt 0

				while { $t < [llength [lindex $mn 1]] } {
					if { $resn == [lindex $mn 1 $t] && $at1 == [lindex $mn 2 $t]} {
						incr count
						set place $t
					}
					incr t
				}

				set t 0
				while { $t < [llength [lindex $mn 1]] } {
					if { $resn == [lindex $mn 1 $t] && $at1 == [lindex $mn 5 $t]} {
						incr countt
					}
					incr t
				}
		
				if { $count != 0 } {
					set headx $corx
					set heady $cory
					set headz $corz
					incr next
				}

				if { $countt != 0 } {	
					set tailx $corx
					set taily $cory
					set tailz $corz
					incr next
				}

				if { $next == 2 } {
					set next 0

					set start $rnum
	
					puts "			**** REPLACING THE LIPID ****"

					set npdb "[lindex $mn 0 $place]"
					set m [open "$npdb" "r"]
					set rpdb [read $m]
					close $m

					set k2 0

					while { $k2 < [llength $rpdb] } {
						if { [lindex $rpdb $k2] == [lindex $mn 3 $place] } {
							set xr [lindex $rpdb [expr { $k2 + 4 }]]
							set yr [lindex $rpdb [expr { $k2 + 5 }]]
							set zr [lindex $rpdb [expr { $k2 + 6 }]]
						}
						incr k2 
					}

					set xorigin [expr { $xr - $headx }]
					set yorigin [expr { $yr - $heady }]
					set zorigin [expr { $zr - $headz }]
			
					# GETTING THE RIGHT ORIENTATION OF THE LIPID :: SIMILAR TO THE LIPID BEING REPLACED

					set old_vec [list [expr { $headx - $tailx }] [expr { $heady - $taily }] [expr { $headz - $tailz }]]

					set k2 0 
	
					while { $k2 < [llength $rpdb] } {
						if { [lindex $rpdb $k2] == "HETATM" } {

							set at1 [lindex $rpdb [expr { $k2 + 2 }]]

							if { $at1 == [lindex $mn 3 $place] } {
								set nheadx [lindex $rpdb [expr { $k2 + 6 }]]
								set nheadx [format "%.3f" [expr { $nheadx - $xorigin }]]
							
								set nheady [lindex $rpdb [expr { $k2 + 7 }]] 
								set nheady [format "%.3f" [expr { $nheady - $yorigin }]]
								

								set nheadz [lindex $rpdb [expr { $k2 + 8 }]] 
								set nheadz [format "%.3f" [expr { $nheadz - $zorigin }]]
							}
								
							if { $at1 == [lindex $mn 6 $place] } {
								set ntailx [lindex $rpdb [expr { $k2 + 6 }]]
								set ntailx [format "%.3f" [expr { $ntailx - $xorigin }]]
							
								set ntaily [lindex $rpdb [expr { $k2 + 7 }]] 
								set ntaily [format "%.3f" [expr { $ntaily - $yorigin }]]
								

								set ntailz [lindex $rpdb [expr { $k2 + 8 }]] 
								set ntailz [format "%.3f" [expr { $ntailz - $zorigin }]]
							}
						}
						incr k2
					}
					set new_vec [list [expr { $nheadx - $ntailx }] [expr { $nheady - $ntaily }] [expr { $nheadz - $ntailz }]]

					set angle [::math::linearalgebra::dotproduct $old_vec $new_vec]
					set normal [::math::linearalgebra::crossproduct $old_vec $new_vec]
					set normal [::math::linearalgebra::unitLengthVector $normal]

					set dum1 [open "dummy1" "w"]
					puts $dum1 "$normal"
					close $dum1

					set dum1 [open "dummy1" "r"]
					set du [read $dum1]
					close $dum1

					# ROTATION OF THE TAIL ABOUT THE ORIGIN AND SO IS THE OTHER ATOMS IN THE RESIDUE

					set u [lindex $du 0]
					set v [lindex $du 1]
					set w [lindex $du 2]
					set u2 [expr { $u * $u }]
					set v2 [expr { $v * $v }]
					set w2 [expr { $w * $w }]
					set l [expr { $u2 + $v2 + $w2 }]

					set rl [expr { sqrt($l) }]
	
					set theta [expr { ($angle * 3.14 * 1.0) / 180.0 }]

					set a11 [expr { ($u2 + (($v2 + $w2) * cos($theta))) / $l } ]
					set a12 [expr { ((($u*$v)*(1-cos($theta))) - ($w * $rl * sin($theta))) / $l }]
					set a13 [expr { ((($u*$w)*(1-cos($theta))) + ($v * $rl * sin($theta))) / $l }]
					set a21 [expr { ((($u*$v)*(1-cos($theta))) + ($w * $rl * sin($theta))) / $l }]
					set a22 [expr { ($v2 + (($u2 + $w2) * cos($theta))) / $l }]
					set a23 [expr { ((($v*$w)*(1-cos($theta))) - ($u * $rl * sin($theta))) / $l }]
					set a31 [expr { ((($u*$w)*(1-cos($theta))) - ($v * $rl * sin($theta))) / $l }]
					set a32 [expr { ((($v*$w)*(1-cos($theta))) + ($u * $rl * sin($theta))) / $l }]
					set a33 [expr { ($w2 + (($u2 + $v2) * cos($theta))) / $l }]

					set row1 [list $a11 $a12 $a13]
					set row2 [list $a21 $a22 $a23]
					set row3 [list $a31 $a32 $a33]
					set tr [list $row1 $row2 $row3]

					#puts "$normal"
					#puts "$angle" 
						
					set k2 0

					while { $k2 < [llength $rpdb] } {
						if { [lindex $rpdb $k2] == "HETATM" } {
							set rn1 $start
							set srn1 [string length $rn1]

							set at1 [lindex $rpdb [expr { $k2 + 2 }]]
							set sat1 [string length $at1]

							#set an1 [lindex $rpdb [expr { $k2 + 5 }]]
							#set san1 [string length $an1]

							set x1 [lindex $rpdb [expr { $k2 + 6 }]]
							set x1 [expr { $x1 - $xorigin }]
							set x1 [expr { $nheadx - $x1 }]

							set y1 [lindex $rpdb [expr { $k2 + 7 }]] 
							set y1 [expr { $y1 - $yorigin }]
							set y1 [expr { $nheady - $y1 }]

							set z1 [lindex $rpdb [expr { $k2 + 8 }]] 
							set z1 [expr { $z1 - $zorigin }]
							set z1 [expr { $nheadz - $z1 }]
		
							#set R [expr { sqrt(($x1*$x1) + ($y1*$y1) + ($z1*$z1)) }]

							set coord [list $x1 $y1 $z1]
							#set coord [::math::linearalgebra::unitLengthVector $coord]
							set tcoord [::math::linearalgebra::matmul $coord $tr]

							set dum [open "dummy" "w"]
	
							puts $dum "$tcoord"

							close $dum

							set dum [open "dummy" "r"]
							set dvar [read $dum]
							close $dum

							set x1 [format "%.3f" [expr { $nheadx - [lindex $dvar 0] }]]
							#set x1 [format "%.3f" [lindex $dvar 0]]
							set sx1 [string length $x1]

							set y1 [format "%.3f" [expr { $nheady - [lindex $dvar 1] }]]
							#set y1 [format "%.3f" [lindex $dvar 1]]
							set sy1 [string length $y1]

							set z1 [format "%.3f" [expr { $nheadz - [lindex $dvar 2] }]]
							#set z1 [format "%.3f" [lindex $dvar 2]]
							set sz1 [string length $z1]

							set resn [lindex $rpdb [expr { $k2 + 3 }]]
							set sresn [string length [lindex $rpdb [expr { $k2 + 3 }]]]
							incr start
				
							puts $h "HETATM$p1($srn1)$rn1 $ic($sat1)$at1$sat($sat1)$p($sresn)$resn $cn$p($san1)$an1    $c($sx1)$x1$c($sy1)$y1$c($sz1)$z1  1.00  0.00           [lindex $rpdb [expr { $k2 + 11 }]]"
						}
				incr k2
				}
			puts $h "TER"
			set old_res $new_res
			}
		}
		incr k
	}
	puts $h "END"
	close $h	
}

proc lipid_insert {} {
	package require math::linearalgebra

	set inp [open "input" "r"]
	set mn [read $inp]
	close $inp

	set pdb [lindex $mn 4 1]

	set f [open "$pdb" "r"]
	set data1 [read $f]
	close $f

	set h [open "lipids_replace.pdb" "r"]
	set data2 [read $h]
	close $h

	set h1 [open "dummy" "w"]

	set g [open "PS2_diff_lipids.pdb" "w"]

	# space variables

	set p(1) "   "
	set p(2) "  "
	set p(3) " "
	set p(4) ""
	
	set p1(1) "    "
	set p1(2) "   "
	set p1(3) "  "
	set p1(4) " "
	set p1(5) ""

	set c(4) "    "
	set c(5) "   "
	set c(6) "  "
	set c(7) " "
	set c(8) ""

	set sat(1) "  "
	set sat(2) " "
	set sat(3) ""
	set sat(4) ""

	set ic(1) " "
	set ic(2) " "
	set ic(3) " "
	set ic(4) ""
	
	set satn(1) "   "
	set satn(2) "  "
	set satn(3) " "
	set satn(4) " "

	# ************* GET RID OF THESE VARIABLES IN FUTURE ******************

	set xori 0.0
	set yori 0.0
	set zori 0.0

	set k 0

	while { $k < [llength $data1] } {
		set term [lindex $data1 $k]
		set t1 [string range $term 0 5]
		if { $term == "TER" } {
			puts $h "TER"
		}
		if { [lindex $data1 $k] == "ATOM" || $t1 == "HETATM" } {
			if { $t1 == "HETATM" } {
				set sterm [string length $term]
				if { $sterm > 6 } {
					set shift 1
					set rn1 $term
					set srn1 5
					set ft ""
				} else {
						set shift 0
						set rn1 [lindex $data1 [expr { $k + 1 }]]
						set srn1 [string length $rn1]
						set ft "HETATM"
				}
			} else { 
					set shift 0
					set rn1 [lindex $data1 [expr { $k + 1 }]]
					set srn1 [string length $rn1]
					set ft "ATOM  "
			}
		
			set atype [lindex $data1 [expr { $k + 2 - $shift}]]
			set satype [string length $atype]

			if { $satype > 5} {
				set shift2 1
				set at1 [lindex $data1 [expr { $k + 2 - $shift }]]		
				set sat1 4
				set resn ""
				set sresn 4
			} else {
				set shift2 0
				set at1 [lindex $data1 [expr { $k + 2 - $shift }]]		
				set sat1 [string length $at1]
				set resn [lindex $data1 [expr { $k + 3 - $shift}]]
				set sresn [string length $resn]
			}			

			set t 0
			set count 0
			set place 0

			while { $t < [llength [lindex $mn 1]] } {
				if { $resn == [lindex $mn 1 $t] } {
					incr count
					set place $t
				}
				incr t
			}

			if { $count == 0 } {

				set chain_id [lindex $data1 [expr { $k + 4 - $shift - $shift2}]]
				set schain_id [string length $chain_id]
				if { $schain_id > 1 } {
					set shift1 1
					set an1 [lindex $data1 [expr { $k + 4 - $shift - $shift2 }]]
					set san1 4
					set cn ""
				} else { 
					set cn [lindex $data1 [expr { $k + 4 - $shift - $shift2  }]]
					set an1 [lindex $data1 [expr { $k + 5 -$shift - $shift2 }]]
					set san1 [string length $an1]
					set shift1 0
				}

				set x1 [lindex $data1 [expr { $k + 6 - $shift - $shift1 -$shift2}]]
				set sx1 [string length $x1]
				if { $sx1 > 8 } {
					set shift3 1
					set t 0
					while { [string range $x1 $t $t] != "." } {
						incr t
					}
					set corx [string range $x1 0 [expr { $t + 3 }]]
					set cory [string range $x1 [expr { $t + 3 }] end]
					set sx1 [string length [string range $x1 0 [expr { $t + 3 }]]]
					set y1 ""
					set sy1 8
					set z1 [lindex $data1 [expr { $k + 8 - $shift -$shift1 - $shift2 - $shift3}]] 
					set z1 [format "%.3f" [expr { $z1 - $zori }]]
					set sz1 [string length $z1]
				} else { 
					set shift3 0
					set x1 [format "%.3f" [expr { $x1 - $xori }]]
					set sx1 [string length $x1]
					set y1 [lindex $data1 [expr { $k + 7 - $shift -$shift1 - $shift2 - $shift3}]] 
					set sy1 [string length $y1]
					if { $sy1 > 8 } {
						set shift4 1
						set t 0
						while { [string range $y1 $t $t] != "." } {
							incr t
						}
						set cory [string range $y1 0 [expr { $t + 3 }]]
						set corz [string range $y1 [expr { $t + 3 }] end]
						set sy1 [string length [string range $y1 0 [expr { $t + 3 }]]]
						set z1 ""
						set sz1 8
					} else {
						set shift4 0
						set y1 [format "%.3f" [expr { $y1 - $yori }]]
						set sy1 [string length $y1]
						set z1 [lindex $data1 [expr { $k + 8 - $shift -$shift1 - $shift2 - $shift3 - $shift4}]] 
						set z1 [format "%.3f" [expr { $z1 - $zori }]]
						set sz1 [string length $z1]
					}
				}
				if { [string length [lindex $data1 [expr { $k + 9 - $shift -$shift1 - $shift2 - $shift3 - $shift4}]]] > 5 } {
					set shift5 1
				} else {
					set shift5 0
				}
		
				puts $h1 "$ft$p1($srn1)$rn1 $ic($sat1)$at1$sat($sat1)$p($sresn)$resn $cn$p($san1)$an1    $c($sx1)$x1$c($sy1)$y1$c($sz1)$z1  1.00  0.00           [lindex $data1 [expr { $k + 11 - $shift - $shift1 - $shift2 - $shift3 - $shift4 - $shift5 }]]"
			}
		}
		incr k
	}
	puts $h1 "TER"
	close $h1

	# COMBINING THE TWO PDB FILES

	set h1 [open "dummy" "r"]
	set data3 [read $h1]
	close $h1

	set data4 $data3$data2
	puts $g "$data4"
	close $g
}	
lipid_remove
lipid_insert
