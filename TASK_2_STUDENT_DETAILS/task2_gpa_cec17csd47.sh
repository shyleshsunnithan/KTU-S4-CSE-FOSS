#!/usr/bin/env bash


## S1 ##
if [[ ! -d "StudentDetails" ]]
then
	mkdir StudentDetails
fi
cd StudentDetails
grep "CHN" S4D.txt | awk '{s=""; for (i=3; i<=NF; i++) s=s $i " "; print s }' | sed '/^L.*/d' > S4D_reg_details.txt
cd ..


## S1 ##
if [[ ! -d "s1" ]]
then
	mkdir s1
fi
cd s1
grep --no-group-separator -A3 'CHN17CS' result_CHN.txt > result_cs.txt
tr '\n' ' ' < result_cs.txt > result_no_newline.txt
sed 's/\ CHN/\nCHN/g' result_no_newline.txt > result_one_per_line.txt
cd ..


## S2 ##
if [[ ! -d "s2" ]]
then
	mkdir s2
fi
cd s2
pdftotext result_CHN2.pdf -layout
grep --no-group-separator -A3 'CHN17CS' result_CHN2.txt > result_CS.txt
tr '\n' ' ' < result_CS.txt > result_no_newline.txt
sed 's/\ CHN/\nCHN/g' result_no_newline.txt > result_one_per_line.txt
cd ..

## STORING S1|S2 RESULTS ##
printf  "SGPA OF S1\n\n" > s1/s1_result.txt
join StudentDetails/S4D_reg_details.txt s1/result_one_per_line.txt | ./compute_gpa/compute_gpa >> s1/s1_result.txt
printf  "SGPA OF S2\n\n" > s2/s2_result.txt
join StudentDetails/S4D_reg_details.txt s2/result_one_per_line.txt | ./compute_gpa/compute_gpa >> s2/s2_result.txt


## CGPA ##
foldername="cgpa"
if [[ ! -d "FOLDER" ]]
then
	mkdir "FOLDER"
fi
cd "FOLDER"
join ../s1/result_one_per_line.txt ../s2/result_one_per_line.txt > s1_s2_with_reg.txt
join ../StudentDetails/S4D_reg_details.txt s1_s2_with_reg.txt | ../compute_gpa/compute_gpa >cgpa.txt
