from riscv_assembler.convert import AssemblyConverter
def assemble():
  cnv = AssemblyConverter(output_type = "t") #just text
  cnv.convert("program.s")
  # Using readlines()
  file1 = open('program/txt/program.txt', 'r')
  Lines = file1.readlines()
  file1 = open('im_data.txt', 'w')


  for line in Lines:
    decimal_representation = int(line, 2)
    hexadecimal_string = hex(decimal_representation)
    file1.write(hexadecimal_string[2:]+'\n')

  file1.close()

assemble()
