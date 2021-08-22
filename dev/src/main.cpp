#include <iostream>

#include "entity.h"

int main(int argc, char* argv[])
{
	std::cout << "MAIN ==> Create entity (entity_id: 1, entity_actions_count: 3)" << std::endl;
	Entity entity1{ 1, 3 };

	std::cout << std::endl;

	std::cout << "MAIN ==> Create entity (entity_id: 2, entity_actions_count: 2)" << std::endl;
	Entity entity2{ 2, 2 };

	std::cout << std::endl;

	std::cout << "MAIN ==> Update entity (entity_id: 1)" << std::endl;
	entity1.Update();

	std::cout << std::endl;

	std::cout << "MAIN ==> Update entity (entity_id: 2)" << std::endl;

	std::cout << std::endl;
	entity2.Update();

	std::cout << std::endl;

	std::cout << "MAIN ==> Destruct" << std::endl;

	return 1;
}
