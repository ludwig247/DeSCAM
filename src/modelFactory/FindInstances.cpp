//
// Created by tobias on 28.10.20.
//

#include "FindInstances.h"


bool DESCAM::FindInstances::setup(clang::TranslationUnitDecl *tu, Model * const model) {
  DESCAM::GetClangMain get_clang_main;
  get_clang_main.setup(tu);

  //The top instance is the sc_main. It doesn't contain any ports
  //Create empty dummy module for sc_main
  auto sc_main = new Module("main");
  //this->model->addModule(sc_main);
  //Create instance for sc_main and add to model
  top_instance_ = new ModuleInstance("TopInstance", sc_main);
  //std::cout << model->getModuleInstance() << std::cout;
  //model_->addTopInstance(top_instance);
  if (!get_clang_main.isScMainFound()) {
    //TODO: add message to loger, not to console
    std::cout << "" << std::endl;
    std::cout << "======================" << std::endl;
    std::cout << "Instances:" << std::endl;
    std::cout << "----------------------" << std::endl;
    std::cout << "-I- No main found, can't create netlist" << std::endl;
    return false;
  }

  DESCAM::GetClangNetlist get_clang_netlist;
  get_clang_netlist.setup(get_clang_main.getSCMainFunctionDecl());

  //findNetlist.getInstanceMap() = std::map<string instance_name,string sc_module>
  for (const auto &instance: get_clang_netlist.getInstanceMap()) {
    //Search for pointer in module map
    Module *module = model->getModules().find(instance.second)->second;
    //In case module is not found -> error!
    if (!module) {TERMINATE("ModelFactory::addInstances module not found"); }
    //Add instance to model
    top_instance_->addModuleInstance(new ModuleInstance(instance.first, module));
  }
  //ChannelMap = <<Instance,Port>, channelDecl*> >
  //Create exactly one channel for each channelDecl and attach respective ports to this channel
  for (const auto &channel: get_clang_netlist.getChannelMap()) {
    //Search instance in model ( instanceName = channel.first.first)
    std::string instanceName = channel.first.first;
    ModuleInstance *instance;
    instance = top_instance_->getModuleInstances().find(instanceName)->second;

    //Channel name and type
    std::string channel_name = channel.second->getNameInfo().getAsString();

    //Check whether channel is already created
    //If channel does not already exist
    if (top_instance_->getChannelMap().count(channel_name) == 0) {
      //Create new channel
      //Add to channelMap of instance
      top_instance_->addChannel(new Channel(channel_name));
    }
    //Otherwise receive current channel
    Channel *current_channel = top_instance_->getChannelMap().find(channel_name)->second;

    //Add port to channel
    //Search search port in instance.module ( portName = channel.first.second )
    std::string port_name = channel.first.second;
    Port *port = instance->getStructure()->getPorts().find(port_name)->second;

    //Differ between in/output port
    std::string direction = port->getInterface()->getDirection();
    //Bind Port to Channel
    if (direction == "in") {
      current_channel->setToPort(port);
      current_channel->setToInstance(instance);
    } else if (direction == "out") {
      current_channel->setFromPort(port);
      current_channel->setFromInstance(instance);
    } else {TERMINATE("Interface direction not supported"); }
    //Add instance to channel

  }
  return true;
}
DESCAM::ModuleInstance *DESCAM::FindInstances::getModuleInstance() {
  return top_instance_;
}
