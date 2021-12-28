#ifndef SCAFFILD_FILE_WRITER
#define	SCAFFILD_FILE_WRITER

#include <filesystem>

namespace scaffold
{
	class FileWriter
	{
	public:

		explicit FileWriter(const std::filesystem::path& programPath);

		~FileWriter();

	};
}

#endif

