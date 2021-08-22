#pragma once

#include <cstdint>

class ObjectManager;

/// Object
class Object
{
public:
	/// Constructor
	/// @param [in] id Object ID
	/// @param [in] manager Manager
	Object(std::uint16_t id, ObjectManager* manager);

	/// Destructor
	virtual ~Object();

	/// Get object ID
	/// @return Object ID
	std::uint16_t GetId() const;

	/// Update object
	virtual void Update() = 0;

private:
	/// Object ID
	std::uint16_t _id;

	/// Object manager
	ObjectManager* _manager;
};
