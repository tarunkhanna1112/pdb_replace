puts ""
puts ""
puts "				********************************************************"
puts "				THIS SCRIPT REPLACES ANY RESIDUE IN THE PDB WITH ANOTHER" 
puts "				RESIDUE IN THE SAME ORIENTATION"
puts "				********************************************************"
puts ""
puts ""

puts "				WRITTEN BY: TARUN KHANNA, IMPERIAL COLLEGE LONDON,U.K."
puts ""
puts ""

puts "		ENTER THE NUMBER OF RESIDUES YOU WANT TO REPLACE"
set num [gets stdin]
puts ""

set f [open "input" "w"]

for {set i 0} {$i < $num} {incr i} {
	puts "				## INPUTS FOR RESIDUE [expr { $i + 1 }] ##"
	puts ""
	puts "		ENTER THE NAME OF THE RESIDUE YOU WANT TO REPLACE"
	set opt2($i) [gets stdin]
	puts ""

	puts "		ENTER THE NAME OF THE FILE TO REPLACE THE RESIDUE $opt2($i) WITH"
	set opt1($i) [gets stdin]
	exec ls $opt1($i)
	puts ""


	puts "		CHOOSE ANY TWO ATOMS IN THE RESISUE $opt2($i) TO ACT AS A REFERENCE FOR ORIENTATION"

	puts "		(FOR LIPIDS ITS BETTER TO CHOOSE ONE ATOM FROM THE HEAD AND OTHER FROM THE END OF THE TAIL)"
	puts "		ENTER THE FIRST ATOM (PDB NAME)"
	set opt3($i) [gets stdin]
	puts ""

	puts "		ENTER THE SECOND ATOM (PDB NAME)"
	set opt6($i) [gets stdin]
	puts ""

	puts "		DO THE SAME FOR THE REPLACING RESIDUE"

	puts "		CHOOSE ANY TWO ATOMS FROM THE FILE $opt1($i) TO ACT AS A REFERENCE FOR ORIENTATION"

	puts "		(FOR LIPIDS ITS BETTER TO CHOOSE ONE ATOM FROM THE HEAD AND OTHER FROM THE END OF THE TAIL)"
	puts "		ENTER THE FIRST ATOM (PDB NAME)"
	set opt4($i) [gets stdin]
	puts ""

	puts "		ENTER THE SECOND ATOM (PDB NAME)"
	set opt7($i) [gets stdin]
	puts ""
}

puts "		ENTER THE PDB NAME OF THE FILE CONTAING RESIDUES TO BE REPLACED"
set opt5 [gets stdin]
exec ls $opt5
puts ""

puts $f "\{ LIPID_PDB:"
for {set i 0} {$i < $num} {incr i} {
	puts $f "$opt1($i)"
}	
puts $f "\}"

puts $f "\{ LIPID_PDB_NAME:"
for {set i 0} {$i < $num} {incr i} {
	puts $f "$opt2($i)"
}	
puts $f "\}"

puts $f "\{ PIVOT_ELEM_OLD:"
for {set i 0} {$i < $num} {incr i} {
	puts $f "$opt3($i)"
}
puts $f "\}"
	
puts $f "\{ PIVOT_ELEM_NEW:"
for {set i 0} {$i < $num} {incr i} {
	puts $f "$opt4($i)"
}	
puts $f "\}"

puts $f "\{ PROTEIN_PDB: $opt5 }"

puts $f "\{ LIPID_TAILS_OLD:"
for {set i 0} {$i < $num} {incr i} {
	puts $f "$opt6($i)"
}
puts $f "\}"

puts $f  "\{ LIPID_TAILS_NEW:"	
for {set i 0} {$i < $num} {incr i} {
	puts $f "$opt7($i)"
}	
puts $f "\}"

close $f

exec tclsh lipid_replace_with_ori.tcl

#file delete input
file delete dummy
file delete dummy1

	
