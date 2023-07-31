%.stl: viragtarto.scad
	openscad /dev/null -D "use <`pwd`/viragtarto.scad> $(basename $@)();" -o $@

mind: $(addsuffix .stl, darab_a darab_b darab_c darab_d)

clean:
