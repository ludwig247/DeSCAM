import argparse, wrapper as pyModule

parser = argparse.ArgumentParser(prog="RUN DESCAM", description='Link input files to DESCAM.')
parser.add_argument("FILE", nargs='+', help='SystemC-PPA file dir')

args = parser.parse_args()
parserList = list()

if args.FILE:
    parserList.append("--file")
    for x in args.FILE:
        parserList.append(str(x))

if parserList is None:
    print("{'No file was given, please give at least one file dir as an argument!'}")

else:
    pyModule.descamCheck(parserList)

