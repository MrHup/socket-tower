This is a file that stores snippets of code I deem as useful:

```
final jointDef = RevoluteJointDef()
  ..initialize(firstBody, secondBody, firstBody.position);
world.createJoint(RevoluteJoint(jointDef));
```

