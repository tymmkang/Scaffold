#include "ProgramSingleton.h"
#include <exception>

namespace scaffold
{
	ProgramSingleton* ProgramSingleton::pInstance = nullptr;

	void ProgramSingleton::Initialize(
		FileReader* pFileReader,
		FileWriter* pFileWriter)
	{
		if (pInstance != nullptr)
		{
			throw std::exception("이미 초기화 된 상태입니다.");
		}

		pInstance = new ProgramSingleton(
			pFileReader,
			pFileWriter);
	}

	void ProgramSingleton::Cleanup()
	{
		if (pInstance == nullptr)
		{
			throw std::exception("이미 클린업 된 상태입니다.");
		}

		delete pInstance;
		pInstance = nullptr;
	}

	ProgramSingleton* ProgramSingleton::GetInstance()
	{
		return ProgramSingleton::pInstance;
	}

	FileReader* ProgramSingleton::GetFileReader() { return this->pFileReader; }

	FileWriter* ProgramSingleton::GetFileWriter() { return this->pFileWriter; }

	ProgramSingleton::ProgramSingleton(
		FileReader* pFileReader,
		FileWriter* pFileWriter)
		: pFileReader(pFileReader), pFileWriter(pFileWriter)
	{ }

	ProgramSingleton::~ProgramSingleton()
	{
		delete pFileReader;
		pFileReader = nullptr;

		delete pFileWriter;
		pFileWriter = nullptr;
	}
}
