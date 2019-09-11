//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 9/19/18.
//

#include "CommandLineProcess.h"


// main object of this formatter is to adjust the spacing when help command is executed
class MyFormatter : public CLI::Formatter {
public:
    MyFormatter() : Formatter() {}
};

namespace SCAM {

    CommandLineProcess::CommandLineProcess(int argc, const char **argv) {
        commandLineInitialize();
        commandLineRead(argc, argv);
    }

    const std::string &CommandLineProcess::getSourceFile() const {
        return this->sourceFile;
    }

    const std::string &CommandLineProcess::getOutputDirectory() const {
        return this->outputDirectory;
    }

    const std::list<std::string> &CommandLineProcess::getActivePlugins() const {
        return this->activePlugins;
    }

    void CommandLineProcess::commandLineInitialize() {
        app = new CLI::App("-- SCAM tool --");
        // we will need this to show the options available for each plugin
        app->set_help_all_flag("--help-all", "Show all help");
        // adjusting the spacing when help command is executed
        auto fmt = std::make_shared<MyFormatter>();
        fmt->column_width(40);
        app->formatter(fmt);

        // adding a flag    //if add_flag used with a bool variable then it only takes a true or false value regardless of how many times it was used
//        app->add_flag("-C,--CLANG", this->usingCLANG, "Use CLANG to compile the source file");

        // option for input source file (can't keep the positional option because it's getting mixed up with other subCommands and options)
//        app->add_option("-f,--file", this->sourceFile, "Source File")->required()->group("FILE");//option "file" without -/-- makes it positional in the commandline
        app->add_option("-f,--file", this->sourceFile, "Source File")->group("FILE");//option "file" without -/-- makes it positional in the commandline
        app->get_option("--file")->type_name("{.h .cpp}");

        // option for output directory subcommand and its following text referring to the directory
        app->add_option("-o,--output", this->outputDirectory, "Output Directory");
        app->get_option("--output")->type_name("{directory}");

        // option for optimization level
//        app->add_set("-l,--level", this->optimizeLevel, {OptimizeLevel::High, OptimizeLevel::Medium, OptimizeLevel::Low}, "Optimization level settings")
//                ->type_name("{0=High, 1=Medium, 2=Low}");

        // add plugins as subcommands and their options as flags
        std::vector<std::string> plugins = split(PLUGIN_NAMES, ';');
        std::vector<std::string> pluginsDescriptions = split(PLUGIN_DESCRIPTIONS, ';');
        for (int i = 0; i < plugins.size(); ++i) {
            app->add_subcommand("-"+plugins[i], pluginsDescriptions[i]);
        }
        std::vector<std::string> pluginOptions = split(OPTION_NAMES, ';');
        std::vector<std::string> pluginOptionsDescriptions = split(OPTION_DESCRIPTIONS, ';');
        for (int i = 0; i < pluginOptions.size(); i=i+2) {
            app->get_subcommand("-"+pluginOptions[i])->add_flag("--"+pluginOptions[i+1], pluginOptionsDescriptions[i+1]);
        }
    }

    void CommandLineProcess::commandLineRead(int argc, const char **argv) {
        try {
            app->parse(argc, argv);
        } catch (const CLI::ParseError &e) {
            app->exit(e);
            exit(0);
        }

        //If commandline only includes the tool, so print help
        if (argc == 1) {
            std::cout << app->help();
            exit(0);
        }

        //don't process source file and output directory in these cases
        if (app->count("--help") || app->count("--help-all"))
            exit(0);

        //don't go further without a source file
        if (!app->count("--file")) {
            std::cout << "Source file is required\n"
                      << "Run with --help for more information.\n";
            exit(0);
        }

        //Manage passed plugins
        std::vector<std::string> plugins = split(PLUGIN_NAMES, ';');
        for (const auto &plugin : plugins) {
            if (app->get_subcommand("-" + plugin)->parsed()) {
                if (app->get_subcommand("-" + plugin)->count("--help") ||
                    app->get_subcommand("-" + plugin)->count("--help-all"))
                    exit(0);

                this->activePlugins.emplace_back(plugin);
                CommandLineParameter::setPluginParameter(plugin, true);
            }
        }

        //Manage passed plugin's options
        std::vector<std::string> pluginsOptions = split(OPTION_NAMES, ';');
        for (int i = 0; i < pluginsOptions.size(); i = i + 2) {
            if (app->get_subcommand("-" + pluginsOptions[i])->parsed()) {
                if (app->get_subcommand("-" + pluginsOptions[i])->count("--" + pluginsOptions[i + 1]) > 0) {
                    CommandLineParameter::setPluginOptionParameter(pluginsOptions[i], pluginsOptions[i + 1], true);
                }
            }
        }

        //Manage Source File
        if (!isSourceFile(this->sourceFile))
            throw std::runtime_error("Unknown Source File: " + this->sourceFile);


        //Manage Output Directory
        if (app->count("--output")) {
            if (!isDirectory(this->outputDirectory))
                throw std::runtime_error("Unknown Output Directory: " + this->outputDirectory);
            else
                createOutputDirectory(this->outputDirectory);
        }
    }
}