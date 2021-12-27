#include <iostream>
#include <format>

int main(int argc, char **argv)
{	
	std::cout << std::format("{} {}!", "Hello", "Scaffold") << std::endl;

	for(int i = 0; i < argc; i++)
	{
		std::cout << argv[i] << std::endl;
	}

	return 0;
}


