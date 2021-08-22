#include "entity_action_manager.h"

#include <iostream>

#include "entity_action.h"

EntityActionManager::EntityActionManager() : ObjectManager()
{
	std::cout << "'EntityActionManager:' Construct" << std::endl;
}

EntityActionManager::~EntityActionManager()
{
	std::cout << "'EntityActionManager:' Destruct" << std::endl;
};

void EntityActionManager::AddAction(std::uint16_t actionId)
{
	std::cout << "'EntityActionManager:' Add action (action_id: " << actionId << ")" << std::endl;
	_entityActions.emplace_back(actionId, this);
}

std::list<const EntityAction*> EntityActionManager::GetVisibleActions() const
{
	std::list<const EntityAction*> visibleActions{};
	for (const EntityAction& action : _entityActions)
	{
		if (action.CanBeVisible())
		{
			visibleActions.push_back(&action);
		}
	}
	return visibleActions;
}
