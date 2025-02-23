shader_type canvas_item;

uniform sampler2D sticksOverlay;
uniform sampler2D ballOverlay;
uniform float defaultWobbleSpeed = 10.f;
uniform float sugar;
uniform float protein;
uniform float fat;
uniform float water;
uniform float fiber;
uniform float vitamin;
//sugar, protein, fat, water, fiber, vitamin

const float SAFE_ZONE = 0.f;
const float VALUE_AMPLITUDE = 20.f;
const float MID = VALUE_AMPLITUDE/2.;
const float SAFE_HI = MID+(SAFE_ZONE/2.);
const float SAFE_LO = MID-(SAFE_ZONE/2.);
const float EFF_RANGE = SAFE_LO;


void vertex() {
	float wobbleSpeed = defaultWobbleSpeed;
	if (sugar>SAFE_HI){
		wobbleSpeed*=sugar-(SAFE_HI/EFF_RANGE*5.);
	}else if(sugar<SAFE_LO){
		wobbleSpeed*=sugar/EFF_RANGE;
	}
	float t=TIME;
	if (water<SAFE_LO){
		t*=water/EFF_RANGE*10.;
		t=floor(t);
		t/=water*EFF_RANGE/10.;
	}
	t*=wobbleSpeed;
	vec2 p = vec2(cos(t)*0.1+1.f, sin(t)*0.1+1.f);
	if (water>SAFE_HI && VERTEX.y<0.){
		float rot=sin(TIME*3.)*((water-SAFE_HI)/EFF_RANGE);
		vec2 pt = VERTEX;
		VERTEX.x = pt.x*cos(rot)-pt.y*sin(rot);
		VERTEX.y = pt.y*cos(rot)+pt.x*sin(rot);
	}
	if (fat>SAFE_HI){
		p.x+=(fat-SAFE_HI)/(2.*EFF_RANGE);
	}else if (fat<SAFE_LO){
		p.x-=1.-((fat)/(2.*EFF_RANGE))-0.5;
	}
	VERTEX *= p;
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv= UV;
	if (protein<SAFE_LO){
		uv=uv*2.-1.;
		float c= protein/SAFE_LO;
		uv=uv*uv*uv*(1.-c)+uv*c;
		uv=(uv+1.)/2.;
	}
	vec4 c =texture(TEXTURE, uv);
	if (fiber>SAFE_HI){
		float coef = (fiber-SAFE_HI)/EFF_RANGE;
		vec4 col = texture(sticksOverlay, uv);
		if (col.a>(1.-coef)){
			//c.a = 1.;
			c.rgb=vec3(0.1,0.5,0.1);
		}
	}
	if (protein>SAFE_HI){
		c-=0.5;
		c*=(protein-SAFE_HI)/EFF_RANGE*5.+1.;
		c+=0.5;
	}

	if (vitamin>SAFE_HI){
		c.gb*=1.-((vitamin-SAFE_HI)/EFF_RANGE);
	}else if (vitamin<SAFE_LO){
		float coef=vitamin/SAFE_LO;
		c.rgb*=coef;
		c.rgb+=1.-coef;
	}

	if (fiber<SAFE_LO){
		float coef = 1.-(fiber/SAFE_LO);
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
