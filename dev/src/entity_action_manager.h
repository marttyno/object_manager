#pragma once

#include "object_manager.h"

class EntityAction;

/// Entity action manager
class EntityActionManager final : public ObjectManager
{
public:
	/// Constructor
	EntityActionManager();

	/// Destructor
	~EntityActionManager() override;

	/// Add new entity action
	/// @param [in] actionId Action ID
	void AddAction(std::uint16_t actionId);

	/// Get all visible entity actions
	/// @return Visible entity actions
	std::list<const EntityAction*> GetVisibleActions() const;

private:

	/// Entity actions
	std::list<EntityAction> _entityActions{};
};
