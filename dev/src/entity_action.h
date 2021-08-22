#pragma once

#include "object.h"

class EntityActionManager;

/// Entity action
class EntityAction : public Object
{
public:
	/// Constructor
	/// @param [in] actionId Action ID
	/// @param [in] actionManager Action manager
	EntityAction(std::uint16_t actionId, EntityActionManager* actionManager);

	/// Destructor
	~EntityAction() override;

	/// Can be visible
	/// @return Visible
	virtual bool CanBeVisible() const;

	/// Update entity action visibility
	void Update() override;

private:
	/// Entity action visibility
	bool _visible;
};
