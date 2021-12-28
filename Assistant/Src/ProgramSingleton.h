#ifndef SCAFFOLD_PROGRAM_SINGLETON
#define SCAFFOLD_PROGRAM_SINGLETON

namespace scaffold
{
	class FileReader;
	class FileWriter;

	class ProgramSingleton
	{
	public:

		static void Initialize(
			FileReader* pFileReader,
			FileWriter* pFileWriter);

		static void Cleanup();

		static ProgramSingleton* GetInstance();

		FileReader* GetFileReader();

		FileWriter* GetFileWriter();

	private:

		static ProgramSingleton* pInstance;

		explicit ProgramSingleton(
			FileReader* pFileReader,
			FileWriter* pFileWriter);

		~ProgramSingleton();

		FileReader* pFileReader;
		FileWriter* pFileWriter;
	};
}

#endif
