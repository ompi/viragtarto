%.stl: viragtarto.scad minta.scad
	openscad /dev/null -D "use <`pwd`/viragtarto.scad> $(basename $@)();" -o $@

mind: $(addsuffix .stl, darab_a darab_b darab_c darab_d)

minta.scad: minta.js node_modules
	node minta.js > minta.scad

node_modules:
	npm install

clean:
