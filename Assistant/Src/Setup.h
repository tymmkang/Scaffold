#ifndef SCAFFOLD_SETUP
#define SCAFFOLD_SETUP

#include <string>
#include <memory>

class TextTemplate;

namespace scaffold
{
	class Setup
	{
	public:
		Setup(const std::string& name, TextTemplate* pTextTemplate);

		~Setup();

	private:
		const std::string name;

		TextTemplate* pTextTemplate;
	};
}

#endif
