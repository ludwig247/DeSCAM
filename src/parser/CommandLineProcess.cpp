//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 9/19/18.
//

#include "CommandLineProcess.h"
#include "FatalError.h"
#include "Logger/Logger.h"

// main object of this formatter is to adjust the spacing when help command is executed
class MyFormatter : public CLI::Formatter {
public:
    MyFormatter() : Formatter() {}
};

namespace DESCAM {

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

    const std::set<std::string>& CommandLineProcess::getOptimizeOptions() const {
        return this->optimizeOptions;
    }

    void CommandLineProcess::commandLineInitialize() {
        app = new CLI::App("-- DESCAM tool --");
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
        app->add_option("-f,--file", this->sourceFile, "Source File")->group(
                "FILE");//option "file" without -/-- makes it positional in the commandline
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
            app->add_subcommand("-" + plugins[i], pluginsDescriptions[i]);
        }
        std::vector<std::string> pluginOptions = split(OPTION_NAMES, ';');
        std::vector<std::string> pluginOptionsDescriptions = split(OPTION_DESCRIPTIONS, ';');
        for (int i = 0; i < pluginOptions.size(); i = i + 2) {
            app->get_subcommand("-" + pluginOptions[i])->add_flag("--" + pluginOptions[i + 1],
                                                                  pluginOptionsDescriptions[i + 1]);
        }
        // add optimize as a subcommand and its options as flags
       // app->add_subcommand("-Optimize", "Perform CFG optimizations");
        app->add_subcommand("-Optimize", "Perform CFG optimizations")->group("Module optimization");
        auto optimizeCmd = app->get_subcommand("-Optimize");
        std::vector<std::string> optOptions = split(OPTIMIZE_OPTIONS, ';');
        std::vector<std::string> optOptionsDescriptions = split(OPTIMIZE_OPTIONS_DESCRIPTIONS, ';');
        for (int i = 0; i < optOptions.size(); i++) {
            optimizeCmd->add_flag("--" + optOptions[i],
                                  optOptionsDescriptions[i]);
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

        //adding passed optmizer options
        if (app->get_subcommand("-Optimize")->parsed()) {
            std::cout << "\033[1;94mOptimizer enabled with the following options:\033[0;94m";
            if (app->get_subcommand("-Optimize")->count("--help") ||
                app->get_subcommand("-Optimize")->count("--help-all"))
                exit(0);

            std::vector<std::string> optOptions = split(OPTIMIZE_OPTIONS, ';');
            for (int i = 0; i < optOptions.size(); i++) {
                if (app->get_subcommand("-Optimize")->count("--" + optOptions[i]) > 0) {
                      this->optimizeOptions.insert(optOptions[i]);
                }
            }
            if(this->optimizeOptions.find("all")!=this->optimizeOptions.end()){ this->optimizeOptions.clear();}
            if(this->optimizeOptions.empty()) {this->optimizeOptions.insert("all");}
            CommandLineParameter::setOptimizeOptionsSet(this->optimizeOptions);
            for(auto option: this->optimizeOptions){
                std::cout << " " << option << " ";
            }
            std::cout << "\033[0m\n";
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
            TERMINATE("Unknown Source File: " + this->sourceFile);


        //Manage Output Directory
        if (app->count("--output")) {
            if (!isDirectory(this->outputDirectory))
            {TERMINATE("Unknown Output Directory: " + this->outputDirectory)}
            else
                createOutputDirectory(this->outputDirectory);
        }
    }
}