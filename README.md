# Object Manager

* Spent time: About 24h, maybe more
* Technologies: Visual Studio 2019, CMake, PlantUml
* Info for task: It's chaotic task for me. I don't know what it's exactly expected result.

## UML

!["UML diagram"](/dev/doc/uml.png "UML diagram")

## Example console output

<pre>
MAIN ==> Create entity (entity_id: 1, entity_actions_count: 3)
'ObjectManager:' Construct
'EntityActionManager:' Construct
'Entity': Construct (entity_id: 1)
'EntityActionManager:' Add action (action_id: 10)
'Object': Construct (id: 10)
'ObjectManager': Attach object (object_id: 10)
'EntityAction': Construct (action_id: 10; visible: false)
'EntityActionManager:' Add action (action_id: 11)
'Object': Construct (id: 11)
'ObjectManager': Attach object (object_id: 11)
'EntityAction': Construct (action_id: 11; visible: true)
'EntityActionManager:' Add action (action_id: 12)
'Object': Construct (id: 12)
'ObjectManager': Attach object (object_id: 12)
'EntityAction': Construct (action_id: 12; visible: true)

MAIN ==> Create entity (entity_id: 2, entity_actions_count: 2)
'ObjectManager:' Construct
'EntityActionManager:' Construct
'Entity': Construct (entity_id: 2)
'EntityActionManager:' Add action (action_id: 13)
'Object': Construct (id: 13)
'ObjectManager': Attach object (object_id: 13)
'EntityAction': Construct (action_id: 13; visible: true)
'EntityActionManager:' Add action (action_id: 14)
'Object': Construct (id: 14)
'ObjectManager': Attach object (object_id: 14)
'EntityAction': Construct (action_id: 14; visible: true)

MAIN ==> Update entity (entity_id: 1)
'Entity': Update (entity_id: 1)
'ObjectManager': Notify attached objects (objects_count: 3)
'EntityAction': Update (visible: false)
'EntityAction': Update (visible: false)
'EntityAction': Update (visible: false)
'Entity': Update (visible_actions_count: 0)

MAIN ==> Update entity (entity_id: 2)

'Entity': Update (entity_id: 2)
'ObjectManager': Notify attached objects (objects_count: 2)
'EntityAction': Update (visible: false)
'EntityAction': Update (visible: false)
'Entity': Update (visible_actions_count: 0)

MAIN ==> Destruct
'Entity': Destruct (entity_id: 2)
'EntityActionManager:' Destruct
'EntityAction': Destruct (action_id: 13; visible: false)
'Object': Destruct (id: 13)
'ObjectManager': Dettach object (object_id: 13)
'EntityAction': Destruct (action_id: 14; visible: false)
'Object': Destruct (id: 14)
'ObjectManager': Dettach object (object_id: 14)
'ObjectManager:' Destruct
'Entity': Destruct (entity_id: 1)
'EntityActionManager:' Destruct
'EntityAction': Destruct (action_id: 10; visible: false)
'Object': Destruct (id: 10)
'ObjectManager': Dettach object (object_id: 10)
'EntityAction': Destruct (action_id: 11; visible: false)
'Object': Destruct (id: 11)
'ObjectManager': Dettach object (object_id: 11)
'EntityAction': Destruct (action_id: 12; visible: false)
'Object': Destruct (id: 12)
'ObjectManager': Dettach object (object_id: 12)
'ObjectManager:' Destruct
</pre>
