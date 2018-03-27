// iChannel0: Link GLSL Elements, filter=linear, wrap=clamp
// BBox: iChannel0

/*
Implementation and Development by CGVIRUS under GNU GPL Version 3 Licence.
Some math ideas have derived from some genius minded folks and books.
Feel free to share the knowledge and any type of code contribution is encouraged.
*/

//Global parametres
uniform float globalSize = 1.0; // Global Scale, min=0., max=100.
uniform float globalRotate= 0.0; // Global Rotation, min=0., max=360.

//parametres
uniform float Radius = .25; // Radius, min=0., max=2.
uniform float Thickness = .12; // Thickness, min=0., max=.9
uniform float softness = .5; // Softness, min=.1, max=1.
uniform int raycount = 100; // Ray Count , min=0., max=200.
uniform float raydepth = .3; // Ray depth , min=-1.5, max=1.5
uniform float rotation = .0; // Rotation , min=0.,max=360.
uniform vec3 Color = vec3(.25,.25,.25); // Color


//creates a ring with or without Rays
float ring(vec2 uv, vec2 pos, float radius, float thick)
{
    float rot = radians(rotation+globalRotate);
	mat2 m = mat2(cos(rot), -sin(rot), sin(rot), cos(rot));
   	uv  = m*uv;
   	pos = m*pos;
    
  vec2 main = pos-uv;
  float ang = atan(main.y, main.x);
  float dist=length(main); dist = pow(dist,.1);
  float f0 = mix(0.0, 1.0, smoothstep(thick*globalSize, thick-softness, abs(length(pos-uv) - (radius*globalSize))));
  
  return f0*(sin((ang)*raycount)*raydepth+dist*.1+.9);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy;
	uv -= 0.5;
	uv.x *= iResolution.x / iResolution.y;
	
	vec2 mouse = iMouse.xy/iResolution.xy;
	mouse -= 0.5;
	mouse.x *= iResolution.x / iResolution.y;
	
    vec2 xy = fragCoord.xy / iResolution.xy;
    vec4 linker = texture(iChannel0,xy);
	
	float c = ring(uv, mouse, Radius, Thickness);
	
	fragColor = vec4(vec3(c*Color), 1)+linker;
}
