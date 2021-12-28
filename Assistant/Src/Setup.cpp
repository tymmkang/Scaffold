#include "Setup.h"

namespace scaffold
{
	Setup::Setup(const std::string& name, TextTemplate* pTextTemplate)
		: name(name), pTextTemplate(pTextTemplate)
	{ }

	Setup::~Setup()
	{

	}
}
