import json
import sys
import getopt

orange = "\033[33m"
white = "\033[0m"
red = "\033[31m"

allowed_options = ["sco", "mco"]


def find_clock():
    with open("HLS/synthesis/solution1/solution1_data.json") as json_file:
        data = json.load(json_file)
        for RTL_ports in data["RtlPorts"]:
            if RTL_ports == "ap_clk":
                return True

        print(f"{orange}operation module is pure combinational => removing clock and reset from module ports in wrapper{white}")
        return False


def find_operation_selector():
    with open("HLS/synthesis/solution1/solution1_data.json") as json_file:
        data = json.load(json_file)
        for RTL_ports in data["RtlPorts"]:
            if RTL_ports == "active_operation":
                return True

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


def get_timings(module_name):
    with open("HLS/synthesis/solution1/solution1_data.json") as json_file:
        data = json.load(json_file)
        latency = data["ModuleInfo"]["Metrics"][module_name + "_operations"]["Latency"]
        if "PipelineIIMin" in latency and "PipelineIIMax" in latency:
            t_min = latency["PipelineIIMin"]
            t_max = latency["PipelineIIMax"]
            return t_min, t_max
        elif "PipelineII" in latency:
            t_min = latency["PipelineII"]
            t_max = latency["PipelineII"]
            return t_min, t_max
        else:
            print(f"{red}Cannot find initiation interval!{white}")


def add_timing_to_property_macros(module_name, t_min, t_max):
    with open('Properties/' + module_name + "_macros.vhi", "a") as f:
        f.write("\n")
        f.write(f"macro t_min : unsigned := {t_min} end macro;\n")
        f.write(f"macro t_max : unsigned := {t_max} end macro;\n")


def main(argv):
    module_name = ""
    hls_option = ""
    try:
        opts, args = getopt.getopt(argv, "hf:t:", ["file=", "type="])
    except getopt.GetoptError:
        print('test.py -f <file>')
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print('test.py -f <file>')
            sys.exit()
        elif opt in ("-f", "--file"):
            module_name = arg
        elif opt in ("-t", "--type"):
            if arg not in allowed_options:
                print(f"{red}Design type not allowed! Allowed types are mco and sco.{white}")
                sys.exit()
            else:
                hls_option = arg

    if len(module_name) == 0 or len(hls_option) == 0:
        print(f"{red}File and type are required arguments. For more info use -h.{white}")
        sys.exit()

    if not find_clock():
        remove_clk_and_reset(module_name)

    if not find_operation_selector():
        print(f"{orange}All operations produce same output => removing operation selector from wrapper{white}")
        remove_operation_selector(module_name)

    t_min, t_max = get_timings(module_name)

    if int(t_min) > 1 and hls_option == "sco":
        print(f"{red}SCO-Design has operation module with initiation interval > 1. Properties can not hold for this design. Use mco option or try to fix this manually in Vivado HLS{white}")
        sys.exit()
    elif hls_option == "mco":
        add_timing_to_property_macros(module_name, t_min, t_max)


if __name__ == '__main__':
    main(sys.argv[1:])
