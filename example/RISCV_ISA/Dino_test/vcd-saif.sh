for f in Dump_files/*.vcd; 
do f=${f%.vcd}; 
f=${f#Dump_files/}; 
vcd2saif -input Dump_files/$f.vcd -output Saif_files/$f.saif
done
