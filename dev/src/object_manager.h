#pragma once

#include <list>

class Object;

/// Generic object manager
class ObjectManager
{
public:
	/// Constructor
	ObjectManager();

	/// Destructor
	virtual ~ObjectManager();

	/// Attach object
	/// @param [in] obj Object
	void Attach(Object* obj);

	/// Detach object
	/// @param [in] obj Object
	void Detach(Object* obj);

	/// Notify all attached objects
	void Notify();

private:

	/// Attached objects
	std::list<Object*> _objects{};
};
