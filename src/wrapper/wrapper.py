import argparse, wrapper as m

MyClass = m.main

parser = argparse.ArgumentParser(prog="RUN DESCAM", description='Link input files to DESCAM.')
parser.add_argument("exec", nargs='?', help='address to exec')
parser.add_argument("-f", "--file", nargs='+', help='source file')
parser.add_argument("-PrintITL", help="Complete set of properties in ITL", action="store_true")

args = parser.parse_args()

if args.exec:
    parserList = list(args.exec)
else:
    parserList = None

if args.file:
    parserList.append("--file")
    for x in args.file:
        parserList.append(x)
    if args.PrintITL:
        parserList.append("-PrintITL")

if parserList == None:
    val = list(input("Parse Arguments: ").split())
    m.main(val)

else:
    m.main(parserList)

# print(MyClass.getSourceFile)
# MyClass.getSourceFile()

