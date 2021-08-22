#include "entity_action.h"

#include <iostream>
#include <random>

#include "entity_action_manager.h"

/// Get random boolean value
/// @return Boolean value
bool GetRandomBool()
{
	static std::random_device randomDevice;
	static std::mt19937 gen(randomDevice());
	const std::uniform_int_distribution<int> distrib(0, 1);

	return distrib(gen) == 0;
}

EntityAction::EntityAction(const std::uint16_t actionId, EntityActionManager* actionManager)
	: Object(actionId, actionManager), _visible(GetRandomBool())
{
	std::cout << std::boolalpha << "'EntityAction': Construct (action_id: " << GetId() << "; visible: " << _visible << ")" << std::endl;
}

EntityAction::~EntityAction()
{
	std::cout << std::boolalpha << "'EntityAction': Destruct (action_id: " << GetId() << "; visible: " << _visible << ")" << std::endl;
};

bool EntityAction::CanBeVisible() const
{
	return _visible;
}

void EntityAction::Update()
{
	_visible = GetRandomBool();
	std::cout << std::boolalpha << "'EntityAction': Update (visible: " << _visible << ")" << std::endl;
}
