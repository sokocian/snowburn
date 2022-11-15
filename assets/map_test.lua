local Map = {
	--name = {"renderClass" (nil for most objs), "mesh/Path.obj", "texture/Path.png", {transform}, {rot}, {scale}, hasCollisions, objClass}
	map = {nil, "assets/map.obj", "assets/tileset.png", nil, nil, {-1,-1,1}, true},
	background = {nil, "assets/sphere.obj", "assets/starfield.png", {0,0,0}, nil, {500,500,500}, false},
	tree = {"tree", nil, nil, {1,0.5,0}, nil, nil, false},
}

return Map