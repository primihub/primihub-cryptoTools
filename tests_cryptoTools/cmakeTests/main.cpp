

#include "src/cryptoTools/Crypto/PRNG.h"

int main()
{
	using namespace ph_oc;
	PRNG prng(ph_oc::ZeroBlock);
	std::cout << prng.get<int>() << std::endl;
	return 0;
}