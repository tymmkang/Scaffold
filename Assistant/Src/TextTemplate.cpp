#include "TextTemplate.h"

namespace scaffold
{
	TextTemplate::TextTemplate(const std::string& text)
		: TextTemplate(text, "{{", "}}")
	{ }

	TextTemplate::TextTemplate(const std::string& text, const std::string& lDelim, const std::string& rDelim)
		: text(text), lDelim(lDelim), rDelim(rDelim)
	{

	}

	TextTemplate::~TextTemplate()
	{

	}
}
