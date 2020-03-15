import json
import sys
import getopt

orange = "\033[33m"
white = "\033[0m"


def find_clock():
    with open("HLS/synthesis/solution1/solution1_data.json") as jsonfile:
        data = json.load(jsonfile)
        for RTL_ports in data["RtlPorts"]:
            if RTL_ports == "ap_clk":
                return True

        print(f"{orange}operation module is pure combinational => removing clock and reset from module ports in wrapper{white}")
        return False


def find_operation_selector():
    with open("HLS/synthesis/solution1/solution1_data.json") as jsonfile:
        data = json.load(jsonfile)
        for RTL_ports in data["RtlPorts"]:
            if RTL_ports == "active_operation":
                return True

        print(f"{orange}All operations produce same output => removing operation selector from wrapper{white}")
        return False


def remove_clk_and_reset(module_name):
    with open('RTL/' + module_name + '.vhd', 'r') as f:
        lines = f.readlines()
    with open('RTL/' + module_name + '.vhd', 'w') as f:
        for line in lines:
            if line.strip('\n') != '\t\tap_rst: in std_logic;' and \
                    line.strip('\n') != '\t\tap_clk: in std_logic;' and \
                    line.strip('\n') != '\t\tap_clk => clk,' and \
                    line.strip('\n') != '\t\tap_rst => rst,':
                f.write(line)


def remove_operation_selector(module_name):
    with open('RTL/' + module_name + '.vhd', 'r') as f:
        lines = f.readlines()
    with open('RTL/' + module_name + '.vhd', 'w') as f:
        for i, line in enumerate(lines):
            if i == len(lines) - 1:
                f.write(line)
                return
            if "active_operation: in" in lines[i + 1]:
                f.write(line.replace(";", ""))
            elif "active_operation =>" in lines[i + 1]:
                f.write(line.replace(",", ""))
            elif "active_operation" not in line:
                f.write(line)


def main(argv):
    try:
        opts, args = getopt.getopt(argv, "hf:", ["file="])
    except getopt.GetoptError:
        print('test.py -f <file>')
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print('test.py -f <file>')
            sys.exit()
        elif opt in ("-f", "--file"):
            module_name = arg
            if not find_clock():
                remove_clk_and_reset(module_name)
            if not find_operation_selector():
                remove_operation_selector(module_name)


if __name__ == '__main__':
    main(sys.argv[1:])
