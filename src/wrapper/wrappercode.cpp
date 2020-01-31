//
// Created by hesselberg on 08.10.19.
//
//. --file /import/lab/users/hesselberg/Simon_repo/SCAM/example/Bus/ESL/Bus_new.h -PrintITL

#include <pybind11/pybind11.h>
#include "main.cpp"
#include <pybind11/stl.h>

namespace py = pybind11;

PYBIND11_MODULE(DESCAM, m)
{
    m.def("main", [](std::vector<std::string> args) {
        std::vector<const char *> cstrs;
        cstrs.reserve(args.size());
        for (auto &s : args) cstrs.push_back(s.c_str());
        return myFunction(cstrs.size(), cstrs.data());
    });

//        py::class_<CommandLineProcess>(m, "CmdProcess")
//                .def(py::init<const std::string &>())
//                .def_property_readonly("getSourceFile", &CommandLineProcess::getSourceFile);




//    m.def("CommandLineProccess", [](std::vector<std::string> args) {
//        std::vector<char *> cstrs;
//        cstrs.reserve(args.size());
//        for (auto &s : args) cstrs.push_back(const_cast<char *>(s.c_str()));
//        return CommandLineProcess(cstrs.size(), cstrs.data());
//    });
}



//PYBIND11_MODULE(wrapper_function, m) {
//    m.def("main function", [](std::vector<std::string> args) {
//        std::vector<char *> cstrs;
//        cstrs.reserve(args.size());
//        for (auto &s : args) cstrs.push_back(const_cast<char *>(s.c_str()));
//        return main(cstrs.size(), cstrs.data());
//    });
//}




