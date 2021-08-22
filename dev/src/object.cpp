#include "object.h"

#include <cassert>
#include <iostream>

#include "object_manager.h"

Object::Object(const std::uint16_t id, ObjectManager* manager) : _id(id), _manager(manager)
{
	std::cout << "'Object': Construct (id: " << _id  << ")" << std::endl;
	assert(_manager != nullptr);
	_manager->Attach(this);
}

Object::~Object()
{
	std::cout << "'Object': Destruct (id: " << _id  << ")" << std::endl;
	_manager->Detach(this);
}

std::uint16_t Object::GetId() const
{
	return _id;
}
