#include <iostream>
#include <exception>
#include <format>
#include <filesystem>
#include "cxxopt/cxxopts.hpp"

#include "ProgramSingleton.h"
#include "FileReader.h"
#include "FileWriter.h"
int main(int argc, char **argv)
{	
	int returnCode = 0;

	try
	{
		std::filesystem::path p(argv[0]);
		
		std::cout << p << std::endl;

		scaffold::ProgramSingleton::Initialize(
			new scaffold::FileReader(),
			new scaffold::FileWriter());

		cxxopts::Options options(argv[0], "Scaffold-Assistant");

		options.add_options()
			("help",		"Show usage.")
			("setup",		"Setup Scaffold project.",	cxxopts::value<std::string>(), "\'project name\'")
			("add_em",		"Add executable module.",	cxxopts::value<std::string>(), "\'executable name\'")
			("add_sm",		"Add static library.",		cxxopts::value<std::string>(), "\'static lib name\'")
			("add_dm",		"Add dynamic library.",		cxxopts::value<std::string>(), "\'dynamic lib name\'")
			("validate",	"Refresh template generated CMakeLists of module.");

		auto result = options.parse(argc, argv);

		if (result.count("help"))
		{
			std::cout << options.help() << std::endl;
		}
		else if (result.count("setup"))
		{
			std::cout << "Project name : " << result["setup"].as<std::string>() << std::endl;
		}
		else if (result.count("add_em"))
		{
			std::cout << "Executable name : " << result["add_em"].as<std::string>() << std::endl;
		}
		else if (result.count("add_sm"))
		{
			std::cout << "Static lib name : " << result["add_sm"].as<std::string>() << std::endl;
		}
		else if (result.count("add_dm"))
		{
			std::cout << "Dynamic lib name : " << result["add_dm"].as<std::string>() << std::endl;
		}
		else if (result.count("validate"))
		{
			std::cout << "Run validation" << std::endl;
		}
	}
	catch (const cxxopts::OptionException& e)
	{
		std::cerr << e.what() << std::endl;
		returnCode = -1;
	}
	catch (const std::exception& e)
	{
		std::cerr << e.what() << std::endl;
		returnCode = -1;
	}

	scaffold::ProgramSingleton::Cleanup();
	return returnCode;
}
