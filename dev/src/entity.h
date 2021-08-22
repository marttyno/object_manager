#pragma once

#include "entity_action_manager.h"

/// Entity
class Entity
{
public:
	/// Constructor
	/// @param [in] entityId Enity ID
	/// @param [in] entityActionsCount Entity actions count
	explicit Entity(std::uint16_t entityId, std::uint16_t entityActionsCount);

	/// Destructor
	~Entity();

	/// Update enity
	void Update();

private:

	/// Entity ID
	std::uint16_t _entityId;

	/// Entity action manager
	EntityActionManager _manager{};
};
