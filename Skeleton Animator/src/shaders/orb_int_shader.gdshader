
shader_type spatial;

uniform vec4 tint : hint_color = vec4(1,1,1,1);
uniform sampler2D noise : hint_white;
uniform vec2 speed = vec2( 0.0, 1.0 );
uniform float energy : hint_range( 1.0,20.0) = 2;
uniform float size = 1;

varying vec3 position;


void vertex()
{
	position = VERTEX;
}

void fragment( )
{
	vec3 local = vec3((position*mat3(CAMERA_MATRIX)).xy,0);
	vec2 uv = vec2(0
	,length(local)/size);
	vec2 suv = vec2(uv.x,-uv.y) + TIME * speed;
	float fire_noise = texture( noise, suv ).r;

	EMISSION = vec3(fire_noise) * energy * tint.rgb;
	NORMAL = normalize(vec3(
		texture( noise, suv+vec2(1,0) ).r -
		texture( noise, suv+vec2(-1,0) ).r, 1,
		texture( noise, suv+vec2(0,1) ).r -
		texture( noise, suv+vec2(0,-1) ).r
		));
}
