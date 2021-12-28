#ifndef SCAFFOLD_TEXT_TEMPLATE
#define SCAFFOLD_TEXT_TEMPLATE

#include <string>
#include <unordered_map>
#include <vector>

namespace scaffold
{
	struct Range
	{
		int Begin = 0;
		int End = 0;
	};

	class TextTemplate
	{
	public:
		TextTemplate(const std::string& text);

		TextTemplate(const std::string& text, const std::string& lDelim, const std::string& rDelim);

		~TextTemplate();

	private:

		const std::string text;

		const std::string lDelim;

		const std::string rDelim;

		const std::unordered_map<std::string, Range> placeholderMap;
	};
}

#endif
