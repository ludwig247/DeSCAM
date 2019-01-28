//===-- src/enums.h - systec-clang class definition -------*- C++ -*-===//
//
//                     systemc-clang: SystemC Parser
//
// This file is distributed under the University of Illinois License.
// See LICENSE.mkd for details.
//
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief Defining enumerated types used throughout systemc-clang.
///
//===----------------------------------------------------------------------===//
#ifndef _ENUM_H_
#define _ENUM_H_
#include <string>


namespace  SCAM{
	enum PROCESS_TYPE {
		NONE, THREAD, CTHREAD, METHOD
	};

	enum buildInType{unknown,integer,boolean,structType};

	inline std::string buildInTypeToString(buildInType type){
		std::string typeString="";
		switch(type){
			case buildInType::boolean : typeString = "bool"; break;
			case buildInType::integer : typeString = "int"; break;
			default: typeString = "unknown";
		}
        return typeString;
	}

}
#endif
