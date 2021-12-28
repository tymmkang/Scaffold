#ifndef SCAFFILD_FILE_READER
#define	SCAFFILD_FILE_READER

#include <filesystem>

namespace scaffold
{
	class FileReader
	{
	public:

		explicit FileReader(const std::filesystem::path& programPath);

		~FileReader();

	};
}

#endif

