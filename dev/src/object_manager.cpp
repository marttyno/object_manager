#include "object_manager.h"

#include <iostream>

#include "object.h"

ObjectManager::ObjectManager()
{
	std::cout << "'ObjectManager:' Construct" << std::endl;
};

ObjectManager::~ObjectManager()
{
	std::cout << "'ObjectManager:' Destruct" << std::endl;
};

void ObjectManager::Attach(Object* obj)
{
	if (std::find(_objects.begin(), _objects.end(), obj) == _objects.end())
	{
		std::cout << "'ObjectManager': Attach object (object_id: " << obj->GetId() << ")" << std::endl;
		_objects.push_back(obj);
	}
}

void ObjectManager::Detach(Object* obj)
{
	if (std::find(_objects.begin(), _objects.end(), obj) != _objects.end())
	{
		std::cout << "'ObjectManager': Dettach object (object_id: " << obj->GetId() << ")" << std::endl;
		_objects.push_back(obj);
	}
}

void ObjectManager::Notify()
{
	std::cout << "'ObjectManager': Notify attached objects (objects_count: " << _objects.size() << ")" << std::endl;
	for (Object* object : _objects)
	{
		object->Update();
	}
}
