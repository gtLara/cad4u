rm -rf test.vcd program im_data.txt; python assemble.py program.s hex;
instruction_count=$(wc -l program/txt/program.txt | cut -d " " -f 1)
sed -i "s/parameter nInstrucoes = [0-9];/parameter nInstrucoes = $instruction_count;/g" main.v
iverilog main.v
./a.out

if [ -f "test.vcd" ]
then
    gtkwave test.vcd
else
	echo "Deu merda"
fi
