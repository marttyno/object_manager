#include "entity.h"

#include <iostream>

Entity::Entity(const std::uint16_t entityId, const std::uint16_t entityActionsCount) : _entityId(entityId)
{
	static std::uint16_t newId { 10 };

	std::cout << "'Entity': Construct (entity_id: " << _entityId << ")" << std::endl;
	for (std::uint16_t i = 0; i < entityActionsCount; ++i)
	{
		_manager.AddAction(newId);
		++newId;
	}
}

Entity::~Entity()
{
	std::cout << "'Entity': Destruct (entity_id: " << _entityId << ")" << std::endl;
}

void Entity::Update()
{
	std::cout << "'Entity': Update (entity_id: " << _entityId << ")" << std::endl;

	_manager.Notify();

	std::cout << "'Entity': Update (visible_actions_count: " << _manager.GetVisibleActions().size() << ")" << std::endl;
}
