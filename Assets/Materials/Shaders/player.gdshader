shader_type canvas_item;

uniform sampler2D sticksOverlay;
uniform sampler2D ballOverlay;
const float defaultWobbleSpeed = 10.f;
const float sugar =10.;
const float protein=10.;
const float fat= 10.;
const float water=10.;
const float fiber = 10.;
const float vitamin = 10.;
//sugar, protein, fat, water, fiber, vitamin

void vertex() {
	float wobbleSpeed = defaultWobbleSpeed;
	if (sugar>15.){
		wobbleSpeed*=sugar-15.;
	}else if(sugar<5.){
		wobbleSpeed*=sugar/5.;
	}
	float t=TIME;
	if (water<5.){
		t*=water*2.;
		t=floor(t);
		t/=water*2.;
	}
	t*=wobbleSpeed;
	vec2 p = vec2(cos(t)*0.1+1.f, sin(t)*0.1+1.f);
	if (water>15. && VERTEX.y<0.){
		float rot=sin(TIME*3.)*((water-15.)/5.);
		vec2 pt = VERTEX;
		VERTEX.x = pt.x*cos(rot)-pt.y*sin(rot);
		VERTEX.y = pt.y*cos(rot)+pt.x*sin(rot);
	}
	if (fat>15.){
		p.x+=(fat-15.)/10.;
	}else if (fat<5.){
		p.x-=1.-((fat)/10.)-0.5;
	}
	VERTEX *= p;
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv= UV;
	if (protein<5.){
		uv=uv*2.-1.;
		float c= protein/5.;
		uv=uv*uv*uv*(1.-c)+uv*c;
		uv=(uv+1.)/2.;
	}
	vec4 c =texture(TEXTURE, uv);
	if (fiber>15.){
		float coef = (fiber-15.)/5.;
		vec4 col = texture(sticksOverlay, uv);
		if (col.a>(1.-coef)){
			c.a = 1.;
			c.rgb=vec3(0.1,0.5,0.1);
		}
	}
	if (protein>15.){
		c-=0.5;
		c*=protein-15.;
		c+=0.5;
	}

	if (vitamin>15.){
		c.gb*=1.-((vitamin-15.)/5.);
	}else if (vitamin<5.){
		float coef=vitamin/5.;
		c.rgb*=coef;
		c.rgb+=1.-coef;
	}

	if (fiber<5.){
		float coef = 1.-(fiber/5.);
		float ttmp = TIME- floor(TIME+uv.y);
		vec4 col = texture(ballOverlay, uv+vec2(0.,ttmp));
		if (coef>(1.-col.a)){
			c.a =0.;
		}
	}

	COLOR=c;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
